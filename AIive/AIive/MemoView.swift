import SwiftUI
import OpenAI

struct Memo: Identifiable {
    var id = UUID()
    var title: String
    var context: String
    var date: Date
}

struct MemoView: View {
    @Binding var showChat: Bool
    @State private var memos: [Memo] = []
    @State private var isAddingMemo = false
    @StateObject private var memoOpenAI = MemoOpenAI()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(groupedMemos.keys.sorted(by: >), id: \.self) { date in
                        Section(header: Text(formattedDate(date))) {
                            ForEach(groupedMemos[date]!) { memo in
                                NavigationLink(destination: MemoDetailView(memo: $memos[getIndex(of: memo)], onUpdate: { updatedMemo in
                                    updateMemo(updatedMemo)
                                })) {
                                    VStack(alignment: .leading) {
                                        Text(memo.title)
                                            .font(.headline)
                                        Text("\(memo.date, formatter: DateFormatter.shortTimeFormatter)")
                                            .font(.caption)
                                    }
                                    .padding(.vertical, 4)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deleteMemo(memo)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Memo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        isAddingMemo = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                    }
                    Button(action: createSummaryMemo) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showChat = true
                    }) {
                        Image(systemName: "message")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
            .sheet(isPresented: $isAddingMemo) {
                AddMemoView(memos: $memos)
            }
            .onAppear {
                memos = MemoDB.shared.fetchMemos()
            }
        }
    }
    
    private var groupedMemos: [Date: [Memo]] {
        Dictionary(grouping: memos) { memo in
            Calendar.current.startOfDay(for: memo.date)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func getIndex(of memo: Memo) -> Int {
        return memos.firstIndex(where: { $0.id == memo.id })!
    }
    
    private func deleteMemo(_ memo: Memo) {
        MemoDB.shared.deleteMemo(memo: memo)
        memos.removeAll { $0.id == memo.id }
    }
    
    private func updateMemo(_ memo: Memo) {
        MemoDB.shared.updateMemo(memo: memo)
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        }
    }
    

    
    private func createSummaryMemo() {
        let today = Date()
        let events = DatabaseManager.shared.fetchEvents(for: today)
        
        if events.isEmpty {
            let newMemo = Memo(title: "Summary of the Day", context: "No Events Today!", date: today)
            MemoDB.shared.addMemo(memo: newMemo)
            memos.append(newMemo)
        } else {
            // Prepare the raw event details to be sent to ChatGPT
            var eventsDetails = "Today's Events:\n"
            for event in events {
                eventsDetails += """
                {
                    "Title": "\(event.title)",
                    "Date": "\(event.date)",
                    "StartTime": "\(event.startTime)",
                    "EndTime": "\(event.endTime)",
                    "Description": "\(event.description)",
                    "PeopleRelated": "\(event.peopleRelated)",
                    "Tag": "\(event.tag)"
                }
                """
            }
            
            // Use MemoOpenAI to generate a natural language summary
            memoOpenAI.generateSummary(from: eventsDetails) { summary in
                let newMemo = Memo(title: "Summary of the Day", context: summary, date: today)
                MemoDB.shared.addMemo(memo: newMemo)
                memos.append(newMemo)
            }
        }
    }
}

struct MemoDetailView: View {
    @Binding var memo: Memo
    var onUpdate: (Memo) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Title", text: $memo.title)
                .onChange(of: memo.title) { newValue in
                    onUpdate(memo)
                }
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextEditor(text: $memo.context)
                .onChange(of: memo.context) { newValue in
                    onUpdate(memo)
                }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Memo Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddMemoView: View {
    @Binding var memos: [Memo]
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var context: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                }
                Section(header: Text("Context")) {
                    TextEditor(text: $context)
                        .frame(height: 150)
                }
            }
            .navigationTitle("Add Memo")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let newMemo = Memo(title: title, context: context, date: Date())
                MemoDB.shared.addMemo(memo: newMemo)
                memos.append(newMemo)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

extension DateFormatter {
    static var shortTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }
}
