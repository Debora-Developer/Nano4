//
//  AddPrescriptionView.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

import SwiftUI

struct AddPrescriptionView: View {
    // Controla o fechamento desta view modal
    @Environment(\.dismiss) var dismiss
    
    // Recebe o repositório do ambiente para poder salvar os lembretes
    @EnvironmentObject var reminderRepo: ReminderRepository
    
    // Ação a ser executada quando o fluxo for concluído com sucesso
    var onComplete: () -> Void
    
    // Estados internos que gerenciam o fluxo
    @State private var capturedImage: UIImage?
    @State private var isShowingPreview = false
    @State private var isShowingGeminiView = false
    @State private var triggerPhotoCapture = false

    var body: some View {
        ZStack {
            CameraView(
                capturedImage: $capturedImage,
                takePicture: $triggerPhotoCapture
            )
            .ignoresSafeArea()

            // Overlay com o botão de captura
            VStack {
                Spacer()
                Button(action: {
                    self.triggerPhotoCapture = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onChange(of: capturedImage) { _, newImage in
            if newImage != nil {
                isShowingPreview = true
            }
        }
        // Modal para a pré-visualização da foto
        .fullScreenCover(isPresented: $isShowingPreview) {
            if let image = capturedImage {
                PhotoPreviewView(
                    image: image,
                    onConfirm: {
                        isShowingPreview = false
                        isShowingGeminiView = true
                    },
                    onRetake: {
                        capturedImage = nil
                        isShowingPreview = false
                    }
                )
            }
        }
        // Modal para a view da IA (Gemini)
        .fullScreenCover(isPresented: $isShowingGeminiView) {
            if let image = capturedImage {
                // GeminiView agora recebe o onComplete para finalizar o fluxo
                GeminiView(
                    image: image,
                    onRetake: {
                        capturedImage = nil
                        isShowingGeminiView = false
                    },
                    onFlowComplete: {
                        // Quando o fluxo terminar, chame o onComplete e feche a modal
                        onComplete()
                        dismiss()
                    }
                )
                // Importante: Passe o environmentObject para a próxima tela
                .environmentObject(reminderRepo)
            }
        }
    }
}
