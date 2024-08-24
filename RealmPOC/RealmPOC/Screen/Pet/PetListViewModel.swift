//
//  PetListViewModel.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/22/24.
//

import Foundation
import Combine

final class PetListViewModel{
    
    @Published var person: Person?
    var cancellable = [AnyCancellable]()
    var id: UUID?
    
    //initializer
    init(){
        guard let id else { return }
        getPerson(id)
    }
    
    //get person depends on id
    func getPerson(_ ownerId: UUID){
        person = DataBaseHelper.shared.getObject(by: ownerId)
    }
    
    //save pet name and update the object
    func savePetObject(person: Person){
        guard let id = self.person?.id else { return }
        DataBaseHelper.shared.updateObject(
            by: id,
            with: person
        )
        self.getPerson(id)
    }
}
