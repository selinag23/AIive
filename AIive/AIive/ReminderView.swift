import SwiftUI
import FMDB
import Foundation

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

class ReminderManager {
    static let shared = ReminderManager()
    
    private init() {}
    
    func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminder.title
        content.sound = .default
        
        let triggerDate = reminder.startTime
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(reminder.startTime)")
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
