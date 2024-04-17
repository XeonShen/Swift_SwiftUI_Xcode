import SwiftUI

struct PaletteManager: View {
    
//MARK: - Constants and Vars
    
    @EnvironmentObject var store: PaletteStore
    @State private var editMode: EditMode = .inactive
    @Environment(\.presentationMode) var presentationMode
    
//MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name)
                            Text(palette.emojis)
                        }
                    }
                }
                //make a delete button for editMode
                .onDelete { IndexSet in
                    store.palettes.remove(atOffsets: IndexSet)
                }
                //make a move button for editMode
                .onMove { IndexSet, newOffset in
                    store.palettes.move(fromOffsets: IndexSet, toOffset: newOffset)
                }
            }
            //navigation title settings
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            //add EditButton for entering editMode, Delete and Move button will appear under this mode
            .toolbar {
                ToolbarItem { EditButton() }
            }
            //add a dismiss button for closing the window
            .dismissable { presentationMode.wrappedValue.dismiss() }
            .environment(\.editMode, $editMode)
        }
    }
}

//MARK: - Preview

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
            .environmentObject(PaletteStore(named: "Preview"))
    }
}
