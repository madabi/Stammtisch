//
//  Anlass.swift
//  Stammtisch
//
//  Created by Lea Boesch on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation
import RealmSwift

class Anlass : Object {
    
    dynamic var eventDate: Date? = nil
    dynamic var restaurant: Restaurant? = nil
    
    
    
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}
