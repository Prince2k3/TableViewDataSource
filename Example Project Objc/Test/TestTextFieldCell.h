//
//  TestTextFieldCellTableViewCell.h
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTextFieldCell : UITableViewCell
+ (NSString * _Nonnull)identifier;
@property(nonatomic, copy, nullable) void(^textFieldValueDidChange)( NSString * _Nullable value);
@end
