import SwiftUI

struct ContactDetailView: View {
    @State var contact: Contact
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(contact.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            HStack {
                Button(action: {
                    callContact(phoneNumber: contact.phone)
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.white)
                        Text("Call")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                }
                .padding(.trailing, 16)
                
                Button(action: {
                    messageContact(phoneNumber: contact.phone)
                }) {
                    HStack {
                        Image(systemName: "message.fill")
                            .foregroundColor(.white)
                        Text("Message")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            .padding(.bottom, 16)
            HStack {
                Text("Position:").fontWeight(.bold)
                Text(contact.position)
            }
            
            HStack {
                Text("Organization:").fontWeight(.bold)
                Text(contact.organization)
            }
            
            HStack {
                Text("Phone:").fontWeight(.bold)
                Text(contact.phone)
            }
            
            HStack {
                Text("Email:").fontWeight(.bold)
                Text(contact.email)
            }
            
            HStack {
                Text("Social Media:").fontWeight(.bold)
                Text(contact.socialMedia)
            }
            
            Text("Description:")
                .fontWeight(.bold)
            Text(contact.description)
            
            Spacer()
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle("Contact Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditContactView(contact: $contact)) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    func callContact(phoneNumber: String) {
        print("Calling \(phoneNumber)")
    }
    
    func messageContact(phoneNumber: String) {
        print("Messaging \(phoneNumber)")
    }
}
