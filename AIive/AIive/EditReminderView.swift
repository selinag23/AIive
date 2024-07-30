import SwiftUI

struct EditReminderView: View {
    @Binding var reminder: Reminder
    @State private var title: String
    @State private var date: Date
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var description: String
    @State private var peopleRelated: String
    @State private var tag: String
    
    init(reminder: Binding<Reminder>) {
        self._reminder = reminder
        self._title = State(initialValue: reminder.wrappedValue.title)
        self._date = State(initialValue: reminder.wrappedValue.date)
        self._startTime = State(initialValue: reminder.wrappedValue.startTime)
        self._endTime = State(initialValue: reminder.wrappedValue.endTime)
        self._description = State(initialValue: reminder.wrappedValue.description)
        self._peopleRelated = State(initialValue: reminder.wrappedValue.peopleRelated)
        self._tag = State(initialValue: reminder.wrappedValue.tag)
    }
    
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

            
            Button(action: saveChanges) {
                Text("Save Changes")
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("Edit Reminder")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveChanges() {
        reminder.title = title
        reminder.date = date
        reminder.startTime = startTime
        reminder.endTime = endTime
        reminder.description = description
        reminder.peopleRelated = peopleRelated
        reminder.tag = tag
    }
}

