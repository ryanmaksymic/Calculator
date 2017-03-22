//
//  HistoryViewController.swift
//  Calculator
//
//  Created by Ryan Maksymic on 2017-02-03.
//  Copyright © 2017 Ryan Maksymic. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // Table:
    @IBOutlet weak var table: UITableView!
    
    // Clear history button:
    @IBOutlet weak var clearHistoryButton: UIButton!
    
    // Array storing arrays of calculation data strings – [firstOperand, operation, secondOperand, result, fact]:
    var calculations = [[String]]()
    
    // Result grabbed from History:
    var grabbedResult = ""
    
    // View did load:
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Clear calculations array:
        calculations.removeAll()
        
        // Fetch request:
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Calculations")
        
        // Set to false in order to access properties of returned objects:
        request.returnsObjectsAsFaults = false
        
        do
        {
            // Try fetching calculation objects:
            let objects = try context.fetch(request)
            
            // If any objects are found:
            if objects.count > 0
            {
                // Loop through objects:
                for object in objects as! [NSManagedObject]
                {
                    // Grab all properties:
                    if let firstOperand = object.value(forKey: "firstOperand") as? String
                    {
                        if let operation = object.value(forKey: "operation") as? String
                        {
                            if let secondOperand = object.value(forKey: "secondOperand") as? String
                            {
                                if let result = object.value(forKey: "result") as? String
                                {
                                    if let fact = object.value(forKey: "fact") as? String
                                    {
                                        // Collect all calculation data:
                                        let tempArray = [firstOperand, operation, secondOperand, result, fact]
                                        
                                        // Store data in the calculations array:
                                        calculations.append(tempArray)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        catch
        {
            print("Error loading calculation data!")
        }
    }
    
    // View will appear:
    override func viewWillAppear(_ animated: Bool)
    {
        // Update view background colors:
        view.backgroundColor = selectedThemeColors["secondaryBackgroundColor"]
        
        // Update button color:
        clearHistoryButton.setTitleColor(selectedThemeColors["tertiaryFontColor"], for: [])
        
        // Update table colors:
        table.backgroundColor = selectedThemeColors["primaryBackgroundColor"]
        table.separatorColor = selectedThemeColors["tertiaryBackgroundColor"]
    }
    
    // Number of rows in section:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Number of elements in the calculations array:
        return calculations.count
    }
    
    // Table view cell for row:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Create cell object from HistoryTableViewCell class:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        // Set cell background color:
        cell.backgroundColor = selectedThemeColors["primaryBackgroundColor"]
        
        // Index allows for results to be displayed in reverse chronological order:
        let index = calculations.count - indexPath.row - 1
        
        // Grab all calculation data:
        let firstOperand = calculations[index][0]
        let operation = calculations[index][1]
        let secondOperand = calculations[index][2]
        let result = calculations[index][3]
        let fact = calculations[index][4]
        
        // Update labels:
        cell.operandsLabel.text = "\(firstOperand) \(operation) \(secondOperand)"
        cell.operandsLabel.textColor = selectedThemeColors["primaryFontColor"]
        cell.resultLabel.text = result
        cell.factLabel.text = fact
        
        return cell
    }
    
    // The Clear button was tapped:
    @IBAction func clearButtonTapped(_ sender: Any)
    {
        // Create an alert:
        let alert = UIAlertController(title: "Are you sure?", message: "This action cannot be undone", preferredStyle: .alert)
        
        // "Proceed" action:
        alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { (alertAction) in
            
            // Fetch request:
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Calculations")
            
            // Set to false in order to access properties of returned objects:
            request.returnsObjectsAsFaults = false
            
            // Delete all calculation objects:
            do
            {
                // Try fetching calculation objects:
                let objects = try context.fetch(request)
                
                // If any objects are found:
                if objects.count > 0
                {
                    // Loop through objects:
                    for object in objects as! [NSManagedObject]
                    {
                        // Delete object:
                        context.delete(object)
                        
                        do
                        {
                            // Save managed object context:
                            try context.save()
                        }
                        catch
                        {
                            print("Error saving calculation data!")
                        }
                    }
                    
                    // Clear calculations array:
                    self.calculations.removeAll()
                    
                    // Reload table:
                    self.table.reloadData()
                }
            }
            catch
            {
                print("Error loading calculation data!")
            }
        }))
        
        // "Cancel" action:
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present alert:
        self.present(alert, animated: true, completion: nil)
    }
    
    // Table row selected:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Calculate correct index:
        let index = calculations.count - indexPath.row - 1
        
        // Grab the selected result:
        grabbedResult = calculations[index][3]
        
        // Segue back to main view:
        performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    
    // Prepare for segue:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Create View Controller object:
        let viewController = segue.destination as! ViewController
        
        // Pass grabbed value to main view:
        viewController.historyValue = grabbedResult
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
