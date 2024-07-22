import SwiftUI

struct Reminder: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var description: String
    var peopleRelated: String
    var tag: String
    var done: Bool = false
}

struct ReminderView: View {
    @Binding var showChat: Bool
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
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(reminders) { reminder in
                        NavigationLink(destination: ReminderDetailView(reminder: binding(for: reminder))) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(reminder.title)
                                        .font(.headline)
                                    Text(formattedDate(reminder.date))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("\(formattedTime(reminder.startTime)) - \(formattedTime(reminder.endTime))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    markReminderAsDone(reminder)
                                }) {
                                    Image(systemName: reminder.done ? "checkmark.square" : "square")
                                        .foregroundColor(reminder.done ? .green : .gray)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: deleteReminder)
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
        if let index = reminders.firstIndex(of: reminder) {
            reminders[index].done.toggle()
        }
    }
    
    private func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}
