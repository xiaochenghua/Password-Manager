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

@end
