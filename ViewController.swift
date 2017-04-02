//
//  ViewController.swift
//  Calculator
//
//  Created by Ryan Maksymic on 2017-01-25.
//  Copyright © 2017 Ryan Maksymic. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

// Core Data managed object context:
var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

class ViewController: UIViewController
{
    // Views:
    @IBOutlet weak var secondaryView: UIView!
    @IBOutlet weak var tertiaryView: UIView!
    
    // Labels:
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var firstOperandLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var secondOperandLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    // Buttons:
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var operationButtons: [UIButton]!
    @IBOutlet var editButtons: [UIButton]!
    
    // Number that is currently active:
    enum DisplayState { case FirstOperand, SecondOperand, Result }
    var dispState = DisplayState.FirstOperand
    
    // Operation in use:
    enum Operation { case Addition, Subtraction, Multiplication, Division }
    var mathOp = Operation.Addition
    
    // Operands:
    var firstOperand : Number!
    var secondOperand : Number!
    
    // Result of calculation:
    var result : Number!
    
    // Number currently being edited; will be equal to one of the above three:
    var activeNumber : Number!
    
    // Stores value passed from History page:
    var historyValue = ""
    
    // Audio player:
    var audioPlayer = AVAudioPlayer()
    
    
    // View did load:
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // App delegate object:
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Managed object context:
        context = appDelegate.persistentContainer.viewContext
        
        // Initialize Number objects:
        firstOperand = Number(withLabel: firstOperandLabel)
        secondOperand = Number(withLabel: secondOperandLabel)
        result = Number(withLabel: resultLabel)
        
        // If a theme selection is stored in permanent data:
        if let theme = UserDefaults.standard.object(forKey: "theme") as? String
        {
            // Blue:
            if theme == "Blue"
            {
                selectedThemeColors = blueThemeColors
            }
                // Orange:
            else if theme == "Orange"
            {
                selectedThemeColors = orangeThemeColors
            }
        }
            // Otherwise:
        else
        {
            print("NO THEME SAVED")
            
            // Default to the Blue theme:
            selectedThemeColors = blueThemeColors
        }
        
        // Clear the display:
        reset()
        
