//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Eaton on 7/4/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    
    //nil until set using the prepareForSegue
    //Load up all the items that is relevant to the Category
    //Grabs the category the user pressed
    //loads all the todolistItems
    //the selectedCategory becomes the indexPath.row of whatever category was pressed
    var selectedCategory : Category? {
        //what should happen as soon as selectedCategory gets set with a value
        didSet{
            loadItems()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    //MARK: - Tableview Datasource Methods
    
    
    
    
    
    
    //Make the number of rows in the table equal to that which are in the item array
    override func tableView(_ tableView : UITableView,  numberOfRowsInSection section: Int) -> Int {
        
        //creates cells based on the number of items in the itemArray
        return todoItems?.count ?? 1
        
    }
    
    //Gets called everytime we want a new cell to appear
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //The following line does not work, because once the cell leaves the screen, it destroys the cell and creates a new one. When user scrolled back to the top it is forgetting if it needs an accessory
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        //Go and find the prototype cell, ToDoItemCell, generate a bunch that can be reused. Once the item is no longer visible, it will reused by going to bottom of table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //indexPath.row is going to hold the value of the row the resuableCell is at. If the Cell is at indexPath 1, then the itemArray is going to hold the 1-element inside
        //if there are no todoItems then the text will be "No Items Added"
        if let item = todoItems?[indexPath.row] {
            
            //have the cell have the text of the item at a certain location and provide the cell text
            //indexPath holds location of the cell
            //Set the text to whatever the title is at the specific indexPath for the itemArray
            cell.textLabel?.text = item.title
            
            //Ternary operator
            //value = condition ? valueIfTrue : valueIfFalse
            //Set the cell accessoryType based on if the item.done is true, if it is, place a checkmark, else put nothing
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    //This is triggered when the tableView is clicked
    //disSelectRowAt detects which row was selected. In the method, we use that information to change the accessory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check to see if todoItems is nil, then we set it to the item they clicked on, later to try to write the updated property of the item and setting it to the opposite
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
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
            
            
           //add a new item to the list
            //look if selectedCategory is nil
            if let currentCategory = self.selectedCategory {
                do{
                    //update realm
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    //set currentCategory item property to append newItem to end of list
                    //newItem has a title, dateCreated and done value
                    currentCategory.items.append(newItem)
                    print(currentCategory.items)
                }
                
            }
                catch {
                    print("Error saving new items, \(error)")
                }
            }
            
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
    //transfer what is in the staging area to our permament data-source
    //This is called when we create a new Item and when we change the .done attribute
    func saveItems(item : Item) {
        do {
            //try to save the data
            //looks at context, temporary area(which was changed when we created a new item), then we save the context to commit unsaved changes to the persistentStore
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving contex \(error)")
        }
        
        //refresh the tableView
        self.tableView.reloadData()
    }
    //method which pulls out every Item inside the persistentContainer
    //external/internal parameter/also include a default value
    func loadItems() {
        //all of the items that belong to the selected category, sort by keypath
        //loading the items in alphabetal order(the sorted does this)
        //only loads items based on its selectedCategory(the indexPath.row)
        //the list of items inside Category.swift  get sorted by the title and enter in alpha-order
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    
    
    
}
//MARK: - Search bar methods

//Split up functionality of viewController
extension ToDoListViewController : UISearchBarDelegate {
//
    //query the database and get the result the user is sending
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //update todoItems to be equal to todoItems filtered by the predicate. Then sort the data based on when each item was created
        todoItems = todoItems? .filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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

