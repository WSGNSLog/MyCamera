//
//  CutPathView.m
//  MyCamera
//
//  Created by shiguang on 2018/7/31.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "CutPathView.h"

@implementation CutPathView

-(void)drawRect:(CGRect)rect{
    //[super drawRect:rect];
    [self.color setStroke];
    [self.path stroke];
}

@end
