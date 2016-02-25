//
//  AXDBManager.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/18.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXPasswordManagerItem;

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
- (void)insertWithItem:(AXPasswordManagerItem *)item;

/**
 *  更新
 */
- (void)updateWithItem:(AXPasswordManagerItem *)item column:(NSString *)column value:(NSString *)value;

/**
 *  删除
 */
- (void)deleteWithItem:(AXPasswordManagerItem *)item;

/**
 *  查询
 */
- (NSArray<AXPasswordManagerItem *> *)queryAll;

- (NSArray<AXPasswordManagerItem *> *)queryWithSite:(NSString *)siteName;

/**
 *  查询记录总数
 */
- (NSUInteger)queryTotalCount;

/**
 *  关闭数据库
 */
- (void)close;

@end
