//
//  HistoryTableViewCell.swift
//  Calculator
//
//  Created by Ryan Maksymic on 2017-02-16.
//  Copyright © 2017 Ryan Maksymic. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell
{
    @IBOutlet weak var operandsLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var factLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
