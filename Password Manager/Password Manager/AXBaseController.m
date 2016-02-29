//
//  AXBaseController.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXBaseController.h"
#import "AXDetailCell.h"
#import "NSString+Encrypt.h"

@interface AXBaseController ()

@end

@implementation AXBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)exchangeStatus:(UIButton *)btn {
    AXBaseCell *cell = nil;
    UIView *view = [[btn superview] superview];
    if ([view isKindOfClass:[AXBaseCell class]]) {
        cell = (AXBaseCell *)view;
    }
    
    if (cell.textField.secureTextEntry) {
        cell.textField.secureTextEntry = NO;
        [btn setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
        
        if (cell.textField == nil || [cell.textField.text trimmingSpaceCharacter].length == 0) {
            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!cell.textField.secureTextEntry) {
                cell.textField.secureTextEntry = YES;
                [btn setImage:[UIImage imageNamed:@"hide_pwd"] forState:UIControlStateNormal];
            }
        });
    } else {
        cell.textField.secureTextEntry = YES;
        [btn setImage:[UIImage imageNamed:@"hide_pwd"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
