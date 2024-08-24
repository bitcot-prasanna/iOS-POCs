//
//  RealmModels.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/23/24.
//

import Foundation
import RealmSwift

class Person: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var city: String
    @Persisted var pets: List<Pet> // Non-optional List
    
    convenience init(id: UUID, name: String, city: String, pets: List<Pet>? = nil) {
        self.init()
        self.id = id
        self.name = name
        self.city = city
        guard let pets else {
            self.pets = List<Pet>()
            return
        }
        self.pets = pets
    }
}

class Pet: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var breed: String
    
    convenience init(id: UUID, name: String, breed: String) {
        self.init()
        self.id = id
        self.name = name
        self.breed = breed
    }
}
