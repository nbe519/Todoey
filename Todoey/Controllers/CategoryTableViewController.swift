//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Noah Eaton on 7/8/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {


    let realm = try! Realm()
    
    //automatically updates so there is no need to append anything to the array, for example, when a new item is created it is saved into the Category class, since categoryArray auto-updates, it saw the changes and updates the view controller
    //changed from array of category items to a collection of results that are category objects
    //is of type results from the category class
    var categoryArray : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

    }

    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Create an alert with an action and a textField, and once the user taps the action, it adds whatever they typed into the textField and appends it to array which adds it to the tableView
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        //the title of the action is what is clicked when the user is done
        //the action keyword in the closure is the action that will be completed when the user taps the button
        let action = UIAlertAction(title: "Add Button", style: .default) { (action) in
            
            //When the add button is pressed, we create a new category that is a new Category() object
            //we give it a name based off the text in the text field
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            //Save the newCategory to realm
            //When this happens, newCategory is appended to categoryArray as it auto-updates any results that are inputed
            self.save(category: newCategory)
            
        }
        //the parameter, alertTextField, further configures the textField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    //MARK: - TableView Datasource Methods
    //Display the categories that are inside the persistent storage container
    
    override func tableView(_ tableView : UITableView,  numberOfRowsInSection section: Int) -> Int {
        //creates cells based on the number of categories in the categoryArray
        //Nil coalescing operator
        //if categoryArray is nil, return a single cell
        return categoryArray?.count ?? 1
    }
    
    //Gets called everytime we want a new cell to appear
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //The following line does not work, because once the cell leaves the screen, it destroys the cell and creates a new one. When user scrolled back to the top it is forgetting if it needs an accessory
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        //gets the cell(s) with identifier ToDoItemCell from the storyboard and allows it to be re-used when it leaves the screen
        //We are creating a reusable cell for memory conservation
        //Go and find the prototype cell, CategoryCell, generate a bunch that can be reused. Once the item is no longer visible, it will reused by going to bottom of table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //have the cell have the text of the item at a certain location and provide the cell text
        //indexPath holds location of the cell
        //if array is nil, append "No categories added yet" to the categoryArray
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    //What should happen when we click on one of the cells, do not do this yet
    
    //When a cell is pressed, send them to the ToDoListViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //just before we segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //store reference to destination
        //now we can get items from the ToDoListViewContoller
        let destinationVC = segue.destination as! ToDoListViewController
        
        //grab the category that corresponds to the selected cell
        //The selected cell is whatever cell the user pressed
        //identifies the current row that is selected, optional because there is a possiblility there is no row
        //indexPathForSelectedRow identifies the current row that is selected
        if let indexPath = tableView.indexPathForSelectedRow {
            //set the destination selectedCategory to the category at the indexpath.row that was selected
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    //Save Data/Load Data
    
    
    //transfer what is in the staging area to our permament data-source
    //This will not interfere with the itemArray because they are being saved into different tables
    //expects it to be of type Category
    func save(category : Category) {
        do {
            //Save data to Realm
            //commit changes to realm, we want to add our new category
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving contex \(error)")
        }
        
        //refresh the tableView
        self.tableView.reloadData()
    }
    //method which pulls out the Categories inside the persistentContainer
    //external/internal parameter/also include a default value
    func loadCategories() {
        
        //fetch all the objects from the Category class
        //categoryArray expects a Result<Category> so the objects are returned as a Result
         categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

