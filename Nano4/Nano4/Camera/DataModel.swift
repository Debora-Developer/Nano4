//
//  DataModel.swift
//  Nano4
//
//  Created by Débora Costa on 07/10/25.
//

import AVFoundation
import SwiftUI
import os.log
internal import Combine
internal import Photos


final class DataModel: ObservableObject {

    let camera = Camera()
    //propriedade que representa uma das câmeras do dispositivo. Pode ser a camera frontal ou traseira que dá para alterar com o método switchCaptureDevice()

    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    //pode representar qualquer coleção de itens na sua fototeca. Inclui todas as fotos da fototeca. Antes vc tem que adicionar a capacidade da Fototeca.
    
    @Published var viewfinderImage: Image?

    @Published var thumbnailImage: Image?

    
    var isPhotosLoaded = false
    
    init() {
        Task {
            await handleCameraPreviews()
        }
        // essa tarefa controla o fluxo de imagens de pré visualização
        Task {
            await handleCameraPhotos()
        }
        //Modelo de dados aguarda por fotos recém capturadas. Tarefa de controlar o fluxo de fotos capturadas.

    }

    func handleCameraPreviews() async {

        let imageStream = camera.previewStream
            //.map { $0.oriented(.left) }
        //gira a orientação da imagem
            //.map { $0.applyingGaussianBlur(sigma: 5) }
        //desfoca a imagem

            .map { $0.image }
        //transforma o fluxo de pré visualização de objetos em um fluxo de visualização Image. a função map converte cada elemento $0 em uma instância Image, transforma o fluxo de instancia Climage em um fluxo de instâncias Image

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            //a imagem do fluxo de pré visualização atualiza essa propriedade. Então esse valor muda.
            }
        }
    //o loop for await espera por cada imagem no imageStream
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
    //Cada elemento AVCapturePhoto pode ter várias imagens com resolução diferentes e outros metadados (tamanho, data, hora...). A primeira coisa que essa função deve fazer é converter photoStream em um unpackedPhotoStream mais útil, onde cada elemento seja uma instancia da estrutura PhotoData.
            .compactMap { self.unpackPhoto($0) }
    //Esse método chama unpackPhoto(_:) para casa foto ($0) no fluxo. Transforma o fluxo AVCapturePhoto em um mais útil para instâncias PhotoData.

        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                thumbnailImage = photoData.thumbnailImage
            //use a imagem de miniatura para atualizar a propriedade do seu modelo
 
            }
            savePhoto(imageData: photoData.imageData)
            //salvar os dados da imagem de photoData como uma foto nova na fototeca
        }
        //esse loop está esperando que um elemento photoData chegue ao fluxo desempacotado antes de processá-lo
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
    //Para desempacotar photoStream. Usa uma foto capturada e retorna uma insctancia.
        guard let imageData = photo.fileDataRepresentation() else { return nil }

        guard let previewCGImage = photo.previewCGImageRepresentation(),
           let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        let imageOrientation = Image.Orientation(cgImageOrientation)
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))
        
        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
    }
    
    func savePhoto(imageData: Data) {
        Task {
            do {
                try await photoCollection.addImage(imageData)
                logger.debug("Added image data to photo collection.")
            } catch let error {
                logger.error("Failed to add image to photo collection: \(error.localizedDescription)")
            }
        }
    }
    //Ele cria uma tarefa e passa o trabalho de salvar os dados da foto para o objeto photoCollection chamando de addImage(_:)
    
    func loadPhotos() async {
        guard !isPhotosLoaded else { return }
        
        let authorized = await PhotoLibrary.checkAuthorization()
        guard authorized else {
            logger.error("Photo library access was not authorized.")
            return
        }
        
        do {
            try await self.photoCollection.load()
            isPhotosLoaded = true
        } catch let error {
            logger.error("Failed to load photo collection: \(error.localizedDescription)")
        }
    }
    
    func loadThumbnail() async {
        guard let asset = photoCollection.photoAssets.first  else { return }
        await photoCollection.cache.requestImage(for: asset, targetSize: CGSize(width: 256, height: 256))  { result in
            if let result = result {
                Task { @MainActor in
                    self.thumbnailImage = result.image
                }
            }
        }
    }
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "DataModel")
