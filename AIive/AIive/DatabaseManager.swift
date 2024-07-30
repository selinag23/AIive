//
//  DatabaseManager.swift
//  AIive
//
//  Created by Peiran Wang on 7/23/24.
//

import Foundation
import FMDB

func resetTimeToMidnight(date: Date) -> Date? {
    // Extract the components from the original date
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: date)
    
    // Set the time components to zero
    components.hour = 0
    components.minute = 0
    components.second = 0
    
    // Create a new date with the updated components
    return calendar.date(from: components)
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

                    try database.executeUpdate("""
                        CREATE TABLE IF NOT EXISTS contacts (
                            id TEXT PRIMARY KEY,
                            name TEXT,
                            position TEXT,
                            organization TEXT,
                            phone TEXT,
                            email TEXT,
                            socialMedia TEXT,
                            description TEXT
                        )
                    """, values: nil)
                } catch {
                    print("Failed to create table: \(error.localizedDescription)")
                }
            }
    
    func fetchAllEvents() -> [CalendarEvent] {
        var events = [CalendarEvent]()
        
        do {
            let rs = try database.executeQuery("SELECT * FROM events ORDER BY tag", values: nil)//测试，但恰好能用
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
                print("Fetched event: \(event)")
            }
        } catch {
            print("Failed to fetch events: \(error.localizedDescription)")
        }
        
        return events
    }
    
    func fetchEvents(for date: Date) -> [CalendarEvent] {
        var events = [CalendarEvent]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let midnight = resetTimeToMidnight(date: date)
        
        print("Show the date looks like: \(date)")
        print("Show the midnight date looks like: \(midnight!)")
        print("Fetching events for date: \(dateString)")
        do {
            let rs = try database.executeQuery("SELECT * FROM events WHERE date <= ? AND date >= ? ORDER BY tag", values: [date, midnight!])//测试，但恰好能用
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
                print("Fetched event: \(event)")
            }
        } catch {
            print("Failed to fetch events: \(error.localizedDescription)")
        }
        
        return events
    }
    
    func fetchContacts() -> [Contact] {
            var contacts = [Contact]()
            
            do {
                let rs = try database.executeQuery("SELECT * FROM contacts ORDER BY name", values: nil)
                while rs.next() {
                    let contact = Contact(
                        id: UUID(uuidString: rs.string(forColumn: "id")!)!,
                        name: rs.string(forColumn: "name")!,
                        position: rs.string(forColumn: "position")!,
                        organization: rs.string(forColumn: "organization")!,
                        phone: rs.string(forColumn: "phone")!,
                        email: rs.string(forColumn: "email")!,
                        socialMedia: rs.string(forColumn: "socialMedia")!,
                        description: rs.string(forColumn: "description")!
                    )
                    contacts.append(contact)
                }
            } catch {
                print("Failed to fetch contacts: \(error.localizedDescription)")
            }
            
            return contacts
     }
    
    func fetchReminders() -> [Reminder] {
        var reminders: [Reminder] = []
        let querySQL = "SELECT * FROM events WHERE done = 0 AND addReminder = 1 ORDER BY date, startTime"
        
        do {
            let rs = try database.executeQuery(querySQL, values: nil)
            while rs.next() {
                let reminder = Reminder(
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
                reminders.append(reminder)
                //reminder manager
                ReminderManager.shared.scheduleNotification(for: reminder)
                ReminderManager.shared.listScheduledNotifications()
            }
        } catch {
            print("Failed to fetch reminders: \(error.localizedDescription)")
        }
        return reminders
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
    
    func addContact(_ contact: Contact) {
            do {
                try database.executeUpdate("""
                    INSERT INTO contacts (id, name, position, organization, phone, email, socialMedia, description)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, values: [
                    contact.id.uuidString,
                    contact.name,
                    contact.position,
                    contact.organization,
                    contact.phone,
                    contact.email,
                    contact.socialMedia,
                    contact.description
                ])
            } catch {
                print("Failed to add contact: \(error.localizedDescription)")
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
    
    func updateContact(_ contact: Contact) {
            do {
                try database.executeUpdate("""
                    UPDATE contacts
                    SET name = ?, position = ?, organization = ?, phone = ?, email = ?, socialMedia = ?, description = ?
                    WHERE id = ?
                """, values: [
                    contact.name,
                    contact.position,
                    contact.organization,
                    contact.phone,
                    contact.email,
                    contact.socialMedia,
                    contact.description,
                    contact.id.uuidString
                ])
            } catch {
                print("Failed to update contact: \(error.localizedDescription)")
            }
        }
    
    func updateReminder(_ reminder: Reminder) {
        do {
            try database.executeUpdate("""
                UPDATE events
                SET done = 1
                WHERE id = ?
            """, values: [
                reminder.id.uuidString
            ])
        } catch {
            print("Failed to update event: \(error.localizedDescription)")
        }
    }
    
    func deleteContact(by id: UUID) {
            let query = "DELETE FROM Contacts WHERE id = ?"
            do {
                try database.executeUpdate(query, values: [id.uuidString])
            } catch {
                print("Failed to delete contact: \(error.localizedDescription)")
            }
        }
    
}
