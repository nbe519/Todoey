//
//  Item.swift
//  Todoey
//
//  Created by Noah Eaton on 7/12/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import Foundation
import RealmSwift

//subclassing realm object
class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //links each item back to a parent category, specify the type of link and the property name of the inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
