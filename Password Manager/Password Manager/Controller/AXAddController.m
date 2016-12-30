//
//  AXAddController.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXAddController.h"
#import "AXMainController.h"
#import "AXPasswordManager.h"
#import "AXDBManager.h"
#import "AXInputCell.h"
#import "NSString+Handler.h"

@interface AXAddController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

static const CGFloat SECTION_MARGIN = 20.0f;

@implementation AXAddController

- (instancetype)init {
    if (self = [super init]) {
        dataSource = @[
                       @[@{@"Site" : @"Site Name"}],
                       @[@{@"User" : @"User Name"}, @{@"Mobile" : @"Phone Number"}, @{@"Email" : @"Email"}],
                       @[@{@"Password" : @"Password"}, @{@"Confirm" : @"Confirm Password"}]
                       ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Password";
    
    [self setUpTableView];
    [self rightBarButton];
}

- (void)setUpTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
}

- (void)rightBarButton {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addButtonItemPressed:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    if (siteField.text == nil || [siteField.text trimmingSpaceCharacter].length == 0) {
        [self alertWithMessage:kSiteIsEmpty];
        return;
    }
    
    if (userField.text == nil || [userField.text trimmingSpaceCharacter].length == 0) {
        [self alertWithMessage:kUserIsEmpty];
        return;
    }
    
    if (mobileField.text != nil && [mobileField.text trimmingSpaceCharacter].length > 0) {
        if (![mobileField.text isLegitimateWithRegex:phoneNumberRegex]) {
            [self alertWithMessage:kMobileFormatError];
            return;
        }
    }
    
    if (emailField.text != nil && [emailField.text trimmingSpaceCharacter].length > 0) {
        if (![emailField.text isLegitimateWithRegex:emailRegex]) {
            [self alertWithMessage:kEmailFormatError];
            return;
        }
    }
    
    NSString *password = [passwordField.text trimmingSpaceCharacter];
    
    if (passwordField.text == nil || password.length == 0) {
        [self alertWithMessage:kPasswordIsEmpty];
        return;
    }
    
    if (![passwordField.text isEqualToString:confirmPasswordField.text]) {
        [self alertWithMessage:kPasswordVerfiyFail];
        return;
    }
    
    AXPasswordManager *manager = [[AXPasswordManager alloc] initWithSite:[siteField.text trimmingSpaceCharacter]
                                                                    user:[userField.text trimmingSpaceCharacter]
                                                                  mobile:[mobileField.text trimmingSpaceCharacter]
                                                                   email:[emailField.text trimmingSpaceCharacter]
                                                                password:[password encrypt]];
    [[AXDBManager sharedManager] insertManager:manager];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    UIView *view = [textField superview];
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    
    UITableViewCell *cell = (UITableViewCell *)view;
    CGRect rect = cell.frame;
    
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
        
    if (statusHeight + navigationBarHeight + rect.origin.y + rect.size.height > kScreenHeight - kSystemKeyboardHeight) {
        
        CGFloat offset = statusHeight + navigationBarHeight + rect.origin.y + rect.size.height - kScreenHeight + kSystemKeyboardHeight;
        CGFloat y = defaultContentOffset.y + offset + SECTION_MARGIN;
        
        [self.tableView setContentOffset:CGPointMake(0, y) animated:YES];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.tableView.contentOffset.x != defaultContentOffset.x || self.tableView.contentOffset.y != defaultContentOffset.y) {
        [self.tableView setContentOffset:defaultContentOffset animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[textField superview] superview]];
    NSIndexPath *next = nil;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        next = [NSIndexPath indexPathForRow:0 inSection:1];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        next = [NSIndexPath indexPathForRow:1 inSection:1];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        next = [NSIndexPath indexPathForRow:2 inSection:1];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        next = [NSIndexPath indexPathForRow:0 inSection:2];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        next = [NSIndexPath indexPathForRow:1 inSection:2];
    } else {
        next = nil;
    }
    
    if (next) {
        AXInputCell *cell = (AXInputCell *)[self.tableView cellForRowAtIndexPath:next];
        [cell.textField becomeFirstResponder];
    }
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
            
        case 1:
            rows = 3;
            break;
            
        case 2:
            rows = 2;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"add";
    AXInputCell *cell = (AXInputCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AXInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dict = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setCellWithDict:dict];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        siteField = cell.textField;
        siteField.keyboardType = UIKeyboardTypeURL;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        userField = cell.textField;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        mobileField = cell.textField;
        mobileField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        emailField = cell.textField;
        emailField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        passwordField = cell.textField;
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        confirmPasswordField = cell.textField;
    }
    
    cell.textField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 2) {
        cell.textField.secureTextEntry = YES;
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [cell addPasswordStatusButton];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.textField.returnKeyType = UIReturnKeyDone;
    } else {
        cell.textField.returnKeyType = UIReturnKeyNext;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_MARGIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
