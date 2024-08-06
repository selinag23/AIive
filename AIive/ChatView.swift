import SwiftUI
import OpenAI


// 定义 ChatMessage 结构体
/*struct ChatMessage {
    var role: String
    var content: String
}*/

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
    //@Binding var events: [CalendarEvent]
    
    @Published var messages: [Message] = []
    
    let openAI = OpenAI(apiToken: "sk-proj-INDPlGmgqFASXMpDSmfST3BlbkFJiNLL4ekvAZjeJdT375K4")
    
    let initialPrompt = Message(content: "You act as the middleman between USER and a DATABASE, extract information from either user or database text. From now you will only ever respond with JSON, which can only contain object 'recipient', 'action', 'target', 'message'. 'recipient' can only be either 'USER' or 'SERVER'. 'action' can only be 'INSERT' or 'QUERY'. 'target' can only be 'Contacts' or 'Events'. 'message' with recipient 'USER' should be natural language. 'message' with recipient 'SERVER' should be another JSON-like text, following either database's SCHEMA.  There are two databases, Contacts and Events. Contacts database has the following SCHEMA: Name, Position, Organization, Phone, Email, SocialMedia, Description. Name cannot be blank. Events database has the following SCHEMA: Title, Date, StartTime, EndTime, Detail, PeopleRelated, Tag, AddReminder, Done. By default, Done is always false; AddReminder is true if you are told to set a reminder, otherwise false. Date, StartTime and EndTime should follow the sqlite Date format. Title, Detail,and Tag should be summarized by you if not given. Before INSERTing any information to server, you have to first ask USER for remaining information and confirmation. For example, when you want to address the user, you use the following format {\"recipient\": \"USER\", \"message\":\"message for the user\"}. When you are given information to be added to the database, the message should be like '{\"recipient\":\"SERVER\", \"action\":\"INSERT\",  \"target\":\"Events\",\"message\":\" {'Title':'Group discussion for Course Linear Algebra', 'Date':'2024-08-02', 'StartTime':'2024-08-02 09:00:00', 'EndTime':'2024-08-02 11:00:00', 'Detail':'In Longbin building', 'PeopleRelated': 'Shane Rowling, Xiaofang Wang', 'Tag': 'meeting', 'AddReminder': true}\"}' ", isUser: false, contact: [], time: [], display: true)
    


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
                print("LINE 73 REPLY:\(messageContent)")
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
                        } else if recipient == "SERVER" {
                            print("start process server reply")
                            let answer = self.processServerReply(reply)
                            self.messages.append(Message(content: answer, isUser: false, contact: [], time: [], display: true))

                        } else{
                            self.messages.append(Message(content: reply, isUser: false, contact: [], time: [], display: true))
                            print("bot reply recipient is wrong")
                        }
                    }
                }
            } catch {
                self.messages.append(Message(content: reply, isUser: false, contact: [], time: [], display: true))
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
                   let target = jsonObject["target"] as? String{
                    
                    switch action {
                    case "INSERT":
                        print("start to insert something")
                        switch target {
                        case "Contacts":
                            handleInsertContacts(message: reply)
                            return "Already insert to database Contact."
                        case "Events":
                            handleInsertEvents(message: reply)
                            return "Already insert to database Events."
                        default:
                            print("Unknown target: \(target)")
                        }

                    case "QUERY":
                        //handleQueryAction(message: message)
                        switch target {
                        case "Contacts":
                            let ContactReply = handleQueryContacts() 
                            self.messages.append(Message(content: ContactReply, isUser: true, contact: [], time: [], display: true))//test query
                            getBotReply()
                            return "Already query database Contact."
                        case "Events":
                            let EventReply = handleQueryEvents()
                            self.messages.append(Message(content: EventReply, isUser: true, contact: [], time: [], display: true))//test query
                            getBotReply()
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
        return "Thank you, I see."//万能敷衍句式
    }
    
    
    func parseEvent(from jsonString: String) -> CalendarEvent? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = Date()
        let dateFormatterDateOnly = DateFormatter()
        dateFormatterDateOnly.dateFormat = "yyyy-MM-dd"
        let defaultDateString = dateFormatterDateOnly.string(from: currentDate)
        let defaultStartTimeString = dateFormatter.string(from: currentDate)
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error: Could not convert string to data")
            return nil
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               var messageString = json["message"] as? String {
                
                // Replace single quotes with double quotes for valid JSON
                messageString = messageString.replacingOccurrences(of: "'", with: "\"")
                
                if let messageData = messageString.data(using: .utf8),
                   let message = try JSONSerialization.jsonObject(with: messageData, options: []) as? [String: Any] {
                    
                    let title = message["Title"] as? String ?? ""
                    let dateString = message["Date"] as? String ?? defaultDateString
                    let startTimeString = message["StartTime"] as? String ?? defaultStartTimeString
                    let endTimeString = message["EndTime"] as? String ?? defaultStartTimeString
                    let peopleRelated = message["PeopleRelated"] as? String ?? ""
                    let tag = message["Tag"] as? String ?? ""
                    let addReminder = message["AddReminder"] as? Bool ?? false
                    let done = message["Done"] as? Bool ?? false
                    let description = message["Detail"] as? String ?? ""

                    guard let date = dateFormatterDateOnly.date(from: dateString),
                          let startTime = dateFormatter.date(from: startTimeString),
                          let endTime = dateFormatter.date(from: endTimeString) else {
                        print("Error: Date format is incorrect")
                        return nil
                    }
                    
                    return CalendarEvent(title: title, date: date, startTime: startTime, endTime: endTime, description: description, peopleRelated: peopleRelated, tag: tag, addReminder: addReminder, done: done)
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return nil
    }


    func parseContact(from jsonString: String) -> Contact? {
        print("start parse contact")
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error: Could not convert string to data")
            return nil
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
            var messageString = json["message"] as? String {
                
                // Replace single quotes with double quotes for valid JSON
                messageString = messageString.replacingOccurrences(of: "'", with: "\"")
                
                if let messageData = messageString.data(using: .utf8),
                let message = try JSONSerialization.jsonObject(with: messageData, options: []) as? [String: Any] {
                    
                    guard let name = message["Name"] as? String,
                        let position = message["Position"] as? String,
                        let organization = message["Organization"] as? String,
                        let phone = message["Phone"] as? String else {
                        print("Error: Missing or invalid fields in JSON")
                        return nil
                    }
                    
                    let email = message["Email"] as? String ?? ""
                    let socialMedia = message["SocialMedia"] as? String ?? ""
                    let description = message["Description"] as? String ?? ""
                    print("succesfully parse contact")
                    return Contact(name: name, position: position, organization: organization, phone: phone, email: email, socialMedia: socialMedia, description: description)
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return nil
    }

    func handleInsertContacts(message: String) {
        print("start handle insert contacts")
        guard let contact = parseContact(from: message) else {
            print("Failed to parse contact from message")
            return
        }
        DatabaseManager.shared.addContact(contact)
        print("Contact successfully added to the database")
    }
    
    func handleInsertEvents(message: String) {
    // Parse the JSON to get event details
        print("start to handle insert event")
        guard let event = parseEvent(from: message) else {
            print("Failed to parse event from message")
            return
        }
        // Add the event to the database
        //events.append(event)
        DatabaseManager.shared.addEvent(event)
        if let mostSimilarContact = DatabaseManager.shared.findMostSimilarContact(name: event.peopleRelated) {
            // Add the connection between the event and the contact
            DatabaseManager.shared.addEventContactConnection(eventID: event.id, contactID: mostSimilarContact.id)
            print("Successfully add event-contact connection: \(event.title)-\(mostSimilarContact.name)")
        }
        print("Event successfully added to the database")
    }

    func handleQueryEvents() -> String {
        let events = DatabaseManager.shared.fetchAllEvents()
        guard !events.isEmpty else {
            return "No events found for the specified date."
        }
        
        var eventDetails = ""
        for event in events {
            eventDetails += """
            Title: \(event.title)
            Date: \(DateFormatter.localizedString(from: event.date, dateStyle: .medium, timeStyle: .none))
            Start Time: \(DateFormatter.localizedString(from: event.startTime, dateStyle: .none, timeStyle: .short))
            End Time: \(DateFormatter.localizedString(from: event.endTime, dateStyle: .none, timeStyle: .short))
            Description: \(event.description)
            People Related: \(event.peopleRelated)
            Tag: \(event.tag)
            """
        }
        
        return eventDetails
    }

    func handleQueryContacts() -> String {
    // Fetch all contacts from the database
        let contacts = DatabaseManager.shared.fetchContacts()
        
        guard !contacts.isEmpty else {
            return "No contacts found."
        }

        var contactDetails = "Contacts:\n"
        
        for contact in contacts {
            contactDetails += """
            Name: \(contact.name)
            Position: \(contact.position)
            Organization: \(contact.organization)
            Phone: \(contact.phone)
            Email: \(contact.email)
            Social Media: \(contact.socialMedia)
            Description: \(contact.description) \n
            """
        }
        
        return contactDetails
    }

//Newly Added////////////////////////////////////
//    func generateSummary(from eventsDetails: String, completion: @escaping (String) -> Void) {
//        let userMessage = Message(content: eventsDetails, isUser: true, contact: [], time: [], display: false)
//        self.messages.append(userMessage)
//        
//        let query = ChatQuery(
//            messages: self.messages.map { .init(role: $0.isUser ? .user : .assistant, content: $0.content)! },
//            model: .gpt3_5Turbo
//        )
//        
//        openAI.chats(query: query) { result in
//            switch result {
//            case .success(let success):
//                guard let choice = success.choices.first else { return }
//                guard let messageContent = choice.message.content?.string else {
//                    print("ERROR: message is not in string")
//                    return
//                }
//                completion(messageContent)
//            case .failure(let failure):
//                print(failure)
//                completion("Unable to generate summary. Please try again.")
//            }
//        }
//    }

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


