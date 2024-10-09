//
//  MessageBubble.swift
//  ChatAIOS
//
//  Created by Emeric on 8/10/24.
//

import SwiftUI

extension Color {
    /// Inicializa un color a partir de un código hexadecimal con opacidad.
    init(hex: String, opacity: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(hex.startIndex, offsetBy: 1)
        }
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension View {
    func cornerRadius(_ topLeft: CGFloat = 0, _ topRight: CGFloat = 0, _ bottomLeft: CGFloat = 0, _ bottomRight: CGFloat = 0) -> some View {
        self.clipShape(RoundedCustomShape(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight))
    }
}

struct RoundedCustomShape: Shape {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight), radius: topRight, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight), radius: bottomRight, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft), radius: bottomLeft, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft), radius: topLeft, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.closeSubpath()
        
        return path
    }
}

struct MessageBubble: View {
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
                Text(chatMessage.message)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#6e52cf"))
                    .cornerRadius(5, 20, 20, 20)
                    .frame(maxWidth: 360, alignment: .leading)
                    .shadow(color: Color.gray.opacity(0.5), radius: 20, x: -20, y: 20)
                
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
        }
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(chatMessage: ChatMessage(message:  "Dime ques es la Inteligencia Artificial General, en el 2024? ", type: .user))
        
        //MessageBubble(chatMessage: ChatMessage(message:  "Es el avance de la humanidad al siguiente nivel", type: .bot))
        
       
    }
}
