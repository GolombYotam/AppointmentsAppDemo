//
//  Appointment.swift
//  appointments
//
//  Created by Yotam Golomb on 15/05/2024.
//

import Foundation

struct AppointmentDTO: Codable {
    var id: String
    var patientId: String
    var doctorId: String
    var appointmentDate: String
}


struct Appointment: Codable {
    var id: String
    let patientId: String
    let doctorId: String
    let appointmentDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case patientId
        case doctorId
        case appointmentDate
    }
    
    init(id: String, patientId: String, doctorId: String, appointmentDate: Date) {
        self.id = id
        self.patientId = patientId
        self.doctorId = doctorId
        self.appointmentDate = appointmentDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        patientId = try container.decode(String.self, forKey: .patientId)
        doctorId = try container.decode(String.self, forKey: .doctorId)
        let dateString = try container.decode(String.self, forKey: .appointmentDate)
        
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            appointmentDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .appointmentDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(patientId, forKey: .patientId)
        try container.encode(doctorId, forKey: .doctorId)
        
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: appointmentDate)
        try container.encode(dateString, forKey: .appointmentDate)
    }
    
    struct DateInfo {
        let fullDate: String
        let time: String
        let weekday: String
    }
    
    var dateInfo: DateInfo {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fullDate = dateFormatter.string(from: appointmentDate)
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: appointmentDate)
        
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: appointmentDate)
        
        return DateInfo(fullDate: fullDate, time: time, weekday: weekday)
    }
}
