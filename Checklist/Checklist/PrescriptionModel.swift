//
//  File.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//


import Foundation

//Parseia o texto da IA
//A IA retorna o texto em formato simples. Quebra o texto em medicamentos usando separação por linhas em branco

func parsePrescriptionText(_ text: String) -> [Medication] {
    let components = text.components(separatedBy: "\n\n")
    var medications: [Medication] = []

    for component in components {
        let lines = component.split(separator: "\n").map { String($0) }
        guard lines.count >= 2 else { continue }

        let nameAndDose = lines[0]
        let instruction = lines[1]

        let parts = nameAndDose.components(separatedBy: ", ")
        let name = parts.first ?? ""
        let dosage = parts.count > 1 ? parts[1] : ""

        // exemplo simples de duração
        let start = Date()
        let end = Calendar.current.date(byAdding: .day, value: 21, to: start)!

        // cria horários padrões (7h, 15h, 23h)
        let times = ["07:00", "15:00", "23:00"].compactMap { timeString in
            var components = DateComponents()
            let parts = timeString.split(separator: ":")
            components.hour = Int(parts[0])
            components.minute = Int(parts[1])
            return Calendar.current.date(from: components)
        }

        medications.append(Medication(
            name: name,
            dosage: dosage,
            instruction: instruction,
            startDate: start,
            endDate: end,
            times: times
        ))
    }

    return medications
}
