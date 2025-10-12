//
//  CameraView.swift
//  test55
//
//  Created by Débora Costa on 08/10/25.
//


import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    /// Imagem capturada pela câmera.
    /// O valor é atualizado quando o usuário tira uma foto.
    @Binding var capturedImage: UIImage?
    /// Controle externo que indica quando a câmera deve tirar uma foto.
    /// Quando `true`, a função `capturePhoto()` será chamada e, em seguida, redefinida para `false`.
    @Binding var takePicture: Bool
    
    /// Cria o controlador de câmera (UIViewController)
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.coordinator = context.coordinator
        return controller
    }
    
    /// Atualiza o controlador quando o estado SwiftUI muda.
    /// Aqui verificamos se o app pediu para tirar uma foto (`takePicture == true`).
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        if takePicture {
            uiViewController.capturePhoto()
            DispatchQueue.main.async {
                self.takePicture = false
            }
        }
    }
    //`Coordinator` — uma ponte entre o SwiftUI e o UIKit.
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // O Coordinator atua como delegado para a captura de fotos.
    /// Ele recebe a imagem da câmera via `AVCapturePhotoCaptureDelegate`
    /// e repassa para o SwiftUI através do binding `capturedImage`.
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        /// Método chamado quando a captura da foto é finalizada.
        /// Aqui convertemos os dados binários da foto em `UIImage`
        /// e atribuimos ao binding `capturedImage` (atualizando a interface SwiftUI).
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.parent.capturedImage = image
                }
            }
        }
    }
}
