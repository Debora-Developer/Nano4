//
//  CameraView.swift
//  test55
//
//  Created by Débora Costa on 08/10/25.
//


import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var takePicture: Bool

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.coordinator = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        if takePicture {
            uiViewController.capturePhoto()
            DispatchQueue.main.async {
                self.takePicture = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // O Coordinator atua como delegado para a captura de fotos.
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.parent.capturedImage = image
                }
            }
        }
    }
}