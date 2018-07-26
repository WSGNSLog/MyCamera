//
//  PaintStep.h
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PaintStep : NSObject{
    
@public
    //路径
    NSMutableArray *pathPoints;
    //颜色
    CGColorRef color;
    //笔画粗细
    float strokeWidth;
}

@end
