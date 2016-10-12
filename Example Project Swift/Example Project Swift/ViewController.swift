//
//  ViewController.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sampleData: [String] = ["Bananas", "Apples", "Oranges", "Grapes", "Strawberry", "Pineapple", "Mango"]
    var dataSource: TableViewDataSource = TableViewDataSource(cellIdentifier:  TestCell.identifier)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(TestCell.self, forCellReuseIdentifier: TestCell.identifier)
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = 54
        
        self.dataSource.items = self.sampleData
        self.tableView.dataSource = self.dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

