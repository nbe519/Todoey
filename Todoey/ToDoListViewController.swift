//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Eaton on 7/4/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - Tableview Datasource Methods
    
    //Make the number of rows in the table equal to that which are in the item array
    override func tableView(_ tableView : UITableView,  numberOfRowsInSection section: Int) -> Int {
        
        //creates cells based on the number of items in the itemArray
        return itemArray.count
        
    }
    
    //function that gets triggered when the table view looks to find something to display in it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //gets the cell(s) with identifier ToDoItemCell from the storyboard and allows it to be used
        //We are creating a reusable cell for memory conservation
        //the indexPath is the location of the cell we are initializing
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //have the cell have the text of the item at a certain location and provide the cell text
        //indexPath holds location of the cell
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    //This is triggered when the tableView is clicked
    //disSelectRowAt detects which row was selected. In  the method, we use that information to change the accessory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        //if the cell already has a checkmark, then change the accessory back to nothing
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            //the cell at this indexPath in our table view will have an accessory type of no accessory
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        //else, display a checkmark
        else {
            //the cell at this indexPath in our table view will have an accessory type of a checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            
            //what will happen once the user clicks the Add Item button on our UIAlert
            //force unwrap because the textField can never be nil
            self.itemArray.append(textField.text!)
            
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

