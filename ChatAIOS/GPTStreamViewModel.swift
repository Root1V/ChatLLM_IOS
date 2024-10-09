//
//  GPTStreamViewModel.swift
//  ChatAIOS
//
//  Created by Emeric on 8/10/24.
//

import Foundation

final class GPTStreamViewModel: ObservableObject {
    private let APIKEY = "apikey"
    private let URLOPENAI = "https://api.openai.com/v1/chat/completions"
    private let MODELOAI = "gpt-4o-mini"
    
    @Published var chatMessages: [ChatMessage] = []
    
    func sendMessage(message: String) {
        let userMessage = ChatMessage(message: message, type: .user)
        self.chatMessages.append(userMessage)
        
        var aiMessage = ChatMessage(message: "", type: .bot)
        self.chatMessages.append(aiMessage)
        
        guard let url = URL(string: URLOPENAI) else {
            print("Error: URL no válida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "model": MODELOAI,
            "messages": [
                ["role": "system", "content": "Eres un asistente de IA llamada ElysIA."],
                ["role": "user", "content": message]
            ],
            "max_tokens": 300,
            "temperature": 0.3,
            "stream": true // Indicamos que la respuesta debe ser en modo streaming
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                print("Error al realizar la solicitud: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, error == nil else {
                print("Error:", error ?? "Unknown error")
                return
            }
            
            if let streamingResponse = String(data: data, encoding: .utf8) {
                streamingResponse.enumerateLines { line, _ in
                    if line.hasPrefix("data: "), let jsonData = line.dropFirst(6).data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let chatResponse = try decoder.decode(ChatResponse.self, from: jsonData)
                            let textFragment = chatResponse.choices.first?.delta.content ?? ""
                            
                            DispatchQueue.main.async {
                                
                                aiMessage.message += textFragment
                                
                                if let index = self?.chatMessages.lastIndex(where: { $0.type == .bot }) {
                                    self?.chatMessages[index] = aiMessage
                                    print("El valor de index \(index): se agrega: \(textFragment)")
                                }
                            }
                        } catch {
                            print("Error al decodificar \(error.localizedDescription)")
                        }
                    }
                }
            }
        }

        task.resume()

        
    }

}
