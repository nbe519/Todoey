//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Eaton on 7/4/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Buy eggos"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Destroy Demogorgon"
        itemArray.append(newItem2)
        
        print(itemArray)
        
        //Returns the array for the specific key
        //as! [Items]  means that the retrieved information will be used as an array ([ ]) of Item values.
        //Whent the project loads, it should load up each cell taht the user added
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }

    //MARK: - Tableview Datasource Methods
    
    //Make the number of rows in the table equal to that which are in the item array
    override func tableView(_ tableView : UITableView,  numberOfRowsInSection section: Int) -> Int {
        
        //creates cells based on the number of items in the itemArray
        return itemArray.count
        
    }
    
    //Gets called everytime we want a new cell to appear
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //The following line does not work, because once the cell leaves the screen, it destroys the cell and creates a new one when scrolled back to the top; forgetting the accessory
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        //gets the cell(s) with identifier ToDoItemCell from the storyboard and allows it to be re-used when it leaves the screen
        //We are creating a reusable cell for memory conservation
        //Go and find the prototype cell, ToDoItemCell, generate a bunch that can be reused. Once the item is no longer visible, it will reused by going to bottom of table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]
        
        //have the cell have the text of the item at a certain location and provide the cell text
        //indexPath holds location of the cell
        cell.textLabel?.text = item.title
         
        //Ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
        //Set the cell accessoryType based on if the item.done is true, if it is, place a checkmark, else put nothing
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    //This is triggered when the tableView is clicked
    //disSelectRowAt detects which row was selected. In  the method, we use that information to change the accessory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //sets the done property to the opposite of the currentItem
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        //after cell is clicked, deselect it
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Create an alert with an action and a textField, and once the user taps the action, it adds whatecher they typed into the textField and appends it to array which adds it to the tableView
        var textField = UITextField()
        
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        //the title of the action is what is clicked when the user is done
        //the action keyword in the closure is the action that will be completed when the user taps the button
        let action = UIAlertAction(title: "Add Button", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            //what will happen once the user clicks the Add Item button on our UIAlert
            //force unwrap because the textField can never be nil
            self.itemArray.append(newItem)
            
            //forKey is the key where the items are going to be retrived from
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //refresh the tableView
            self.tableView.reloadData()
            
        }
        //the parameter, alertTextField, helps configure the textField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

