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
    
    @EnvironmentObject var reminderRepo: ReminderRepository
    
    @State private var responseText: String? = nil
    @State private var isLoading = true
    
    var image: UIImage
    var onRetake: () -> Void
    // Novo callback para sinalizar o fim do fluxo
    var onFlowComplete: () -> Void
    
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
                        NavigationStack{
                            PrescriptionView(
                                text: text,
                                onRetake: onRetake,
                                onConfirm: {}, // A navegação é tratada pelo NavigationLink
                                onFlowComplete: onFlowComplete // Passa o callback adiante
                            )
                            .environmentObject(reminderRepo)
                        }
                    } else {
                        Text("Não foi possível ler a receita. Tente novamente.")
                            .foregroundColor(.red)
                    }
                }
                .onAppear {
                    Task {
                        let model = ai.generativeModel(modelName: "gemini-2.5-flash")
                        let prompt = """
Extraia da imagem da receita médica os nomes dos medicamentos, suas dosagens e as instruções.
Formate CADA medicamento estritamente da seguinte forma, com cada um em uma nova linha:
Nome do Medicamento (Dosagem): Instrução de uso

Exemplo:
Amoxicilina (500mg): Tomar 1 cápsula a cada 8 horas.
Dipirona (1g): Tomar 1 comprimido se houver dor.
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

