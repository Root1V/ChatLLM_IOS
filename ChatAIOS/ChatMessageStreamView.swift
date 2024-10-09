//
//  ChatMessageStreamView.swift
//  ChatAIOS
//
//  Created by Emeric on 8/10/24.
//


import SwiftUI

struct ChatMessageStreamView: View {
    
    @ObservedObject var viewModel = GPTStreamViewModel()
    @State private var userInput: String = ""

    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.chatMessages, id: \.id) { message in
                            MessageBubbleStream(chatMessage: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .onChange(of: viewModel.chatMessages.count) { _ in
                        // Auto-scroll hacia el último mensaje cuando se agregue uno nuevo
                        scrollView.scrollTo(viewModel.chatMessages.last?.id, anchor: .bottom)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#f4f7ff")) // Fondo de la conversación
                .cornerRadius(10)
                .padding(.bottom, 10)
                .padding(.top, 10)
            }
            
            // Input para que el usuario escriba su mensaje
            HStack {
                TextField("Escribe tu pregunta...", text: $userInput)
                    .padding(.horizontal, 10)
                    .background(Color.white) // Color de fondo
                    .cornerRadius(20) // Esquinas redondeadas
                    .padding(.leading, 10)
                    .focused($isInputFocused)
                
                Button(action: {
                    guard !userInput.isEmpty else { return }
                    viewModel.sendMessage(message: userInput)
                    userInput = ""
                }) {
                    Image(systemName: "paperplane.fill")
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
   
}

struct ChatMessageStreamView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageStreamView()
    }
}

