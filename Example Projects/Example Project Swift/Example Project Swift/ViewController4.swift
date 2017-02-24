//
//  ViewController4.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class ViewController4: UIViewController, TableViewDataSourceDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: TableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: TestTextFieldCell.identifier, bundle: nil), forCellReuseIdentifier: TestTextFieldCell.identifier)
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        build()
    }
    
    func build() {
        
        let item = TableViewDataSourceCellItem()
        item.cellIdentifier = TestTextFieldCell.identifier
        
        self.dataSource = TableViewDataSource(cellItems: [item])
        self.dataSource?.delegate = self
        self.tableView?.dataSource = self.dataSource
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didConfigureCell(_ cell: TableViewCellDataSource, atIndexPath indexPath: IndexPath) {
        let textFieldCell = cell as? TestTextFieldCell
        textFieldCell?.valueDidChange = { text in
            print(text)
        }
    }
}
