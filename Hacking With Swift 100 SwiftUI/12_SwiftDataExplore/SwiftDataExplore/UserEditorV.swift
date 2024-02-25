import SwiftUI
import SwiftData

struct UserEditorV: View {
    @Bindable var user: UserM
    
    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: UserM.self, configurations: config)
        
        let user = UserM(name: "Taylor Swift", city: "Nashville", joinDate: .now)
        return UserEditorV(user: user)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
