//
//  Number.swift
//  Calculator
//
//  Created by Ryan Maksymic on 2017-03-06.
//  Copyright © 2017 Ryan Maksymic. All rights reserved.
//

import Foundation
import UIKit

class Number
{
    // Label displaying the value:
    var label : UILabel
    
    // True if number contains a decimal:
    var decimalUsed : Bool
    
    // Initialize a Number object:
    init(withLabel label: UILabel)
    {
        self.label = label
        self.label.text = ""
        
        self.decimalUsed = false
    }
    
    // Invert the number:
    func invert()
    {
        // If the first operand is negative:
        if self.label.text!.contains("-")
        {
            // Make first operand positive:
            self.label.text = self.label.text!.replacingOccurrences(of: "-", with: "")
        }
            // Otherwise:
        else
        {
            // Make first operand negative:
            self.label.text = "-\(self.label.text!)"
        }
    }
    
    // Remove a useless decimal or trailing zeros:
    func cleanUp()
    {
        // While the first operand has a useless decimal or trailing zero:
        while self.label.text!.characters.last == "." || (self.decimalUsed && self.label.text!.characters.last == "0")
        {
            // If a decimal is about to be removed:
            if self.label.text!.characters.last == "."
            {
                // Update decimalUsed:
                self.decimalUsed = false
            }
            
            // Remove the first operand's last character:
            self.label.text = String(self.label.text!.characters.dropLast())
        }
    }
    
    // Reset the object:
    func reset(withValue value: String? = nil)
    {
        // If no value is provided then it is empty:
        self.label.text = value ?? ""
        
        // Reset decimalUsed:
        self.decimalUsed = false
        
        // Rethink this; if given value has a decimal then decimalUsed will be inaccurate
    }
}


// Override == operator for Number class:
func ==(lhs: Number, rhs: Number) -> Bool
{
    // Check for label equality:
    if lhs.label == rhs.label
    {
        return true
    }
    else
    {
        return false
    }
}
