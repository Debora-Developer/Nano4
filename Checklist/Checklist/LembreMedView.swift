//
//  LembreMedView.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

// Em LembreMedView.swift

import SwiftUI

struct LembreMedView: View {
    
    
    // Recebe o repositório compartilhado do ambiente
    @EnvironmentObject var reminderRepo: ReminderRepository
    // Esta variável é a "fonte da verdade" para o WeekSlider
    @State private var selectedDate = Date()
    // Estado para controlar a exibição do fluxo de adicionar receita
    @State private var isAddingPrescription = false
    
    // Helper para verificar se a data é a mesma
    //private func isSameDay(date1: Date, date2: Date) -> Bool {
    //Calendar.current.isDate(date1, inSameDayAs: date2)
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                WeekSlider(selectedDate: $selectedDate)
                
                Divider().padding(.vertical, 8)
                
                List {
                    // Se não houver lembretes para o dia, mostre uma mensagem
                    if reminderRepo.reminders(for: selectedDate).isEmpty {
                        Text("Nenhum lembrete para hoje.")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 50)
                    } else {
                        ForEach(reminderRepo.reminders(for: selectedDate)) { reminder in
                            HStack {
                                Button(action: {
                                    reminderRepo.markAsTaken(reminder)
                                }) {
                                    Image(systemName: reminder.isTaken ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(reminder.isTaken ? .blue : .gray)
                                        .font(.title2) // Um pouco maior para facilitar o toque
                                }
                                .buttonStyle(.plain) // Evita que a linha inteira pisque
                                
                                VStack(alignment: .leading) {
                                    Text(reminder.medicationName)
                                        .font(.headline)
                                    Text(reminder.dosage)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(reminder.time.formatted(date: .omitted, time: .shortened))
                                    .font(.callout)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.plain) // Um estilo mais limpo para a lista
                
                Button("+ Adicionar receita médica") {
                    isAddingPrescription = true
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(25)
                .padding()
                
                //Lógica de histórico
                VStack(alignment: .leading) {
                    Text("Histórico")
                        .font(.title3.bold())
                        .padding(.horizontal)
                    
                    // Propriedade do repositório
                    ForEach(reminderRepo.completedPrescriptions) { prescription in
                        VStack(alignment: .leading) {
                            Text(prescription.name)
                                .font(.headline)
                            // Usa a propriedade computada do PrescriptionModel
                            Text(prescription.formattedDuration)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    }
                }
                Spacer()
            }
            .navigationTitle("LembreMed")
        }
        // A modal para adicionar uma nova receita
        .fullScreenCover(isPresented: $isAddingPrescription) {
            AddPrescriptionView(onComplete: {})
                .environmentObject(reminderRepo)
        }
    }
}
