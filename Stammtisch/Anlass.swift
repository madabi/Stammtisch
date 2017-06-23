//
//  Anlass.swift
//  Stammtisch
//
//  Created by Lea Boesch on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation

class Anlass {
    
    var eventDate: Date!
    var restaurant: Restaurant
    
    init(eventDate: Date, restaurant: Restaurant){
        self.eventDate = eventDate
        self.restaurant = restaurant
    }
    
}
