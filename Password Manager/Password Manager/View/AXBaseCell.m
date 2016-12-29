//
//  AXBaseCell.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/23.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXBaseCell.h"
#import "UIView+Controller.h"
#import "NSString+Handler.h"

@interface AXBaseCell ()

@property (nonatomic, strong) UIButton *statusButton;
@property (nonatomic, strong) NSLayoutConstraint *constraint;

@end

@implementation AXBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    [self.contentView addSubview:self.titleLabel];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_titleLabel autoSetDimensionsToSize:CGSizeMake(kScreenWidth / 4, 44.0f)];
    
    [self.contentView addSubview:self.separatorView];
    [_separatorView autoSetDimensionsToSize:CGSizeMake(0.5, 20.0f)];
    [_separatorView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_separatorView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_titleLabel withOffset:10.0f];
    
    [self.contentView addSubview:self.textField];
    [_textField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_separatorView withOffset:10.0f];
    self.constraint = [_textField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_textField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_textField autoSetDimension:ALDimensionHeight toSize:44.0f];
}

- (void)addPasswordStatusButton {
    [self setUpStatusButton];
}

- (void)setUpStatusButton {
    [self.contentView addSubview:self.statusButton];
    [_statusButton autoSetDimensionsToSize:CGSizeMake(19.0f, 19.0f)];
    [_statusButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [_statusButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    self.constraint.constant = -19.0f - 15.0f - 10;
    [self.contentView setNeedsUpdateConstraints];
}

#pragma mark - Events
- (void)statusButtonClick:(UIButton *)button {
    if (self.textField.secureTextEntry) {
        self.textField.secureTextEntry = NO;
        [button setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
        
        if (self.textField.text == nil || [self.textField.text trimmingSpaceCharacter].length == 0) {
            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.textField.secureTextEntry) {
                self.textField.secureTextEntry = YES;
                [button setImage:[UIImage imageNamed:@"hide_pwd"] forState:UIControlStateNormal];
            }
        });
        
    } else {
        self.textField.secureTextEntry = YES;
        [button setImage:[UIImage imageNamed:@"hide_pwd"] forState:UIControlStateNormal];
    }
}

//- (void)setButtonImage:(UIButton *)button isSecureText:(BOOL)isSecureText {
//    NSString *imageName = nil;
//    if (isSecureText) {
//        imageName = @"hide_pwd";
//    } else {
//        imageName = @"show_pwd";
//    }
//    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}

#pragma mark - Lazy Loading
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = [UIColor lightGrayColor];
    }
    return _separatorView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return _textField;
}

- (UIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton setImage:[UIImage imageNamed:@"hide_pwd"]
                       forState:UIControlStateNormal];
        [_statusButton addTarget:self
                          action:@selector(statusButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusButton;
}

- (NSLayoutConstraint *)constraint {
    if (!_constraint) {
        _constraint = [[NSLayoutConstraint alloc] init];
    }
    return _constraint;
}

@end
