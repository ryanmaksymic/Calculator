//
//  SettingsViewController.swift
//  Calculator
//
//  Created by Ryan Maksymic on 2017-02-03.
//  Copyright © 2017 Ryan Maksymic. All rights reserved.
//

import UIKit

// Blue theme colors:
let blueThemeColors = [
    "primaryBackgroundColor" : UIColor(colorLiteralRed: 137/255.0, green: 165/255.0, blue: 189/255.0, alpha: 1.0),
    "secondaryBackgroundColor": UIColor(colorLiteralRed: 108/255.0, green: 149/255.0, blue: 191/255.0, alpha: 1.0),
    "tertiaryBackgroundColor" : UIColor(colorLiteralRed: 75/255.0, green: 120/255.0, blue: 176/255.0, alpha: 1.0),
    
    "primaryFontColor" : UIColor(colorLiteralRed: 255/255.0, green: 243/255.0, blue: 153/255.0, alpha: 1.0),
    "secondaryFontColor" : UIColor(colorLiteralRed: 255/255.0, green: 181/255.0, blue: 130/255.0, alpha: 1.0),
    "tertiaryFontColor" : UIColor(colorLiteralRed: 255/255.0, green: 141/255.0, blue: 93/255.0, alpha: 1.0)
]

// Orange theme colors:
let orangeThemeColors = [
    "primaryBackgroundColor" : UIColor(colorLiteralRed: 255/255.0, green: 243/255.0, blue: 153/255.0, alpha: 1.0),
    "secondaryBackgroundColor": UIColor(colorLiteralRed: 255/255.0, green: 181/255.0, blue: 130/255.0, alpha: 1.0),
    "tertiaryBackgroundColor" : UIColor(colorLiteralRed: 255/255.0, green: 141/255.0, blue: 93/255.0, alpha: 1.0),
    
    "primaryFontColor" : UIColor(colorLiteralRed: 137/255.0, green: 165/255.0, blue: 189/255.0, alpha: 1.0),
    "secondaryFontColor" : UIColor(colorLiteralRed: 108/255.0, green: 149/255.0, blue: 191/255.0, alpha: 1.0),
    "tertiaryFontColor" : UIColor(colorLiteralRed: 75/255.0, green: 120/255.0, blue: 176/255.0, alpha: 1.0)
]

// User selected theme:
var selectedThemeColors : [String:UIColor]!


class SettingsViewController: UIViewController
{
    // Theme selector segmented control:
    @IBOutlet weak var themeSelector: UISegmentedControl!
    
    // Views:
    @IBOutlet weak var secondaryView: UIView!
    @IBOutlet weak var tertiaryView: UIView!
    
    // Labels:
    @IBOutlet weak var secondaryFontLabel: UILabel!
    @IBOutlet weak var tertiaryFontLabel: UILabel!
    
    // View did load:
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // View will appear:
    override func viewWillAppear(_ animated: Bool)
    {
        // If Blue theme selected:
        if selectedThemeColors == blueThemeColors
        {
            // Update theme selector segmented control:
            themeSelector.selectedSegmentIndex = 0
        }
            // Otherwise, if Orange theme selected:
        else if selectedThemeColors == orangeThemeColors
        {
            // Update theme selector segmented control:
            themeSelector.selectedSegmentIndex = 1
        }
        
        // Update the theme color:
        updateTheme()
    }
    
    // Theme selector segmented control changed:
    @IBAction func themeChanged(_ sender: Any)
    {
        // Update the theme colors:
        updateTheme()
    }
    
    // Update the theme colors:
    func updateTheme()
    {
        // If Blue theme selected:
        if themeSelector.selectedSegmentIndex == 0
        {
            // Update selectedThemeColors:
            selectedThemeColors = blueThemeColors
            
            // Save theme to UserDefaults:
            UserDefaults.standard.set("Blue", forKey: "theme")
        }
            // Otherwise, if Orange theme selected:
        else if themeSelector.selectedSegmentIndex == 1
        {
            // Update selectedThemeColors:
            selectedThemeColors = orangeThemeColors
            
            // Save theme to UserDefaults:
            UserDefaults.standard.set("Orange", forKey: "theme")
        }
        
        // Update view colors:
        view.backgroundColor = selectedThemeColors["primaryBackgroundColor"]
        secondaryView.backgroundColor = selectedThemeColors["secondaryBackgroundColor"]
        tertiaryView.backgroundColor = selectedThemeColors["tertiaryBackgroundColor"]
        
        // Update text colors:
        themeSelector.tintColor = selectedThemeColors["primaryFontColor"]
        secondaryFontLabel.textColor = selectedThemeColors["secondaryFontColor"]
        tertiaryFontLabel.textColor = selectedThemeColors["tertiaryFontColor"]
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
