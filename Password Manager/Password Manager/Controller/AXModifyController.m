//
//  AXModifyController.m
//  Password Manager
//
//  Created by arnoldxiao on 16/3/1.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXModifyController.h"
#import "AXPasswordManager.h"
#import "AXInputCell.h"
#import "NSString+Handler.h"
#import "AXDBManager.h"

@interface AXModifyController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) AXPasswordManager *manager;

@end

static const CGFloat SECTION_MARGIN = 20.0f;

@implementation AXModifyController

- (instancetype)initWithPasswordManagerItem:(AXPasswordManager *)manager {
    if (self = [super init]) {
        self.manager = manager;
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
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Modify Password";
    
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
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)saveButtonItemPressed:(UIBarButtonItem *)sender {
    
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
        if (![NSString isLegitimate:mobileField.text regex:phoneNumberRegex]) {
            [self alertWithMessage:kMobileFormatError];
            return;
        }
    }
    
    if (emailField.text != nil && [emailField.text trimmingSpaceCharacter].length > 0) {
        if (![NSString isLegitimate:emailField.text regex:emailRegex]) {
            [self alertWithMessage:kEmailFormatError];
            return;
        }
    }
    
    if (passwordField.text == nil || [passwordField.text trimmingSpaceCharacter].length == 0) {
        [self alertWithMessage:kPasswordIsEmpty];
        return;
    }
    
    if (![passwordField.text isEqualToString:confirmPasswordField.text]) {
        [self alertWithMessage:kPasswordVerfiyFail];
        return;
    }
    
    [self.manager setPMWithSite:[siteField.text trimmingSpaceCharacter]
                       user:[userField.text trimmingSpaceCharacter]
                     mobile:[mobileField.text trimmingSpaceCharacter]
                      email:[emailField.text trimmingSpaceCharacter]
                   password:[passwordField.text trimmingSpaceCharacter]];
    
    [[AXDBManager sharedManager] updateManager:self.manager];
    
    [self.navigationController popViewControllerAnimated:YES];
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
    static NSString *identifier = @"modify";
    AXInputCell *cell = (AXInputCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AXInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dict = [[dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setCellWithDict:dict];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        siteField = cell.textField;
        siteField.text = self.manager.siteName;
        siteField.keyboardType = UIKeyboardTypeURL;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        userField = cell.textField;
        userField.text = self.manager.userName;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        mobileField = cell.textField;
        mobileField.text = self.manager.mobile;
        mobileField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        emailField = cell.textField;
        emailField.text = self.manager.email;
        emailField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        passwordField = cell.textField;
        passwordField.text = self.manager.password;
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        confirmPasswordField = cell.textField;
        confirmPasswordField.text = self.manager.password;
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

- (AXPasswordManager *)manager {
    if (!_manager) {
        _manager = [[AXPasswordManager alloc] init];
    }
    return _manager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
