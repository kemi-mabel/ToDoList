//
//  SecondViewController.swift
//  ToDoList
//
//  Created by USER on 07/11/2020.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var goals : [NSManagedObject] = []
    
//   var goal: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func writeGoal(_ sender: Any) {
        let alert = UIAlertController(title: "New goals", message: "Add a goal", preferredStyle: .alert)
        
        let Save = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in
            
            guard let textfield = alert.textFields?.first,
                 let goaltosave = textfield.text  else{ return
           }
//            self.goal.append(goaltosave)
            self.savegoal(goal: goaltosave)
            self.tableview.reloadData()
//            print(self.goals)
            
            }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alert.addAction(Save)
        alert.addAction(cancel)
        alert.addTextField()
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let reusableIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath)
//      cell.textLabel?.text = goal[indexPath.row]

        let aim = goals[indexPath.row]
        cell.textLabel?.text = aim.value(forKeyPath: "goal") as? String
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
//        2
        let managedContext =  appDelegate.persistentContainer.viewContext
//        3
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Resolution")
//        4
        do {
            goals = try managedContext.fetch(fetchRequest)
        }   catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }

    
    func savegoal(goal : String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managecontext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Resolution", in: managecontext)!
        
        let resolution = NSManagedObject(entity: entity, insertInto: managecontext)
        
        resolution.setValue(goal, forKeyPath: "goal")
        
        do {
            try managecontext.save()
            goals.append(resolution)
        }   catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
        self.tableview.reloadData()
    }
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

