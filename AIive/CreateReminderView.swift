import SwiftUI

struct CreateReminderView: View {
    @Binding var reminders: [Reminder]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    @State private var description: String = ""
    @State private var peopleRelated: String = ""
    @State private var tag: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Reminder Details")) {
                TextField("Title", text: $title)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                TextField("Description", text: $description)
                TextField("People Related", text: $peopleRelated)
                TextField("Tag", text: $tag)
            }
            
            Button(action: saveReminder) {
                Text("Save Reminder")
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("Create Reminder")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveReminder() {
        let newReminder = Reminder(
            title: title,
            date: date,
            startTime: startTime,
            endTime: endTime,
            description: description,
            peopleRelated: peopleRelated,
            tag: tag
        )
        reminders.append(newReminder)
        presentationMode.wrappedValue.dismiss()
    }
}

