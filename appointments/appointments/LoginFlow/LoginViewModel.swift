//
//  LoginViewModel.swift
//  appointments
//
//  Created by Yotam Golomb on 10/05/2024.
//

import Foundation

// Login View Model
class LoginViewModel: ObservableObject {
    
    @Published var selectedUser: UserProfile?
    @Published var id: String = ""
    @Published var birthDate: String = ""
    @Published var showingAlert: Bool = false
    @Published var isDatePickerVisible = false
    @Published var isLoggedIn = false
    
    var errorMessage: String = ""
    var selectedDate = Date()
    
    // Function to perform login validation
    func login() -> Bool {
        
        guard let users = DatabaseUtil.shared.loadUsers() else {
            errorMessage = "Server Error"
            showingAlert = true // Show alert on login failure
            return false
        }
        for user in users {
            if id == user.id && birthDate == user.birthDate {
                selectedUser = user
                return true // Login successful
            }
        }

        errorMessage = "Invalid ID or Birth Date"
        showingAlert = true // Show alert on login failure
        return false // Login failed
        
    }
}


