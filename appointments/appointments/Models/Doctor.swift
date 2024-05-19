//
//  Doctor.swift
//  appointments
//
//  Created by Yotam Golomb on 15/05/2024.
//

import Foundation

// Models
struct Specialty: Codable {
    let id: Int
    let name: String
    let description: String
    let crowdType: String
}

struct Doctor: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let crowdType: String
    let specialtyID: Int
    let workingHours: [WorkingDay]

    struct WorkingDay: Codable {
        let day: String
        let hours: [String]
    }
}

