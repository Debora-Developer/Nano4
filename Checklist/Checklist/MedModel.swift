//
//  MedModel.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//
import Foundation

struct Medication: Identifiable {
    let id = UUID()
    var name: String
    var dosage: String
    var instruction: String
    var startDate: Date
    var endDate: Date
    var times: [Date] // horários de tomada
}


