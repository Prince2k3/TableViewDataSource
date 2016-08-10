//
//  ViewController2.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "ViewController2.h"
#import "Test-Swift.h"
#import "TestCell.h"

@interface ViewController2 ()
@property(nonatomic, weak, nullable) IBOutlet UITableView *tableView;
@property(nonatomic, strong, nullable) MSTableViewDataSource *dataSource;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TestCell class] forCellReuseIdentifier:[TestCell identifier]];
    self.tableView.estimatedRowHeight = 54;
    self.tableView.rowHeight = 54;
    
    [self build];
}


- (void)build {
    
    NSMutableArray *items = @[].mutableCopy;
    
    for (NSInteger i = 0; i < 100; i++) {
        MSTableViewDataSourceCellItem *item = [[MSTableViewDataSourceCellItem alloc] init];
        item.cellIdentifier = [TestCell identifier];
        item.item = [NSString stringWithFormat:@"%ld", i];
        [items addObject:item];
    }
    
    self.dataSource = [[MSTableViewDataSource alloc] initWithCellItems:items];

    self.tableView.dataSource = self.dataSource;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

