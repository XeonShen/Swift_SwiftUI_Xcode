import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
    
//MARK: - Constants and Vars
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            scheduleAutosave()
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
            
// newer code for image fetching
            
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
            
// legacy code for image fetching
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
    
//MARK: - Data Saving - autosave to remain data persistance
    
    private var autosaveTimer: Timer?
    
    private struct Autosave {
        static let filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
        static let coalescingIntervel = 5.0
    }
    
    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingIntervel, repeats: false) { timer in
            self.autosave()
        }
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try emojiArt.json()
            print("\(thisFunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) couldn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
        } catch let error {
            print("\(thisFunction) error = \(error)")
        }
    }
    
//MARK: - Data Restoring
    
    init() {
        if let url = Autosave.url, let autosavedEmojiArtModel = try? EmojiArtModel(url: url) {
            emojiArt = autosavedEmojiArtModel
            fetchBackgroundImageDataIfNecessary()
        } else {
            emojiArt = EmojiArtModel()
        }
    }
    
//MARK: - Intents - should be passed to the Model
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
        print("background set to \(background)")
    }
    
    func addEmoji(_ emoji: String, at location:(x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
    
}
