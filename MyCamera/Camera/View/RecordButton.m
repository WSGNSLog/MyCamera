//
//  RecordButton.m
//  MyCamera
//
//  Created by shiguang on 2018/1/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "RecordButton.h"

@implementation RecordButton

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
    
    // 调整图片
    self.imageView.x = self.width * 0.25;
    self.imageView.y = self.height * 0.25;
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.width * 0.5;
}



@end
