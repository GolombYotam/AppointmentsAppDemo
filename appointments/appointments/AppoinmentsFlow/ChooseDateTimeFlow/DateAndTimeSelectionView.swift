//
//  DateAndTimeSelectionViewModel.swift
//  appointments
//
//  Created by Yotam Golomb on 16/05/2024.
//

import SwiftUI

struct DateAndTimeSelectionView: View {
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    //@State private var isConfirmationViewPresented = false
    //@Binding var isPresented: Bool
    
    @ObservedObject var viewModel: DateAndTimeSelectionViewModel
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: String?
    let mainViewModel: MainViewModel
    let patientId: String
    
    var availableDates: Set<Date> {
        var dates = Set<Date>()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        for workingHour in viewModel.doctor.workingHours {
            for dayOffset in 0..<365 { // Check next 365 days
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: Date()),
                   calendar.component(.year, from: date) == currentYear ||
                    calendar.component(.year, from: date) == currentYear + 1 {
                    let weekday = calendar.component(.weekday, from: date)
                    if calendar.weekdaySymbols[weekday - 1] == workingHour.day {
                        dates.insert(calendar.startOfDay(for: date))
                    }
                }
            }
        }
        return dates
    }
    
    var availableHours: [String] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selectedDate)
        let dayName = calendar.weekdaySymbols[weekday - 1]
        
        if let workingHour = viewModel.doctor.workingHours.first(where: { $0.day == dayName }) {
            return workingHour.hours
        }
        return []
    }
    
    var body: some View {
        VStack {
            Text("Doctor: \(viewModel.doctor.firstName) \(viewModel.doctor.lastName)")
                .font(.headline)
            Text("Specialty: \(viewModel.specialty.name)")
                .font(.subheadline)
            
            CalendarView(selectedDate: $selectedDate, availableDates: availableDates)
            
            if !availableHours.isEmpty {
                Text("Available Hours:")
                    .font(.headline)
                    .padding(.top)
                
                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(availableHours, id: \.self) { hour in
                        Button(action: {
                            selectedTime = hour
                        }) {
                            Text(hour)
                                .foregroundColor(selectedTime == hour ? .white : .primary)
                                .padding()
                                .background(selectedTime == hour ? Color.blue : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.vertical, 4)
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                Text("No available hours for the selected date.")
                    .foregroundColor(.gray)
                    .padding(.top)
            }
            
            Spacer()
            
            Button(action: {
                // Logic for date and time selection
                if let selectedTime = selectedTime {
                    let confirmationViewModel = ConfirmationViewModel(
                        patientId: patientId,
                        doctor: viewModel.doctor,
                        specialtyName: viewModel.specialty.name,
                        appointmentDate: selectedDate,
                        appointmentTime: selectedTime
                    )
                    rootViewModel.currentView = .confirmation(patientId: patientId, confirmationViewModel: confirmationViewModel, dateAndTimeViewModel: viewModel, mainViewModel: mainViewModel)
                }
                
            }) {
                Text("Confirm")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 20)
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
}

