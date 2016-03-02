//
//  AXMainController.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXMainController.h"
#import "AXDBManager.h"
#import "AXPasswordManagerItem.h"
#import "NSString+Encrypt.h"
#import "AXAddController.h"
#import "AXDetailController.h"
#import "AXModifyController.h"

@interface AXMainController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AXMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Password Manager";
        
    [self setUpTableView];
    [self rightBarButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)setUpTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
}

- (void)rightBarButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPMItem:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addPMItem:(UIBarButtonItem *)sender {
    AXAddController *controller = [[AXAddController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[AXDBManager sharedManager] queryTotalCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"main";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    AXPasswordManagerItem *pmItem = [[AXDBManager sharedManager] queryAll][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = pmItem.siteName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AXPasswordManagerItem *pmItem = [[AXDBManager sharedManager] queryAll][indexPath.row];
    AXDetailController *controller = [[AXDetailController alloc] initWithPasswordManagerItem:pmItem];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AXPasswordManagerItem *pmItem = [[AXDBManager sharedManager] queryAll][indexPath.row];
        [[AXDBManager sharedManager] deleteWithItem:pmItem];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    UITableViewRowAction *updateAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AXPasswordManagerItem *pmItem = [[AXDBManager sharedManager] queryAll][indexPath.row];
        AXModifyController *controller = [[AXModifyController alloc] initWithPasswordManagerItem:pmItem];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    updateAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    return @[updateAction, deleteAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
