//
//  AXPasswordModel.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXPasswordModel.h"

@interface AXPasswordModel ()

@property (nonatomic, assign) NSInteger itemID;
@property (nonatomic, copy  ) NSString  *siteName;
@property (nonatomic, copy  ) NSString  *userName;
@property (nonatomic, copy  ) NSString  *mobile;
@property (nonatomic, copy  ) NSString  *email;
@property (nonatomic, copy  ) NSString  *password;

@end

@implementation AXPasswordModel

- (instancetype)initWithSite:(NSString *)site
                        user:(NSString *)user
                      mobile:(NSString *)mobile
                       email:(NSString *)email
                    password:(NSString *)password {
    if (self = [super init]) {
        _siteName = site;
        _userName = user;
        _mobile = mobile;
        _email = email;
        _password = password;
    }
    return self;
}

- (instancetype)initWithSite:(NSString *)site
                        user:(NSString *)user
                      mobile:(NSString *)mobile
                       email:(NSString *)email
                    password:(NSString *)password
                      itemID:(NSInteger)itemID {
    if (self = [self initWithSite:site
                             user:user
                           mobile:mobile
                            email:email
                         password:password]) {
        _itemID = itemID;
    }
    return self;
}

@end
