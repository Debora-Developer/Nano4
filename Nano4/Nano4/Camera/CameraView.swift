//
//  CameraView.swift
//  Nano4
//
//  Created by Débora Costa on 07/10/25.
//

import SwiftUI

struct CameraView: View {

    @StateObject private var model = DataModel()
    //@State private var delayCount = 0 (OA)
 
    private static let barHeightFactor = 0.15
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                //quando vc toca o botão obturador da camera

                ViewfinderView(image:$model.viewfinderImage)
                //Usada para mostrar o vídeo ao vivo da câmera
                //Ao vincular a viewfinderImage a ViewfinderView, garante que o visor seja atualizado sempre que a camera recebe uma nova imagem de pré visualização. Seus olhos a veem como um vídeo no visor.
 
                    .overlay(alignment: .top) {
                        Color.black
                            .opacity(0.75)
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                    }
                    .overlay(alignment: .bottom) {
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(.black.opacity(0.75))
                    }
                    .overlay(alignment: .center)  {
                        Color.clear
                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                            .accessibilityElement()
                            .accessibilityLabel("View Finder")
                            .accessibilityAddTraits([.isImage])
                    }
                    .background(.black)
            }
            .task {
                await model.camera.start()
                await model.loadPhotos()
                await model.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            NavigationLink {
                PhotoCollectionView(photoCollection: model.photoCollection)
                //destino: coleção de fotos
                
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
                //se concentrar o dispositivo em exibir as fotos da fototeca ao invés da camera
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            //ícone a esquerda que leva vc a galeria de fotos.
            Button {
            //se vc quiser adcionar um obturador atrasado. Como captura com contagem regressiva, vc precisa adicionar um pequeno atraso depois de clicar no botão. Veja o código obturador atrasado (OA)
                model.camera.takePhoto() //comente essa linha (OA)
                //delayCount = 5 (OA)
                //Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                //delayCount -= 1
            //} (OA)
                //if delayCount == 0 {
                //timer.invalidate()
                //model.camera.takePhoto()
            //}
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                    //if delayCount > 0 {
                    //Text("\(delayCount)")
                //}
                // Mostra a contagem regressiva ali mesmo no botão

                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}

//print("Timer \(delayCount) \(Date.now)") (OA)


