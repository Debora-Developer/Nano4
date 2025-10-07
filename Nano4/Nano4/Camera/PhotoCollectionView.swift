//
//  PhotoCollectionView.swift
//  Nano4
//
//  Created by Débora Costa on 07/10/25.
//

import SwiftUI
import os.log

struct PhotoCollectionView: View {
    //mostrar as fotos numa grade rolável, fotos mais recentes no topo.
    @ObservedObject var photoCollection : PhotoCollection
    //Ao transformar a photoCollection em um objeto observado, o SwiftUI atualiza a visualização da coleção em resposta as mudanças nos valores publicados da coleção
    
    @Environment(\.displayScale) private var displayScale
        
    private static let itemSpacing = 12.0
    private static let itemCornerRadius = 15.0
    private static let itemSize = CGSize(width: 90, height: 90)
    
    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2), height: Self.itemSize.height * min(displayScale, 2))
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing)
         //Se vc quiser um número fixo de colunas, columns precisa conter um item de grade flexible(minimum:maximum:) para cada coluna desejada (Grade fixa)
        //let fixedColumns = [
            //GridItem(.flexible(), spacing: itemSpacing),
            //GridItem(.flexible(), spacing: itemSpacing)
        //]

    ]
    //Torna responsivo para diferentes tipos de visualização.
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Self.itemSpacing) {
            //mostra as fotos como itens em um layout de grade. Decidir colunas e spacing de cada item.
                //LazyVGrid(columns: fixedColumns, spacing: Self.itemSpacing) (Grade fixa)
                ForEach(photoCollection.photoAssets) { asset in
                    NavigationLink {
                        PhotoView(asset: asset, cache: photoCollection.cache)
                    // Mostra a foto individual em tamanho original
                    } label: {
                        photoItemView(asset: asset)
                    //Cria uma visualização que mostra uma miniatura da foto
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel(asset.accessibilityLabel)
                }
                //A medida que vc rola a ScrollView, ForEach opera apenas nos materiais de foto visíveis
            }
            .padding([.vertical], Self.itemSpacing)
            //Mude o preenchimento da visualização para que ocorra em todos os lados e não somente vertical
            //.padding(Self.itemSpacing)
        }
        .navigationTitle(photoCollection.albumName ?? "Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .statusBar(hidden: false)
    }
    
    private func photoItemView(asset: PhotoAsset) -> some View {
        PhotoItemView(asset: asset, cache: photoCollection.cache, imageSize: imageSize)
            .frame(width: Self.itemSize.width, height: Self.itemSize.height)
        // Vc não quer mais que tenha um tamanho fixo de frame para cada foto. O tamanho da imagem estaria sendo determinado pela largura da visualização e o número de colunas. Então essa linha seria comentadada. (Grade fixa)
            .clipped()
            .cornerRadius(Self.itemCornerRadius)
            .overlay(alignment: .bottomLeading) {
                if asset.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 1)
                        .font(.callout)
                        .offset(x: 4, y: -4)
                }
            }
            .onAppear {
                Task {
                    await photoCollection.cache.startCaching(for: [asset], targetSize: imageSize)
                }
            }
            .onDisappear {
                Task {
                    await photoCollection.cache.stopCaching(for: [asset], targetSize: imageSize)
                }
            }
    }
}
