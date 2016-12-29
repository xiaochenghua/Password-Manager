//
//  UIView+Controller.h
//  Password Manager
//
//  Created by arnoldxiao on 16/2/24.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Controller)

/**
 *  获取view所在的UIViewController，如果没有，则返回nil
 */
- (nullable UIViewController *)viewController;

@end
