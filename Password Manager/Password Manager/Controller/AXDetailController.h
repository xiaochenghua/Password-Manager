//
//  AXDetailController.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/23.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXBaseController.h"

@class AXPasswordManagerItem;

@interface AXDetailController : AXBaseController

- (instancetype)initWithPasswordManagerItem:(AXPasswordManagerItem *)pmItem;

@end
