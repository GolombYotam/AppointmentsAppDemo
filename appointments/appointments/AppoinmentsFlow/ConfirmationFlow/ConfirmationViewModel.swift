//
//  ConfirmationViewModel.swift
//  appointments
//
//  Created by Yotam Golomb on 16/05/2024.
//

import SwiftUI

class ConfirmationViewModel: ObservableObject {
    @Published var doctor: Doctor
    @Published var specialtyName: String
    @Published var appointmentDate: Date
    @Published var appointmentTime: String
    @Published var patientId: String
    
    init(patientId: String, doctor: Doctor, specialtyName: String, appointmentDate: Date, appointmentTime: String) {
        self.patientId = patientId
        self.doctor = doctor
        self.specialtyName = specialtyName
        self.appointmentDate = appointmentDate
        self.appointmentTime = appointmentTime
    }
    
    func createAndAddAppointment(patientId: String) {
        // Combine date and time
        let dateFormatter = ISO8601DateFormatter()
        
        guard let appointmentDateTime = combineDateAndTime(date: appointmentDate, time: appointmentTime) else {
            print("Error combining date and time")
            return
        }
        
        let appointmentDateString = dateFormatter.string(from: appointmentDateTime)
        
        // Create appointment object
        let newAppointment = AppointmentDTO(
            id: "", // This will be set by the DatabaseUtil's addAppointment function
            patientId: patientId,
            doctorId: doctor.id,
            appointmentDate: appointmentDateString
        )
        
        // Check for conflicting appointments
        if hasConflictingAppointments(newAppointment: newAppointment) {
            print("Conflicting appointment exists")
            return
        }
        
        // Add appointment to the database
        DatabaseUtil.shared.addAppointment(newAppointment: newAppointment)
    }
    
    private func combineDateAndTime(date: Date, time: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateTimeFormatter.date(from: "\(dateString) \(time)")
    }
    
    private func hasConflictingAppointments(newAppointment: AppointmentDTO) -> Bool {
        let existingAppointments = DatabaseUtil.shared.loadAppointmentsDTOs()
        let doctors = DatabaseUtil.shared.loadDoctors()
        let specialties = DatabaseUtil.shared.loadSpecialties()
        
        guard let newAppointmentDate = ISO8601DateFormatter().date(from: newAppointment.appointmentDate),
              let newDoctor = doctors.first(where: { $0.id == newAppointment.doctorId }),
              let newSpecialty = specialties.first(where: { $0.id == newDoctor.specialtyID }) else {
            return false
        }
        
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -3, to: newAppointmentDate)!
        let endDate = calendar.date(byAdding: .month, value: 3, to: newAppointmentDate)!
        
        for appointment in existingAppointments {
            guard let appointmentDate = ISO8601DateFormatter().date(from: appointment.appointmentDate),
                  let appointmentDoctor = doctors.first(where: { $0.id == appointment.doctorId }),
                  let appointmentSpecialty = specialties.first(where: { $0.id == appointmentDoctor.specialtyID }) else {
                continue
            }

            if appointment.patientId == newAppointment.patientId &&
                ((appointment.doctorId == newAppointment.doctorId) ||
                 (appointmentSpecialty.id == newSpecialty.id)) &&
                (appointmentDate >= startDate && appointmentDate <= endDate) {
                return true
            }
        }
        return false
    }
}
