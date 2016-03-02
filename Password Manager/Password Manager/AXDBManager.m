//
//  AXDBManager.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXDBManager.h"
#import "FMDB.h"
#import "AXPasswordManagerItem.h"

@interface AXDBManager ()<NSCopying>

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation AXDBManager

- (instancetype)init {
    if (self = [super init]) {
        [self create];
    }
    return self;
}

+ (instancetype)sharedManager {
    static AXDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [AXDBManager sharedManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return [AXDBManager sharedManager];
}

- (void)create {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileName = [documentDirectory stringByAppendingPathComponent:@"password.sqlite"];
    
    NSLog(@"%@", fileName);
    
    _db = [FMDatabase databaseWithPath:fileName];
    
    if ([_db open]) {
        BOOL result = [_db executeUpdate:kCreateString];
        NSString *message = result ? @"create success!" : @"create failed!";
        NSLog(@"%@", message);
    }
}

- (void)insertWithItem:(AXPasswordManagerItem *)item {
    BOOL result = [_db executeUpdate:kInsertString, item.siteName, item.userName, item.mobile, item.email, item.password];
    NSString *message = result ? @"insert success!" : @"insert failed!";
    NSLog(@"%@", message);
}

- (void)updateWithItem:(AXPasswordManagerItem *)item {
    NSString *update_str = [NSString stringWithFormat:kUpdateString, item.itemID];
    BOOL result = [_db executeUpdate:update_str, item.siteName, item.userName, item.mobile, item.email, item.password];
    NSString *message = result ? @"update success!" : @"update failed!";
    NSLog(@"%@", message);
}

- (void)deleteWithItem:(AXPasswordManagerItem *)item {
    NSString *delete_str = [NSString stringWithFormat:kDeleteString, item.itemID];
    BOOL result = [_db executeUpdate:delete_str];
    NSString *message = result ? @"delete success!" : @"delete failed!";
    NSLog(@"%@", message);
}

- (NSArray<AXPasswordManagerItem *> *)queryAll {
    return [self arrayWithResultSet:[_db executeQuery:kQueryAllString]];
}

- (NSArray<AXPasswordManagerItem *> *)queryWithSite:(NSString *)siteName {
    NSString *sql = [_db stringForQuery:kQueryString, siteName];
    NSLog(@"sql = %@", sql);          //  <---测试
    FMResultSet *rs = [_db executeQuery:sql];
    
    return [self arrayWithResultSet:rs];
}

- (NSArray<AXPasswordManagerItem *> *)arrayWithResultSet:(FMResultSet *)rs {
    NSMutableArray<AXPasswordManagerItem *> *tempArray = [NSMutableArray array];
    while ([rs next]) {
        AXPasswordManagerItem *item = [[AXPasswordManagerItem alloc] init];
        item.itemID   = [rs stringForColumn:@"item_id"].integerValue;
        item.siteName = [rs stringForColumn:@"site_name"];
        item.userName = [rs stringForColumn:@"user_name"];
        item.mobile   = [rs stringForColumn:@"mobile"];
        item.email    = [rs stringForColumn:@"email"];
        item.password = [rs stringForColumn:@"password"];
        [tempArray addObject:item];
    }
    return [tempArray copy];
}

- (NSUInteger)queryTotalCount {
    return [_db intForQuery:kQueryCountString];
}

- (void)close {
    [_db close];
}

@end
