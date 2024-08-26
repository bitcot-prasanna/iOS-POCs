//
//  DataBaseHelper.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/21/24.
//

import UIKit
import RealmSwift

class DataBaseHelper {
    // Shared instance
    static let shared = DataBaseHelper()
    // Realm instance
    private let realm: Realm?
    // Private init
    private init() {
        do {
            realm = try Realm()
        } catch {
            debugPrint("Error initializing Realm: \(error.localizedDescription)")
            realm = nil // Set realm to nil if initialization fails
        }
    }
    
    //MARK: - Get database path
    func getDatabasePath() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    //MARK: - Generic function to save an object
    func saveObject<T: Object>(_ object: T) {
        do {
            try realm?.write {
                realm?.add(object)
            }
        } catch {
            debugPrint("Error saving object: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Generic function to get all objects of a type
    func getAllObjects<T: Object>(_ type: T.Type) -> [T]  {
        guard let realm else {
            debugPrint("Realm not initialized")
            return []
        }
        
        let results = realm.objects(type)
        return Array(results)
    }
    
    //MARK: - Get one Object by ID
    func getObject<T: Object>(by id: UUID?) -> T {
        guard let id,
              let realm
        else { return T() }
        print("Fetching object of type \(T.self) with ID \(id)")
        return realm.object(ofType: T.self, forPrimaryKey: id) ?? T()
    }
    
    //MARK: - Update object by ID
    func updateObject<T: Object>(
        by id: UUID,
        with object: T
    ) {
        let oldObject: T = getObject(by: id)
        do {
            try realm?.write {
                for property in object.objectSchema.properties {
                    // Skip the id property to retain the original id
                    if property.name == "id" {
                        continue
                    }
                    // Copy each property value from the new object to the old object
                    oldObject.setValue(object.value(forKey: property.name), forKey: property.name)
                }
                debugPrint(oldObject,object, terminator: "\n")
            }
        } catch {
            debugPrint("Error updating Object: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete single object
    func deleteObject<T: Object>(by id: UUID,type object: T) {
        guard let data = realm?.object(ofType: T.self, forPrimaryKey: id) else { return }
        do {
            try realm?.write {
                realm?.delete(data)
            }
        } catch {
            debugPrint("Error deleting Object: \(error.localizedDescription)")
        }
    }
}
