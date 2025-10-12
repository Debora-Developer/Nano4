//
//  ReminderRepository.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//
import Foundation
import Combine

class ReminderRepository: ObservableObject {
    @Published var reminders: [ReminderModel] = []
    @Published var prescriptions: [PrescriptionModel] = []

    func addReminders(for prescription: PrescriptionModel, times: [Date]) {
        for time in times {
            let reminder = ReminderModel(
                prescriptionId: prescription.id,
                medicationName: prescription.name,
                dosage: prescription.dosage,
                time: time
            )
            reminders.append(reminder)
        }
    }
    
    //propriedade computada para o histórico
    var completedPrescriptions: [PrescriptionModel] {
        // Filtra as prescrições cuja data de término já passou
        prescriptions.filter { $0.endDate < Date() }
    }

    func reminders(for date: Date) -> [ReminderModel] {
        let calendar = Calendar.current
        return reminders.filter { calendar.isDate($0.time, inSameDayAs: date) }
    }

    func markAsTaken(_ reminder: ReminderModel) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isTaken.toggle()
        }
    }
}
