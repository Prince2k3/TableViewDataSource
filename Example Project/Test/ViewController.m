//
//  ViewController.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "ViewController.h"
#import "Test-Swift.h"
#import "TestCell.h"

@interface ViewController ()
@property(nonatomic, weak, nullable) IBOutlet UITableView *tableView;
@property(nonatomic, strong, nullable) MSTableViewDataSource *dataSource;
@end

@implementation ViewController

- (NSArray *)sampleData {
        return @[@"Bananas", @"Apples", @"Oranges", @"Grapes", @"Strawberry", @"Pineapple", @"Mango"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Note: You can set the items anytime you want. Make sure you reload the table view for the changes to take effect.
    
    [self.tableView registerClass:[TestCell class] forCellReuseIdentifier:[TestCell identifier]];
    self.tableView.estimatedRowHeight = 54;
    self.tableView.rowHeight = 54;
    
    self.dataSource = [[MSTableViewDataSource alloc] initWithCellIdentifier:[TestCell identifier] items:self.sampleData];
    self.tableView.dataSource = self.dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
