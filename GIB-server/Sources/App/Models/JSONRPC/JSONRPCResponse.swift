//
//  File.swift
//  
//
//  Created by Pfriedrix on 25.04.2023.
//

import Foundation
import Vapor

struct JSONRPCResponse: Codable, ResponseEncodable {
    func encodeResponse(for request: Vapor.Request) -> NIOCore.EventLoopFuture<Vapor.Response> {
        do {
            let data = try JSONEncoder().encode(self)
            let response = Response(status: .ok, body: .init(data: data))
            response.headers.replaceOrAdd(name: .contentType, value: "application/json")
            return request.eventLoop.makeSucceededFuture(response)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
    
    let jsonrpc: String
    let id: Int
    let result: JSONRPCResult
}

