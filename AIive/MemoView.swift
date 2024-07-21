import SwiftUI

struct Memo: Identifiable {
    var id = UUID()
    var title: String
    var context: String
    var date: Date
}

struct MemoView: View {
    @Binding var showChat: Bool
    @State private var memos: [Memo] = [
        Memo(title: "Buy groceries", context: "Milk, Eggs, Bread, Butter", date: Date()),
        Memo(title: "Doctor appointment", context: "Discuss blood test results", date: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!),
        Memo(title: "Meeting with team", context: "Review project progress", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        Memo(title: "Submit report", context: "Annual financial report submission", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
        Memo(title: "Plan vacation", context: "Book flights and hotels", date: Calendar.current.date(byAdding: .hour, value: -48, to: Date())!)
    ]
    @State private var isAddingMemo = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(groupedMemos.keys.sorted(by: >), id: \.self) { date in
                        Section(header: Text(formattedDate(date))) {
                            ForEach(groupedMemos[date]!) { memo in
                                NavigationLink(destination: MemoDetailView(memo: $memos[getIndex(of: memo)])) {
                                    VStack(alignment: .leading) {
                                        Text(memo.title)
                                            .font(.headline)
                                        Text("\(memo.date, formatter: DateFormatter.shortTimeFormatter)")
                                            .font(.caption)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Memo")
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isAddingMemo = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
            .sheet(isPresented: $isAddingMemo) {
                AddMemoView(memos: $memos)
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
}

struct MemoDetailView: View {
    @Binding var memo: Memo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(memo.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextEditor(text: $memo.context)
                .onChange(of: memo.context) { newValue in
                    // Auto-save logic can be added here
                    print("Memo context updated: \(newValue)")
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
