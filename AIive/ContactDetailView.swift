import SwiftUI
import OpenAI

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
    
    private func updateDescription() {
        Task {
            do {
                let newDescription = try await BotDescription(contact: contact)
                print("new description is \(newDescription)")
                self.description = newDescription
            } catch {
                print("Failed to update description: \(error)")
            }
        }
    }
    
    // Function to format a contact's description using OpenAI's API
    private func BotDescription(contact: Contact) async throws -> String {
        // Initialize the OpenAI client with your API key
        /*let openAI = OpenAI(apiToken: "sk-proj-INDPlGmgqFASXMpDSmfST3BlbkFJiNLL4ekvAZjeJdT375K4")

        // The current description of the contact
        let currentDescription = contact.description + DatabaseManager.shared.findContactEventsString(for: contact)

        // Create an EditsQuery to reformat the description
        let query = EditsQuery(
            model: .gpt3_5Turbo,
            input: currentDescription,
            instruction: """
        Organize the description into the format:
        "Attribute1: Content\n
        Attribute2: Content\n
        Involved events: \n
        This person has attended something with A and B;..."
        Ensure each attribute and content pair, and new event is on a new line.
        """
        )
        print("query is: \(query)")
        do {
            // Send the query to OpenAI's edits endpoint and wait for the result
            let result = try await openAI.edits(query: query)
            print("result from GPT is \(result)")
            // Extract the updated description from the response
            if let newDescription = result.choices.first?.text {
                return newDescription.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                throw NSError(domain: "BotDescriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get a valid response"])
            }
        } catch {
            // Handle any errors that occur during the API call
            print("Error calling OpenAI API: \(error.localizedDescription)")
            throw error
        }*/
        let openAIcontact = OpenAI(apiToken: "sk-proj-INDPlGmgqFASXMpDSmfST3BlbkFJiNLL4ekvAZjeJdT375K4")
        var currentDescription = contact.description + DatabaseManager.shared.findContactEventsString(for: contact)
        let prompt = currentDescription + """
                    Organize the description into the format:
                    "Attribute1: Content\n
                    Attribute2: Content\n
                    Involved events: \n
                    This person has attended something with A and B;..."
                    Ensure each attribute and content pair, and new event is on a new line.
                    Only give me the modified answer! DO NOT INCLUDE ANY OTHER WORDS!
            """
        let query = ChatQuery(messages: [.init(role: .user, content: prompt)!], model: .gpt3_5Turbo)
        
        let result = try await openAIcontact.chats(query: query)
        print("result is: \(result)")

        // Extract the updated description from the response
        if let choice = result.choices.first, let messageContent = choice.message.content {
            if let trimmedContent = messageContent as? String {
                return trimmedContent.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                throw NSError(domain: "BotDescriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get a valid response"])
            }
        } else {
            throw NSError(domain: "BotDescriptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get a valid response"])
        }
        
        /*openAIcontact.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else { return }
                guard let messageContent = choice.message.content?.string else {
                    print("ERROR: message is not in string")
                    return
                }
                print("LINE 73 REPLY:\(messageContent)")
                //处理messageContent
            case .failure(let failure):
                print(failure)
            }
        }*/
    }
}
