//
//  NSString+Handler.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Handler)

/**
 *  编码
 *
 *  @return 已编码的字符串
 */
- (NSString *)encrypt;

/**
 *  解码
 *
 *  @return 已解码的字符串
 */
- (NSString *)decrypt;

/**
 *  隐藏字符串中特定位置的子字符串
 *
 *  @return 隐藏后的字符串
 */
- (NSString *)hideSubString;

/**
 *  验证字符串是否合法
 *  @param regex  正则表达式
 *
 *  @return 合法则返回YES，否则返回NO
 */
- (BOOL)isLegitimateWithRegex:(NSString *)regex;

/**
 *  去除字符串两端的空格
 *
 *  @return 处理后的字符串
 */
- (NSString *)trimmingSpaceCharacter;

@end
