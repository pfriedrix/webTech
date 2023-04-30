//
//  CreateIncidentVM.swift
//  GIB-client
//
//  Created by Pfriedrix on 01.04.2023.
//

import Foundation

class IncidentVM: ObservableObject {
    @Published var incident = Incident(description: "", latitude: 0, longitude: 0, file: Data())
    
    private let urlString = "http://localhost:8080/incidents"
    
    func create(_ completion: @escaping (Result<Incident, Error>) -> Void) {
        guard incident.file.count > 0 else {
            print("No file")
            completion(.failure(NSError(domain: "No file", code: 0, userInfo: nil)))
            return
        }
        
        let file: [String: Any] = [
            "data": incident.file.base64EncodedString(),
            "filename": "image.png"
        ]
        
        let incident: [String: Any] = [
            "description": incident.description,
            "latitude": incident.latitude,
            "longitude": incident.longitude,
            "file": file,
        ]
        API.shared.post(url: urlString, body: incident) { (result: Result<Incident, Error>) in
            switch result {
            case .success(let incident):
                completion(.success(incident))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createJSONRPC(_ completion: @escaping (Result<Bool, Error>) -> Void) {
        guard incident.file.count > 0 else {
            print("No file")
            completion(.failure(NSError(domain: "No file", code: 0, userInfo: nil)))
            return
        }
        
        let file: [String: Any] = [
            "data": incident.file.base64EncodedString(),
            "filename": "image.png"
        ]
        
        let incident: [String: Any] = [
            "description": incident.description,
            "latitude": incident.latitude,
            "longitude": incident.longitude,
            "file": file,
        ]
        
        let body: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "create",
            "id": 1,
            "params": incident
        ]
        
        let jsonrpcURL = urlString + "/jsonrpc"
        API.shared.post(url: jsonrpcURL, body: body) { (result: Result<JSONRPCResponse, Error>) in
            switch result {
            case .success(let incident):
                print(incident)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}


