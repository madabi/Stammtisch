//
//  ProgramData.swift
//  Stammtisch
//
//  Created by Marco Bibrich and Lea Boesch on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation
import RealmSwift

class ProgramData : Object {
    
     var groupName: String? = "group"
     var startDate: Date? = Date()
     var frequency: String? = String()
     let anlaesse = RealmSwift.List<Anlass>()
   
    
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
