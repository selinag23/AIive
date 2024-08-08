//
//  MemoOpenAi.swift
//  AIive
//
//  Created by Aya Shinkawa on 2024/8/6.
//



import Foundation
import OpenAI

class MemoOpenAI: ObservableObject {
    @Published var messages: [Message] = []
    
    let openAI = OpenAI(apiToken: "your-api-key")

    func generateSummary(from eventsDetails: String, completion: @escaping (String) -> Void) {
        let userMessage = Message(content: eventsDetails, isUser: true, contact: [], time: [], display: false)
        self.messages.append(userMessage)
        
        let query = ChatQuery(
            messages: self.messages.map { .init(role: $0.isUser ? .user : .assistant, content: $0.content)! },
            model: .gpt3_5Turbo
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else { return }
                guard let messageContent = choice.message.content?.string else {
                    print("ERROR: message is not in string")
                    completion("Unable to generate summary. Please try again.")
                    return
                }
                completion(messageContent)
            case .failure(let failure):
                print(failure)
                completion("Unable to generate summary. Please try again.")
            }
        }
    }
}
