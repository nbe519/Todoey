//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Eaton on 7/4/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - Tableview Datasource Methods
    
    //Make the number of rows in the table equal to that which are in the item array
    override func tableView(_ tableView : UITableView,  numberOfRowsInSection section: Int) -> Int {
        
        //creates 3 cells(the number of items in the array)
        return itemArray.count
        
    }
    
    //function that gets triggered when the table view looks to find something to display in it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //what should be the cell that we display at a row. This is for all number of cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //have the cell have the text of the item at x-location, gives the cell text
        //indexPath holds location of the cell
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    //This is triggered when the tableView is clicked
    //disSelectRowAt detects which row was selected. In  the method, we use that information to change the accessory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if you do not place itemArray before the indexPath.row, then it will just print the cell number
        //print(itemArray[indexPath.row])
        
        
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
    
    
    
}

