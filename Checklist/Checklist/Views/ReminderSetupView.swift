//
//  ReminderModel.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

import SwiftUI

struct ReminderSetupView: View {
    @State var medications: [Medication]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach($medications) { $med in
                    MedicationCardView(medication: $med)
                }

                Button {
                    // ação final
                } label: {
                    Text("Criar lembretes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.51, green: 0.67, blue: 0.02))
                        .cornerRadius(30)
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}
