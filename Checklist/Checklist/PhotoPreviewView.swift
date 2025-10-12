//
//  PhotoPreviewView.swift
//  test55
//
//  Created by Débora Costa on 08/10/25.
//


import SwiftUI
import AVFoundation

/// Tela de pré-visualização após tirar uma foto.
struct PhotoPreviewView: View {
    let image: UIImage
    var onConfirm: () -> Void
    var onRetake: () -> Void

    var body: some View {
        ZStack {
            // Mostra a foto capturada em tela cheia
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack{
                Spacer()
                HStack(spacing:60) {
                    // ❌ Refazer
                    Button(action: {
                        onRetake()
                    }) {
                        ZStack{
                            Circle()
                                .fill(Color.red)
                            
                            Image(systemName:"trash")
                                .font(.system(size:36))
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 80, alignment: .center)
                    }
                    /// ✅ Confirmar
                    Button(action: {
                        onConfirm()
                    }) {
                        ZStack{
                            Circle()
                                .fill(Color.blue)
                            Image(systemName: "checkmark")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        .frame(width: 80, height: 80, alignment: .center)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    PhotoPreviewView(
        image: UIImage(named: "example") ?? UIImage(),
        onConfirm: {},
        onRetake: {}
    )
}
