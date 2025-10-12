//
//  ReminderModel.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

import Foundation

struct ReminderModel: Identifiable, Codable {
    var id = UUID()
    var prescriptionId: UUID       // Link com PrescriptionModel
    var medicationName: String
    var dosage: String
    var time: Date                 // Horário do lembrete
    var isTaken: Bool = false      // Marcação de concluído
}
