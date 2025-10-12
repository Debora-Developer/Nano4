//
//PrescriptionText.swift
//  Checklist
//
//  Created by Débora Costa on 12/10/25.
//


import Foundation

//Parseia o texto da IA
//A IA retorna o texto em formato simples. Quebra o texto em medicamentos usando separação por linhas em branco

func parsePrescriptionText(_ text: String) -> [PrescriptionModel] {
    var prescriptions: [PrescriptionModel] = []
    
    // Regex para encontrar "Nome (Dosagem): Instrução"
     let pattern = #"(.*?)\s*\((.*?)\):\s*(.*)"#
    
    // Divide o texto em linhas para analisar uma por uma
       let lines = text.split(separator: "\n")

    for line in lines {
           do {
               let regex = try NSRegularExpression(pattern: pattern)
               let nsString = String(line) as NSString
               let results = regex.matches(in: String(line), range: NSRange(location: 0, length: nsString.length))
               
               if let match = results.first {
                   // Grupo 1: Nome do Medicamento
                   let name = nsString.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespaces)
                   // Grupo 2: Dosagem
                   let dosage = nsString.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespaces)
                   // Grupo 3: Instrução
                   let instruction = nsString.substring(with: match.range(at: 3)).trimmingCharacters(in: .whitespaces)
                   
                   if !name.isEmpty {
                       prescriptions.append(PrescriptionModel(
                           name: name,
                           dosage: dosage,
                           frequencyHours: 8, // Valor padrão
                           durationDays: 7,   // Valor padrão
                           notes: instruction,
                           startDate: Date(),
                           endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!
                       ))
                   }
               }
           } catch {
               print("Regex inválido: \(error.localizedDescription)")
           }
       }
       
       return prescriptions
   }
