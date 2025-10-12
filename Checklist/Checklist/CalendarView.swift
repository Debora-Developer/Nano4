//
//  CalendarView.swift
//  Checklist
//
//  Created by Débora Costa on 11/10/25.
//  Created by Thayssa Romão on 09/10/25.
//

import SwiftUI

struct WeekDay: Identifiable {
    let id = UUID()
    let date: Date
    
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var dayLetter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "pt_BR")
        return String(formatter.string(from: date).prefix(1)).capitalized
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
}

struct DayView: View {
    let day: WeekDay
    let isSelected: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 15) {
            Text(day.dayLetter)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isSelected ? .white : .secondary)
            
            Text(day.dayNumber)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .frame(width: 45, height: 80)
        .background(
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(Color(red: 0.51, green: 0.67, blue: 0.02))
                        .matchedGeometryEffect(id: "selectedBackground", in: namespace)
                }
                
                if day.isToday {
                    Circle()
                        .fill(isSelected ? .clear : Color(red: 0.51, green: 0.67, blue: 0.02, opacity: 0.5))
                        .frame(width: 40, height: 40)
                }
            }
        )
    }
}


struct WeekSlider: View {
    // Cria uma "ponte" para a view mãe.
    @Binding var selectedDate: Date
    
    @State private var days: [WeekDay] = []
    @State private var selectedDayId: UUID?
    
    // Namespace para a animação suave da seleção
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(days) { day in
                            DayView(
                                day: day,
                                isSelected: day.id == selectedDayId,
                                namespace: namespace
                            )
                            .id(day.id)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedDayId = day.id
                                    // Quando um dia é tocado, atualize a data na view mãe.
                                    selectedDate = day.date
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    self.days = generateDays()
                    
                    // Inicializa a seleção com a data de hoje
                    if let today = days.first(where: { $0.isToday }) {
                        self.selectedDayId = today.id
                        proxy.scrollTo(today.id, anchor: .center)
                    }
                }
                //Reage a mudanças na data selecionada pela view mãe
                .onChange(of: selectedDate) { _, newDate in
                    if let newSelectedDay = days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: newDate) }) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedDayId = newSelectedDay.id
                            proxy.scrollTo(newSelectedDay.id, anchor: .center)
                        }
                    }
                }
            }
        }
        .frame(height: 90) // Altura da barra de rolagem
    }
    
        func generateDays() -> [WeekDay] {
            let calendar = Calendar.current
            let today = Date()
            var tempDays: [WeekDay] = []
            
            // Gera 30 dias no passado e 30 dias no futuro
            for i in -30...30 {
                if let date = calendar.date(byAdding: .day, value: i, to: today) {
                    tempDays.append(WeekDay(date: date))
                }
            }
            return tempDays
    }
}

    // Atualiza o Preview para funcionar com o @Binding
    struct WeekSlider_Preview: View {
        @State private var previewDate = Date()
        var body: some View {
            WeekSlider(selectedDate: $previewDate)
        }
    }
