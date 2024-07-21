import SwiftUI

struct Contact: Identifiable {
    var id = UUID()
    var name: String
    var position: String
    var organization: String
    var phone: String
    var email: String
    var socialMedia: String
    var description: String
}

struct ContactView: View {
    @Binding var showChat: Bool
    @State private var contacts: [Contact] = [
        Contact(name: "John Doe", position: "Manager", organization: "Company A", phone: "123-456-7890", email: "john@example.com", socialMedia: "@john_doe", description: "A good manager."),
        Contact(name: "Jane Smith", position: "Engineer", organization: "Company B", phone: "098-765-4321", email: "jane@example.com", socialMedia: "@jane_smith", description: "An experienced engineer."),
        Contact(name: "Alice Johnson", position: "Designer", organization: "Company C", phone: "555-123-4567", email: "alice@example.com", socialMedia: "@alice_johnson", description: "A creative designer."),
        Contact(name: "Bob Brown", position: "Developer", organization: "Company D", phone: "555-765-4321", email: "bob@example.com", socialMedia: "@bob_brown", description: "A skillful developer."),
        Contact(name: "Zara White", position: "Analyst", organization: "Company E", phone: "555-333-2222", email: "zara@example.com", socialMedia: "@zara_white", description: "An insightful analyst.")
    ]
    
    @State private var selectedLetter: String? = nil
    @State private var searchText: String = ""
    @State private var scrollViewProxy: ScrollViewProxy? = nil

    var body: some View {
        NavigationView {
            HStack(spacing: 0) {
                // Alphabet navigator
                VStack {
                    ForEach(letters, id: \.self) { letter in
                        Button(action: {
                            selectedLetter = letter
                            searchText = "" // Clear search text when selecting a letter
                        }) {
                            Text(letter)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.blue)
                                .padding(4)
                        }
                    }
                }
                .padding(.leading, 8)
                
                // Contacts List
                ScrollViewReader { proxy in
                    VStack {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search by name", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            
                            NavigationLink(destination: CreateContactView()) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.trailing)
                            }
                        }
                        .padding()
                        
                        List {
                            ForEach(filteredContacts) { contact in
                                NavigationLink(destination: ContactDetailView(contact: contact)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(contact.name)
                                                .font(.headline)
                                            Text(contact.position)
                                                .font(.subheadline)
                                            Text(contact.organization)
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            callContact(phoneNumber: contact.phone)
                                        }) {
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(.green)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        
                                        Button(action: {
                                            showChat = true
                                        }) {
                                            Image(systemName: "message.fill")
                                                .foregroundColor(.blue)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .padding(.vertical, 8)
                                }
                                .id(contact.id)
                            }
                        }
                        .navigationTitle("Contacts")
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
                    }
                    .onAppear {
                        scrollViewProxy = proxy
                    }
                    .onChange(of: selectedLetter) { newValue in
                        scrollToLetter(newValue)
                    }
                }
            }
        }
    }
    
    private var letters: [String] {
        let letters = contacts.map { String($0.name.prefix(1)) }
        return Array(Set(letters)).sorted()
    }
    
    private var filteredContacts: [Contact] {
        let sortedContacts = contacts.sorted { $0.name < $1.name }
        
        if !searchText.isEmpty {
            return sortedContacts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return sortedContacts
    }
    
    func callContact(phoneNumber: String) {
        print("Calling \(phoneNumber)")
    }
    
    func messageContact(phoneNumber: String) {
        print("Messaging \(phoneNumber)")
    }
    
    func scrollToLetter(_ letter: String?) {
        guard let letter = letter else { return }
        
        if let index = filteredContacts.firstIndex(where: { $0.name.hasPrefix(letter) }) {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    scrollViewProxy?.scrollTo(filteredContacts[index].id, anchor: .top)
                }
            }
        }
    }
}
