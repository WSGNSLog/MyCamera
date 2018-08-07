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

typedef enum {
    DrawModeCircle = 0,
    DrawModeSquare = 1,
    DrawModeLine = 2,
    DrawModeTriangle = 3,
    DrawModeFree = 4
}DrawMode;

@interface DrawView : UIView

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIColor *paintColor;
//当前绘图模式
@property (nonatomic,assign) DrawMode drawMode;
@property (nonatomic,assign) CGFloat sliderValue;
- (UIImage *)getImage;
- (void)deleteLastDrawing;

@end
