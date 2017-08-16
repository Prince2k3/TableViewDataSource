# TableViewDataSource
UITableView DataSource Class written in Swift that moves away repetitive code and keeps the View Controller light

This repo does have a sample projects you can download, view and see first hand how things work. They are available in both ObjC and Swift.

## Working with UITableView
Note: If you are using UITableViewCell as a nib file, be sure to register the cell to the table view you are using. Otherwise you won't see the cell.

To use TableViewDataSource you'll need to initialize it and give it your UITableViewCell identifier. Once you have done that set the UITableView dataSource be set to the TableViewDataSource dataSource property. 
```
   @IBOutlet weak var tableView: UITableView! {
     didSet {
       self.tableView?.dataSource = self.dataSource
     }
   }

  let dataSource: TableViewDataSource = TableViewDataSource(cellIdentifier: "<YourCellIdentifier>")
```
In your UITableViewCell add this protocol `TableViewCellDataSource`. (I recommend that this be an extension to keep your cell and how your cell is configured separate.)
```
extension MyTableViewCell: TableViewCellDataSource {
   func configure(_ data: Any?) {
       /// setup your cell here     
   }  
}
```

## Building from UITableViewCells from scratch

```
var items: [String] = ["Apples", "Oranges", "Grapes", "Bannanas"]
...
func buildTable() {
  var cellItems = [TableViewDataSourceCellItem]()
  for item in items {
    let cellItem = TableViewDataSourceCellItem()
    cellItem.identifier = "<YourCellIdentifier>"
    cellItem.item = item
    cellItems.append(cellItem)
  }
  
  self.dataSource = TableViewDataSource(cellItems: cellItems)
  self.tableView.dataSource = self.dataSource
  self.tableView.reloadData()
} 
...
```
## Working with UITableView sections
```
var items: [String] = ["Apples", "Oranges", "Grapes", "Bannanas"]
...
func buildTable() {
  var dataSources = [TableViewDataSource]()
  var cellItems = [TableViewDataSourceCellItem]()
  for item in items {
    let cellItem = TableViewDataSourceCellItem()
    cellItem.identifier = "<YourCellIdentifier>"
    cellItem.item = item
    cellItems.append(cellItem)
  }
  
  for i in 0..<3 {
    let dataSource = TableViewDataSource(cellItems: cellItems)
    dataSources.append(dataSource)
  }
  
  self.sectionDataSource = TableViewSectionDataSource(dataSources: dataSources)
  self.tableView.dataSource = self.sectionDataSource
  self.tableView.reloadData()
} 
...
```
## Working Static UITableViewController
With the same setup you can manage dynamic cells within static tableviews. 

Example coming soon

## Indexing setup
coming soon

## Moving and Deleting Cells
coming soon

## Installation

##### CocoaPods

if you're using CocoaPods, just add this to your Podfile: 
```
pod 'MSTableViewDataSource'
```
Install by running this command in your terminal:
```
pod install
```
Then import the library in all files where you use it:
```
import MSTableViewDataSource
```

##### Carthage 
just add to your Cartfile:
```
github "Prince2k3/TableViewDataSource"
```
Then import the library in all files where you use it:
```
import TableViewDataSource
```
