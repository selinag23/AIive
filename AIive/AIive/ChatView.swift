import SwiftUI
import OpenAI


// 定义 ChatMessage 结构体
struct ChatMessage {
    var role: String
    var content: String
}

// 定义 Message 结构体
struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
    var contact: [Contact]
    var time: [Date]
    var display: Bool
}

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    
    let openAI = OpenAI(apiToken: "sk-proj-INDPlGmgqFASXMpDSmfST3BlbkFJiNLL4ekvAZjeJdT375K4")
    
//    let initialPrompt = Message(content: "You act as the middleman between USER and a DATABASE, extract information from either user or database text. There are two databases, Contacts and Events. Contacts database has the following SCHEMA: ID, Name, Position, Organization, Phone, Email, SocialMedia, Description. Events database has the following SCHEMA: EventID, Title, Date, StartTime, EndTime, Detail, PeopleRelated, Tag, AddReminder, Done. From now you will only ever respond with JSON, which can only contain object 'recipient', 'action', 'target', 'message'. 'recipient' can only be either 'USER' or 'SERVER'. 'action' can only be 'INSERT' or 'QUERY'. 'target' can only be 'Contacts' or 'Events'. 'message' with recipient 'USER' should be natural language. 'message' with recipient 'SERVER' should be another JSON-like text, following either database's SCHEMA. For example, when you want to address the user, you use the following format {\"recipient\": \"USER\", \"message\":\"message for the user\"}. When you are given information to be added to the database, the message should be like '{\"recipient\":\"SERVER\", \"action\":\"INSERT\",  \"target\":\"Events\",\"message\":\" {'Title':'Group discussion for Course Linear Algebra', 'Date':'July 22, 2024', 'StartTime':'9:00', 'EndTime':'11:00', 'Detail':'In Longbin building', 'PeopleRelated': ['Shane Rowling', 'Xiaofang Wang'], 'Tag': 'meeting', 'AddReminder': true, 'Done':false }\"}' ", isUser: false, contact: [], time: [], display: true)
    
    let initialPrompt = Message(content: "You act as the middleman between USER and a DATABASE, extract information from either user or database text. There are two databases, Contacts and Events. Contacts database has the following SCHEMA: ID, Name, Position, Organization, Phone, Email, SocialMedia, Description. Events database has the following SCHEMA: EventID, Title, Date, StartTime, EndTime, Detail, PeopleRelated, Tag, AddReminder, Done. From now you will only ever respond with JSON, which can only contain object 'recipient', 'action', 'target', 'message'. 'recipient' can only be either 'USER' or 'SERVER'. 'action' can only be 'INSERT' or 'QUERY'. 'target' can only be 'Contacts' or 'Events'. 'message' with recipient 'USER' should be natural language. 'message' with recipient 'SERVER' should be another JSON-like text, following either database's SCHEMA. For example, when you want to address the user, you use the following format {\"recipient\": \"USER\", \"message\":\"message for the user\"}. When you are given information to be added to the database, the message should be like '{\"recipient\":\"SERVER\", \"action\":\"INSERT\",  \"target\":\"Events\",\"message\":\" {'Title':'Group discussion for Course Linear Algebra', 'Date':'July 22, 2024', 'StartTime':'9:00', 'EndTime':'11:00', 'Detail':'In Longbin building', 'PeopleRelated': ['Shane Rowling', 'Xiaofang Wang'], 'Tag': 'meeting', 'AddReminder': true, 'Done':false }\"}' ", isUser: false, contact: [
        Contact(
            name: "John Doe",
            position: "Software Engineer",
            organization: "Tech Corp",
            phone: "123-456-7890",
            email: "john.doe@example.com",
            socialMedia: "@johndoe",
            description: "A skilled software engineer with 5 years of experience."
        ),
        Contact(
            name: "Jane Doe",
            position: "Project Manager",
            organization: "Innovate Inc.",
            phone: "987-654-3210",
            email: "jane.doe@example.com",
            socialMedia: "@janedoe",
            description: "An experienced project manager leading multiple successful projects."
        )
    ], time: [Date(), Date().addingTimeInterval(3600)], display: true)

    init() {
        self.messages.append(initialPrompt)
    }
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true, contact: [], time: [], display: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map { .init(role: $0.isUser ? .user : .assistant, content: $0.content)! },
            model: .gpt3_5Turbo
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else { return }
                guard let messageContent = choice.message.content?.string else {
                    print("ERROR: message is not in string")
                    return
                }

                self.processBotReply(messageContent)
 
            case .failure(let failure):
                print(failure)
                self.messages.append(Message(content: "network error", isUser: false, contact: [], time: [], display: true))
            }
        }
    }

    func processBotReply(_ reply: String) {
        if let data = reply.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                   let recipient = jsonObject["recipient"],
                   let message = jsonObject["message"] {
                    DispatchQueue.main.async {
                        if recipient == "USER" {
                            self.messages.append(Message(content: message, isUser: false, contact: [], time: [], display: true))
                        } else {
                            let answer = self.processServerReply(reply)
                            self.messages.append(Message(content: answer, isUser: false, contact: [], time: [], display: true))
                        }
                    }
                }
            } catch {
                print("Failed to parse JSON reply: \(error)")
            }
        }
    }

    func processServerReply(_ reply: String) -> String {
        if let data = reply.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let recipient = jsonObject["recipient"] as? String,
                   recipient == "SERVER",
                   let action = jsonObject["action"] as? String,
                   let target = jsonObject["target"] as? String,
                   let message = jsonObject["message"] as? String {
                    
                    switch action {
                    case "INSERT":
                        switch target {
                        case "Contacts":
                            handleInsertAction(message: message)
                            return "Already insert to database Contact."
                        case "Events":
                            handleInsertAction(message: message)
                            return "Already insert to database Events."
                        default:
                            print("Unknown target: \(target)")
                        }

                    case "QUERY":
                        handleQueryAction(message: message)
                        switch target {
                        case "Contacts":
                            handleQueryAction(message: message)
                            return "Already query database Contact."
                        case "Events":
                            handleQueryAction(message: message)
                            return "Already query database Events."
                        default:
                            print("Unknown target: \(target)")
                        }
                    default:
                        print("Unknown action: \(action)")
                    }
                }
            } catch {
                print("Failed to parse server reply: \(error)")
            }
        }
        return ""
    }
    
    func handleInsertAction(message: String) {
        if let data = message.data(using: .utf8) {
            do {
                if let insertData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Insert action with data: \(insertData)")
                }
            } catch {
                print("Failed to parse INSERT message: \(error)")
            }
        }
    }
    
    func handleQueryAction(message: String) {
        print("Query action with message: \(message)")
    }
}

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(chatController.messages) { message in
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
            }
            .background(Color.white)
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
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
                    VStack(alignment: .leading) {
                        Text(message.content)
                        if message.display {
                            if !message.contact.isEmpty {
                                VStack(alignment: .trailing) {
                                    ForEach(message.contact) { contact in
                                        Button(action: {
                                            print("Contact button tapped: \(contact.name)")
                                        }) {
                                            Text(contact.name)
                                                .padding(5)
                                                .background(Color.blue)
                                                .foregroundColor(Color.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                            }

                            if !message.time.isEmpty {
                                VStack(alignment: .trailing) {
                                    ForEach(message.time, id: \.self) { time in
                                        Button(action: {
                                            print("Time button tapped: \(time)")
                                        }) {
                                            Text(formattedTime(time))
                                                .padding(5)
                                                .background(Color.green)
                                                .foregroundColor(Color.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            else {
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(message.content)
                        if message.display {
                            if !message.contact.isEmpty {
                                VStack(alignment: .leading) {
                                    ForEach(message.contact) { contact in
                                        Button(action: {
                                            print("Contact button tapped: \(contact.name)")
                                        }) {
                                            Text(contact.name)                                                .padding(5)
                                                .background(Color.blue)
                                                .foregroundColor(Color.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                            }

                            if !message.time.isEmpty {
                                VStack(alignment: .trailing) {
                                    ForEach(message.time, id: \.self) { time in
                                        Button(action: {
                                            print("Time button tapped: \(time)")
                                        }) {
                                            Text(formattedTime(time))
                                                .padding(5)
                                                .background(Color.green)
                                                .foregroundColor(Color.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black)
                .foregroundColor(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }
    }
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


//import SwiftUI
//import OpenAI
//
//struct ChatMessage {
//    var role: String
//    var content: String
//}
//
//struct Message: Identifiable {
//    var id: UUID = .init()
//    var content: String
//    var isUser: Bool
//    var contact: [Contact]
//    var time: [Date]
//    var display: Bool
//}
//
//class ChatController: ObservableObject {
//    @Published var messages: [Message] = []
//
//    let openAI = OpenAI(apiToken: "sk-proj-INDPlGmgqFASXMpDSmfST3BlbkFJiNLL4ekvAZjeJdT375K4")
//
//    let initialPrompt = Message(content: "You act as the middleman between USER and a DATABASE, extract information from either user or database text. There are two database, Contacts and Events. Contacts database has following SCHEMA: ID, Name, Position, Organization, Phone, Email, SocialMedia, Description. Events database has following SCHEMA: EventID, Title, Date, StartTime, EndTime, Detail, PeopleRelated, Tag, AddReminder, Done. From now you will only ever respond with JSON, which only can contain object 'recipient', 'action', 'target', 'message'. 'recipient' can only be either 'USER' or 'SERVER'. 'action' can only be 'INSERTt' or 'QUERY'. 'target' can only be 'Contacts' or 'Events'. 'message' with recipient 'USER' should be natural language. 'message' with recipient 'SERVER' should be another json like text, following either database's SCHEMA. For example, when you want to address the user, you use the following format {\"recipient\": \"USER\", \"message\":\"message for the user\"}. when you are given information to be added to database, message should be like '{\"recipient\":\"SERVER\", \"action\":\"INSERT\",  \"target\":\"Events\",\"message\":\" {'Title':'Group discussion for Course Linear Algebra', 'Date':'July 22, 2024', 'StartTime':'9:00', 'EndTime':'11:00', 'Detail':'In Longbin building', 'PeopleRelated': ['Shane Rowlilng', 'Xiaofang Wang'], 'Tag': 'meeting', 'AddReminder': true, 'Done':false }\"}' ", isUser: false, contact: [], time: [], display: true)
//
//
//    init() {
//        self.messages.append(initialPrompt)
//    }
//
//    func sendNewMessage(content: String) {
//        let userMessage = Message(content: content, isUser: true, contact: [], time: [], display: true)
//        self.messages.append(userMessage)
//        getBotReply()
//    }
//
//    func getBotReply() {
//        //var queryMessages = self.messages.map {
//        //    ChatMessage(role: $0.isUser ? "user" : "assistant", content: $0.content)
//        //}
//        //queryMessages.insert(initialPrompt, at: 0)
//
//
//        let query = ChatQuery(
//            messages: self.messages.map{.init(role: $0.isUser ? .user : .assistant, content: $0.content)!},
//            model: .gpt3_5Turbo
//        )
//
//        openAI.chats(query: query) { result in
//            switch result {
//            case .success(let success):
//                guard let choice = success.choices.first else {
//                    return
//                }
//                guard let messageContent = choice.message.content?.string else {
//                    print("ERROR: message is not in string")
//                    return
//                }
//
//                //let filter work
//                self.processBotReply(messageContent)
//
//            case .failure(let failure):
//                print(failure)
//                self.messages.append(Message(content: "network error", isUser: false, contact: [], time: [], display: true))
//            }
//        }
//    }
//
//
//    func processBotReply(_ reply: String) {
//        // Parse the JSON string and handle messages based on the recipient
//        if let data = reply.data(using: .utf8) {
//            do {
//                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
//                   let recipient = jsonObject["recipient"],
//                   let message = jsonObject["message"] {
//                    DispatchQueue.main.async {
//                        if recipient == "USER" {
//                            self.messages.append(Message(content: message, isUser: false, contact: [], time: [], display: true))
//                        } else {
//                            // Handle message to SERVER
//                            let answer = self.processServerReply(reply)
//
//                            self.messages.append(Message(content: answer, isUser: false, contact: [], time: [], display: true))
//                        }
//                    }
//                }
//            } catch {
//                print("Failed to parse JSON reply: \(error)")
//            }
//        }
//    }
//
//    func processServerReply(_ reply: String)->String {
//        if let data = reply.data(using: .utf8) {
//            do {
//                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let recipient = jsonObject["recipient"] as? String,
//                   recipient == "SERVER",
//                   let action = jsonObject["action"] as? String,
//                   let target = jsonObject["target"] as? String,
//                   let message = jsonObject["message"] as? String {
//
//                    switch action {
//                    case "INSERT":
//                        switch target{
//                        case "Contacts":
//                            handleInsertAction(message: message)
//                            return "Already insert to database Contact."
//                        case "Events":
//                            handleInsertAction(message: message)
//                            return "Already insert to database Events."
//                        default:
//                            print("Unknown target:\(target)")
//                        }
//
//                    case "QUERY":
//                        handleQueryAction(message: message)
//                        switch target{
//                        case "Contacts":
//                            handleQueryAction(message: message)
//                            return "Already query database Contact."
//                        case "Events":
//                            handleQueryAction(message: message)
//                            return "Already query database Events."
//                        default:
//                            print("Unknown target:\(target)")
//                        }
//                    default:
//                        print("Unknown action: \(action)")
//                    }
//                }
//            } catch {
//                print("Failed to parse server reply: \(error)")
//            }
//        }
//        return ""
//    }
//
//    func handleInsertAction(message: String) {
//        // Process the INSERT action message
//        if let data = message.data(using: .utf8) {
//            do {
//                if let insertData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // Handle the insertion of Event or Contacts
//
//                    print("Insert action with data: \(insertData)")
//                }
//            } catch {
//                print("Failed to parse INSERT message: \(error)")
//            }
//        }
//    }
//
//    func handleQueryAction(message: String) {
//        // Process the QUERY action message
//        print("Query action with message: \(message)")
//    }
//
//}
//
//struct ChatView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject var chatController: ChatController = .init()
//    @State var string: String = ""
//    var body: some View {
//        NavigationView {
//            VStack {
//                ScrollView {
//                    ForEach(chatController.messages) {
//                        message in
//                        MessageView(message: message)
//                            .padding(5)
//                    }
//                }
//                Divider()
//                HStack {
//                    TextField("Message...", text: self.$string, axis: .vertical)
//                        .padding(5)
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(15)
//                    Button {
//                        self.chatController.sendNewMessage(content: string)
//                        string = ""
//                    } label: {
//                        Image(systemName: "paperplane")
//                    }
//                }
//                .padding()
//            }.background(Color.white) // Set a consistent background color for the entire view
//                .navigationTitle("Chat")
//                            .navigationBarTitleDisplayMode(.inline)
//                            .navigationBarBackButtonHidden(true) // Hide default back button
//                            .toolbar {
//                                ToolbarItem(placement: .navigationBarLeading) {
//                                    Button(action: {
//                                        presentationMode.wrappedValue.dismiss()
//                                    }) {
//                                        Image(systemName: "chevron.left")
//                                            .foregroundColor(.blue) // Customize the color if needed
//                                    }
//                                }
//                            }
//
//        }
//    }
//}
//
//
//
//struct MessageView: View {
//    var message: Message
//    var body: some View {
//        Group {
//            if message.isUser {
//                HStack {
//                    Spacer()
//                    Text(message.content)
//                        .padding()
//                        .background(Color.gray)
//                        .foregroundColor(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 30))
//                }
//            } else {
//                HStack {
//                    Text(message.content)
//                        .padding()
//                        .background(Color.black)
//                        .foregroundColor(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 30))
//                    Spacer()
//                }
//            }
//        }
//    }
//    private func formattedTime(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//}
