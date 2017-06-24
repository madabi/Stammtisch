//
//  ProgramData.swift
//  Stammtisch
//
//  Created by Lea Boesch on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation
import RealmSwift

class ProgramData: Object {
    
    dynamic var groupName: String? = "group"
    dynamic var startDate: Date? = Date()
    dynamic var frequency: String? = String()
   // var anlaesse: [Anlass]? = nil
    dynamic var anlaesse: [Anlass]? = nil

        
}
