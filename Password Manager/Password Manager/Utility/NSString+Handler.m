//
//  NSString+Handler.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "NSString+Handler.h"

//  salt
static NSString *salt = @"q4ZUYTwEL2TMwTFLIVJu";

@implementation NSString (Handler)

+ (NSString *)encrypt:(NSString *)string {
    //  @"Password"转换为NSData，再进行Base64编码，转换为可变模式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *temp = [[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] mutableCopy];
    
    //  如果末尾有字符串@"="，去掉@"="
    NSString *sign = @"=";
    while ([temp hasSuffix:sign]) {
        temp = [[temp substringWithRange:NSMakeRange(0, temp.length - sign.length)] mutableCopy];
    }
    
    //  加盐运算
    return [temp stringByAppendingString:salt];
}

+ (NSString *)decrypt:(NSString *)string {
    //  去除salt
    NSRange range = [string rangeOfString:salt];
    NSString *temp = [string substringToIndex:range.location];
    
    //  加上@"="
    NSString *sign;
    switch (temp.length % 4) {
        case 1:
            sign = @"===";
            break;
        
        case 2:
            sign = @"==";
            break;
            
        case 3:
            sign = @"=";
            break;
    }
    
    if (sign) {
        temp = [temp stringByAppendingString:sign];
    }
    //  先转换成NSData，再转换成已解码的字符串
    NSData *data = [[NSData alloc] initWithBase64EncodedString:temp options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return str;
}

+ (NSString *)hideSubStringFromString:(NSString *)string {
    NSMutableString *tempString = [string mutableCopy];
    //  保留头部1个字符和尾部2个字符明文显示
    NSUInteger length = tempString.length - 1 - 2;
    [tempString replaceCharactersInRange:NSMakeRange(1, length) withString:@"●●●●●"];
    return tempString;
}

+ (BOOL)isLegitimate:(NSString *)string regex:(NSString *)regex {
    
    if (string == nil || string.length == 0) {
        return NO;
    }
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regularExpression matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    return results.count > 0 ? YES : NO;
}

- (NSString *)trimmingSpaceCharacter {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
