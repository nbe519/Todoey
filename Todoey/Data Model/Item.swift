//
//  Item.swift
//  Todoey
//
//  Created by Noah Eaton on 7/6/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import Foundation

//the item type is now able to encode itself in the plist
class Item : Codable {
    var title : String = ""
    var done : Bool = false
}
