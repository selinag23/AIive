import SwiftUI

struct ContactDetailView: View {
    var contact: Contact
    var onSave: (Contact) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var position: String
    @State private var organization: String
    @State private var phone: String
    @State private var email: String
    @State private var socialMedia: String
    @State private var description: String

    init(contact: Contact, onSave: @escaping (Contact) -> Void) {
        self.contact = contact
        self.onSave = onSave
        _name = State(initialValue: contact.name)
        _position = State(initialValue: contact.position)
        _organization = State(initialValue: contact.organization)
        _phone = State(initialValue: contact.phone)
        _email = State(initialValue: contact.email)
        _socialMedia = State(initialValue: contact.socialMedia)
        _description = State(initialValue: contact.description)
    }

    var body: some View {
        Form {
//            Section(header: Text("Contact Info")) {
//                TextField("Name", text: $name)
//                TextField("Position", text: $position)
//                TextField("Organization", text: $organization)
//                TextField("Phone", text: $phone)
//                TextField("Email", text: $email)
//                TextField("Social Media", text: $socialMedia)
//                TextField("Description", text: $description)
//            }
            Section(header: Text("Contact Info")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name:")
                    TextField("Name", text: $name)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Position:")
                    TextField("Position", text: $position)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Organization:")
                    TextField("Organization", text: $organization)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Phone:")
                    TextField("Phone", text: $phone)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email:")
                    TextField("Email", text: $email)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Social Media:")
                    TextField("Social Media", text: $socialMedia)
                }
                
                VStack(alignment: .leading) {
                    Text("Description:")
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    Button(action: updateDescription){
                        Text("Update")
                            .foregroundColor(.blue)
                    }
                }
            }
            Button(action: {
                let updatedContact = Contact(
                    id: contact.id,
                    name: name,
                    position: position,
                    organization: organization,
                    phone: phone,
                    email: email,
                    socialMedia: socialMedia,
                    description: description
                )
                onSave(updatedContact)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            }
        }
        .navigationBarTitle("Edit Contact", displayMode: .inline)
    }
    
    private func updateDescription(){
        
    }
}
