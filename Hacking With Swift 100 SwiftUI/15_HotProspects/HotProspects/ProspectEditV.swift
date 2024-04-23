import SwiftUI

struct ProspectEditV: View {
    
    @State var prospectToEdit: ProspectsM
    
    var body: some View {
        Spacer()
        
        VStack {
            Text("Edit Prospect Info")
                .font(.title)
            TextField("Name", text: $prospectToEdit.name)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
            TextField("Email Address", text: $prospectToEdit.emailAddress)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
        }
        .padding()
        
        Spacer()
        Spacer()
        Spacer()
    }
}
