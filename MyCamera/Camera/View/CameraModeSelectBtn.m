//
//  CameraModeSelectBtn.m
//  eCamera
//
//  Created by shiguang on 2018/1/25.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "CameraModeSelectBtn.h"
#import "UIView+ECategory.h"

@implementation CameraModeSelectBtn

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整文字
    self.titleLabel.x = self.width * 0.05;
    self.titleLabel.y = self.height * 0.0;
    self.titleLabel.width = self.width * 0.9;
    self.titleLabel.height = self.width * 0.7;
}

@end
