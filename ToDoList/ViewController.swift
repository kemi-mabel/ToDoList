//
//  ViewController.swift
//  ToDoList
//
//  Created by USER on 27/10/2020.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
//    var names: [String] = []
    
    var people : [NSManagedObject] = []
    
    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        
        return cell
//        key value coding
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
//        2
        let managedContext =  appDelegate.persistentContainer.viewContext
//        3
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
//        4
        do {
            people = try managedContext.fetch(fetchRequest)
        }   catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
    
        let saveAction = UIAlertAction(title: "save", style: .default) { (UIAlertAction) in
        
        guard let textfield  = alert.textFields?.first,
        
              let nametosave = textfield.text  else{
                return
        }
        
//            self.people.append(nametosave)
        self.save(name: nametosave)
        self.tableview.reloadData()
        
    }
        
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelaction)
        alert.addTextField()
        present(alert, animated: true  )
    }
    
    func save(name: String){
        
//        1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
//        2
        let manageContext =
            appDelegate.persistentContainer.viewContext
//        3
         let entity =
            NSEntityDescription.entity(forEntityName: "Person", in: manageContext)!
//        4
        let person = NSManagedObject(entity: entity, insertInto: manageContext)
//        5
        person.setValue(name, forKeyPath: "name")
//        6
        do {
            try manageContext.save()
            people.append(person)
        }   catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    } 
}
    
        
        
    

    
    



