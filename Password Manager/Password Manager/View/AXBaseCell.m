//
//  AXBaseCell.m
//  Password Manager
//
//  Created by arnoldxiao on 16/2/23.
//  Copyright © 2016年 arnoldxiao. All rights reserved.
//

#import "AXBaseCell.h"

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
    [_textField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_textField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_textField autoSetDimension:ALDimensionHeight toSize:44.0f];
}

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

@end
