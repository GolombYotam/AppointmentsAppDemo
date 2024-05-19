//
//  ConfirmationView.swift
//  appointments
//
//  Created by Yotam Golomb on 11/05/2024.
//

import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var rootViewModel: RootViewModel
    @ObservedObject var viewModel: ConfirmationViewModel
    let mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text("Doctor: \(viewModel.doctor.firstName) \(viewModel.doctor.lastName)")
                .font(.headline)
                .padding()
            Text("Specialty: \(viewModel.specialtyName)")
                .font(.subheadline)
                .padding()
            Text("Date: \(viewModel.appointmentDate, formatter: dateFormatter)")
                .font(.subheadline)
                .padding()
            Text("Time: \(viewModel.appointmentTime)")
                .font(.subheadline)
                .padding()
            
            Spacer()
            
            Button(action: {
                viewModel.createAndAddAppointment(patientId: viewModel.patientId)
                rootViewModel.currentView = .main(mainViewModel: mainViewModel)
            }) {
                Text("Done")
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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

