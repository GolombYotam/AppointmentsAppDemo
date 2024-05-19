//
//  DateAndTimeSelectionViewModel.swift
//  appointments
//
//  Created by Yotam Golomb on 16/05/2024.
//

import SwiftUI

class DateAndTimeSelectionViewModel: ObservableObject {
    @Published var doctor: Doctor
    @Published var specialty: Specialty
    let crowdType: String
    let firstName: String
    
    init(doctor: Doctor, specialty: Specialty, crowdType: String, firstName: String) {
        self.doctor = doctor
        self.specialty = specialty
        self.crowdType = crowdType
        self.firstName = firstName
    }
}
