//
//  AXAddOptionCell.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/23.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXAddOptionCell.h"

@implementation AXAddOptionCell

- (void)setCellWithDict:(NSDictionary *)dict {
    [self setCellWithTitle:[dict allKeys][0] placeholder:[dict allValues][0]];
}

- (void)setCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    self.titleLabel.text = title;
    self.textField.placeholder = placeholder;
}

@end
