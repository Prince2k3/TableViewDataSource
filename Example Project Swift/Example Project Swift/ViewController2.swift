//
//  SecondViewController.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: TableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(TestCell.self, forCellReuseIdentifier: TestCell.identifier)
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = 54
        
        build()
    }

    func build() {
        var items = [TableViewDataSourceCellItem]()
        for i in 0..<100 {
            let cellItem = TableViewDataSourceCellItem()
            cellItem.item = i
            cellItem.cellIdentifier = TestCell.identifier
            items.append(cellItem)
        }
        self.dataSource = TableViewDataSource(cellItems: items)
        self.tableView.dataSource = self.dataSource
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

