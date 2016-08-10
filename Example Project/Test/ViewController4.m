//
//  ViewController4.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "ViewController4.h"
#import "Test-Swift.h"
#import "TestTextFieldCell.h"

@interface ViewController4 () <MSTableViewDataSourceDelegate>
@property(nonatomic, weak, nullable) IBOutlet UITableView *tableView;
@property(nonatomic, strong, nullable) MSTableViewDataSource *dataSource;
@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:[TestTextFieldCell identifier] bundle:nil] forCellReuseIdentifier:[TestTextFieldCell identifier]];
    self.tableView.estimatedRowHeight = 54;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self build];
}


- (void)build {
    
    
    MSTableViewDataSourceCellItem *item = [[MSTableViewDataSourceCellItem alloc] init];
    item.cellIdentifier = [TestTextFieldCell identifier];
    item.item = nil;
    
    self.dataSource = [[MSTableViewDataSource alloc] initWithCellItems:@[item]];
    self.dataSource.delegate = self;
    
    self.tableView.dataSource = self.dataSource;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Mark - MSTableViewDataSourceDelegate

- (void)dataSource:(TestTextFieldCell *)cell didConfigureCellAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    cell.textFieldValueDidChange = ^(NSString *text){
        NSLog(@"%@", text);
    };
}

@end
