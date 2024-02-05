import Foundation

struct EmojiArtModel: Codable {
    
//MARK: - Structs
    
    struct Emoji: Identifiable, Hashable, Codable {
        let id: Int
        let text: String
        var x: Int
        var y: Int
        var size: Int
        
        fileprivate init(id: Int, text: String, x: Int, y: Int, size: Int) {
            self.id = id
            self.text = text
            self.x = x // offset from the center
            self.y = y // offset from the center
            self.size = size
        }
    }
    
//MARK: - Data Restoring
    
    init() { }
    
    init(jsonData: Data) throws {
        self = try JSONDecoder().decode(EmojiArtModel.self, from: jsonData)
    }
    
    init(url: URL) throws {
        let jsonData = try Data(contentsOf: url)
        self = try EmojiArtModel(jsonData: jsonData)
    }
    
//MARK: - Others
    
    var background = Background.blank
    var emojis = [Emoji]()
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, at location: (x: Int, y: Int), size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(id: uniqueEmojiId, text: text, x: location.x, y: location.y, size: size))
    }
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
}
