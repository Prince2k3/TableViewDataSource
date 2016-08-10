//
//  TestCell.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

+ (NSString  * _Nonnull)identifier {
    return @"TestCell";
}


- (void)configureDataForCell:(NSString *)data {
    self.textLabel.text = data;
}

@end
