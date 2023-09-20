//
//  CategoryTableViewController.swift
//  CoreDataTest
//
//  Created by Ashraf Eltantawy on 16/09/2023.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    var categoryName:String?
    var arrayCategory :Results<Category>?
   
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategory()
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayCategory?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = arrayCategory?[indexPath.row].name ?? "No category added."
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryName = arrayCategory?[indexPath.row].name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemViewController = segue.destination as? TodoListViewController , let indexPath = tableView.indexPathForSelectedRow {
                itemViewController.categoryName = arrayCategory?[indexPath.row].name
                itemViewController.selectedCategory = arrayCategory?[indexPath.row]
            
      
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

    
    @IBAction func buttonClick(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) {[weak self] action in
            guard let self = self else {return}
            if textField.text?.isEmpty == true{
                textField.placeholder = "please add item."
                self.present(alert, animated: true)
            }else{
                if let text = textField.text{
                    let newItem = Category()
                    newItem.name = text
                    saveItems(category:newItem)
                }
                
                self.dismiss(animated: true)
            }
        }
        
        alert.addTextField{
            $0.placeholder = "Create New Item"
            textField = $0
            
        }
        
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    func saveItems(category:Category){
        do{
           try realm.write {
                realm.add(category)
            }
        }catch{
            print("error from save category \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(){
        arrayCategory = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateDataModel(at indexPath: IndexPath) {
        if let category = arrayCategory?[indexPath.row]{
            do{
                try realm.write({
                    realm.delete(category)
                })
            }catch{
                
            }
        }
    }
    
}


