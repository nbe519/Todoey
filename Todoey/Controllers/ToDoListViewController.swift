//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Eaton on 7/4/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    //following lines: converts arrayOfItems into a plist file we can save and retrive from
    var itemArray = [Item]()
    
    //(C.R.U.D)
    //tapping into the UIapplicationClass, we are getting the shared singleton element(this corresponds to the current app as an object) tapping into its delegate with the data-type of an optional UIApplicationDelegate, casting it to our class Appdelegate. Now have access to appDelegate as an object.
    //Context is a temporary area, where you create things in the database, you do not do this directly in the persistentContainer. Only once you decided you are happy with your results, do you save the context
    //context is a constant that goes into appDelegate then we grab a reference to the viewContext.
    //viewContext is the temporary area that our app talks to
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //load up the data
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
        
        //indexPath.row is going to hold the value of the row the resuableCell is at. If the Cell is at indexPath 1, then the itemArray is going to hold the 1-element inside
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
        

//        //removes from the context, this has to be called before we remove it from the itemArray
//        context.delete(itemArray[indexPath.row])
//        //removes the data from the itemArray, which loads up tableViewDataSource
//        itemArray.remove(at: indexPath.row)
//
        
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
            
            
            //When we add a new item to our tableview, we create a new object of type Item(automatically generated when we create a new entity), class already has access to all the properties. Type NSManagedObject, the rows that are inside the table, every row is its own NSManagedObject. Then we fill each of its fields then save it.
            //not only initializes new item but also inserts it to the context
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            //declare all new items with the done equal to false, no checkmark
            newItem.done = false
            
            //what will happen once the user clicks the Add Item button on our UIAlert
            //force unwrap because the textField can never be nil
            self.itemArray.append(newItem)
            
            //save the items whenever a newItem is appended to the itemArray
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
    //transfer what is in the staging area to our permament data-source
    //This is called when we create a new Item and when we change the .done attribute
    func saveItems() {
        do {
            //try to save the data
            //looks at context, temporary area(which was changed when we created a new item), then we save the context to commit unsaved changes to the persistentStore
            try context.save()
        } catch {
            print("Error saving contex \(error)")
        }
        
        //refresh the tableView
        self.tableView.reloadData()
    }
    //method which pulls out every Item inside the persistentContainer
    //external/internal parameter/also include a default value
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            //try to fetch all of the data and set the itemArray equal to the request
            itemArray = try context.fetch(request)//output for this method is an array of items that is stored in persistentData
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    
}
//MARK: - Search bar methods

//Split up functionality of viewController
extension ToDoListViewController : UISearchBarDelegate {
    
    //query the database and get the result the user is sending
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //This fetches all Item results, we later set limitations to it
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //tag on a query, specifies what we want to get back from database
        //When we hit search bar, whatever text placed into the searchBar into the %@. Then the query looks for all the items in the item array and look for the ones where the titles contain that text(%@)
        //NSPredicate is a foundation class that specifies how data should be fetched or sorted
        //[cd] makes the list case-insensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Sort the title data in alphabetal order
        //add the sortDescriptor to the fetchRequest and it expects an array
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //pass the request into the loadItems method, then we perform it
        //Attempt to fetch the data, and if successful, make it equal to the itemArray
        loadItems(with: request)
        
        
        tableView.reloadData()
    }
    //Function gets called everytime a letter is typed in or the (x) is pressed (text is changed)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //looks at number of characters in the searchBar
        if searchBar.text?.count == 0 {
            //Fetch all the items, uses the default value as we give no parameter
            loadItems()
            
            //manager that assigns projects to different threads, ask it to grab the main thread
            //get the main Queue then resignFirstResponder
            DispatchQueue.main.async {
                //dismiss the keyboard by have the keyboard go away because we are no longing editing it, go back to the state it was before it was active
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

