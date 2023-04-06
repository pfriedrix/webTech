//
//  File.swift
//  
//
//  Created by Pfriedrix on 01.04.2023.
//

import Vapor
import Fluent

// create Controller for Incident model
struct IncidentController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let incidents = routes.grouped("incidents")
        incidents.post(use: create)
        incidents.get(use: index)
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Incident]> {
        return Incident.query(on: req.db).all()
    }
    
    // create new incident
    func create(req: Request) throws -> EventLoopFuture<Incident> {
        let content = try req.content.decode(IncidentContent.self)
        let fileData = Data(buffer: content.file.data)
        let incident = Incident(description: content.description, latitude: content.latitude, longitude: content.longitude, file: fileData)
        return incident.save(on: req.db).map { incident }
    }
}
