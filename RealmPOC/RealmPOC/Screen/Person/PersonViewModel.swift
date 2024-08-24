//
//  PersonViewModel.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/21/24.
//

import Combine
import RealmSwift

final class PersonViewModel {
    @Published var persons = [Person]()
    var personsModel = [PersonModel]()
    var cancellable = [AnyCancellable]()
    
    // Fetch all persons from the database
    func getPersons() {
        self.persons = DataBaseHelper.shared.getAllObjects(Person.self)
    }
    
    // Save a person to the database
    func savePerson(person: Person) {
        DataBaseHelper.shared.saveObject(person)
    }
    
    // Update a person in the database
    func updatePerson(
        id: UUID,
        person: Person
    ) {
        DataBaseHelper.shared.updateObject(by: id, with: person)
        getPersons() // Refresh the list
    }
    
    // Delete a person from the database
    func deletePerson(person: Person) {
        DataBaseHelper.shared.deleteObjects(by: person.pets)
        DataBaseHelper.shared.deleteObject(by: person)
        getPersons() // Refresh the list
    }
    
    func convertRealMObjectToCodaleObject() -> [PersonModel] {
        personsModel = persons.compactMap({
            person in
            return PersonModel(
                id: person.id,
                name: person.name,
                city: person.city,
                pets: person.pets.compactMap({
                    pet in
                    return PetModel(
                        id: pet.id,
                        name: pet.name,
                        breed: pet.breed
                    )
                })
            )
        })
        return personsModel
    }
}
