//
//  PrescriptionView.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

import SwiftUI

struct PrescriptionView: View {
    var text: String
    var onRetake: () -> Void
    var onConfirm: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Informações da receita:")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.19, green: 0.1, blue: 0.32))
                .padding(.top, 30)
            
            Divider()
            
            ScrollView {
                // Exibe o texto retornado pela IA
                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.bottom, 40)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                // Botão de refazer
                Button(action: onRetake) {
                    Text("Tirar nova foto")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(30)
                }
                
                // Botão de confirmar
                Button(action: {
                    let meds = parsePrescriptionText(text)
                    //Navegue para ReminderSetupView com esses medicamentos
                }
                ) {
                    Text("Confirmar informações")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color(red: 0.51, green: 0.67, blue: 0.02))
                        .cornerRadius(30)
                }
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    PrescriptionView(
        text: """
        **Amoxicilina, 500mg**
        Tomar 01 cápsula a cada 8h por 7 dias.

        **Paracetamol, 750mg**
        Tomar 01 comprimido a cada 8h se houver dor.
        """,
        onRetake: {},
        onConfirm: {}
    )
}
