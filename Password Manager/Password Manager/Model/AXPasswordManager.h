//
//  AXPasswordManager.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/17.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXPasswordManager : NSObject

@property (nonatomic, assign) NSInteger itemID;
@property (nonatomic, copy  ) NSString  *siteName;
@property (nonatomic, copy  ) NSString  *userName;
@property (nonatomic, copy  ) NSString  *mobile;
@property (nonatomic, copy  ) NSString  *email;
@property (nonatomic, copy  ) NSString  *password;

- (void)setPasswordManagerWithSite:(NSString *)site user:(NSString *)user mobile:(NSString *)mobile email:(NSString *)email password:(NSString *)password;

@end
