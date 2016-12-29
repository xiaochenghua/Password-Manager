//
//  UIView+Controller.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/24.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "UIView+Controller.h"

@implementation UIView (Controller)

- (nullable UIViewController *)viewController {
    UIResponder *responder = nil;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end
