//
//  SpecialtySelectionViewModel.swift
//  appointments
//
//  Created by Yotam Golomb on 15/05/2024.
//

import SwiftUI
import Combine

class SpecialtySelectionViewModel: ObservableObject {
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    @Published var specialties: [Specialty] = []
    @Published var selectedSpecialty: Specialty?
    @Published var doctors: [Doctor] = []
    
    let crowdType: String
    let firstName: String
    let patientId: String
    
    init(patientId: String, crowdType: String, firstName: String) {
        self.crowdType = crowdType
        self.firstName = firstName
        self.patientId = patientId
        loadSpecialties()
        loadDoctors()
    }
    
    private func loadSpecialties() {
        specialties = DatabaseUtil.shared.loadSpecialties().filter { $0.crowdType == crowdType }
    }
    
    private func loadDoctors() {
        doctors = DatabaseUtil.shared.loadDoctors().filter { $0.crowdType == crowdType }
    }
    
    func specialtyName(for id: Int) -> String {
        return specialties.first(where: { $0.id == id })?.name ?? "Unknown"
    }
    
    func availableHours(for doctor: Doctor) -> String {
        return doctor.workingHours.map { "\($0.day): \($0.hours.joined(separator: ", "))" }.joined(separator: "; ")
    }
}


