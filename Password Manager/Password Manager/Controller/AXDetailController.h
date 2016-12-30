//
//  AXDetailController.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/23.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXBaseController.h"

@class AXPasswordModel;

@interface AXDetailController : AXBaseController

- (instancetype)initWithPasswordModel:(AXPasswordModel *)model;

@end
