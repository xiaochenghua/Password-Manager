//
//  AXBaseController.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXBaseController : UIViewController
{
    CGPoint defaultContentOffset;
    NSArray<NSArray *> *dataSource;
    
    UITextField *itemIdField, *siteField, *userField, *mobileField, *emailField, *passwordField, *confirmPasswordField;
}

@property (nonatomic, strong) UITableView *tableView;

- (void)alertWithMessage:(NSString *)string;
- (void)exchangeStatus:(UIButton *)btn;

@end
