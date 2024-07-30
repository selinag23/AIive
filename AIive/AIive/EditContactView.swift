import SwiftUI

struct EditContactView: View {
    @Binding var contact: Contact
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Contact Info")) {
                HStack {
                    Text("Name:")
                    TextField("Name", text: $contact.name)
                }
                
                HStack {
                    Text("Position:")
                    TextField("Position", text: $contact.position)
                }
                
                HStack {
                    Text("Organization:")
                    TextField("Organization", text: $contact.organization)
                }
                
                HStack {
                    Text("Phone:")
                    TextField("Phone", text: $contact.phone)
                }
                
                HStack {
                    Text("Email:")
                    TextField("Email", text: $contact.email)
                }
                
                HStack {
                    Text("Social Media:")
                    TextField("Social Media", text: $contact.socialMedia)
                }
                
                VStack(alignment: .leading) {
                    Text("Description:")
                    TextEditor(text: $contact.description)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
            }
            
            Button(action: {
                // Save the changes and dismiss the view
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Edit Contact")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func updateDescription(_ contact: Contact) {
    }
}
