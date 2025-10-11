import SwiftUI
internal import Photos


struct PhotoView: View {
    //Para mostrar uma foto sozinha. Vc mostra uma imagem em alta resolução e uma sobreposição para apagar a foto ou marca-la como favorita

    var asset: PhotoAsset

    var cache: CachedImageManager?
    //referencia ao cache da imagem. Voce pode solicitar uma imagem de um tamanho especificado a partir do cache. Ele tb mantem as imagens solicitadas recentemente na memória para não precisar recarrega-las.

    @State private var image: Image?
    //É um tipo - Image? - opcional porque vc quer que ele não tenha um valor de início
    @State private var imageRequestID: PHImageRequestID?
    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)
    
    var body: some View {
        Group {

            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                //Se image tiver um valor, vc desempacota a imagem e mostra na visualizaçõa com as características acima
                    .accessibilityLabel(asset.accessibilityLabel)
            } else {

                ProgressView()
                //Se não (tiver um valor), usa a ProgressView para mostrar um indicador giratório como marcador de posição.
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.secondary)
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            buttonsView()
                .offset(x: 0, y: -50)
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                    //O encerramento de resultado procura uma imagem de resultado. Se ela encontra, atualiza a propriedade image.
                }
                //Recebe uma ou mais chamadas do cache. Se o cache já tiver a imagem que vc solicitou, ele chama a imagem em seu result. Se o cache não tiver, ele carregará a imagem do material e armazenará no cache.
            }
        //solicitação de uma imagem de alta resolução a partir do cache do recurso de foto. Especificando o tamanho desejado
        }
    //modificador para executar o código assincronamente sempre que a visualização é carregada
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Button {
                Task {
                    await asset.setIsFavorite(!asset.isFavorite)
                }
            } label: {
                Label("Favorite", systemImage: asset.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 24))
            }

            Button {
                Task {
                    await asset.delete()
                    await MainActor.run {
                        dismiss()
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
                    .font(.system(size: 24))
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
        .background(Color.secondary.colorInvert())
        .cornerRadius(15)
    }
}
