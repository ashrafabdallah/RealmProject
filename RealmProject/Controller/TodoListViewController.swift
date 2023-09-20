//
//  ViewController.swift
//  Todoey
//
//  Created by Ashraf Eltantawy on 11/09/2023.
//

import UIKit
import CoreData
import RealmSwift
class TodoListViewController: SwipeTableViewController {
    var categoryName:String?
    let realm = try! Realm()
    var selectedCategory:Category? {
        didSet{
            loadItems()
        }
    }
    var arrayOfItems : Results<Item>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if   let item = arrayOfItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done  ? .checkmark : .none
        }else{
            cell.textLabel?.text = "items not added."
        }
     
       // cell.accessoryType  = (indexPath.row  == selectedRow) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = arrayOfItems?[indexPath.row]{
            
            do{
                try realm.write({
                    item.done = !item.done
                })
                
            }catch{
                print("Error from update item")
            }
        }
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {[weak self] action in
            guard let self = self else {return}
            if textField.text?.isEmpty == true{
                textField.placeholder = "please add item."
                self.present(alert, animated: true)
           }
            else{
                if let text = textField.text{
                    let newItem = Item()
                    if let currentCategory = self.selectedCategory{
                        do{
                            try realm.write {
                                newItem.title = text
                                newItem.done = false
                                newItem.dateCreated=Date()
                                currentCategory.items.append(newItem)
                            }
                        }catch{
                            print("error from save item ")
                        }
                    }
                    tableView.reloadData()
                    //saveItems(item: newItem)
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

    func loadItems(){
        arrayOfItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }
    
    override func updateDataModel(at indexPath: IndexPath) {
        if let item = arrayOfItems?[indexPath.row]{
            do{
                try realm.write({
                    realm.delete(item)
                })
                
            }catch{}
        }
    }
    
}
// MARK: - search
extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        arrayOfItems = arrayOfItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
