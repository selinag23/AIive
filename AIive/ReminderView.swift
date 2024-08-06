import SwiftUI
import FMDB
import Foundation
import OpenAI

struct Reminder: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var description: String
    var peopleRelated: String
    var tag: String
    var addReminder: Bool = false
    var done: Bool = false
}

struct ChatMessage: Codable {
    let role: String
    let content: String
}

struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double
}

struct ChatChoice: Codable {
    let message: ChatMessage
}

struct ChatCompletionResponse: Codable {
    let choices: [ChatChoice]
}

class ReminderManager {
    static let shared = ReminderManager()
    
    private init() {}
    
    func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminder.title
        content.sound = .default
        
        var something = 0
        suggestReminderTime(tag: reminder.tag, title: reminder.title, startTime: reminder.startTime, endTime: reminder.endTime) { reminderMinutes in
            if let reminderMinutes = reminderMinutes {
                something = reminderMinutes
                print("GPT answer is \(something) minutes")
            } //else {
                //print("Failed to get a reminder time.")
            //}
        }
        
        let triggerDate = Calendar.current.date(byAdding: .minute, value: -something, to: reminder.startTime) ?? reminder.startTime
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(triggerDate)")
            }
        }
    }
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("Pending notification: \(request.identifier) at \(String(describing: request.trigger))")
            }
        }
    }
    
    func removeNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
    
    func calculateRemindingTime(for reminder: Reminder) -> Date {
        // Step 1: The initial reminding time is the start time
        var remindingTime = reminder.startTime
        
        // Step 2: If the tag is "exam" then 30 min ahead
        if reminder.tag.lowercased() == "exam" {
            remindingTime = Calendar.current.date(byAdding: .minute, value: -30, to: remindingTime) ?? remindingTime
        }
        
        // Step 3: If the tag is "meeting" then 15 min ahead
        else if reminder.tag.lowercased() == "meeting" {
            remindingTime = Calendar.current.date(byAdding: .minute, value: -15, to: remindingTime) ?? remindingTime
        }
        
        // Step 4: For other tags, remain the same
        // This step is implicitly handled as we don't modify the reminding time for other tags
        
        // Step 5: If the duration is within 1 hour, then 0 more min ahead
        // Step 6: If the duration is longer than 1 hour, then 10 more min ahead
        let duration = reminder.endTime.timeIntervalSince(reminder.startTime)
        if duration > 3600 {
            remindingTime = Calendar.current.date(byAdding: .minute, value: -10, to: remindingTime) ?? remindingTime
        }
        
        return remindingTime
    }

    func suggestReminderTime(tag: String, title: String, startTime: Date, endTime: Date, completion: @escaping (Int?) -> Void) {
        let apiKey = "sk-proj-INDPlGmgqFASXMpDSmfST3BlbkFJiNLL4ekvAZjeJdT375K4" // Replace with your actual API key
        let endpoint = "https://api.openai.com/v1/chat/completions"

        let prompt = """
        Given the following details:
        - Tag: \(tag)
        - Title: \(title)
        - Start Time: \(startTime)
        - End Time: \(endTime)
        
        How many minutes in advance should I set a reminder for this event?
        Please respond with an integer value only.
        """

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are an assistant that provides reminder suggestions."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        print("defination completed")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        print("request completed")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize request body: \(error)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String,
                   let minutes = Int(content.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    completion(minutes)
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to parse response: \(error)")
                completion(nil)
            }
        }
        print("task resume?")
        task.resume()
    }
    

    // Helper function to format date and time
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    // Example Usage
    /*let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let startTime = dateFormatter.date(from: "2024/07/22 14:00")!
    let endTime = dateFormatter.date(from: "2024/07/22 16:00")!
    let reminder = Reminder(startTime: startTime, endTime: endTime, tag: "meeting")
    let remindingTime = calculateRemindingTime(for: reminder)
    
    print("Reminding Time: \(dateFormatter.string(from: remindingTime))")
    */
}


struct ReminderView: View {
    @Binding var showChat: Bool
    /*
    @State private var reminders: [Reminder] = [
        Reminder(
            title: "Buy groceries",
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            description: "Buy groceries for the week",
            peopleRelated: "N/A",
            tag: "Personal"
        ),
        Reminder(
            title: "Doctor appointment",
            date: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!,
            startTime: Date().addingTimeInterval(3600 * 3),
            endTime: Date().addingTimeInterval(3600 * 4),
            description: "Routine check-up",
            peopleRelated: "N/A",
            tag: "Health"
        ),
        Reminder(
            title: "Meeting with team",
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            startTime: Date().addingTimeInterval(86400),
            endTime: Date().addingTimeInterval(86400 + 3600),
            description: "Discuss project milestones",
            peopleRelated: "Team",
            tag: "Work"
        )
    ].sorted { $0.startTime < $1.startTime }
    */
    @State private var reminders: [Reminder] = DatabaseManager.shared.fetchReminders()

    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(reminders) { reminder in
                        HStack {
                            VStack(alignment: .leading) {
                                if !reminder.tag.isEmpty {
                                    Text(reminder.tag)
                                        .font(.caption)
                                        .padding(5)
                                        .background(tagColor(for: reminder.tag))
                                        .cornerRadius(5)
                                        .foregroundColor(.white)
                                }
                                Text(reminder.title)
                                    .font(.headline)
                                Text(formattedDate(reminder.date))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("\(formattedTime(reminder.startTime)) - \(formattedTime(reminder.endTime))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Button(action: {
                                markReminderAsDone(reminder)
                            }) {
                                Image(systemName: reminder.done ? "checkmark.square" : "square")
                                    .foregroundColor(reminder.done ? .green : .gray)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .background(
                            NavigationLink(destination: EditReminderView(reminder: binding(for: reminder))) {
                                EmptyView()
                            }
                            .opacity(0)
                        )
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: deleteReminder)
                }
                .refreshable {
                    loadReminders()
                }
                NavigationLink(destination: CreateReminderView(reminders: $reminders)) {
                    Text("Create Reminder")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Reminders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showChat = true
                    }) {
                        Image(systemName: "message")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
        }
        .onAppear {
            loadReminders()
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func binding(for reminder: Reminder) -> Binding<Reminder> {
        guard let index = reminders.firstIndex(of: reminder) else {
            fatalError("Reminder not found")
        }
        return $reminders[index]
    }
    
    private func markReminderAsDone(_ reminder: Reminder) {
        withAnimation(){
            if let index = reminders.firstIndex(of: reminder) {
                reminders[index].done.toggle()
                DatabaseManager.shared.updateReminder(reminders[index])
                if reminders[index].done {
                    ReminderManager.shared.removeNotification(for: reminders[index])
                } else {
                    ReminderManager.shared.scheduleNotification(for: reminders[index])
                }
                loadReminders()
            }
        }
    }
    
    private func loadReminders() {
        reminders = DatabaseManager.shared.fetchReminders()
    }
    
    private func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}
