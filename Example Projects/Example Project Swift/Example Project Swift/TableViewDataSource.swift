import UIKit

@objc(MSTableViewCellDataSource)
public protocol TableViewCellDataSource: class {
    @objc(configureDataForCell:)
    func configure(_ data: Any?)
}

@objc(MSTableViewDataSourceDelegate)
public protocol TableViewDataSourceDelegate: class {
    @objc(dataSource:didConfigureCellAtIndexPath:)
    func didConfigureCell(_ cell: TableViewCellDataSource, atIndexPath indexPath: IndexPath)
    
    @objc(dataSource:commitEditingStyleForIndexPath:)
    optional func commitEditingStyle(_ editingStyle: UITableViewCellEditingStyle, forIndexPath indexPath: IndexPath)
}

@objc(MSTableViewDataSourceCellItem)
open class TableViewDataSourceCellItem: NSObject {
    open var cellIdentifier: String?
    open var item: Any?
    open var cellHeight: CGFloat?
}

@objc(MSTableViewDataSource)
open class TableViewDataSource: NSObject, UITableViewDataSource {
    internal var cellItems: [TableViewDataSourceCellItem]?
    internal(set) var cellIdentifier: String?
    open var items: [Any]?
    open var title: String?
    open weak var delegate: TableViewDataSourceDelegate?
    open var sectionHeaderView: UIView?
    open var reusableHeaderFooterViewIdentifier: String?
    open var editable: Bool = false
    open var movable: Bool = false
    open var editableCells: [IndexPath: UITableViewCellEditingStyle]? // NSNumber represents the UITableViewCellEditingStyle
    open var movableCells: [IndexPath]?
    
    override init() {
        super.init()
    }
    
    public convenience init(cellItems: [TableViewDataSourceCellItem]) {
        self.init()
        self.cellItems = cellItems
    }
    
    public convenience init(cellIdentifier: String, items: [Any]? = nil) {
        self.init()
        self.cellIdentifier = cellIdentifier
        self.items = items
    }
    
    //MARK: -
    
    @objc(itemAtIndexPath:)
    open func item(at indexPath: IndexPath) -> Any? {
        if let items = self.items , items.count > 0 && indexPath.row < items.count {
            return items[indexPath.row]
        }
        return nil
    }
    
    @objc(cellItemAtIndexPath:)
    open func cellItem(at indexPath: IndexPath) -> TableViewDataSourceCellItem? {
        if let cellItems = self.cellItems , cellItems.count > 0 && indexPath.row < cellItems.count {
            return cellItems[indexPath.row]
        }
        return nil
    }
    
    //MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cellItems = self.cellItems {
            return cellItems.count
        }
        
        if let items = self.items {
            return items.count
        }
        return 0
    }
    
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if self.movable {
            if let movableCells = movableCells {
                return movableCells.contains(indexPath)
            }
        }
        return false
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.editable {
            if let editableCells = editableCells {
                return editableCells.keys.contains(indexPath)
            }
        }
        return false
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.delegate?.commitEditingStyle?(editingStyle, forIndexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let item = items?[sourceIndexPath.row] {
            self.items?.remove(at: sourceIndexPath.row)
            self.items?.insert(item, at: destinationIndexPath.row)
        }
    }
    
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier: String?
        var item: Any?
        
        if let cellItems = cellItems , cellItems.count > 0 {
            let cellItem = self.cellItem(at: indexPath)!
            identifier = cellItem.cellIdentifier
            item = cellItem.item
        } else {
            item = self.item(at: indexPath)
            identifier = cellIdentifier
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath)
        
        if cell is TableViewCellDataSource {
            let sourceCell = cell as! TableViewCellDataSource
            sourceCell.configure(item)
            delegate?.didConfigureCell(sourceCell, atIndexPath: indexPath)
        }
        
        return cell
    }
}

@objc(MSTableViewSectionDataSource)
open class TableViewSectionDataSource: NSObject, UITableViewDataSource {
    
    open weak var delegate: TableViewDataSourceDelegate?
    open fileprivate(set) var dataSources: [TableViewDataSource]?
    open var enableIndexing: Bool  = false
    open var showDefaultHeaderTitle: Bool = true
    
    public convenience init(dataSources: [TableViewDataSource]) {
        self.init()
        self.dataSources = dataSources
    }
    
    @objc(itemAtIndexPath:)
    open func item(at indexPath: IndexPath) -> Any? {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.item(at: indexPath)
    }
    
    @objc(cellItemAtIndexPath:)
    open func cellItem(at indexPath: IndexPath) -> TableViewDataSourceCellItem? {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.cellItem(at: indexPath)
    }
    
    @objc(dataSourceAtIndexPath:)
    open func dataSource(at indexPath: IndexPath) -> TableViewDataSource {
        return self.dataSources![indexPath.section]
    }
    
    @objc(titleAtIndexPath:)
    open func title(at indexPath: IndexPath) -> String? {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.title
    }
    
    @objc(sectionHeaderViewAtIndexPath:)
    open func sectionHeaderView(at indexPath: IndexPath) -> UIView? {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.sectionHeaderView
    }
    
    //MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        if let dataSources = self.dataSources {
            return dataSources.count
        }
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSources = self.dataSources {
            let dataSource = dataSources[section]
            return dataSource.tableView(tableView, numberOfRowsInSection: section)
        }
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }

    
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.tableView(tableView, canMoveRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let dataSource = self.dataSources![indexPath.section]
        return dataSource.tableView(tableView, canEditRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.delegate?.commitEditingStyle?(editingStyle, forIndexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if var sourceItems = self.dataSource(at: sourceIndexPath).items,
           var destinationItems = self.dataSource(at: destinationIndexPath).items {
            
            let item = sourceItems.remove(at: sourceIndexPath.row)
            destinationItems.insert(item, at: destinationIndexPath.row)
            
            self.dataSources?[sourceIndexPath.section].items = sourceItems
            self.dataSources?[destinationIndexPath.section].items = destinationItems
        }
    }
    
    //MARK - Indexing
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.showDefaultHeaderTitle {
            if let dataSources = self.dataSources {
                let dataSource = dataSources[section]
                return dataSource.title
            }
            return nil
        }
        
        if !self.enableIndexing {
            return nil
        }
        
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: section)
        if numberOfRows == 0 {
            return nil
        }
        
        return UILocalizedIndexedCollation.current().sectionTitles[section]
    }
    
    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !self.enableIndexing {
            return nil
        }
        
        return UILocalizedIndexedCollation.current().sectionTitles
    }
    
    
    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
}

