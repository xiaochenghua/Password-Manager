//
//  AXDBManager.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXPasswordManager;

@interface AXDBManager : NSObject

/**
 *  单例类方法创建对象实例
 *
 *  @return 实例
 */
+ (instancetype)sharedManager;

/**
 *  创建数据库、表
 */
- (void)create;

/**
 *  插入
 */
- (void)insertManager:(AXPasswordManager *)manager;

/**
 *  更新
 */
- (void)updateManager:(AXPasswordManager *)manager;

/**
 *  删除
 */
- (void)deleteManager:(AXPasswordManager *)manager;

/**
 *  删除所有数据
 */
- (BOOL)deleteAll;

/**
 *  序列号重置为0，只有数据为空时才可操作
 */
- (BOOL)seqSet0;

/**
 *  查询
 */
- (NSArray<AXPasswordManager *> *)queryAll;

- (NSArray<AXPasswordManager *> *)queryWithSite:(NSString *)siteName;

/**
 *  查询记录总数
 */
- (NSUInteger)queryTotalCount;

/**
 *  关闭数据库
 */
- (void)close;

@end
