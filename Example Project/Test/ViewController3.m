//
//  ViewController3.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "ViewController3.h"
#import "Test-Swift.h"
#import "TestCell.h"

@interface ViewController3 () <MSTableViewDataSourceDelegate>
@property(nonatomic, weak, nullable) IBOutlet UITableView *tableView;
@property(nonatomic, strong, nullable) MSTableViewSectionDataSource *sectionDataSource;
@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TestCell class] forCellReuseIdentifier:[TestCell identifier]];
    self.tableView.estimatedRowHeight = 54;
    self.tableView.rowHeight = 54;
    
    [self build];
}


- (void)build {
    
    NSMutableArray *dataSources = @[].mutableCopy;
    for (NSInteger i = 0; i < 3; i++) {
        NSMutableArray *items = @[].mutableCopy;
        
        for (NSInteger j = 0; j < 10; j++) {
            [items addObject:[NSString stringWithFormat:@"%ld", j]];
        }
        
        MSTableViewDataSource *dataSource = [[MSTableViewDataSource alloc] initWithCellIdentifier:[TestCell identifier] items:items];
        dataSource.title = [NSString stringWithFormat:@"Section %ld", i];
        if (i == 0) { // (first 2 are editable)
            dataSource.editable = YES;
            dataSource.editableCells = @{
                                         [NSIndexPath indexPathForRow:0 inSection:i]: @(UITableViewCellEditingStyleDelete),
                                         [NSIndexPath indexPathForRow:1 inSection:i]: @(UITableViewCellEditingStyleDelete)
                                         };
        } else if (i == 1) { // first 2 are movable
            dataSource.movable = YES;
            dataSource.movableCells = @[
                                        [NSIndexPath indexPathForRow:0 inSection:i],
                                        [NSIndexPath indexPathForRow:1 inSection:i]
                                        ];
        }
        [dataSources addObject:dataSource];
    }
    
    self.sectionDataSource = [[MSTableViewSectionDataSource alloc] initWithDataSources:dataSources];
    self.sectionDataSource.showDefaultHeaderTitle = YES;
    self.sectionDataSource.delegate = self;
    
    self.tableView.dataSource = self.sectionDataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - MSTableViewDataSourceDelegate

- (void)dataSource:(id <MSTableViewCellDataSource> _Nonnull)cell didConfigureCellAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    // Other configurable things to do with the cell @ex view Example 4
}

- (void)dataSource:(UITableViewCellEditingStyle)editingStyle commitEditingStyleForIndexPath:(NSIndexPath * _Nonnull)indexPath {
    // handle delete or move here
}

@end