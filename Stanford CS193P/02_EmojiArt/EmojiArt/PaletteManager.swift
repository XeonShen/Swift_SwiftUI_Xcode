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
            //tap EditButton to enter editMode, delete and move button will appear
            //Close button will only shown under presentationMode, and devices other than iPad
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    if presentationMode.wrappedValue.isPresented,
                       UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
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
