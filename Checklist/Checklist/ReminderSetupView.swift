//
//  ReminderSetupView.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

import SwiftUI

struct ReminderSetupView: View {
    var prescription: PrescriptionModel
    var onFlowComplete: () -> Void // Recebe o callback final
    
    //Isso diz: "Eu espero receber um ReminderRepository do ambiente."
    @EnvironmentObject var reminderRepo: ReminderRepository
    // O dismiss aqui fechará esta tela e voltará para a PrescriptionView.
    // O onFlowComplete é que cuidará de fechar todo o fluxo modal.
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedTimes: [Date] = [Date()] //Inicia com um horário
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(7 * 24 * 60 * 60) // 7 dias padrão
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Definir lembretes para \(prescription.name)")
                .font(.title3.bold())
                .padding(.top)

            DatePicker("Data inicial", selection: $startDate, displayedComponents: .date)
            DatePicker("Data final", selection: $endDate, displayedComponents: .date)

            VStack(alignment: .leading) {
                Text("Horários dos lembretes")
                    .font(.headline)
                ForEach(selectedTimes, id: \.self) { time in
                    Text(time.formatted(date: .omitted, time: .shortened))
                }

                Button("+ Adicionar horário") {
                    selectedTimes.append(Date())
                }
                .foregroundColor(.purple)
            }

            Spacer()
            
            // Button que salva e depois navega
                 Button(action: {
                     // 1. Salva os lembretes no repositório compartilhado
                                     reminderRepo.addReminders(for: prescription, times: selectedTimes)
                     // 2. Chama o callback para sinalizar que o fluxo inteiro terminou
                                    onFlowComplete()
                     // Fecha a tela de setup
                    // (Isso vai te levar de volta para a PrescriptionView)
                     dismiss() // Fecha
                 }) {
                     Text("Salvar lembretes")
                         .font(.headline)
                         .foregroundColor(.white)
                         .frame(maxWidth: .infinity)
                         .padding()
                         .background(Color(red: 0.51, green: 0.67, blue: 0.02))
                         .cornerRadius(12)
                 }
             }
             .padding()
             .navigationTitle("Lembretes")
             .navigationBarBackButtonHidden(true) // Opcional: esconde o botão de voltar
         }
     }
