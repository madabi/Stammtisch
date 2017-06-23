//
//  Anlass.swift
//  Stammtisch
//
//  Created by Lea Boesch on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation

class Anlass {
    
    var date: Date!
    var restaurant: Restaurant!
    
    init(date: Date, restaurant: Restaurant){
        self.date = date
        self.restaurant = restaurant
    }
    
}
