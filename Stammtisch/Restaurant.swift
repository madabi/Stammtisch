//
//  Restaurant.swift
//  Stammtisch
//
//  Created by Marco Bibrich and Lea Boesch on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON



class Restaurant : Object {
    dynamic var location_lat:Double = 0.0
    dynamic var location_long:Double = 0.0
    dynamic var name:String = ""
    dynamic var formatted_address:String = ""

    
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
