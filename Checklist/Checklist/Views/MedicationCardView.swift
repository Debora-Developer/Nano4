//
//  MedicationCardView.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

import SwiftUI

struct MedicationCardView: View {
    @Binding var medication: Medication

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(medication.name), \(medication.dosage)")
                .font(.headline)

            Text(medication.instruction)
                .foregroundColor(.gray)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Duração")
                    .font(.subheadline).bold()

                HStack {
                    VStack(alignment: .leading) {
                        Text("Início")
                        Text(medication.startDate, style: .date)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Término")
                        Text(medication.endDate, style: .date)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Que horas?")
                    .font(.subheadline).bold()

                ForEach(medication.times, id: \.self) { time in
                    Text(time.formatted(date: .omitted, time: .shortened))
                }

                Button {
                    // lógica para adicionar novo horário
                } label: {
                    Label("Adicione um horário", systemImage: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

