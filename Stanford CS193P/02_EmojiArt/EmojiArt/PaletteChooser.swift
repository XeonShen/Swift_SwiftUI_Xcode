import SwiftUI

struct PaletteChooser: View {
    
//MARK: - Constants and Vars
    
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font { .system(size: emojiFontSize) }
    
    @EnvironmentObject var store: PaletteStore
    
    //use @SceneStorage wrapper instead of @State, so this var will be stored even if App crash
    @SceneStorage("PaletteChooser.chosenPaletteIndex") private var chosenPaletteIndex = 0
    @State private var editing = false
    @State private var managing = false
    
//MARK: - Body
    
    var body: some View {
        HStack {
            paletteControlButton
            paletteBody(for: store.palette(at: chosenPaletteIndex))
        }
        .clipped()
    }

//MARK: - Body Component - paletteControlButton
    
    var paletteControlButton: some View {
        Button {
            //triggeer the animation transition
            withAnimation {
                chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        //add an contextMenu to the Button
        .contextMenu { contextMenu }
    }
    
    @ViewBuilder
    var contextMenu: some View {
        //"Edit" Button
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
            editing = true
        }
        //"New" Button
        AnimatedActionButton(title: "New", systemImage: "plus") {
            store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
            editing = true
        }
        //"Delete" Button
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
            chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
        }
        //"Manage" Button
        AnimatedActionButton(title: "Mange", systemImage: "slider.vertical.3") {
            managing = true
        }
        //"Go To" Button
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = store.palettes.index(matching: palette) {
                        chosenPaletteIndex = index
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }
    }
    
//MARK: - Body Component - paletteBody
    
    func paletteBody(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(palette.emojis.map{ String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .onDrag{ NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .font(emojiFont)
        }
        //custom an animation transition, bind it to the HStack
        .transition(AnyTransition.asymmetric(
            insertion: .offset(x: 0, y: emojiFontSize),
            removal: .offset(x: 0, y: -emojiFontSize)
            )
        )
        .id(palette.id)
        //pop up the paletteEditor window
        .popover(isPresented: $editing) {
            PaletteEditor(palette: $store.palettes[chosenPaletteIndex])
        }
        //pop up the paletteManager window
        .sheet(isPresented: $managing) {
            PaletteManager()
        }
    }
}

//MARK: - Preview

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
