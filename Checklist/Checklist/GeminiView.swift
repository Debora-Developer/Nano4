//
//  ContentView.swift
//  Checklist
//
//  Created by Débora Costa on 08/10/25.
//

import SwiftUI
import FirebaseAI

struct GeminiView: View {
    private let ai = FirebaseAI.firebaseAI(backend: .googleAI())
    private let vm = GeminiViewModel()
    
    @State private var responseText: String? = nil
    @State private var isLoading = true
    
    var image: UIImage
    var onRetake: () -> Void
    
    var body: some View {
        Group {
                    if isLoading {
                        VStack(spacing: 20) {
                            ProgressView("Lendo a receita...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                            Text("Por favor, aguarde alguns segundos.")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    } else if let text = responseText {
                        PrescriptionView(
                            text: text,
                            onRetake: onRetake,
                            onConfirm: {
                                // ação futura — talvez salvar no Firebase
                            }
                        )
                    } else {
                        Text("Não foi possível ler a receita. Tente novamente.")
                            .foregroundColor(.red)
                    }
                }
                .onAppear {
                    Task {
                        let model = ai.generativeModel(modelName: "gemini-2.5-flash")
                        let prompt = """
                        Extraia da receita médica apenas os nomes dos medicamentos e suas respectivas posologias, formatando o texto como uma lista limpa.
                        """
                        
                        do {
                            let response = try await vm.generateDescription(from: image, withPrompt: prompt, type: model)
                            DispatchQueue.main.async {
                                self.responseText = response
                                self.isLoading = false
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.responseText = "Erro ao processar a imagem."
                            }
                        }
                    }
                }
                .padding()
            }
        }

        #Preview {
            GeminiView(image: UIImage(systemName: "photo")!, onRetake: {})
        }
