//
//  PrescriptionView.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

import SwiftUI

struct PrescriptionView: View {
    //texto da receita médica
    var text: String
    //callback tirar nova foto
    var onRetake: () -> Void
    //callback confirmar informações
    var onConfirm: () -> Void
    //callback
    var onFlowComplete: () -> Void

    //prescriptions vai armazenar a lista de medicamentos extraídos na PrescriptionModel
    @State private var prescriptions: [PrescriptionModel] = []
    
    //pegar o primeiro item da lista e passar ao próximo passo
    private var firstPrescription: PrescriptionModel? {
        prescriptions.first
    }

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
            
            //Botões de ação
            
            HStack(spacing: 16) {
                Button(action: onRetake) {
                    Text("Tirar nova foto")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(30)
                }
                
                // Botão de confirmar (só aparece se houver uma prescrição válida)
                if let prescription = firstPrescription {
                    NavigationLink(destination: ReminderSetupView(prescription: prescription,
                        onFlowComplete: onFlowComplete // Passa o callback adiante
                        )) {
                        Text("Confirmar informações")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.51, green: 0.67, blue: 0.02))
                            .cornerRadius(30)
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .padding(.horizontal)
        .onAppear {
            self.prescriptions = parsePrescriptionText(self.text)
        }
    }
}