        // Generate a random welcome message:
        generateRandomWelcomeMessage()
    }
    
    // View will appear:
    override func viewWillAppear(_ animated: Bool)
    {
        // If a value was passed from History:
        if historyValue != ""
        {
            // If the active number is the result:
            if activeNumber == result
            {
                // Reset the calculator:
                reset()
            }
            
            // Set History value as the active operand:
            activeNumber.reset(withValue: historyValue)
            
            // Clear historyValue:
            historyValue = ""
        }
        
        // Update view background colors:
        view.backgroundColor = selectedThemeColors["primaryBackgroundColor"]
        secondaryView.backgroundColor = selectedThemeColors["secondaryBackgroundColor"]
        tertiaryView.backgroundColor = selectedThemeColors["tertiaryBackgroundColor"]
        
        //Update label colors:
        firstOperandLabel.textColor = selectedThemeColors["primaryFontColor"]
        operatorLabel.textColor = selectedThemeColors["secondaryFontColor"]
        
        // Update button colors:
        for button in numberButtons
        {
            button.setTitleColor(selectedThemeColors["primaryFontColor"], for: [])
        }
        for button in operationButtons
        {
            button.setTitleColor(selectedThemeColors["secondaryFontColor"], for: [])
        }
        for button in editButtons
        {
            button.setTitleColor(selectedThemeColors["tertiaryFontColor"], for: [])
        }
    }
    
    // A number button was tapped:
    @IBAction func numberButtonTapped(_ sender: UIButton)
    {
        print("\(sender.tag)")
        
        // Play a sound:
        playSound(ofType: "pop")
        
        // Grab the button value:
        let entry = "\(sender.tag)"
        
        // If the active number is the result:
        if activeNumber == result
        {
            // Reset the calculator:
            reset()
        }
        
        // If the active number's value is currently "0":
        if activeNumber.label.text == "0"
        {
            // Clear the text field:
            activeNumber.label.text = ""
        }
            // If the active number's value is currently "-0":
        else if activeNumber.label.text == "-0"
        {
            // Clear the text field except for "-":
            activeNumber.label.text = "-"
        }
        
        // Append entry to active number:
        activeNumber.label.text!.append(entry)
    }
    
    // The decimal button was tapped:
    @IBAction func decimalButtonTapped(_ sender: Any)
    {
        // If the active number is the result:
        if activeNumber == result
        {
            // Reset the calculator:
            reset()
        }
        
        // If the number does not yet contain a decimal:
        if activeNumber.decimalUsed == false
        {
            print(".")
            
            // Play a sound:
            playSound(ofType: "pop")
            
            // If the active number's value is currently "":
            if activeNumber.label.text == ""
            {
                // Append "0" to active number:
                activeNumber.label.text!.append("0")
            }
            
            // Append entry to active number:
            activeNumber.label.text!.append(".")
            
            // Update decimalUsed:
            activeNumber.decimalUsed = true
        }
    }
    
    // The invert button was tapped:
    @IBAction func invertButtonTapped(_ sender: Any)
    {
        print("±")
        
        // Play a sound:
        playSound(ofType: "pop")
        
        // If the active number is the result:
        if activeNumber == result
        {
            // Save the value of the result:
            let tempResult = activeNumber.label.text
            
            // Reset the calculator:
            reset()
            
            // Move the result value to the first operand:
            activeNumber.label.text = tempResult
        }
        
        // Invert the active number:
        activeNumber.invert()
    }
    
    // An operator button was tapped:
    @IBAction func operatorButtonTapped(_ sender: UIButton)
    {
        // Play a sound:
        playSound(ofType: "pop")
        
        // Stores a string of the operator:
        var operation = ""
        
        // Determine operator using object tag:
        switch sender.tag
        {
        case 0:
            print("+")
            
            mathOp = .Addition
            
            operation = "+"
        case 1:
            print("-")
            
            mathOp = .Subtraction
            
            operation = "-"
        case 2:
            print("×")
            
            mathOp = .Multiplication
            
            operation = "×"
        case 3:
            print("÷")
            
            mathOp = .Division
            
            operation = "÷"
        default:
            return
        }
        
        // If the active number is the first operand:
        if activeNumber == firstOperand
        {
            // Clean up the first operand:
            firstOperand.cleanUp()
        }
            // Otherwise, if the active number is the result:
        else if activeNumber == result
        {
            // Save the value of the result:
            let tempResult = resultLabel.text
            
            // Reset the calculator:
            reset()
            
            // Move the result value to the first operand:
            activeNumber.label.text = tempResult
        }
        
        // Update activeNumber:
        activeNumber = secondOperand
        
        if activeNumber.label.text == ""
        {
            activeNumber.reset(withValue: "0")
        }
        
        // Update the operator label:
        operatorLabel.text = operation
    }
    
    // The equals button was tapped:
    @IBAction func equalsButtonTapped(_ sender: Any)
    {
        // Play a sound:
        playSound(ofType: "toot")
        
        // Stores results of calculation:
        var tempResult = 0.0
        
        // String version of results:
        var resultString = ""
        
        // If the active number is the first operand:
        if operatorLabel.text == ""
        {
            // Set the result equal to the first operand:
            resultString = firstOperand.label.text!
        }
            // Otherwise:
        else
        {
            if activeNumber == secondOperand
            {
                // Clean up the second operand:
                secondOperand.cleanUp()
            }
            else if activeNumber == result
            {
                firstOperand.label.text = activeNumber.label.text
            }
            
            // Perform calculation:
            switch mathOp
            {
            case .Addition:
                tempResult = Double(firstOperand.label.text!)! + Double(secondOperand.label.text!)!
            case .Subtraction:
                tempResult = Double(firstOperand.label.text!)! - Double(secondOperand.label.text!)!
            case .Multiplication:
                tempResult = Double(firstOperand.label.text!)! * Double(secondOperand.label.text!)!
            case .Division:
                tempResult = Double(firstOperand.label.text!)! / Double(secondOperand.label.text!)!
            }
            
            // If the result is infinity:
            if tempResult.isInfinite
            {
                // Display infinity symbol:
                resultString = "∞"
            }
                // Otherwise:
            else
            {
                // If the result is a whole number:
                if tempResult.truncatingRemainder(dividingBy: 1) == 0
                {
                    // Format results without any decimal places:
                    resultString = String(format: "%.0f", tempResult)
                }
                    // Otherwise:
                else
                {
                    // Display results as is:
                    resultString = "\(tempResult)"
                }
            }
        }
        
        // Update activeNumber:
        activeNumber = result
        
        // Update resultLabel:
        activeNumber.label.text = resultString
        
        if tempResult > 1
        {
            generateFact(forNumber: tempResult)
        }
        else
        {
            factLabel.text = "Whoa! You calculated the number \(resultString)! You must feel like a really cool person!"
        }
        
        // Fade in factLabel:
        factLabel.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: {
            self.factLabel.alpha = 1.0
        }, completion: nil)
        
        
        // SAVE DATA
        
        let calculation = NSEntityDescription.insertNewObject(forEntityName: "Calculations", into: context)
        
        calculation.setValue(firstOperand.label.text, forKey: "firstOperand")
        calculation.setValue(operatorLabel.text, forKey: "operation")
        calculation.setValue(secondOperand.label.text, forKey: "secondOperand")
        calculation.setValue(result.label.text, forKey: "result")
        calculation.setValue(factLabel.text, forKey: "fact")
        
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving calculation data!")
        }
    }
    
    func generateFact(forNumber number: Double)
    {
        let newNumber = floor(number)
        
        let newString = String(format: "%.0f", newNumber)
        
        // Generate URL using number:
        let url = URL(string: "http://numbersapi.com/\(newString)?json")!
        
        print("URL: \(url)")
        
        // Task that retrieves contents of the given URL:
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // If there is an error:
            if error != nil
            {
                print("Error loading URL!")
            }
                // Otherwise:
            else
            {
                // If data makes sense:
                if let urlContent = data
                {
                    do
                    {
                        // Try pulling JSON data from URL content:
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: .mutableContainers) as AnyObject
                        
                        print(jsonResult["text"])
                        
                        DispatchQueue.main.sync(execute: {
                            
                            let fact = jsonResult["text"] as! String
                            
                            self.factLabel.text = fact
                        })
                    }
                    catch
                    {
                        print("Error retrieving JSON data!")
                    }
                }
            }
        }
        
        // Run the task:
        task.resume()
    }
    
    // An edit button was tapped:
    @IBAction func editButtonTapped(_ sender: UIButton)
    {
        // Play a sound:
        playSound(ofType: "pop")
        
        // If the active number is the result:
        if activeNumber == result
        {
            // Reset the calculator:
            reset()
            
            // Generate a random welcome message:
            generateRandomWelcomeMessage()
        }
            // Otherwise:
        else
        {
            // Determine function using object tag:
            switch sender.tag
            {
            // DELETE:
            case 0:
                // If the second operand is active and equal to "0":
                if activeNumber == secondOperand && activeNumber.label.text == "0"
                {
                    // Reset the second operand:
                    activeNumber.reset()
                    
                    // Update activeNumber:
                    activeNumber = firstOperand
                    
                    // Clear the operator:
                    operatorLabel.text = ""
                }
                    // Otherwise:
                else
                {
                    // If the last character is a decimal:
                    if activeNumber.label.text?.characters.last == "."
                    {
                        // Update decimalUsed:
                        activeNumber.decimalUsed = false
                    }
                    
                    // Remove last character:
                    activeNumber.label.text = String(activeNumber.label.text!.characters.dropLast())
                    
                    // If the active number is empty or just a "-":
                    if activeNumber.label.text == "" || activeNumber.label.text == "-"
                    {
                        // Revert to "0":
                        activeNumber.label.text = "0"
                    }
                }
            // CLEAR:
            case 1:
                // If the active number is the first operand:
                if activeNumber == firstOperand
                {
                    // Reset the first operand:
                    activeNumber.reset(withValue: "0")
                }
                    // Otherwise, if the active number is the second operand:
                else if activeNumber == secondOperand
                {
                    // If the second operand is "0":
                    if activeNumber.label.text == "0"
                    {
                        // Reset the second operand:
                        activeNumber.reset()
                        
                        // Update activeNumber:
                        activeNumber = firstOperand
                        
                        // Clear the operator:
                        operatorLabel.text = ""
                    }
                        // Otherwise:
                    else
                    {
                        // Reset the second operand:
                        activeNumber.reset(withValue: "0")
                    }
                }
            // ALL CLEAR:
            case 2:
                // Reset the calculator:
                reset()
            default:
                return
            }
        }
    }
    
    // Play a sound file:
    func playSound(ofType type: String)
    {
        // Arrays of audio file names:
        let popSounds = ["pop1", "pop2", "pop3", "pop4", "pop5", "pop6", "pop7", "pop8", "pop9", "pop10", "pop11"]
        let tootSounds = ["toot1", "toot2"]
        
        // Audio file path name:
        var audioPath : String!
        
        if type == "pop"
        {
            audioPath = Bundle.main.path(forResource: popSounds[randomIndex(forArray: popSounds)], ofType: "wav")
        }
        else if type == "toot"
        {
            audioPath = Bundle.main.path(forResource: tootSounds[randomIndex(forArray: tootSounds)], ofType: "wav")
        }
        
        do
        {
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            
            audioPlayer.play()
        }
        catch
        {
            print("Error playing audio file!")
        }
    }
    
    // Generate a random index from the given array:
    func randomIndex(forArray array: [String]) -> Int
    {
        return Int(arc4random_uniform(UInt32(array.count)))
    }
    
    // Reset the calculator:
    func reset()
    {
        // Reset all labels:
        firstOperand.reset(withValue: "0")
        operatorLabel.text = ""
        secondOperand.reset()
        result.reset()
        
        // Update activeNumber:
        activeNumber = firstOperand
        
        // Generate a random welcome message:
        //generateRandomWelcomeMessage()
    }
    
    // Generate a random welcome message:
    func generateRandomWelcomeMessage()
    {
        // Array of welcome messages:
        let messageArray = [
            "Hey! Looking to calculate something?\nJust start tapping numbers, bucko.",
            "Did you know that the first calculator was invented by a 12-year-old child in rural Estonia? Just kidding, I have no idea.",
            "\"Calculator\" comes from the Latin \"calculatus\", which means \"to reckon, compute\".\nAccording to Google. Probably true.",
            "What? You don't carry your TI-83 with you everywhere you go? Fine, you can use this app.",
            "Pro tip: Don't let the number pad deceive you. This app can NOT be used to make phone calls.",
            "A million calculators isn't cool. Know what's cool? A BILLION calculators.",
            "I know a guy – tried to calculate somethin' without usin' a calculator app. Next day – BOOM – dead.",
            "We're running low on 3's this month, so please try to use them sparingly.",
            "This isn't EXACTLY the same calculator that Stephen Hawking uses, but it's close. Cool, huh?",
            "SEND HELP. TRAPPED IN BASEMENT. FORCED TO WRITE JOKES FOR CALCULATOR APP.",
            "Premium version of this app available for $49.99! Includes even more numbers!",
            "Sometimes I just think, like, what's the point of even calculating stuff, ya know? I dunno. Forget I said anything.",
            "Probably time to throw out the ol' abacus, hey boss?",
            "Technicality no down boo over",
            ""
        ]
        
        // Generate random integer:
        let randomIndex = Int(arc4random_uniform(UInt32(messageArray.count)))
        
        // Update factLabel text with random message:
        factLabel.text = messageArray[randomIndex]
        
        // Fade in factLabel:
        factLabel.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            self.factLabel.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
