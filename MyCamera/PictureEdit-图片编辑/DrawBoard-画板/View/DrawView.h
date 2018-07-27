//
//  DrawView.h
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DrawViewModeStroke,
    DrawViewModeBezier
} DrawViewMode;

@interface DrawView : UIView

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIColor *paintColor;
//当前绘图模式
@property (nonatomic,assign) DrawViewMode drawViewMode;
@property (nonatomic,assign) CGFloat sliderValue;
- (UIImage *)getImage;
- (void)deleteLastDrawing;

@end
