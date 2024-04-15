import SwiftUI

struct PaletteEditor: View {
    
//MARK: - Constants and Vars
    
    @Binding var palette: Palette
    @State private var emojiToAdd = ""
    
//MARK: - Body
    
    var body: some View {
        Form {
            nameSection
            addEmojiSection
            removeEmojiSection
        }
        .frame(minWidth: 300, minHeight: 350)
    }
    
//MARK: - Body Component
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $palette.name)
        }
    }
    
    var addEmojiSection: some View {
        Section(header: Text("Add Emoji")) {
            TextField("", text: $emojiToAdd)
                .onChange(of: emojiToAdd) { emoji in
                    withAnimation {
                        palette.emojis = emoji + palette.emojis
                            .filter { $0.isEmoji }
                    }
                }
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = palette.emojis.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
}

//MARK: - Preview

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 4)))
            .previewLayout(.fixed(width: 300, height: 350))
    }
}
