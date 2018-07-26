//
//  DrawView.h
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

@interface DrawView : UIView

@property (nonatomic,strong,getter=getImage) UIImage *image;
@property (nonatomic,strong) UIColor *paintColor;
//当前绘图模式
@property (nonatomic,assign) PaintViewMode paintViewMode;
@property (nonatomic,assign) CGFloat sliderValue;

@end
