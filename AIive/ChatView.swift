import SwiftUI

// 模型类，表示一条聊天消息
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// 视图模型，管理聊天消息的状态
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        let newMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(newMessage)
        
        // 模拟agent回复
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let agentMessage = ChatMessage(text: "Agent: \(self.inputText)", isUser: false)
            self.messages.append(agentMessage)
        }
        
        inputText = ""
    }
}

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .background(Color.clear) // Ensure the scroll view background is clear

                HStack {
                    TextField("输入消息...", text: $viewModel.inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 30)
                    
                    Button(action: viewModel.sendMessage) {
                        Text("发送")
                    }
                    .padding()
                }
                .padding()
            }
            .background(Color.white) // Set a consistent background color for the entire view
            .navigationTitle("Chat")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true) // Hide default back button
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.blue) // Customize the color if needed
                                }
                            }
                        }
        }
    }
}


