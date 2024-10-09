//
//  ChatResponse.swift
//  ChatAIOS
//
//  Created by Emeric on 8/10/24.
//

import Foundation

// Estructura para decodificar las respuestas del streaming
struct ChatResponse: Decodable {
    struct Choice: Decodable {
        struct Delta: Decodable {
            let content: String?
        }
        let delta: Delta
    }
    let choices: [Choice]
}
