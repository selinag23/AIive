//
//  test.swift
//  AIive
//
//  Created by Peiran Wang on 8/6/24.
//
/*
import Foundation

let message = """
{
    "recipient": "SERVER",
    "action": "INSERT",
    "target": "Contacts",
    "message": {
        "Name": "Xu Ruiqi",
        "Position": "PM",
        "Organization": "SJTU",
        "Phone": "12345",
        "Email": "123@456.789",
        "SocialMedia": "23456",
        "Description": "final design teammate"
    }
}
"""

func parseContact(from jsonString: String) -> Contact? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        print("Error: Could not convert string to data")
        return nil
    }
    
    do {
        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
        var messageString = json["message"] as? String {
            
            // Replace single quotes with double quotes for valid JSON
            messageString = messageString.replacingOccurrences(of: "'", with: "\"")
            
            if let messageData = messageString.data(using: .utf8),
            let message = try JSONSerialization.jsonObject(with: messageData, options: []) as? [String: Any] {
                
                guard let name = message["Name"] as? String,
                    let position = message["Position"] as? String,
                    let organization = message["Organization"] as? String,
                    let phone = message["Phone"] as? String else {
                    print("Error: Missing or invalid fields in JSON")
                    return nil
                }
                
                let email = message["Email"] as? String ?? ""
                let socialMedia = message["SocialMedia"] as? String ?? ""
                let description = message["Description"] as? String ?? ""
                
                return Contact(name: name, position: position, organization: organization, phone: phone, email: email, socialMedia: socialMedia, description: description)
            }
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    
    return nil
}

guard let contact = parseContact(from: message) else {
    print("Failed to parse contact from message")
    return
}
//DatabaseManager.shared.addContact(contact)
print("Contact successfully added to the database")

*/
