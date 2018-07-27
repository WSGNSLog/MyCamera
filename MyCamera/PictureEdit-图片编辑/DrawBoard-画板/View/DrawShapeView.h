//
//  DrawShapeView.h
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LineShapeCircle = 0,
    LineShapeSquare = 1,
    LineShapeLine = 2,
    LineShapeTriangle = 3,
    LineShapeFree = 4
}LineShape;

@interface DrawShapeView : UIView

@property (nonatomic,copy) void(^ShapeChangeBlock)(LineShape shape);
@property (nonatomic,assign) LineShape shape;

- (instancetype)initWithFrame:(CGRect)frame DefaultShape:(LineShape)shape;
@end
