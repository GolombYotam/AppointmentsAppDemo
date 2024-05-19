//
//  ChooseSpecialtyView.swift
//  appointments
//
//  Created by Yotam Golomb on 11/05/2024.
//

import SwiftUI

struct SpecialtySelectionView: View {
    
    @EnvironmentObject var rootViewModel: RootViewModel
    @ObservedObject var viewModel: SpecialtySelectionViewModel
    @State private var selectedDoctorId: String?
    
    private let navBarTitle: String
    let mainViewModel: MainViewModel
    
    init(crowdType: String, firstName: String, mainViewModel: MainViewModel) {
        self.navBarTitle = "Doctors for \(firstName)"
        self.mainViewModel = mainViewModel
        if let selectedPatientId = mainViewModel.selectedPatientId {
            self.viewModel = SpecialtySelectionViewModel(patientId: selectedPatientId, crowdType: crowdType, firstName: firstName)
        } else {
            self.viewModel = SpecialtySelectionViewModel(patientId: "", crowdType: crowdType, firstName: firstName)

        }
    }
    
    var body: some View {
        VStack {
            if viewModel.doctors.isEmpty {
                Text("No doctors available for the selected specialty.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.doctors, id: \.id) { doctor in
                            Button(action: {
                                selectedDoctorId = doctor.id
                            }) {
                                VStack(alignment: .leading) {
                                    Text("\(doctor.firstName) \(doctor.lastName)")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Specialty: \(viewModel.specialtyName(for: doctor.specialtyID))")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    ForEach(doctor.workingHours, id: \.day) { workingHour in
                                        Text("\(workingHour.day): \(workingHour.hours.joined(separator: ", "))")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedDoctorId == doctor.id ? Color.blue : Color.gray, lineWidth: 1)
                                )
                                .padding(.horizontal, 5)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .background(Color.clear)
                .padding(.bottom, 5)
            }
            
            // Button to open DateAndTimeSelectionView
            Spacer()
            Button(action: {
                goToDateAndTimeSelectionView()
                
            }, label: {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 20)
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
        .navigationBarTitle(navBarTitle, displayMode: .inline)
    }
    
    private func goToDateAndTimeSelectionView() {
        if let selectedDoctorId = selectedDoctorId,
           let selectedDoctor = viewModel.doctors.first(where: { $0.id == selectedDoctorId }),
           let selectedSpecialty = viewModel.specialties.first(where: { $0.id == selectedDoctor.specialtyID }) {
            let dateAndTimeViewModel = DateAndTimeSelectionViewModel(doctor: selectedDoctor, specialty: selectedSpecialty, crowdType: viewModel.crowdType, firstName: viewModel.firstName)
            rootViewModel.currentView = .dateAndTimeSelection(patientId: mainViewModel.selectedPatientId ?? "", dateAndTimeViewModel: dateAndTimeViewModel, mainViewModel: mainViewModel)
        }
    }
}

