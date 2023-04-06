//
//  Incident.swift
//  GIB-client
//
//  Created by Pfriedrix on 01.04.2023.
//

import Foundation
import MapKit

class Incident: Codable, Identifiable, Hashable {
    // comfort hashable
    static func == (lhs: Incident, rhs: Incident) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID?
    var description: String
    var latitude: Double
    var longitude: Double
    var file: Data
    
    var coordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    }
    
    init(id: UUID? = nil, description: String, latitude: Double, longitude: Double, file: Data) {
        self.id = id
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.file = file
    }
}
