import SwiftUI
import Combine
import UniformTypeIdentifiers

class EmojiArtDocument: ReferenceFileDocument {
    
//MARK: - Constants and Vars
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            //legacy data persistant method
            //scheduleAutosave()
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    private var backgroundImageFetchCancellable: AnyCancellable?
    
//MARK: - Set Background Image
    
    @Published var backgroundImage: UIImage?
    enum BackgroundImageFetchStatus: Equatable { case idle, fetching, failed(URL) }
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            backgroundImageFetchStatus = .fetching
            
//newer image fetching by using Publisher
            
            //cancel the previous fetching(if exists), then fetch the latest one
            backgroundImageFetchCancellable?.cancel()
            let session = URLSession.shared
            //this publisher get data from the url; it get nil when fetching failed; it publish to subscribers on the main queue
            let publisher = session.dataTaskPublisher(for: url)
                .map { (data, urlResponse) in UIImage(data: data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            backgroundImageFetchCancellable = publisher
                .sink { [weak self] image in
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = (image != nil) ? .idle : .failed(url)
                }
            
//legacy image fetching by using GCD
//
//            DispatchQueue.global(qos: .userInitiated).async {
//                let imageData = try? Data(contentsOf: url)
//                DispatchQueue.main.async { [weak self] in
//                    //user may smash lot of urls within a short time,
//                    //this IF statement check whether this url is the latest one that user want to fetch
//                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
//                        //when fetching the image, switch status to idle
//                        self?.backgroundImageFetchStatus = .idle
//                        //if the image fetched successful, force unwrap it, set it to backgroundImage
//                        if imageData != nil { self?.backgroundImage = UIImage(data: imageData!) }
//                        //if the image fetched fail, switch status to failed
//                        if self?.backgroundImage == nil { self?.backgroundImageFetchStatus = .failed(url) }
//                    }
//                }
//            }
            
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
//MARK: - Newer Data Persistence - conform to ReferenceFileDocument so data can be R&W
    
    static var readableContentTypes = [UTType.emojiart]
    static var writeableContentTypes = [UTType.emojiart]
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArtModel(jsonData: data)
            fetchBackgroundImageDataIfNecessary()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func snapshot(contentType: UTType) throws -> Data {
        try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
//MARK: - Newer Data Persistence - register Undo so data can be auto-saved
    
    private func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.undoablyPerform(operation: operation, with: undoManager) { //this line makes an undo undoably, which means redo
                myself.emojiArt = oldEmojiArt //this line undo
            }
        }
        undoManager?.setActionName(operation)
    }
    
//MARK: - Legacy Data Persistence - data saving
//
//    private var autosaveTimer: Timer?
//
//    private struct Autosave {
//        static let filename = "Autosaved.emojiart"
//        static var url: URL? {
//            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            return documentDirectory?.appendingPathComponent(filename)
//        }
//        static let coalescingIntervel = 5.0
//    }
//
//    private func scheduleAutosave() {
//        autosaveTimer?.invalidate()
//        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingIntervel, repeats: false) { timer in
//            self.autosave()
//        }
//    }
//
//    private func autosave() {
//        if let url = Autosave.url {
//            save(to: url)
//        }
//    }
//
//    private func save(to url: URL) {
//        let thisFunction = "\(String(describing: self)).\(#function)"
//        do {
//            let data: Data = try emojiArt.json()
//            print("\(thisFunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
//            try data.write(to: url)
//        } catch let encodingError where encodingError is EncodingError {
//            print("\(thisFunction) couldn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
//        } catch let error {
//            print("\(thisFunction) error = \(error)")
//        }
//    }
//
    
//MARK: - Legacy Data Persistence - data restoring
//
//    init() {
//        if let url = Autosave.url, let autosavedEmojiArtModel = try? EmojiArtModel(url: url) {
//            emojiArt = autosavedEmojiArtModel
//            fetchBackgroundImageDataIfNecessary()
//        } else {
//            emojiArt = EmojiArtModel()
//        }
//    }
//
    
//MARK: - Initializer
    
    init() {
        emojiArt = EmojiArtModel()
    }
    
//MARK: - Intents - should be passed to the Model
    
    func setBackground(_ background: EmojiArtModel.Background, undoManager: UndoManager?) {
        undoablyPerform(operation: "Set Background", with: undoManager) { //enable undo
            emojiArt.background = background
        }
    }
    
    func addEmoji(_ emoji: String, at location:(x: Int, y: Int), size: CGFloat, undoManager: UndoManager?) {
        undoablyPerform(operation: "Add \(emoji)", with: undoManager) { //enable undo
            emojiArt.addEmoji(emoji, at: location, size: Int(size))
        }
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Move", with: undoManager) { //enable undo
                emojiArt.emojis[index].x += Int(offset.width)
                emojiArt.emojis[index].y += Int(offset.height)
            }
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Scale", with: undoManager) { //enable undo
                emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            }
        }
    }
    
}

//MARK: - Newer Data Persistence - create an unique UTType for DocumentGroup

extension UTType {
    static let emojiart = UTType(exportedAs: "spacedrifter.emojiart")
}
