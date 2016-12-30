//
//  AXModifyController.h
//  Password Manager
//
//  Created by arnoldxiao on 16/3/1.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXBaseController.h"

@class AXPasswordModel;

@interface AXModifyController : AXBaseController

- (instancetype)initWithPasswordModel:(AXPasswordModel *)model;

@end
