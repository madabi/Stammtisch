//
//  ProgramData.swift
//  Stammtisch
//
//  Created by Lea Boesch on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation


class ProgramData {
    
    var groupName: String!
    var startDate: Date!
    var frequency: String!
    var restaurants: [Restaurant]
    
    init(groupName: String, startDate: Date, frequency: String, restaurants: [Restaurant]){
        self.groupName = groupName
        self.startDate = startDate
        self.frequency = frequency
        self.restaurants = restaurants
    }
    
}
