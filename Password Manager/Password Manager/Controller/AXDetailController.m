//
//  AXDetailController.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/23.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXDetailController.h"
#import "AXPasswordCell.h"
#import "AXPasswordManagerItem.h"

@interface AXDetailController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray<NSArray *> *dataSource;
}
@end

@implementation AXDetailController

- (instancetype)init {
    if (self = [super init]) {
        dataSource = @[
                       @[@"ID", @"Site"],
                       @[@"User", @"Mobile", @"Email"],
                       @[@"Password"]
                       ];
        _pmItem = [[AXPasswordManagerItem alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Password Detail";
    
    [self setUpTableView];
}

- (void)setUpTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 2;
            break;
            
        case 1:
            rows = 3;
            break;
            
        case 2:
            rows = 1;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"detail";
    AXDetailCell *cell = (AXDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if (indexPath.section == 2 && indexPath.row == 0) {
            cell = [[AXPasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        } else {
            cell = [[AXDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    
    NSString *title = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setCellWithTitle:title];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        itemIdField = cell.textField;
        itemIdField.text = [NSString stringWithFormat:@"%ld", self.pmItem.itemID];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        siteField = cell.textField;
        siteField.text = self.pmItem.siteName;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        userField = cell.textField;
        userField.text = self.pmItem.userName;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        mobileField = cell.textField;
        mobileField.text = self.pmItem.mobile;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        emailField = cell.textField;
        emailField.text = self.pmItem.email;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        passwordField = cell.textField;
        passwordField.text = self.pmItem.password;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.textColor = [UIColor grayColor];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textField.secureTextEntry = YES;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (void)exchangeStatus:(UIButton *)btn {
    AXDetailCell *cell = nil;
    UIView *view = [[btn superview] superview];
    if ([view isKindOfClass:[AXDetailCell class]]) {
        cell = (AXDetailCell *)view;
    }
    
    if (cell.textField.secureTextEntry) {
        cell.textField.secureTextEntry = NO;
        [btn setImage:[UIImage imageNamed:@"hide_pwd"] forState:UIControlStateNormal];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!cell.textField.secureTextEntry) {
                cell.textField.secureTextEntry = YES;
                [btn setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
            }
        });
    } else {
        cell.textField.secureTextEntry = YES;
        [btn setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
