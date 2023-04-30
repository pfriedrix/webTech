//
//  File.swift
//  
//
//  Created by Pfriedrix on 25.04.2023.
//

import Foundation

struct JSONRPCError: Codable {
    let code: Int
    let message: String
}
