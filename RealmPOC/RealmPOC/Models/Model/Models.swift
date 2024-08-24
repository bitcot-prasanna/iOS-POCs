//
//  Models.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/23/24.
//

import Foundation

struct PersonModel: Codable {
    var id: UUID
    var name: String
    var city: String
    var pets: [PetModel]?
}

struct PetModel: Codable {
    var id: UUID
    var name: String
    var breed: String
}

