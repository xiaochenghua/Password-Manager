//
//  AXBaseCell.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/23.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXBaseCell : UITableViewCell

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UITextField *textField;

- (void)setUpSubviews;

@end
