//
//  UserProfile.swift
//  appointments
//
//  Created by Yotam Golomb on 10/05/2024.
//

import Foundation

struct UserProfile: Codable {
    let id: String
    let birthDate: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let email: String
    let crowdType: String
    let kids: [KidProfile]?

    struct KidProfile: Codable {
        let id: String
        let birthDate: String
        let firstName: String
        let lastName: String
        let phoneNumber: String
        let email: String
        let crowdType: String
    }
}

struct Users: Codable {
    let users: [UserProfile]
}

