//
//  TestTextFieldCellTableViewCell.m
//  Test
//
//  Created by Prince Ugwuh on 8/10/16.
//  Copyright © 2016 TTT. All rights reserved.
//

#import "TestTextFieldCell.h"
#import "Test-Swift.h"

@interface TestTextFieldCell () <UITextFieldDelegate, MSTableViewCellDataSource>
@property(nonatomic, weak, nullable) IBOutlet UITextField *textField;
@end

@implementation TestTextFieldCell

+ (NSString * _Nonnull)identifier {
    return @"TestTextFieldCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.textField addTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textField becomeFirstResponder];
}

- (void)configureDataForCell:(NSString *)data {
  //  self.textField.text = data;
}

- (void)textFieldValueDidChange:(id)sender {
    if (self.textFieldValueDidChange != nil) {
        self.textFieldValueDidChange(self.textField.text);
    }
}

@end
