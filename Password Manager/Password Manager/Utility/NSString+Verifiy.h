//
//  NSString+Verifiy.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/22.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verifiy)

/**
 *  验证字符串是否合法
 *
 *  @param string 待验证的字符串
 *  @param regex  正则表达式
 *
 *  @return 合法则返回YES，否则返回NO
 */
+ (BOOL)isLegitimate:(NSString *)string regex:(NSString *)regex;

@end
