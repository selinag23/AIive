import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    
    let openAI = OpenAI(apiToken: "sk-proj-INDPlGmgqFASXMpDSmfST3BlbkFJiNLL4ekvAZjeJdT375K4")
    
    let initialPrompt = [Message(content: "You are a helpful assistant.", isUser: false)]
    

    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { 
                    print("ERROR: message is not in string")
                    return 
                }

                //let filter work
                self.processBotReply(message)
 
            case .failure(let failure):
                print(failure)
            }
        }
    }


    func processBotReply(_ reply: String) {
        // Parse the JSON string and handle messages based on the recipient
        if let data = reply.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                   let recipient = jsonObject["recipient"],
                   let message = jsonObject["message"] {
                    
                    DispatchQueue.main.async {
                        if recipient == "USER" {
                            self.messages.append(Message(content: message, isUser: false))
                        } else {
                            // Handle message to SERVER
                            let answer = self.processServerReply(data)

                            self.messages.append(Message(content: answer, isUser: false))
                        }
                    }
                }
            } catch {
                print("Failed to parse JSON reply: \(error)")
            }
        }
    }
    func processServerReply(_ reply: String) {
        if let data = reply.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let recipient = jsonObject["recipient"] as? String,
                   recipient == "SERVER",
                   let action = jsonObject["action"] as? String,
                   let message = jsonObject["message"] as? String {
                    
                    switch action {
                    case "INSERT":
                        handleInsertAction(message: message)
                    case "QUERY":
                        handleQueryAction(message: message)
                    default:
                        print("Unknown action: \(action)")
                    }
                }
            } catch {
                print("Failed to parse server reply: \(error)")
            }
        }
    }
    
    func handleInsertAction(message: String) {
        // Process the INSERT action message
        if let data = message.data(using: .utf8) {
            do {
                if let insertData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Handle the insertion of data
                    print("Insert action with data: \(insertData)")
                }
            } catch {
                print("Failed to parse INSERT message: \(error)")
            }
        }
    }
    
    func handleQueryAction(message: String) {
        // Process the QUERY action message
        print("Query action with message: \(message)")
    }

}

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(chatController.messages) {
                        message in
                        MessageView(message: message)
                            .padding(5)
                    }
                }
                Divider()
                HStack {
                    TextField("Message...", text: self.$string, axis: .vertical)
                        .padding(5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    Button {
                        self.chatController.sendNewMessage(content: string)
                        string = ""
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                .padding()
            }.background(Color.white) // Set a consistent background color for the entire view
                .navigationTitle("Chat")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden(true) // Hide default back button
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.blue) // Customize the color if needed
                                    }
                                }
                            }
            
        }
    }
}



struct MessageView: View {
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    Spacer()
                }
            }
        }
    }
}
