//
//  EasyCamerPercentCycle.m
//  BabyDaily
//
//  Created by Alice on 2017/8/15.
//  Copyright © 2017年 Andon Health Co,.Ltd;. All rights reserved.
//

#import "EasyCamerPercentCycle.h"

@implementation EasyCamerPercentCycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);  //设置圆心位置
    CGFloat radius = self.frame.size.width/2-2;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 4); //设置线条宽度
    [[UIColor colorWithHexString:@"2EB9C3"] setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
    
}


- (void)setProgress:(CGFloat )progress
{
    _progress = progress;
    [self setNeedsDisplay];
}


@end
