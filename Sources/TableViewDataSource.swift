import UIKit

public protocol TableViewCellDataSource {
    func configure(data: AnyObject?)
}

public protocol TableViewDataSourceDelegateEditable: class {
    func commitEditingStyle(editingStyle: UITableViewCellEditingStyle, forIndexPath indexPath: NSIndexPath)
}

public protocol TableViewDataSourceDelegate: class {
    func didConfigureCell(cell: TableViewCellDataSource, atIndexPath indexPath: NSIndexPath)
}

public struct TableViewDataSourceCellItem {
    var cellIdentifier: String?
    var item: AnyObject?
    var cellHeight: CGFloat?
}

public class TableViewDataSource: NSObject, UITableViewDataSource {
    private var cellItems: [TableViewDataSourceCellItem]?
    private(set) var cellIdentifier: String?
    public var items: [AnyObject]?
    public var title: String?
    public weak var delegate: TableViewDataSourceDelegate?
    public weak var editableDelegate: TableViewDataSourceDelegateEditable?
    public var sectionHeaderView: UIView?
    public var reusableHeaderFooterViewIdentifier: String?
    public var editable: Bool = false
    public var movable: Bool = false
    public var editableCells: [NSIndexPath: UITableViewCellEditingStyle]?
    public var movableCells: [NSIndexPath]?
    
    override init() {
        super.init()
    }
    
    public convenience init(cellItems: [TableViewDataSourceCellItem]) {
        self.init()
        self.cellItems = cellItems
    }
    
    public convenience init(cellIdentifier: String, items: [AnyObject]? = nil) {
        self.init()
        self.cellIdentifier = cellIdentifier
        self.items = items
    }
    
    //MARK: - 
    
    public func itemAt(indexPath: NSIndexPath) -> AnyObject? {
        if let items = items where items.count > 0 && indexPath.row < items.count {
            return items[indexPath.row]
        }
        return nil
    }
    
    public func cellItemAt(indexPath: NSIndexPath) -> TableViewDataSourceCellItem? {
        if let cellItems = cellItems where cellItems.count > 0 && indexPath.row < cellItems.count {
            return cellItems[indexPath.row]
        }
        return nil
    }
    
    //MARK: - UITableViewDataSource 
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cellItems = cellItems {
            return cellItems.count
        }
        
        if let items = items {
            return items.count
        }
        return 0
    }
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if movable {
            if let movableCells = movableCells {
                return movableCells.contains(indexPath)
            }
            
            return true
        }
        return false
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if editable {
            if let editableCells = editableCells {
                return editableCells.keys.contains(indexPath)
            }
            return false
        }
        return false
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        editableDelegate?.commitEditingStyle(editingStyle, forIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if let item = items?[sourceIndexPath.row] {
            items?.removeAtIndex(sourceIndexPath.row)
            items?.insert(item, atIndex: destinationIndexPath.row)
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier: String?
        var item: AnyObject?
        
        if let cellItems = cellItems where cellItems.count > 0 {
            let cellItem = cellItemAt(indexPath)!
            identifier = cellItem.cellIdentifier
            item = cellItem.item
        } else {
            item = itemAt(indexPath)
            identifier = cellIdentifier
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier!, forIndexPath: indexPath)
        
        if cell is TableViewCellDataSource {
            let sourceCell = cell as! TableViewCellDataSource
            sourceCell.configure(item)
            delegate?.didConfigureCell(sourceCell, atIndexPath: indexPath)
        }
        
        return cell
    }
}

public class TableViewSectionDataSource: NSObject, UITableViewDataSource {
    
    public var delegate: TableViewDataSourceDelegate?
    public private(set) var dataSources: [TableViewDataSource]?
    public var enableIndexing: Bool  = false
    public var showDefaultHeaderTitle: Bool = true
    
    public convenience init(dataSources: [TableViewDataSource]) {
        self.init()
        self.dataSources = dataSources
    }
    
    func itemAt(indexPath: NSIndexPath) -> AnyObject? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.itemAt(indexPath)
    }
    
    func cellItemAt(indexPath: NSIndexPath) -> TableViewDataSourceCellItem? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.cellItemAt(indexPath)
    }
    
    func dataSourceAt(indexPath: NSIndexPath) -> TableViewDataSource {
        return dataSources![indexPath.section]
    }
    
    func titleForDataSourceAt(indexPath: NSIndexPath) -> String? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.title
    }
    
    func sectionHeaderViewForDataSourceAt(indexPath: NSIndexPath) -> UIView? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.sectionHeaderView
    }
    
    //MARK: - UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let dataSources = dataSources {
            return dataSources.count
        }
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSources = dataSources {
            let dataSource = dataSources[section]
            return dataSource.tableView(tableView, numberOfRowsInSection: section)
        }
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dataSource = dataSources![indexPath.section]
        return dataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }

    
    //MARK - Indexing
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if showDefaultHeaderTitle {
            if let dataSources = dataSources {
                let dataSource = dataSources[section]
                return dataSource.title
            }
            return nil
        }
        
        if !enableIndexing {
            return nil
        }
        
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: section)
        if numberOfRows == 0 {
            return nil
        }
        
        return UILocalizedIndexedCollation.currentCollation().sectionTitles[section]
    }

    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        if !enableIndexing {
            return nil
        }
        
        return UILocalizedIndexedCollation.currentCollation().sectionTitles
    }
    
    public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
    }
}

