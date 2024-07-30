import SwiftUI

struct EditEventView: View {
    @Binding var event: CalendarEvent
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var date: Date
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var description: String
    @State private var peopleRelated: String
    @State private var tag: String
    
    init(event: Binding<CalendarEvent>) {
        self._event = event
        self._title = State(initialValue: event.wrappedValue.title)
        self._date = State(initialValue: event.wrappedValue.date)
        self._startTime = State(initialValue: event.wrappedValue.startTime)
        self._endTime = State(initialValue: event.wrappedValue.endTime)
        self._description = State(initialValue: event.wrappedValue.description)
        self._peopleRelated = State(initialValue: event.wrappedValue.peopleRelated)
        self._tag = State(initialValue: event.wrappedValue.tag)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Title:")
                    TextField("Title", text: $title)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description:")
                    TextField("Description", text: $description)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("People Related:")
                    TextField("People Related", text: $peopleRelated)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tag:")
                    TextField("Tag", text: $tag)
                }
            }
            
            Button(action: saveChanges) {
                Text("Save Changes")
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("Edit Event")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
                .foregroundColor(.blue)
        })
    }
    
    private func saveChanges() {
        event.title = title
        event.date = date
        event.startTime = startTime
        event.endTime = endTime
        event.description = description
        event.peopleRelated = peopleRelated
        event.tag = tag
        
        // Update event in database
        DatabaseManager.shared.updateEvent(event)
        
        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
}
