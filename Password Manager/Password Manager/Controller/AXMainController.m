//
//  AXMainController.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXMainController.h"
#import "AXDBManager.h"
#import "AXPasswordManager.h"
#import "NSString+Handler.h"
#import "AXAddController.h"
#import "AXDetailController.h"
#import "AXModifyController.h"

@interface AXMainController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
{
    /**
     *  搜索关键字
     */
    NSString *searchWords;
    
    /**
     *  搜索出来的AXPasswordManager对象
     */
    NSMutableArray<AXPasswordManager *> *searchResults;
}

/**
 *  所有的AXPasswordManager对象
 */
@property (nonatomic, copy) NSArray<AXPasswordManager *> *searchManagers;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation AXMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Password Manager";
    
    [self setUpTableView];
    [self barButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)setUpTableView {
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];
}

- (void)barButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPMItem:)];
}

- (void)compose:(UIBarButtonItem *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:kComposeMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = [UIColor darkGrayColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dealWithCode:alertController.textFields.firstObject.text];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dealWithCode:(NSString *)code {
    switch (code.integerValue) {
        case 1011:
            [self deleteAllAlertController];
            break;
            
        default:
            [self alertWithMessage:@"Command code error!"];
            break;
    }
}

- (void)deleteAllAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:kDeleteAllMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAllTheData];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteAllTheData {
    [[AXDBManager sharedManager] deleteAll];
    [self.tableView reloadData];
}

- (void)addPMItem:(UIBarButtonItem *)sender {
    AXAddController *controller = [[AXAddController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.active) {
        return searchResults.count;
    }
    return [[AXDBManager sharedManager] queryTotalCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"main";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (_searchController.active) {
        UIColor *color = [UIColor colorWithRed:30 / 255.0 green:144 / 255.0 blue:255 / 255.0 alpha:1.0];
        NSString *result = searchResults[indexPath.row].siteName;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:result];
        NSRange range = [result rangeOfString:searchWords.lowercaseString];
        [attr addAttribute:NSForegroundColorAttributeName value:color range:range];
        cell.textLabel.attributedText = attr;
    } else {
        AXPasswordManager *manager = [[AXDBManager sharedManager] queryAll][indexPath.row];
        cell.textLabel.text = manager.siteName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AXPasswordManager *manager = _searchController.active ? searchResults[indexPath.row] : [[AXDBManager sharedManager] queryAll][indexPath.row];
    
    if (_searchController.active) {
        _searchController.active = NO;
    }
    
    AXDetailController *controller = [[AXDetailController alloc] initWithPasswordManagerItem:manager];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AXPasswordManager *manager = [[AXDBManager sharedManager] queryAll][indexPath.row];
        [[AXDBManager sharedManager] deleteManager:manager];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    UITableViewRowAction *updateAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AXPasswordManager *manager = [[AXDBManager sharedManager] queryAll][indexPath.row];
        AXModifyController *controller = [[AXModifyController alloc] initWithPasswordManagerItem:manager];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    updateAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    return @[updateAction, deleteAction];
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"Please enter the keywords";
        _searchController.searchBar.delegate = self;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    searchWords = _searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.siteName CONTAINS[c] %@", searchWords];
    searchResults = [NSMutableArray arrayWithArray:[self.searchManagers filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    for (id obj in searchBar.subviews[0].subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (NSArray<AXPasswordManager *> *)searchManagers {
    return [[AXDBManager sharedManager] queryAll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
