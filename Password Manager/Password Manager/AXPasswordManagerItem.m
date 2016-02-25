//
//  AXPasswordManagerItem.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXPasswordManagerItem.h"

@implementation AXPasswordManagerItem

- (void)setPMItemWithSite:(NSString *)site user:(NSString *)user mobile:(NSString *)mobile email:(NSString *)email password:(NSString *)password {
    self.siteName = site;
    self.userName = user;
    self.mobile = mobile;
    self.email = email;
    self.password = password;
}

////  解档
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        self.itemID = [aDecoder decodeIntegerForKey:@"itemID"];
//        self.siteName = [aDecoder decodeObjectForKey:@"siteName"];
//        self.userName = [aDecoder decodeObjectForKey:@"userName"];
//        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
//        self.email = [aDecoder decodeObjectForKey:@"email"];
//        self.password = [aDecoder decodeObjectForKey:@"password"];
//    }
//    return self;
//}
//
////  归档
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeInteger:self.itemID forKey:@"itemID"];
//    [aCoder encodeObject:self.siteName forKey:@"siteName"];
//    [aCoder encodeObject:self.userName forKey:@"userName"];
//    [aCoder encodeObject:self.mobile forKey:@"mobile"];
//    [aCoder encodeObject:self.email forKey:@"email"];
//    [aCoder encodeObject:self.password forKey:@"password"];
//}

@end
