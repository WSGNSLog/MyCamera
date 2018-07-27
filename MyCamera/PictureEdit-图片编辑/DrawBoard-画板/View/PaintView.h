//
//  PaintView.h
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PaintViewModeStroke,
    PaintViewModeBezier
} PaintViewMode;

@interface PaintView : UIView
//当前绘图模式
@property(nonatomic,assign) PaintViewMode paintViewMode;
@property (nonatomic,strong) UIColor *paintColor;
@property (nonatomic,assign) CGFloat sliderValue;

@end
