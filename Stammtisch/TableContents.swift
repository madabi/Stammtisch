//
//  TableContents.swift
//  Stammtisch
//
//  Created by Lea Boesch on 24.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation
import RealmSwift

class TableContents: Object {
    let cells = List<CellContent>()

}
