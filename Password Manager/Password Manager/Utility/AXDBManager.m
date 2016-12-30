//
//  AXDBManager.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXDBManager.h"
#import "FMDB.h"
#import "AXPasswordModel.h"

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

- (void)insertManager:(AXPasswordModel *)model {
    BOOL result = [_db executeUpdate:kInsertString, model.siteName, model.userName, model.mobile, model.email, model.password];
    NSString *message = result ? @"insert success!" : @"insert failed!";
    NSLog(@"%@", message);
}

- (void)updateManager:(AXPasswordModel *)model {
    NSString *update_str = [NSString stringWithFormat:kUpdateString, model.itemID];
    BOOL result = [_db executeUpdate:update_str, model.siteName, model.userName, model.mobile, model.email, model.password];
    NSString *message = result ? @"update success!" : @"update failed!";
    NSLog(@"%@", message);
}

- (void)deleteManager:(AXPasswordModel *)model {
    NSString *delete_str = [NSString stringWithFormat:kDeleteString, model.itemID];
    BOOL result = [_db executeUpdate:delete_str];
    NSString *message = result ? @"delete success!" : @"delete failed!";
    NSLog(@"%@", message);
}

- (BOOL)deleteAll {
    return [_db executeUpdate:kDeleteAllString];
}

- (BOOL)seqSet0 {
//    BOOL result = [_db executeUpdate:kSeqEqual0];
//    NSString *message = result ? @"Seq set 0 success!" : @"Seq set 0 failed!";
//    NSLog(@"%@", message);
    return [_db executeUpdate:kSeqEqual0];
}

- (NSArray<AXPasswordModel *> *)queryAll {
    return [self arrayWithResultSet:[_db executeQuery:kQueryAllString]];
}

- (NSArray<AXPasswordModel *> *)queryWithSite:(NSString *)siteName {
    NSString *sql = [_db stringForQuery:kQueryString, siteName];
    NSLog(@"sql = %@", sql);          //  <---测试代码
    FMResultSet *rs = [_db executeQuery:sql];
    
    return [self arrayWithResultSet:rs];
}

- (NSArray<AXPasswordModel *> *)arrayWithResultSet:(FMResultSet *)rs {
    NSMutableArray<AXPasswordModel *> *tempArray = [NSMutableArray array];
    while ([rs next]) {
        AXPasswordModel *model = [[AXPasswordModel alloc] initWithSite:[rs stringForColumn:@"site_name"]
                                                                  user:[rs stringForColumn:@"user_name"]
                                                                mobile:[rs stringForColumn:@"mobile"]
                                                                 email:[rs stringForColumn:@"email"]
                                                              password:[rs stringForColumn:@"password"]
                                                                itemID:[rs stringForColumn:@"item_id"].integerValue];
        [tempArray addObject:model];
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
