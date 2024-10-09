//
//  ChatMessageView.swift
//  ChatAIOS
//
//  Created by Emeric on 8/10/24.
//

import SwiftUI

struct ChatMessageView: View {
    
    @ObservedObject var viewModel = GPTViewModel()
    @State private var userInput: String = ""

    @FocusState private var isInputFocused: Bool
    
    var body: some View {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.messages, id: \.message) { chatMessage in
                            MessageBubble(chatMessage: chatMessage)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#f4f7ff")) // Fondo de la conversación
                .cornerRadius(10)
                .padding(.bottom, 10)
                .padding(.top, 10)

                HStack {
                            TextField("Escribe tu pregunta...", text: $userInput, onCommit: send) // Evento Enter para enviar
                                    .padding(.horizontal, 10)
                                    .background(Color.white) // Color de fondo
                                    .cornerRadius(20) // Esquinas redondeadas
                                    .padding(.leading, 10)
                                    .focused($isInputFocused)

                            Button(action: send) {
                                    Image(systemName: "paperplane.fill") // Icono de avión de papel
                                        .foregroundColor(.white)
                                        .padding(13)
                                        .background(Color(hex: "#6e52cf")) // Color de fondo del botón
                                        .clipShape(Circle()) // Forma circular
                            }
                        }
                            .padding(.horizontal, 3)
                            .padding(.vertical, 3)
                            .background(
                                Color.white // Fondo de la figura ovalada
                                    .cornerRadius(30) // Esquinas redondeadas para el fondo
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Sombra
                            )
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
            }
            .background(Color(hex: "#f4f7ff"))
            .onAppear {
                isInputFocused = true
            }
    
    }
    
    func send() {
        guard !userInput.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Texto vacio, no se envia el mensaje")
            return
        }
        
        viewModel.sendMessage(userInput)
        self.userInput = ""
        isInputFocused = true
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView()
    }
}
