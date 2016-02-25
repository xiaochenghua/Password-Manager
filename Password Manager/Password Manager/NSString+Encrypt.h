//
//  NSString+Encrypt.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

/**
 *  编码
 *
 *  @param string 需要编码的字符串
 *
 *  @return 已编码的字符串
 */
+ (NSString *)encrypt:(NSString *)string;

/**
 *  解码
 *
 *  @param string 需要解码的字符串
 *
 *  @return 已解码的字符串
 */
+ (NSString *)decrypt:(NSString *)string;

/**
 *  隐藏字符串中特定位置的子字符串
 *
 *  @param string 字符串
 *
 *  @return 隐藏后的字符串
 */
+ (NSString *)hideSubStringFromString:(NSString *)string;

/**
 *  去除字符串两端的空格
 *
 *  @return 处理后的字符串
 */
- (NSString *)trimmingSpaceCharacter;

@end
