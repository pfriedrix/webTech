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
        incidents.post("jsonrpc", use: jsonrpc)
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Incident]> {
        return Incident.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Incident> {
        let content = try req.content.decode(IncidentContent.self)
        let fileData = Data(buffer: content.file.data)
        let incident = Incident(description: content.description, latitude: content.latitude, longitude: content.longitude, file: fileData)
        return incident.save(on: req.db).map { incident }
    }
    
    func jsonrpc(req: Request) throws -> EventLoopFuture<JSONRPCResponse> {
        let content = try req.content.decode(JSONRPCRequest.self)
        switch content.method {
        case "getAll":
            return Incident.query(on: req.db).all().map { incidents in
                JSONRPCResponse(jsonrpc: "2.0", id: content.id, result: .success(incidents))
            }
        case "create":
            let file = content.params.first { $0.key == "file" }?.value as? File
            let description = content.params.first { $0.key == "description" }?.value as? String
            let latitude = content.params.first { $0.key == "latitude" }?.value as? Double
            let longitude = content.params.first { $0.key == "longitude" }?.value as? Double
           
            guard let file = file,
                  let description = description,
                  let latitude = latitude,
                  let longitude = longitude
            else {
                let error = JSONRPCError(code: -32602, message: "Invalid params")
                let response = JSONRPCResponse(jsonrpc: "2.0", id: content.id, result: .failure(error))
                return req.eventLoop.makeSucceededFuture(response)
            }
            let fileData = Data(buffer: file.data)
            let incident = Incident(description: description, latitude: latitude, longitude: longitude, file: fileData)
            return incident.save(on: req.db).map {
                JSONRPCResponse(jsonrpc: "2.0", id: content.id, result: .success("Created"))
            }
        default:
            let error = JSONRPCError(code: -32601, message: "Method not found")
            let response = JSONRPCResponse(jsonrpc: "2.0", id: content.id, result: .failure(error))
            return req.eventLoop.makeSucceededFuture(response)
        }
    }
}
