//
//  QBVideoIndicatorView.m
//  MyCamera
//
//  Created by shiguang on 2018/3/12.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "QBVideoIndicatorView.h"

@implementation QBVideoIndicatorView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Add gradient layer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[
                             (__bridge id)[[UIColor clearColor] CGColor],
                             (__bridge id)[[UIColor blackColor] CGColor]
                             ];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end
