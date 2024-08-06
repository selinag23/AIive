let jsonString = "{'Title':'Meeting with John and Jason', 'Date':'2024-08-03', 'StartTime':'2024-08-03 09:00:00', 'EndTime':'2024-08-03 11:00:00', 'Detail':'', 'PeopleRelated':['John', 'Jason'], 'Tag':'meeting', 'AddReminder':false, 'Done':false}".replacingOccurrences(of: "'", with: "\"")

if let event = parseEvent(jsonString: jsonString) {
    print("Parsed event: \(event)")
} else {
    print("Failed to parse event")
}