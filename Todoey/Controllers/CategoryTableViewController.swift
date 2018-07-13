//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Noah Eaton on 7/8/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    //temporary area where data is held before being commited
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()

    }

    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Create an alert with an action and a textField, and once the user taps the action, it adds whatever they typed into the textField and appends it to array which adds it to the tableView
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        //the title of the action is what is clicked when the user is done
        //the action keyword in the closure is the action that will be completed when the user taps the button
        let action = UIAlertAction(title: "Add Button", style: .default) { (action) in
            
            
            //When we add a new item to our tableview, we create a new object of type Category(automatically generated when we create a new entity), class already has access to all the properties.
            //not only initializes new item but also inserts it to the Category context(the temporary zone)
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            //what will happen once the user clicks the Add Item button on our UIAlert
            self.categoryArray.append(newCategory)
            
            //save the items whenever a newItem is appended to the itemArray
            self.saveItems()
            
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
        return categoryArray.count
    }
    
    //Gets called everytime we want a new cell to appear
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //The following line does not work, because once the cell leaves the screen, it destroys the cell and creates a new one. When user scrolled back to the top it is forgetting if it needs an accessory
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        //gets the cell(s) with identifier ToDoItemCell from the storyboard and allows it to be re-used when it leaves the screen
        //We are creating a reusable cell for memory conservation
        //Go and find the prototype cell, CategoryCell, generate a bunch that can be reused. Once the item is no longer visible, it will reused by going to bottom of table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //indexPath.row is going to hold the value of the row the resuableCell is at. If the Cell is at indexPath 1, then the itemArray is going to hold the 1-element inside
        let category = categoryArray[indexPath.row]
        
        //have the cell have the text of the item at a certain location and provide the cell text
        //indexPath holds location of the cell
        cell.textLabel?.text = category.name
        
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
            //set the selectedCategory method to the categoryArray's row
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    //Save Data/Load Data
    
    
    //transfer what is in the staging area to our permament data-source
    //This will not interfere with the itemArray because they are being saved into different tables
    func saveItems() {
        do {
            //try to save the data
            //looks at context, temporary area(which was changed when we created a new item), then we save the context to commit unsaved changes to the persistentStore
            //Save anything in the temporary zone
            try context.save()
        } catch {
            print("Error saving contex \(error)")
        }
        
        //refresh the tableView
        self.tableView.reloadData()
    }
    //method which pulls out the Categories inside the persistentContainer
    //external/internal parameter/also include a default value
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            //try to fetch all of the data and set the itemArray equal to whatever it retrives
            categoryArray = try context.fetch(request)//output for this method is an array of items that is stored in persistentData
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}
