//
//  File.swift
//  
//
//  Created by Pfriedrix on 25.04.2023.
//

import Foundation

enum JSONRPCResult: Codable {
    case success(Any)
    case failure(JSONRPCError)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let successValue = try container.decode(JSONAny.self, forKey: .result)
            self = .success(try successValue.getValue())
        } catch {
            let errorValue = try container.decode(JSONRPCError.self, forKey: .error)
            self = .failure(errorValue)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .success(let value):
            let jsonAnyValue = try JSONAny(value)
            try container.encode(jsonAnyValue, forKey: .result)
        case .failure(let error):
            try container.encode(error, forKey: .error)
        }
    }

    enum CodingKeys: CodingKey {
        case result
        case error
    }
}

