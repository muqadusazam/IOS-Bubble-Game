//
//  ScoreBoardController.swift
//  Bubble Pop
//
//  Created by Muqadus on 29/4/19.
//  Copyright © 2019 Muqadus. All rights reserved.
//

import UIKit
import CoreData


class ScoreBoardController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI variables
    @IBOutlet weak var tableView: UITableView!
    
    // Arrays for storing name and sores (Both matches the datatype of xcode data source)
    var namesArray: [String] = []
    var scoresArray: [Int32] = []
    var combinedDic = Dictionary<String, Int>()
    var sortedDic = [(String, Int)]()
    
    
    // variables to store name and sores (their data is being passed by segue from previous controller)
    var playerName: String!
    var playerScore: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialising tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        saveData() //calling the method to save data in xcode data source model
    }
    
    // method to lock the rotation of the View
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // function to save Data in xcode Data model
    func saveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Data", in: context)
        let newScore = NSManagedObject(entity: entity!, insertInto: context)
        
        // Save the current player's name and score in the data model
        newScore.setValue(playerName, forKey: "names")
        newScore.setValue(playerScore, forKey: "points")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        // creating a request variable which fetches data from "Data" entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                // saving the data into array
                namesArray.append(data.value(forKey: "names") as! String)
                scoresArray.append(data.value(forKey: "points") as! Int32)
                
                // Making a dictoinary with combined keys and values by merging both arrays
                for (names, scores) in zip(namesArray, scoresArray)
                {
                    combinedDic[names] = Int(scores) // appending the array
                }
                // sorting and saving the sorted array from combined dictionary bassed on the values
                sortedDic = combinedDic.sorted(by: { $0.value > $1.value })
            }
        } catch {
            print("Failed")
        }
    }
    
    // function to delete all the data from table view (EXTRA FUNCTIONALITY)
    @IBAction func deleteAllData(_ sender: UIButton) {
        self.deleteAllData("Data")
    }
    
    // function to clear all the data
    func deleteAllData(_ entity : String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                context.delete(objectData)
                showMessage() // show message of success
            }
        } catch let error {
            // show error message
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func homePressed(_ sender: Any) {
        self.showHome() // calling the home view function
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // getting the no of rows depending on the entries of name in array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedDic.count
    }
    
    // function to display data on table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")! // providing a unique identifier for cell
        
        // definiing 2 cells with name and score in one each (called by the tag giving to it)
        let nameCell: UILabel = cells.viewWithTag(1) as! UILabel
        let scoreCell: UILabel = cells.viewWithTag(2) as! UILabel
        
        // checking for the count to color the cells
        if sortedDic.count >= 3 {
            if indexPath.row == 0 {
                nameCell.textColor = UIColor(hue: 0.1556, saturation: 1, brightness: 0.81, alpha: 1.0) // gold
                scoreCell.textColor = UIColor(hue: 0.1556, saturation: 1, brightness: 0.81, alpha: 1.0)
            } else if indexPath.row == 1 {
                nameCell.textColor = UIColor(hue: 0.425, saturation: 0, brightness: 0.72, alpha: 1.0) // silver
                scoreCell.textColor = UIColor(hue: 0.425, saturation: 0, brightness: 0.72, alpha: 1.0)
            } else if indexPath.row == 2 {
                nameCell.textColor = UIColor(hue: 0.1444, saturation: 1, brightness: 0.4, alpha: 1.0) // bronze
                scoreCell.textColor = UIColor(hue: 0.1444, saturation: 1, brightness: 0.4, alpha: 1.0)
            }
        } else if sortedDic.count == 2 {
            if indexPath.row == 0 {
                nameCell.textColor = UIColor(hue: 0.1556, saturation: 1, brightness: 0.81, alpha: 1.0)
                scoreCell.textColor = UIColor(hue: 0.1556, saturation: 1, brightness: 0.81, alpha: 1.0)
            } else if indexPath.row == 1 {
                nameCell.textColor = UIColor(hue: 0.425, saturation: 0, brightness: 0.72, alpha: 1.0)
                scoreCell.textColor = UIColor(hue: 0.425, saturation: 0, brightness: 0.72, alpha: 1.0)
            }
        } else if sortedDic.count == 1 {
            if indexPath.row == 0 {
                nameCell.textColor = UIColor(hue: 0.1556, saturation: 1, brightness: 0.81, alpha: 1.0)
                scoreCell.textColor = UIColor(hue: 0.1556, saturation: 1, brightness: 0.81, alpha: 1.0)
            }
        }
        
        // setting the cells text to sorted value from dictionary
        nameCell.text = "\(sortedDic[indexPath.row].0)"
        scoreCell.text = "\(sortedDic[indexPath.row].1)"
        
        // return cells data
        return cells
    }
    
    // creating segue function to show Home
    func showHome(){
        // creating an object of the story controller, calling it by its assigned indentifier
        let home = self.storyboard?.instantiateViewController(withIdentifier: "homeControllerID") as! HomeController
        // Initialising values in home
        home.heighestScore = self.sortedDic[0].1
        // showing the view
        self.show(home, sender: nil)
    }
    
    
    // function to show log cleared message
    func showMessage(){
        let alert = UIAlertController(title: "Notice", message: "Log has been cleared", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
