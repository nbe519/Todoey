//
//  Category.swift
//  Todoey
//
//  Created by Noah Eaton on 7/12/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//



import Foundation
import RealmSwift

//inside each category has items that point to a list of item objects
//Category is a realm object
class Category : Object {
    //has name property and is dynamic so we can monitor for changes in the property during run-time
    @objc dynamic var name : String = ""
    
    //set up relationships with realm
    //define forward relationship
    //relationship which specify that each category can have a number of items which is a list of item objects
    //this is similiar to an array/dictionary
    let items = List<Item>()
    
}
