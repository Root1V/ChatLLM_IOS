//
//  MessageBubbleStream.swift
//  ChatAIOS
//
//  Created by Emeric on 8/10/24.
//

import SwiftUI

struct MessageBubbleStream: View {
    var chatMessage: ChatMessage
    
    var body: some View {
        HStack(alignment: .top) {
            if chatMessage.type == .bot {
                // Icono circular personalizado para la IA
                Image("icon-bot") // Asegúrate de que "ai-icon" esté en tus assets
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.trailing, 0) // Espaciado entre icono y mensaje
                    

                // Texto del mensaje de la IA
                //print("Ingresa a la interfaz de usuario: \(chatMessage.message)")
                Text(chatMessage.message)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#6e52cf"))
                    .cornerRadius(5, 20, 20, 20)
                    .frame(maxWidth: 360, alignment: .leading)
                    .shadow(color: Color.gray.opacity(0.5), radius: 20, x: -20, y: 20)
                    .animation(.linear(duration: 0.3), value: chatMessage.message)
                
                Spacer() // Espacio a la derecha del mensaje
            } else if chatMessage.type == .user {
                Spacer() // Espacio a la izquierda del mensaje

                // Texto del mensaje del usuario
                Text(chatMessage.message)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background(Color(hex: "#6e52cf"))
                    .foregroundColor(.white)
                    .cornerRadius(23, 5, 20, 20)
                    .frame(maxWidth: 360, alignment: .trailing)
                    .shadow(color: Color.gray.opacity(0.5), radius: 20, x: 20, y: 20)

                // Icono circular personalizado para el usuario
                Image("icon-human") // Asegúrate de que "user-icon" esté en tus assets
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.leading, 0) // Espaciado entre icono y mensaje
            }
        }.onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                //Forzamos la animacion suave
                print("Ingresa a la interfaz de usuario: \(chatMessage.message)")
            }
        }
    }
}

struct MessageBubbleStream_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubbleStream(chatMessage: ChatMessage(message:  "Dime ques es la Inteligencia Artificial General, en el 2024?", type: .bot))
    }
}
