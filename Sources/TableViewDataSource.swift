import UIKit

@objc(MSTableViewCellDataSource)
public protocol TableViewCellDataSource: class {
    @objc(configureDataForCell:)
    func configure(data: AnyObject?)
}

@objc(MSTableViewDataSourceDelegate)
public protocol TableViewDataSourceDelegate: class {
    @objc(dataSource:didConfigureCellAtIndexPath:)
    func didConfigureCell(cell: TableViewCellDataSource, atIndexPath indexPath: NSIndexPath)
    
    @objc(dataSource:commitEditingStyleForIndexPath:)
    optional func commitEditingStyle(editingStyle: UITableViewCellEditingStyle, forIndexPath indexPath: NSIndexPath)
}

@objc(MSTableViewDataSourceCellItem)
public class TableViewDataSourceCellItem: NSObject {
    var cellIdentifier: String?
    var item: AnyObject?
    var cellHeight: CGFloat?
}

@objc(MSTableViewDataSource)
public class TableViewDataSource: NSObject, UITableViewDataSource {
    private var cellItems: [TableViewDataSourceCellItem]?
    private(set) var cellIdentifier: String?
    public var items: [AnyObject]?
    public var title: String?
    public weak var delegate: TableViewDataSourceDelegate?
    public var sectionHeaderView: UIView?
    public var reusableHeaderFooterViewIdentifier: String?
    public var editable: Bool = false
    public var movable: Bool = false
    public var editableCells: [NSIndexPath: NSNumber]? // NSNumber represents the UITableViewCellEditingStyle
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
    
    @objc(itemAtIndexPath:)
    public func item(at indexPath: NSIndexPath) -> AnyObject? {
        if let items = items where items.count > 0 && indexPath.row < items.count {
            return items[indexPath.row]
        }
        return nil
    }
    
    @objc(cellItemAtIndexPath:)
    public func cellItem(at indexPath: NSIndexPath) -> TableViewDataSourceCellItem? {
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
        }
        return false
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if editable {
            if let editableCells = editableCells {
                return editableCells.keys.contains(indexPath)
            }
        }
        return false
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.commitEditingStyle?(editingStyle, forIndexPath: indexPath)
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
            let cellItem = self.cellItem(at: indexPath)!
            identifier = cellItem.cellIdentifier
            item = cellItem.item
        } else {
            item = self.item(at: indexPath)
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

@objc(MSTableViewSectionDataSource)
public class TableViewSectionDataSource: NSObject, UITableViewDataSource {
    
    public weak var delegate: TableViewDataSourceDelegate?
    public private(set) var dataSources: [TableViewDataSource]?
    public var enableIndexing: Bool  = false
    public var showDefaultHeaderTitle: Bool = true
    
    public convenience init(dataSources: [TableViewDataSource]) {
        self.init()
        self.dataSources = dataSources
    }
    
    @objc(itemAtIndexPath:)
    public func item(at indexPath: NSIndexPath) -> AnyObject? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.item(at: indexPath)
    }
    
    @objc(cellItemAtIndexPath:)
    public func cellItem(at indexPath: NSIndexPath) -> TableViewDataSourceCellItem? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.cellItem(at: indexPath)
    }
    
    @objc(dataSourceAtIndexPath:)
    public func dataSource(at indexPath: NSIndexPath) -> TableViewDataSource {
        return dataSources![indexPath.section]
    }
    
    @objc(titleAtIndexPath:)
    public func title(at indexPath: NSIndexPath) -> String? {
        let dataSource = dataSources![indexPath.section]
        return dataSource.title
    }
    
    @objc(sectionHeaderViewAtIndexPath:)
    public func sectionHeaderView(at indexPath: NSIndexPath) -> UIView? {
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

    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let dataSource = dataSources![indexPath.section]
        return dataSource.tableView(tableView, canMoveRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let dataSource = dataSources![indexPath.section]
        return dataSource.tableView(tableView, canEditRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.commitEditingStyle?(editingStyle, forIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if var sourceItems = dataSource(at: sourceIndexPath).items,
           var destinationItems = dataSource(at: destinationIndexPath).items {
            
            let item = sourceItems.removeAtIndex(sourceIndexPath.row)
            destinationItems.insert(item, atIndex: destinationIndexPath.row)
            
            dataSources?[sourceIndexPath.section].items = sourceItems
            dataSources?[destinationIndexPath.section].items = destinationItems
        }
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
    
    public func sectionIndexTitles(tableView: UITableView) -> [String]? {
        
        if !enableIndexing {
            return nil
        }
        
        return UILocalizedIndexedCollation.currentCollation().sectionTitles
    }
    
    public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
    }
}

