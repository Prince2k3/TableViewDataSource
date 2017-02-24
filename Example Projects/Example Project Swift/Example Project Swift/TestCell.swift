//
//  TestCell.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell, TableViewCellDataSource {
    static var identifier: String = "TestCell"
    
    func configure(_ data: Any?) {
        if let number = data as? Int {
            self.textLabel?.text = "\(number)"
        } else if let string = data as? String {
            self.textLabel?.text = string
        }
    }
}
