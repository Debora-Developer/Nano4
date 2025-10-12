//
//  ContentView.swift
//
//  Created by Débora Costa on 08/10/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    //o repositório está sendo criado aqui
    @StateObject private var reminderRepo = ReminderRepository()

    // Salva se o usuário já viu o onboarding
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    // Controla a exibição do fluxo de adicionar receita
    @State private var isAddingPrescription = false
    
    // Estados da câmera e pré-visualização
    @State private var capturedImage: UIImage?
    @State private var isShowingPreview = false
    @State private var isShowingGeminiView = false
    @State private var triggerPhotoCapture = false

    var body: some View {
        if hasSeenOnboarding {
            LembreMedView()
                .environmentObject(reminderRepo)
//        ZStack {
//            CameraView(
//                capturedImage: $capturedImage,
//                takePicture: $triggerPhotoCapture
//            )
//            .ignoresSafeArea()
//
//            // Overlay com o botão de captura
//            VStack {
//                Spacer()
//                Button(action: {
//                    self.triggerPhotoCapture = true
//                }) {
//                    ZStack {
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 70, height: 70)
//                        
//                        Circle()
//                            .stroke(Color.white, lineWidth: 4)
//                            .frame(width: 80, height: 80)
//                    }
//                }
//                .padding(.bottom, 30)
//            }
//        }
//        //Quando a foto é tirada
//        .onChange(of: capturedImage) { _, newImage in
//            // Quando a imagem é capturada, ativamos a pré-visualização.
//            // espaço para confirmação
//            if newImage != nil {
//                isShowingPreview = true
//            }
//        }
//            //Mostra a view de pós-captura
//        .fullScreenCover(isPresented: $isShowingPreview) {
//            if let image = capturedImage {
//                PhotoPreviewView(
//                    image: image,
//                    onConfirm: {
//                        //Usuário confirmou - abre IA
//                        isShowingPreview = false
//                        isShowingGeminiView = true
//                    },
//                    onRetake: {
//                        // Usuário quer refazer — volta à câmera
//                        capturedImage = nil
//                        isShowingPreview = false
//                    }
//                )
//            }
//        }
//            // Mostra a tela da IA após a confirmação
//            // A GeminiView agora tem acesso ao repositório
//             .fullScreenCover(isPresented: $isShowingGeminiView) {
//                 if let image = capturedImage {
//                     GeminiView(
//                        image: image,
//                        onRetake: {
//                            capturedImage = nil
//                            isShowingGeminiView = false
//                        }
//                    )
//                 }
//             }
//            //Injeção do repositório no ambiente para todas as telas filhas.
//             .environmentObject(reminderRepo)
            
        } else {
            // Se for a primeira vez, mostre o onboarding
            OnboardingView(onContinue: {
                // O botão do onboarding agora ativa a modal de adicionar receita
                isAddingPrescription = true
            })
            // Apresenta o fluxo de adicionar receita em tela cheia
                        .fullScreenCover(isPresented: $isAddingPrescription) {
                            AddPrescriptionView(onComplete: {
                                               // Quando o fluxo for concluído com sucesso pela primeira vez,
                                               // marcamos que o onboarding foi finalizado.
                                               hasSeenOnboarding = true
                                           })
                                           .environmentObject(reminderRepo)
                                       }
        }
    }
}

#Preview {
    ContentView()
}
