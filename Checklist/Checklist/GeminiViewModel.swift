//
//  GeminiViewModel.swift
//  Checklist
//
//  Created by Débora Costa on 08/10/25.
//

import SwiftUI
import Combine
import FirebaseAI

enum GeminiError: Error {
    case apiKeyNotFound
    case modelInitializationError
    case imageConversionError
    case requestFailed(Error)
}

final class GeminiViewModel {
    
    func generateDescription(from image: UIImage, withPrompt userPrompt: String, type model: GenerativeModel) async throws -> String {
            
            
            do {
                let response = try await model.generateContent(userPrompt, image)
                
                // Extrai o texto da resposta (continua igual)
                guard let text = response.text else {
                    return "Não foi possível gerar uma descrição. Tente novamente."
                }
                
                return text
                
            } catch {
                throw GeminiError.requestFailed(error)
            }
        }
}
