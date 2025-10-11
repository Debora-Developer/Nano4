//
//  ContentView.swift
//  Checklist
//
//  Created by Débora Costa on 08/10/25.
//

import SwiftUI
import FirebaseAI

struct GeminiView: View {
    private let ai = FirebaseAI.firebaseAI(backend: .googleAI())
    private let vm = GeminiViewModel()
    
    @State private var meuTexto = "Ola mundo"
    var image: UIImage
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(meuTexto)
            Button("Usar IA") {
                let model = ai.generativeModel(modelName: "gemini-2.5-flash")
                
                Task {
                    let prompt = "Extraia da receita médica apenas os nomes dos medicamentos e suas respectivas posologias"
                    
                    let response = try await vm.generateDescription(from: image, withPrompt: prompt, type: model)
                    
                    
                    DispatchQueue.main.async {
                        self.meuTexto = response
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


