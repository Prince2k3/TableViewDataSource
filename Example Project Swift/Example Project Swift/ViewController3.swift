//
//  ViewController3.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class ViewController3: UIViewController, TableViewDataSourceDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var sectionDataSource: TableViewSectionDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(TestCell.self, forCellReuseIdentifier: TestCell.identifier)
        self.tableView.estimatedRowHeight = 54
        self.tableView.rowHeight = 54
        
        build()
    }
    
    func build() {
        var dataSources = [TableViewDataSource]()
        
        for i in 0..<3 {
            
            var items = [Int]()
            for j in 0..<10 {
                items.append(j)
            }
            
            let dataSource = TableViewDataSource(cellIdentifier: TestCell.identifier, items: items)
            dataSource.title = "Section \(i)"
            
            if i == 0 {
                dataSource.editable = true
                dataSource.editableCells = [
                    IndexPath(row: 0, section: i): .delete,
                    IndexPath(row: 1, section: i): .delete,
                ]
            } else if i == 1 {
                dataSource.movable = true
                dataSource.movableCells = [
                    IndexPath(row: 0, section: i),
                    IndexPath(row: 1, section: i)
                ]
            }
            
            dataSources.append(dataSource)
        }
        
        
        self.sectionDataSource = TableViewSectionDataSource(dataSources: dataSources)
        self.sectionDataSource?.showDefaultHeaderTitle = true
        self.sectionDataSource?.delegate = self
        self.tableView.dataSource = self.sectionDataSource
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didConfigureCell(_ cell: TableViewCellDataSource, atIndexPath indexPath: IndexPath) {
        
    }
}
