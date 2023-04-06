//
//  File.swift
//  
//
//  Created by Pfriedrix on 01.04.2023.
//

import Vapor
import Fluent

// MARK: - model Incident
final class Incident: Model, Content {
    static let schema = "incidents"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "description")
    var description: String

    @Field(key: "latitude")
    var latitude: Double

    @Field(key: "longitude")
    var longitude: Double

    @Field(key: "file")
    var file: Data
    
    init() { }
    
    init(id: UUID? = nil, description: String, latitude: Double, longitude: Double, file: Data) {
        self.id = id
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.file = file
    }
}

struct IncidentContent: Content {
    var description: String
    var latitude: Double
    var longitude: Double
    var file: File
}
