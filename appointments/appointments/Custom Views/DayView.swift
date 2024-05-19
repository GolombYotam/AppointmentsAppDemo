//
//  DayView.swift
//  appointments
//
//  Created by Yotam Golomb on 16/05/2024.
//

import SwiftUI

//struct DayView: View {
//    var date: Date
//    var isSelected: Bool
//    var onSelect: (Date) -> Void
//
//    var body: some View {
//        Button(action: {
//            onSelect(date)
//        }) {
//            Text("\(Calendar.current.component(.day, from: date))")
//                .foregroundColor(isSelected ? .white : isIrrelevantDate(date) ? .gray : .primary)
//                .frame(width: 30, height: 30)
//                .background(isSelected ? Color.blue : Color.clear)
//                .clipShape(Circle())
//        }
//        .disabled(isIrrelevantDate(date))
//    }
//
//    private func isIrrelevantDate(_ date: Date) -> Bool {
//        let currentDate = Calendar.current.startOfDay(for: Date())
//        let selectedDate = Calendar.current.startOfDay(for: date)
//
//        if selectedDate < currentDate {
//            return true
//        }
//
//        return false
//    }
//}

struct DayView: View {
    var date: Date
    var isSelected: Bool
    var onSelect: (Date) -> Void
    var availableDates: Set<Date> // Add this property

    var body: some View {
        Button(action: {
            onSelect(date)
        }) {
            Text("\(Calendar.current.component(.day, from: date))")
                .foregroundColor(isSelected ? .white : isIrrelevantDate(date) ? .gray : .primary)
                .frame(width: 30, height: 30)
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
        }
        .disabled(isIrrelevantDate(date))
    }

    private func isIrrelevantDate(_ date: Date) -> Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let selectedDate = Calendar.current.startOfDay(for: date)

        if selectedDate < currentDate || !availableDates.contains(selectedDate) {
            return true
        }

        return false
    }
}

