//
//  AXDetailCell.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/23.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXDetailCell.h"

@implementation AXDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textField.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setCellWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
