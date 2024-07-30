import SwiftUI

struct CreateEventView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var events: [CalendarEvent]
    var selectedDate: Date
    
    @State private var title: String = ""
    @State private var date: Date
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    @State private var description: String = ""
    @State private var peopleRelated: String = ""
    @State private var tag: String = ""
    @State private var addReminder: Bool = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    init(events: Binding<[CalendarEvent]>, selectedDate: Date) {
        self._events = events
        self.selectedDate = selectedDate
        self._date = State(initialValue: selectedDate)
    }
    
    var body: some View {
        NavigationView {
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
                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("Add to Reminder", isOn: $addReminder)
                    }
                }
                
                Button(action: createEvent) {
                    Text("Create Event")
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Create Event")
            .navigationBarTitleDisplayMode(.inline)
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func createEvent() {
        if title.isEmpty {
            alertMessage = "Title cannot be empty."
            showAlert = true
            return
        }
        
        let newEvent = CalendarEvent(
            title: title,
            date: date,
            startTime: startTime,
            endTime: endTime,
            description: description,
            peopleRelated: peopleRelated,
            tag: tag,
            addReminder: addReminder
        )
        events.append(newEvent)
        DatabaseManager.shared.addEvent(newEvent)
        presentationMode.wrappedValue.dismiss()
    }
}
