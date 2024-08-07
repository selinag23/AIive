//
//  ContentView.swift
//  Alive
//
//  Created by 徐睿棋 on 2024/7/18.
//

import SwiftUI

struct MainView: View {
    @State private var showChat = false

    var body: some View {
        TabView {
            CalendarView(showChat: $showChat)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            ReminderView(showChat: $showChat)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Reminders")
                }
            
            ContactView(showChat: $showChat)
                .tabItem {
                    Image(systemName: "person")
                    Text("Contacts")
                }
            
            MemoView(showChat: $showChat)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Memo")
                }
        }
        .sheet(isPresented: $showChat) {
            ChatView()
        }
    }
}

// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
