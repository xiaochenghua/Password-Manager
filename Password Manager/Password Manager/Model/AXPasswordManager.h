//
//  AXPasswordManager.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXPasswordManager : NSObject

@property (nonatomic, assign, readonly) NSInteger itemID;
@property (nonatomic, copy, readonly  ) NSString  *siteName;
@property (nonatomic, copy, readonly  ) NSString  *userName;
@property (nonatomic, copy, readonly  ) NSString  *mobile;
@property (nonatomic, copy, readonly  ) NSString  *email;
@property (nonatomic, copy, readonly  ) NSString  *password;

- (instancetype)initWithSite:(NSString *)site
                        user:(NSString *)user
                      mobile:(NSString *)mobile
                       email:(NSString *)email
                    password:(NSString *)password;

- (instancetype)initWithSite:(NSString *)site
                        user:(NSString *)user
                      mobile:(NSString *)mobile
                       email:(NSString *)email
                    password:(NSString *)password
                      itemID:(NSInteger)itemID;

@end
