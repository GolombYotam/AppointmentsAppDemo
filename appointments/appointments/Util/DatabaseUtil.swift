//
//  DatabaseUtil.swift
//  appointments
//
//  Created by Yotam Golomb on 15/05/2024.
//

import Foundation

class DatabaseUtil {
    static let shared = DatabaseUtil()
    
    private init() {
        copyFilesToDocumentsDirectory()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Copy JSON files from the main bundle to the documents directory
    private func copyFilesToDocumentsDirectory() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        
        let files = ["specialties.json", "doctors.json", "users.json", "appointments.json"]
        
        for file in files {
            let bundleURL = Bundle.main.url(forResource: file, withExtension: nil)!
            let destinationURL = documentsURL.appendingPathComponent(file)
            
            if !fileManager.fileExists(atPath: destinationURL.path) {
                do {
                    try fileManager.copyItem(at: bundleURL, to: destinationURL)
                    print("\(file) copied to documents directory")
                } catch {
                    print("Error copying \(file): \(error)")
                }
            }
        }
    }
    
    // Read specialties from JSON
    func loadSpecialties() -> [Specialty] {
        let url = getDocumentsDirectory().appendingPathComponent("specialties.json")
        
        
        do {
            let data = try Data(contentsOf: url)
            let specialties = try JSONDecoder().decode([Specialty].self, from: data)
            return specialties
        } catch {
            print("Error decoding specialties JSON: \(error)")
            return []
        }
    }
    
    // Read doctors from JSON
    func loadDoctors() -> [Doctor] {
        let url = getDocumentsDirectory().appendingPathComponent("doctors.json")
        
        
        do {
            let data = try Data(contentsOf: url)
            let doctors = try JSONDecoder().decode([Doctor].self, from: data)
            return doctors
        } catch {
            print("Error decoding doctors JSON: \(error)")
            return []
        }
    }
    
    // Read user profiles from JSON
    func loadUsers() -> [UserProfile]? {
        let url = getDocumentsDirectory().appendingPathComponent("users.json")
        
        do {
            let data = try Data(contentsOf: url)
            let users = try JSONDecoder().decode(Users.self, from: data)
            return users.users
        } catch {
            print("Error decoding users JSON: \(error)")
            return nil
        }
    }
    
    // Read appointments from JSON
    func loadAppointments() -> [Appointment] {
        let url = getDocumentsDirectory().appendingPathComponent("appointments.json")
        
        do {
            let data = try Data(contentsOf: url)
            let appointments = try JSONDecoder().decode([Appointment].self, from: data)
            return appointments
        } catch {
            print("Error decoding appointments JSON: \(error)")
            return []
        }
    }
    
    // Read appointments from JSON
    func loadAppointmentsDTOs() -> [AppointmentDTO] {
        
        let url = getDocumentsDirectory().appendingPathComponent("appointments.json")
        
        do {
            let data = try Data(contentsOf: url)
            let appointments = try JSONDecoder().decode([AppointmentDTO].self, from: data)
            return appointments
        } catch {
            print("Error decoding appointments JSON: \(error)")
            return []
        }
    }
    
    
    
    // Add new appointment to JSON
    func addAppointment(newAppointment: AppointmentDTO) {
        // Load current appointments
        var appointments = loadAppointmentsDTOs()
        
        // Determine new ID
        let newId = (appointments.map { Int($0.id) ?? 0 }.max() ?? 0) + 1
        
        // Create a new appointment with incremented ID
        var newAppointment = newAppointment
        newAppointment.id = String(newId)
        
        // Append the new appointment
        appointments.append(newAppointment)
        
        // Save the updated list back to the JSON file in the documents directory
        let url = getDocumentsDirectory().appendingPathComponent("appointments.json")
        
        do {
            let data = try JSONEncoder().encode(appointments)
            try data.write(to: url)
        } catch {
            print("Error encoding appointments JSON: \(error)")
        }
    }
    
    // Delete appointment from JSON
    func deleteAppointment(_ appointmentId: String) {
        var appointments = loadAppointmentsDTOs()
        appointments.removeAll { $0.id == appointmentId }
        
        // Save updated appointments back to JSON file
        let url = getDocumentsDirectory().appendingPathComponent("appointments.json")
        do {
            let data = try JSONEncoder().encode(appointments)
            try data.write(to: url)
        } catch {
            print("Error saving updated appointments: \(error)")
        }
    }
}
