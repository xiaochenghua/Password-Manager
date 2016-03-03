//
//  AXDBManager.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXDBManager.h"
#import "FMDB.h"
#import "AXPasswordManager.h"

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

- (void)insertManager:(AXPasswordManager *)manager {
    BOOL result = [_db executeUpdate:kInsertString, manager.siteName, manager.userName, manager.mobile, manager.email, manager.password];
    NSString *message = result ? @"insert success!" : @"insert failed!";
    NSLog(@"%@", message);
}

- (void)updateManager:(AXPasswordManager *)manager {
    NSString *update_str = [NSString stringWithFormat:kUpdateString, manager.itemID];
    BOOL result = [_db executeUpdate:update_str, manager.siteName, manager.userName, manager.mobile, manager.email, manager.password];
    NSString *message = result ? @"update success!" : @"update failed!";
    NSLog(@"%@", message);
}

- (void)deleteManager:(AXPasswordManager *)manager {
    NSString *delete_str = [NSString stringWithFormat:kDeleteString, manager.itemID];
    BOOL result = [_db executeUpdate:delete_str];
    NSString *message = result ? @"delete success!" : @"delete failed!";
    NSLog(@"%@", message);
}

- (void)deleteAll {
    BOOL result01, result02 = NO;
    result01 = [_db executeUpdate:kDeleteAllString];
    if (result01) {
        result02 = [_db executeUpdate:kSeqEqual0];
    }
    NSString *message01 = result01 ? @"delete all success!" : @"delete all failed!";
    NSString *message02 = result02 ? @"Seq set 0 success!" : @"Seq set 0 failed!";
    NSLog(@"%@ and %@", message01, message02);
}

- (NSArray<AXPasswordManager *> *)queryAll {
    return [self arrayWithResultSet:[_db executeQuery:kQueryAllString]];
}

- (NSArray<AXPasswordManager *> *)queryWithSite:(NSString *)siteName {
    NSString *sql = [_db stringForQuery:kQueryString, siteName];
    NSLog(@"sql = %@", sql);          //  <---测试
    FMResultSet *rs = [_db executeQuery:sql];
    
    return [self arrayWithResultSet:rs];
}

- (NSArray<AXPasswordManager *> *)arrayWithResultSet:(FMResultSet *)rs {
    NSMutableArray<AXPasswordManager *> *tempArray = [NSMutableArray array];
    while ([rs next]) {
        AXPasswordManager *manager = [[AXPasswordManager alloc] init];
        manager.itemID   = [rs stringForColumn:@"item_id"].integerValue;
        manager.siteName = [rs stringForColumn:@"site_name"];
        manager.userName = [rs stringForColumn:@"user_name"];
        manager.mobile   = [rs stringForColumn:@"mobile"];
        manager.email    = [rs stringForColumn:@"email"];
        manager.password = [rs stringForColumn:@"password"];
        [tempArray addObject:manager];
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
