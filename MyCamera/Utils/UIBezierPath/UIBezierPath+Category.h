//
//  UIBezierPath+Category.h
//  MyCamera
//
//  Created by shiguang on 2018/7/31.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Category)
//绘制珠宝形路径
+(UIBezierPath *)jewelryPathWithInRect:(CGRect)rect;
//绘制三角形路径
+(UIBezierPath *)trianglePathWithInRect:(CGRect)rect;
//绘制五角星路径
+(UIBezierPath *)fivePointStarPathWithInRect:(CGRect)rect;
//绘制椭圆锯齿形路径
+(UIBezierPath*)sawtoothPathWithInRect:(CGRect)rect;
//绘制心形路径
+(UIBezierPath *)heartPathWithInRect:(CGRect)rect;
@end
