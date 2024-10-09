//
//  ChatMessage.swift
//  ChatAIOS
//
//  Created by Emeric on 8/10/24.
//

import Foundation

struct ChatMessage {
    enum MessageType {
        case user
        case bot
    }
    
    let id = UUID()
    var message: String
    let type: MessageType
}
