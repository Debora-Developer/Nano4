//
//  Prescription Model.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//

import Foundation

struct PrescriptionModel: Identifiable, Codable {
    var id = UUID()
    var name: String               // Ex: "Amoxicilina, 500mg"
    var dosage: String             // Ex: "1 cápsula"
    var frequencyHours: Int        // Ex: 8 (a cada 8 horas)
    var durationDays: Int          // Ex: 7 dias
    var notes: String?             // Ex: "Tomar se houver dor"
    var startDate: Date            // Data de início
    var endDate: Date              // Data de término

    // Computed property de conveniência
    var formattedDuration: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "\(formatter.string(from: startDate)) até \(formatter.string(from: endDate))"
    }
}
