//
//  AXPasswordCell.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/24.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXPasswordCell.h"
#import "UIView+Controller.h"

@interface AXPasswordCell ()
@property (nonatomic, strong) UIButton *statusButton;
@end

@implementation AXPasswordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    
    [super setUpSubviews];
    
    [self.contentView addSubview:self.statusButton];
    
    [_statusButton autoSetDimensionsToSize:CGSizeMake(19.0f, 19.0f)];
    [_statusButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [_statusButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    
    
}

- (UIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [[UIButton alloc] init];
        [_statusButton setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [_statusButton addTarget:self.viewController action:@selector(exchangeStatus:) forControlEvents:UIControlEventTouchUpInside];
#pragma clang diagnostic pop
    }
    return _statusButton;
}

@end
