//
//  NSString+Verifiy.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/22.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "NSString+Verifiy.h"

@implementation NSString (Verifiy)

+ (BOOL)isLegitimate:(NSString *)string regex:(NSString *)regex {
    
    if (string == nil || string.length == 0) {
        return NO;
    }
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regularExpression matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    return results.count > 0 ? YES : NO;
}

@end
