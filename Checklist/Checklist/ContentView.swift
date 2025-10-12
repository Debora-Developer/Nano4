//
//  ContentView.swift
//
//  Created by Débora Costa on 08/10/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    // Salva se o usuário já viu o onboarding
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    // Estados da câmera e pré-visualização
    @State private var capturedImage: UIImage?
    @State private var isShowingPreview = false
    @State private var isShowingGeminiView = false
    @State private var triggerPhotoCapture = false

    var body: some View {
        if hasSeenOnboarding {
            
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
        //Quando a foto é tirada
        .onChange(of: capturedImage) { _, newImage in
            // Quando a imagem é capturada, ativamos a pré-visualização.
            // espaço para confirmação
            if newImage != nil {
                isShowingPreview = true
            }
        }
            //Mostra a view de pós-captura
        .fullScreenCover(isPresented: $isShowingPreview) {
            if let image = capturedImage {
                PhotoPreviewView(
                    image: image,
                    onConfirm: {
                        //Usuário confirmou - abre IA
                        isShowingPreview = false
                        isShowingGeminiView = true
                    },
                    onRetake: {
                        // Usuário quer refazer — volta à câmera
                        capturedImage = nil
                        isShowingPreview = false
                    }
                )
            }
        }
            // Mostra a tela da IA após a confirmação
             .fullScreenCover(isPresented: $isShowingGeminiView) {
                 if let image = capturedImage {
                     GeminiView(image: image)
                 }
             }
            
        } else {
            OnboardingView() {
                // Quando o usuário tocar no botão, marcamos que já viu o onboarding
                hasSeenOnboarding = true
            }
        }
    }
}

#Preview {
    ContentView()
}
