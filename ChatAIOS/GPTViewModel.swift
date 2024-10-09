//
//  GPTViewModel.swift
//  ChatAIOS
//
//  Created by Emeric on 8/10/24.
//

import Foundation

final class GPTViewModel: ObservableObject {
    
    private let APIKEY = "apikey"
    private let URLOPENAI = "https://api.openai.com/v1/chat/completions"
    private let MODELOAI = "gpt-4o-mini"
    
    @Published var messages: [ChatMessage] = []
     
    func sendMessage(_ message: String) {
        
        DispatchQueue.main.async {
            self.messages.append(ChatMessage(message: message, type: .user))
        }
        
         // 1. Preparar la URL y la solicitud
         guard let url = URL(string: URLOPENAI) else {
             print("Error: URL no válida")
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         
         // 2. Configurar los headers
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
         
         // 3. Configurar el cuerpo de la solicitud
         let body: [String: Any] = [
             "model": MODELOAI,
             "messages": [
                 ["role": "system", "content": "Eres un asistente de IA llamada ElysIA."],
                 ["role": "user", "content": message]
             ],
             "max_tokens": 300,
             "temperature": 0.3
         ]
         
         do {
             request.httpBody = try JSONSerialization.data(withJSONObject: body)
         } catch {
             print("Error al serializar el cuerpo de la solicitud: \(error.localizedDescription)")
             return
         }
         
         // 4. Realizar la solicitud
         let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
             guard let self = self else { return }
             
             if let error = error {
                 print("Error al realizar la solicitud: \(error.localizedDescription)")
                 return
             }
             
             guard let data = data else {
                 print("Error: no se recibió ningún dato")
                 return
             }
             
             // 5. Manejar la respuesta
             do {
                 print("Procesamos la respuesta")
                 if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let choices = jsonResponse["choices"] as? [[String: Any]],
                    let message = choices.first?["message"] as? [String: Any],
                    let content = message["content"] as? String {
                     DispatchQueue.main.async {
                         print("Respuesta - content: \(content)")
                         self.messages.append(ChatMessage(message: content, type: .bot))
                     }
                 } else {
                     print("Respuesta inesperada de la API: \(String(data: data, encoding: .utf8) ?? "Desconocido")")
                 }
                 
             } catch {
                 print("Error al parsear la respuesta de la API: \(error.localizedDescription)")
             }
         }
         
         task.resume() // 6. Iniciar la solicitud
     }
}
