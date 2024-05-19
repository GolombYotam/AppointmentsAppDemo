//
//  MainView.swift
//  appointments
//
//  Created by Yotam Golomb on 10/05/2024.
//

import SwiftUI

// Main View
struct MainView: View {
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    @ObservedObject var viewModel: MainViewModel
    @State private var selectedUserName: String
    @State private var selectedCrowdType: String
    @State private var selectedPatientId: String
    
    
    @State private var isSpecialtySelectionViewPresented = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        // Initialize selectedUserName with the main user's first name
        if let mainUser = viewModel.mainUser {
            _selectedUserName = State(initialValue: mainUser.firstName)
            _selectedCrowdType = State(initialValue: mainUser.crowdType)
            _selectedPatientId = State(initialValue: mainUser.id)
        } else {
            _selectedUserName = State(initialValue: "")
            _selectedCrowdType = State(initialValue: "over18")
            _selectedPatientId = State(initialValue: "")
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack {
                    Text("Current Patient:")
                    Picker(selection: $selectedUserName, label: Text("")) {
                        if let mainUser = viewModel.mainUser {
                            // Unwrap mainUser
                            let userNames = [mainUser.firstName] + (mainUser.kids?.map({ $0.firstName }) ?? [])
                            ForEach(userNames, id: \.self) { userName in
                                Text(userName)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.white)
                    .onChange(of: selectedUserName) { newValue in
                        onPickerChange(newValue: newValue)
                    }
                }
                .background(Color.white)
                
                // Your main UI here
                // Headline for appointments
                Text("Your Appointments")
                    .font(.headline)
                    .padding(.top, 5)
                
                // Conditional view based on whether there are appointments
                if viewModel.selectedUserAppointments.isEmpty {
                    // Message for no appointments
                    Text("No Appointments Scheduled Yet")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // List of appointments
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.selectedUserAppointments, id: \.appointment.id) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Doctor: \(item.doctorName)")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Specialty: \(item.specialty)")
                                            .font(.subheadline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Date: \(item.appointment.dateInfo.fullDate)")
                                            .font(.subheadline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Weekday: \(item.appointment.dateInfo.weekday)")
                                            .font(.caption)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("Time: \(item.appointment.dateInfo.time)")
                                            .font(.caption)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    
                                    Spacer()
                                    Button(action: {
                                        viewModel.deleteAppointment(item.appointment.id)
                                        
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .padding()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                            .listRowBackground(Color.white)
                            .padding(.horizontal, 10)
                            .listRowSeparator(.hidden)
                            
                            
                        }
                        .padding(.top, 10)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                    }
                }
                Spacer()
                
            }
            .padding()
            .background(Color.white)
            .navigationBarTitle("Hello, \(selectedUserName)")
            .onAppear {
                onAppear()
            }
            
            // Floating button to schedule appointment
            Button(action: {
                onButtonPressed()
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            .padding(.bottom, 20)
            .padding(.trailing, 20)
        }
    }
    
    private func onButtonPressed() {
        viewModel.selectedPatientId = selectedPatientId
        rootViewModel.currentView = .specialtySelection(crowdType: selectedCrowdType, firstName: selectedUserName, mainViewModel: viewModel)
    }
    
    private func onAppear() {
        viewModel.loadDoctors()
        viewModel.loadSpecialties()
        viewModel.loadAppointments()
        viewModel.filterAppointments(selectedUserName: selectedUserName)
    }
    
    private func onPickerChange(newValue: String) {
        if let mainUser = viewModel.mainUser {
            if newValue == mainUser.firstName {
                selectedCrowdType = mainUser.crowdType
                selectedPatientId = mainUser.id
            } else if let kid = mainUser.kids?.first(where: { $0.firstName == newValue }) {
                selectedCrowdType = kid.crowdType
                selectedPatientId = kid.id
            }
        }
        viewModel.filterAppointments(selectedUserName: selectedUserName)
    }
}

// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(loginViewModel: LoginViewModel()))
    }
}

