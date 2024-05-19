//
//  MainViewModel.swift
//  appointments
//
//  Created by Yotam Golomb on 10/05/2024.
//

import Foundation

// Main View Model
class MainViewModel: ObservableObject {
    @Published var mainUser: UserProfile?
    @Published var kids: [UserProfile.KidProfile]?
    
    @Published var appointments: [Appointment] = []
    @Published var doctors: [Doctor] = []
    @Published var specialties: [Specialty] = []
    @Published var selectedUserAppointments: [(appointment: Appointment, doctorName: String, specialty: String)] = []
    
    @Published var selectedPatientId: String?
    
    init(loginViewModel: LoginViewModel) {
        self.mainUser = loginViewModel.selectedUser
        self.kids = loginViewModel.selectedUser?.kids
    }
    
    // Load appointments from the database
    func loadAppointments() {
        appointments = DatabaseUtil.shared.loadAppointments()
    }
    
    // Load doctors from the database
    func loadDoctors() {
        doctors = DatabaseUtil.shared.loadDoctors()
    }
    
    // Load specialties from the database
    func loadSpecialties() {
        specialties = DatabaseUtil.shared.loadSpecialties()
    }
    
    // Filter appointments for the selected user
    func filterAppointments(selectedUserName: String) {
        guard let mainUser = mainUser else {
            selectedUserAppointments = []
            return
        }
        
        let selectedUserId: String?
        if selectedUserName == mainUser.firstName {
            selectedUserId = mainUser.id
        } else {
            selectedUserId = mainUser.kids?.first { $0.firstName == selectedUserName }?.id
        }
        
        if let userId = selectedUserId {
            selectedUserAppointments = appointments.filter { $0.patientId == userId }.compactMap { appointment in
                if let doctor = doctors.first(where: { $0.id == appointment.doctorId }) {
                    let specialty = specialties.first(where: { $0.id == doctor.specialtyID })?.name ?? "Unknown"
                    return (appointment: appointment, doctorName: "\(doctor.firstName) \(doctor.lastName)", specialty: specialty)
                } else {
                    return nil
                }
            }
        } else {
            selectedUserAppointments = []
        }
    }
    
    // Delete appointment
    func deleteAppointment(_ appointmentId: String) {
        DatabaseUtil.shared.deleteAppointment(appointmentId)
        loadAppointments()
        if let selectedUserName = mainUser?.firstName {
            filterAppointments(selectedUserName: selectedUserName)
        }
    }
}
