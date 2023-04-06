//
//  File.swift
//  
//
//  Created by Pfriedrix on 01.04.2023.
//

import Fluent

// create migration CreateIncidents
struct CreateIncidents: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("incidents")
            .id()
            .field("description", .string, .required)
            .field("longitude", .double, .required)
            .field("latitude", .double, .required)
            .field("file", .data, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("incidents").delete()
    }
}

