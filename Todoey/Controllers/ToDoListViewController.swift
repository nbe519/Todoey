//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Eaton on 7/4/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    //following lines: converts arrayOfItems into a plist file we can save and retrive from
    var itemArray = [Item]()
    //Get the directory the data is being stored, return the location, and create a new plist in it
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(dataFilePath)
        
        
        //load up Item.plist
        loadItems()
    }

    //MARK: - Tableview Datasource Methods
    
    //Make the number of rows in the table equal to that which are in the item array
    override func tableView(_ tableView : UITableView,  numberOfRowsInSection section: Int) -> Int {
        
        //creates cells based on the number of items in the itemArray
        return itemArray.count
        
    }
    
    //Gets called everytime we want a new cell to appear
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //The following line does not work, because once the cell leaves the screen, it destroys the cell and creates a new one. When user scrolled back to the top it is forgetting if it needs an accessory
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
        
        //sets the done property to the opposite of what it currently is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

        
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
            
            self.saveItems()
            
        }
        //the parameter, alertTextField, helps configure the textField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //method which pushes the items into the Item.plist
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            //encode the itemArray
            let data = try encoder.encode(self.itemArray)
            //write the data to the dataFilePath
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
        
        //refresh the tableView
        self.tableView.reloadData()
    }
    //method which decodes the items in the Item.plist to display them back on the VC
    func loadItems() {
        //tap into our data by grabbing the property list
        if let data = try? Data(contentsOf: dataFilePath!) {
            //create the decoder
            let decoder = PropertyListDecoder()
            do {
                //decode the data from the dataFilePath, the data-type is of type Item
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error deconding item array \(error)")
            }
        }
    }
    
    
}

