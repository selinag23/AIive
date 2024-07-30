import SwiftUI
import FMDB

struct CalendarEvent: Identifiable, Equatable {
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


struct CalendarView: View {
    @Binding var showChat: Bool
    @State private var selectedDate: Date? = Date()
    @State private var events: [CalendarEvent] = DatabaseManager.shared.fetchAllEvents()
    @State private var isShowingCreateEventView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CalendarDatePickerView(selectedDate: $selectedDate)
                    .padding(.top)
                
                if let date = selectedDate {
                    List {
                        ForEach(groupedEvents(for: date), id: \.key) { tag, events in
                            Section(header: Text(tag)) {
                                ForEach(events) { event in
                                    NavigationLink(destination: EditEventView(event: binding(for: event))) {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                if !event.tag.isEmpty {
                                                    Text(event.tag)
                                                        .font(.caption)
                                                        .padding(5)
                                                        .background(tagColor(for: event.tag))
                                                        .cornerRadius(5)
                                                        .foregroundColor(.white)
                                                }
                                                Text(event.title)
                                                    .font(.headline)
                                                Text("\(formattedTime(event.startTime)) - \(formattedTime(event.endTime))")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }.frame(maxWidth: .infinity, alignment: .leading)

                                            Spacer()
                                            Button(action: {
                                                markEventAsDone(event)
                                            }) {
                                                Image(systemName: event.done ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(event.done ? .green : .gray)
                                            }.buttonStyle(BorderlessButtonStyle())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .animation(.default, value: selectedDate)
                } else {
                    Text("Select a date to view events")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Calendar")
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
            .overlay(
                Button(action: {
                    isShowingCreateEventView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .padding()
                }
                .foregroundColor(.blue)
                .sheet(isPresented: $isShowingCreateEventView) {
                    CreateEventView(events: $events, selectedDate: selectedDate ?? Date())
                },
                alignment: .bottomTrailing
            )
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func binding(for event: CalendarEvent) -> Binding<CalendarEvent> {
        guard let index = events.firstIndex(of: event) else {
            fatalError("Event not found")
        }
        return $events[index]
    }
    
    private func markEventAsDone(_ event: CalendarEvent) {
        withAnimation {
            if let index = events.firstIndex(where: { $0.id == event.id }) {
                var updatedEvent = events[index]
                updatedEvent.done.toggle()
                events[index] = updatedEvent
                DatabaseManager.shared.updateEvent(updatedEvent)
            } else {
                print("Event not found: \(event.id)")
            }
        }
    }

    
    private func groupedEvents(for date: Date) -> [(key: String, value: [CalendarEvent])] {
        let eventsForDate = events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) && !$0.done }
        let grouped = Dictionary(grouping: eventsForDate) { $0.tag }
        return grouped.sorted(by: { $0.key < $1.key })
    }
}

struct CalendarDatePickerView: View {
    @Binding var selectedDate: Date?
    
    var body: some View {
        DatePicker(
            "Select Date",
            selection: Binding(
                get: { selectedDate ?? Date() },
                set: { selectedDate = $0 }
            ),
            displayedComponents: .date
        )
        .datePickerStyle(GraphicalDatePickerStyle())
        .padding()
    }
}


func tagColor(for tag: String) -> Color {
    switch tag {
    case "Meeting":
        return .blue
    case "Daily":
        return .green
    default:
        return .gray
    }
}
