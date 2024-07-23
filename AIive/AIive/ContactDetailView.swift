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
            Section(header: Text("Contact Info")) {
                TextField("Name", text: $name)
                TextField("Position", text: $position)
                TextField("Organization", text: $organization)
                TextField("Phone", text: $phone)
                TextField("Email", text: $email)
                TextField("Social Media", text: $socialMedia)
                TextField("Description", text: $description)
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
}