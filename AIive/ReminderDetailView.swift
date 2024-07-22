import SwiftUI

struct ReminderDetailView: View {
    @Binding var reminder: Reminder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(reminder.title)
                .font(.title)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "calendar")
                Text(formattedDate(reminder.date))
            }
            .font(.headline)
            .padding(.bottom, 5)
            
            HStack {
                Image(systemName: "clock")
                Text("\(formattedTime(reminder.startTime)) - \(formattedTime(reminder.endTime))")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.bottom, 10)
            
            Text(reminder.description)
                .font(.body)
                .padding(.bottom, 10)
            
            HStack {
                Image(systemName: "person.2")
                Text("People Related: \(reminder.peopleRelated)")
            }
            .font(.body)
            .padding(.bottom, 10)
            
            HStack {
                Image(systemName: "tag")
                Text(reminder.tag)
                    .padding(5)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(5)
                    .foregroundColor(.blue)
            }
            .font(.body)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle("Reminder Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditReminderView(reminder: $reminder)) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
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
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
