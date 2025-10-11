//
//  ContentView.swift
//  test55
//
//  Created by Débora Costa on 08/10/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {

    
    @State private var capturedImage: UIImage?
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
            // Quando a imagem é capturada, ativamos a pré-visualização.
            // espaço para confirmação
            if newImage != nil {
                isShowingGeminiView = true
            }
        }
        .fullScreenCover(isPresented: $isShowingGeminiView) {
            if let image = capturedImage {
                GeminiView(image: image)

            }
        }
    }
}


// A View de pré-visualização da foto permanece a mesma.


// Representa o UIViewController que gerencia a câmera.


// O UIViewController que contém a lógica do AVFoundation.


#Preview {
    ContentView()
}
