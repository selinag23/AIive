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

class DatabaseManager {
    static let shared = DatabaseManager()
    private let database: FMDatabase
    
    private init() {
        let fileURL = try? FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("events.sqlite")
        
        guard let url = fileURL else {
            fatalError("Unable to access the file URL for the database.")
        }
        
        database = FMDatabase(url: url)
        
        if !database.open() {
            fatalError("Unable to open the database.")
        }
        
        do {
            try database.executeUpdate("""
                CREATE TABLE IF NOT EXISTS events (
                    id TEXT PRIMARY KEY,
                    title TEXT,
                    date DATE,
                    startTime DATE,
                    endTime DATE,
                    description TEXT,
                    peopleRelated TEXT,
                    tag TEXT,
                    addReminder INTEGER,
                    done INTEGER
                )
            """, values: nil)
        } catch {
            print("Failed to create table: \(error.localizedDescription)")
        }
    }
    
    func fetchEvents(for date: Date) -> [CalendarEvent] {
        var events = [CalendarEvent]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        do {
            let rs = try database.executeQuery("SELECT * FROM events WHERE date = ? ORDER BY tag", values: [dateString])
            while rs.next() {
                let event = CalendarEvent(
                    id: UUID(uuidString: rs.string(forColumn: "id")!)!,
                    title: rs.string(forColumn: "title")!,
                    date: rs.date(forColumn: "date")!,
                    startTime: rs.date(forColumn: "startTime")!,
                    endTime: rs.date(forColumn: "endTime")!,
                    description: rs.string(forColumn: "description")!,
                    peopleRelated: rs.string(forColumn: "peopleRelated")!,
                    tag: rs.string(forColumn: "tag")!,
                    addReminder: rs.bool(forColumn: "addReminder"),
                    done: rs.bool(forColumn: "done")
                )
                events.append(event)
            }
        } catch {
            print("Failed to fetch events: \(error.localizedDescription)")
        }
        
        return events
    }
    
    func addEvent(_ event: CalendarEvent) {
        do {
            try database.executeUpdate("""
                INSERT INTO events (id, title, date, startTime, endTime, description, peopleRelated, tag, addReminder, done)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, values: [
                event.id.uuidString,
                event.title,
                event.date,
                event.startTime,
                event.endTime,
                event.description,
                event.peopleRelated,
                event.tag,
                event.addReminder ? 1 : 0,
                event.done ? 1 : 0
            ])
        } catch {
            print("Failed to add event: \(error.localizedDescription)")
        }
    }
    
    func updateEvent(_ event: CalendarEvent) {
        do {
            try database.executeUpdate("""
                UPDATE events
                SET title = ?, date = ?, startTime = ?, endTime = ?, description = ?, peopleRelated = ?, tag = ?, addReminder = ?, done = ?
                WHERE id = ?
            """, values: [
                event.title,
                event.date,
                event.startTime,
                event.endTime,
                event.description,
                event.peopleRelated,
                event.tag,
                event.addReminder ? 1 : 0,
                event.done ? 1 : 0,
                event.id.uuidString
            ])
        } catch {
            print("Failed to update event: \(error.localizedDescription)")
        }
    }
}

struct CalendarView: View {
    @Binding var showChat: Bool
    @State private var selectedDate: Date? = Date()
    @State private var events: [CalendarEvent] = DatabaseManager.shared.fetchEvents(for: Date())
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


