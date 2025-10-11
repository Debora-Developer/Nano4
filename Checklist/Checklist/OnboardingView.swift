//
//  Untitled.swift
//  Checklist
//
//  Created by Débora Costa on 11/10/25.
//
import SwiftUI

struct OnboardingView: View {
    // MARK: Properties
    /// A closure executada quando o usuário toca no botão de continuar.
    /// É opcional (`?`) e permite que a view pai reaja à conclusão do onboarding.
    var onContinue: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.11, green: 0.29, blue: 1).opacity(0), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.02, green: 0.08, blue: 0.34), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .ignoresSafeArea()
            
            Image("Onboarding_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 60) {
                Image("LembreMed_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                VStack(alignment: .leading, spacing: 30) {
                    FeatureRow(
                        icon: "text.document.fill",
                        text: "Transcreva os remédios com uma foto da sua receita médica."
                    )
                    FeatureRow(
                        icon: "pills.fill",
                        text: "Acompanhe o uso dos remédios marcando os que já tomou."
                    )
                    FeatureRow(
                        icon: "alarm.fill",
                        text: "Defina horários e receba lembrete de quando comprar mais."
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                Button(action: {
                    // Chama a closure 'onContinue' (o callback) se ela foi fornecida,
                    // usando optional chaining (`?`) para evitar falhas se for nil.
                    onContinue?()
                }) {
                    HStack{
                        Image(systemName: "camera.fill")
                            .foregroundStyle(.white)
                        Text("Tirar foto da receita médica")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 16)
                    .frame(width: 248)
                     //cor verde
                    .background(Color(red: 0.51, green: 0.67, blue: 0.02))
                    .cornerRadius(32)
                }
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 16)
        }
        //cor verde
        .background(Color(red: 0.51, green: 0.67, blue: 0.02))
    }
}

//Estrutura da linha
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                //cor verde
                    .fill(Color(red: 0.51, green: 0.67, blue: 0.02))
                    .frame(width: 56, height: 56)
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 28))
            }
            
            Text(text)
                .foregroundStyle(.white)
                .font(.body)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
