import SwiftUI

struct CreateContactView: View {
    @State private var name = ""
    @State private var position = ""
    @State private var organization = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var socialMedia = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                TextField("Name", text: $name)
                TextField("Position", text: $position)
                TextField("Organization", text: $organization)
                TextField("Phone", text: $phone)
                TextField("Email", text: $email)
                TextField("Social Media", text: $socialMedia)
                TextField("Description", text: $description)
            }
            
            Button(action: {
                createContact()
            }) {
                Text("Create")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("Create Contact")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func createContact() {
        let newContact = Contact(
            name: name,
            position: position,
            organization: organization,
            phone: phone,
            email: email,
            socialMedia: socialMedia,
            description: description
        )
        
        // Here you would typically save the new contact to a database or similar.
        print("Created Contact: \(newContact)")
        presentationMode.wrappedValue.dismiss()
    }
}
