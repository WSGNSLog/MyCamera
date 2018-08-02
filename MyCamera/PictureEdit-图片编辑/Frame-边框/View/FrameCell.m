//
//  FrameCell.m
//  MyCamera
//
//  Created by shiguang on 2018/7/30.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "FrameCell.h"

@implementation FrameCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if (!_imageView) {
            self.imageView = [[UIImageView alloc]init];
            self.imageView.frame = self.bounds;
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:self.imageView];
        }
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    }
    
    return self;
}

@end
