//
//  CalendarView.swift
//  appointments
//
//  Created by Yotam Golomb on 16/05/2024.
//

import SwiftUI

//struct CalendarView: View {
//    @Binding var selectedDate: Date
//
//    @State private var selectedYear: String
//    @State private var selectedMonth: String
//
//    init(selectedDate: Binding<Date>) {
//        _selectedDate = selectedDate
//
//        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate.wrappedValue)
//        _selectedYear = State(initialValue: "\(components.year ?? Calendar.current.component(.year, from: Date()))")
//        _selectedMonth = State(initialValue: DateFormatter().shortMonthSymbols[components.month! - 1])
//    }
//
//    var body: some View {
//        VStack {
//            // Year and month selection
//            HStack {
//                // Year picker
//                Picker("Year", selection: $selectedYear) {
//                    ForEach(currentYear..<currentYear+5, id: \.self) { year in
//                        Text(String(year)).tag(String(year))
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
//                .padding()
//
//                // Month picker
//                                Picker("Month", selection: $selectedMonth) {
//                                    ForEach(monthsToShow(), id: \.self) { month in
//                                        Text(month).tag(month)
//                                    }
//                                }
//                                .pickerStyle(MenuPickerStyle())
//                                .padding()
//            }
//
//            // Grid of days
//            let firstDayOfMonth = Calendar.current.date(from: DateComponents(year: Int(selectedYear), month: DateFormatter().shortMonthSymbols.firstIndex(of: selectedMonth)! + 1))!
//            let range = Calendar.current.range(of: .day, in: .month, for: firstDayOfMonth)!
//            let daysInMonth = range.lowerBound..<range.upperBound
//
//            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
//                ForEach(daysInMonth, id: \.self) { day in
//                    let date = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
//                    DayView(date: date, isSelected: selectedDate == date, onSelect: { _ in selectedDate = date })
//                        .foregroundColor(isDateDisabled(date) ? .gray : .primary)
//                        .disabled(isDateDisabled(date))
//                }
//            }
//        }
//    }
//    
//    private func monthsToShow() -> [String] {
//        if selectedYear == String(currentYear) {
//            let currentMonthIndex = Calendar.current.component(.month, from: Date())
//            return Array(DateFormatter().shortMonthSymbols[currentMonthIndex-1..<DateFormatter().shortMonthSymbols.count])
//        } else {
//            return DateFormatter().shortMonthSymbols
//        }
//    }
//
//    private func isDateDisabled(_ date: Date) -> Bool {
//        let currentDate = Calendar.current.startOfDay(for: Date())
//        let selectedDate = Calendar.current.startOfDay(for: date)
//
//        if selectedDate < currentDate {
//            return true
//        }
//
//        if selectedYear == String(currentYear) && Calendar.current.component(.month, from: date) < Calendar.current.component(.month, from: currentDate) {
//            return true
//        }
//
//        return false
//    }
//
//    private var currentYear: Int {
//        return Calendar.current.component(.year, from: Date())
//    }
//}

struct CalendarView: View {
    @Binding var selectedDate: Date
    var availableDates: Set<Date> // Add this property

    @State private var selectedYear: String
    @State private var selectedMonth: String

    init(selectedDate: Binding<Date>, availableDates: Set<Date>) {
        _selectedDate = selectedDate
        self.availableDates = availableDates

        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate.wrappedValue)
        _selectedYear = State(initialValue: "\(components.year ?? Calendar.current.component(.year, from: Date()))")
        _selectedMonth = State(initialValue: DateFormatter().shortMonthSymbols[components.month! - 1])
    }

    var body: some View {
        VStack {
            // Year and month selection
            HStack {
                // Year picker
                Picker("Year", selection: $selectedYear) {
                    ForEach(currentYear..<currentYear+5, id: \.self) { year in
                        Text(String(year)).tag(String(year))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Month picker
                Picker("Month", selection: $selectedMonth) {
                    ForEach(monthsToShow(), id: \.self) { month in
                        Text(month).tag(month)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            }

            // Grid of days
            let firstDayOfMonth = Calendar.current.date(from: DateComponents(year: Int(selectedYear), month: DateFormatter().shortMonthSymbols.firstIndex(of: selectedMonth)! + 1))!
            let range = Calendar.current.range(of: .day, in: .month, for: firstDayOfMonth)!
            let daysInMonth = range.lowerBound..<range.upperBound

            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                ForEach(daysInMonth, id: \.self) { day in
                    let date = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
                    DayView(date: date, isSelected: selectedDate == date, onSelect: { _ in selectedDate = date }, availableDates: availableDates)
                        .foregroundColor(isDateDisabled(date) ? .gray : .primary)
                        .disabled(isDateDisabled(date))
                }
            }
        }
    }

    private func monthsToShow() -> [String] {
        if selectedYear == String(currentYear) {
            let currentMonthIndex = Calendar.current.component(.month, from: Date())
            return Array(DateFormatter().shortMonthSymbols[currentMonthIndex-1..<DateFormatter().shortMonthSymbols.count])
        } else {
            return DateFormatter().shortMonthSymbols
        }
    }

    private func isDateDisabled(_ date: Date) -> Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let selectedDate = Calendar.current.startOfDay(for: date)

        if selectedDate < currentDate || !availableDates.contains(selectedDate) {
            return true
        }

        if selectedYear == String(currentYear) && Calendar.current.component(.month, from: date) < Calendar.current.component(.month, from: currentDate) {
            return true
        }

        return false
    }

    private var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }
}


