//
//  DrawView.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//
/*
 前面思路来自http://liuyanwei.jumppo.com/2015/07/26/ios-draw-Graffiti.html
 */

#import "DrawView.h"
#import "PaintStep.h"
#import "BezierStep.h"
#import <math.h>

@interface DrawView()
@property (nonatomic,strong) UIImageView *imageView;
@end
@implementation DrawView{
    
    //画的线路径的集合，内部是NSMutableArray类型
    NSMutableArray *paintSteps;
    //当前选中的颜色
    UIColor *currColor;
    //画的线路径的集合，内部是NSMutableArray类型
    NSMutableArray *bezierSteps;

}

-(instancetype)init{
    self = [super init];
    if (self) {
        //初始化uiview的样式
        [self paintViewInit];
    }
    return  self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化uiview的样式
//        [self paintViewInit];
    }
    return  self;
}
- (void)setPaintColor:(UIColor *)paintColor{
    currColor = paintColor;
}
//初始化paintViewInit样式和数据
-(void)paintViewInit{
    //添加背景色
    self.backgroundColor = [UIColor clearColor];
//    self.imageView =  [[UIImageView alloc]init];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.imageView.image = self.image;
//    self.imageView.backgroundColor = self.backgroundColor;
//    [self addSubview:self.imageView];
    //初始化路径集合
    paintSteps = [[NSMutableArray alloc]init];
    bezierSteps = [[NSMutableArray alloc]init];
    self.sliderValue = 1;
}
//- (void)layoutSubviews{
//    self.imageView.image = self.image;
//    self.imageView.frame = self.bounds;
//}

-(void)drawRect:(CGRect)rect{
    //必须调用父类drawRect方法，否则 UIGraphicsGetCurrentContext()获取不到context
    [super drawRect:rect];
    //获取ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //渲染所有路径
    for (int i=0; i<paintSteps.count; i++) {
        PaintStep *step = paintSteps[i];
        NSMutableArray *pathPoints = step->pathPoints;
        CGMutablePathRef path = CGPathCreateMutable();
        for (int j=0; j<pathPoints.count; j++) {
            CGPoint point = [[pathPoints objectAtIndex:j]CGPointValue] ;
            if (j==0) {
                CGPathMoveToPoint(path, &CGAffineTransformIdentity, point.x,point.y);
            }else{
                CGPathAddLineToPoint(path, &CGAffineTransformIdentity, point.x, point.y);
            }
        }
        //设置path 样式
        CGContextSetStrokeColorWithColor(ctx, step->color);
        CGContextSetLineWidth(ctx, step->strokeWidth);
        //路径添加到ct
        CGContextAddPath(ctx, path);
        //描边
        CGContextStrokePath(ctx);
    }
    
    //渲染bezier路径
    for (int i=0; i<bezierSteps.count; i++) {
        BezierStep *step = bezierSteps[i];
        //设置path 样式
        CGContextSetStrokeColorWithColor(ctx, step->color);
        CGContextSetLineWidth(ctx, step->strokeWidth);
//        UIColor *color = [UIColor colorWithCGColor:step->color];
//        [color set];
        CGPoint centerPoint = CGPointMake((step->startPoint.x+step->endPoint.x)/2, (step->startPoint.y+step->endPoint.y)/2);
        //hypot(double x,double y);已知直角三角形两个直角边长度，求斜边长度
        double a1 = centerPoint.x - step->startPoint.x;
        double a2 = centerPoint.y - step->startPoint.y;
        double radius = hypot(a1, a2);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
        path.lineWidth = step->strokeWidth;
        [path stroke];
        
        switch (step->status) {
            case BezierStepStatusSetControl:
                //画出起点到控制线的距离
            {
                //设置path 样式
                CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.233 green:0.480 blue:0.858 alpha:1.000].CGColor);
                //虚线线条样式
                CGFloat lengths[] = {10,10};
                CGContextSetLineDash(ctx, 1, lengths, 2);
                CGContextMoveToPoint(ctx, step->startPoint.x, step->startPoint.y);
                CGContextAddLineToPoint(ctx, step->controlPoint.x, step->controlPoint.y);
                CGContextAddLineToPoint(ctx, step->endPoint.x, step->endPoint.y);
                CGContextStrokePath(ctx);
            }
                break;
                
            default:
                break;
        }
        
        
    }
}

#pragma mark -手指移动
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    switch (self.drawViewMode) {
            //笔画模式
        case DrawViewModeStroke:
            [self strokeModeTouchesBegan:touches withEvent:event];
            break;
            //曲线模式
        case DrawViewModeBezier:
            [self bezierModeTouchesBegan:touches withEvent:event];
            break;
        default:
            break;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    switch (self.drawViewMode) {
            //笔画模式
        case DrawViewModeStroke:
            [self strokeModeTouchesMoved:touches withEvent:event];
            break;
            //曲线模式
        case DrawViewModeBezier:
            [self bezierModeTouchesMoved:touches withEvent:event];
            break;
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (self.drawViewMode) {
            //笔画模式
        case DrawViewModeStroke:
            [self strokeModeTouchesEnded:touches withEvent:event];
            break;
            //曲线模式
        case DrawViewModeBezier:
            [self bezierModeTouchesEnded:touches withEvent:event];
            break;
        default:
            break;
    }
    
}

-(void)strokeModeTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    PaintStep *paintStep = [[PaintStep alloc]init];
    paintStep->color = currColor.CGColor;
    paintStep->pathPoints =  [[NSMutableArray alloc]init];
    paintStep->strokeWidth = self.sliderValue;
    [paintSteps addObject:paintStep];
}

-(void)strokeModeTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //获取当前路径
    PaintStep *step = [paintSteps lastObject];
    NSMutableArray *pathPoints = step->pathPoints;
    //获取当前点
    CGPoint movePoint = [[touches anyObject]locationInView:self];
    //CGPint要通过NSValue封装一次才能放入NSArray
    [pathPoints addObject:[NSValue valueWithCGPoint:movePoint]];
    //通知重新渲染界面，这个方法会重新调用UIView的drawRect:(CGRect)rect方法
    [self setNeedsDisplay];
}

-(void)strokeModeTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}



-(void)bezierModeTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //创建贝塞尔 步骤
    BezierStep *step = [bezierSteps lastObject];
    CGPoint point =[[touches anyObject]locationInView:self];
    
    if (step) {
        switch (step->status) {
                
            case BezierStepStatusSetStart:
            case BezierStepStatusSetEnd:
            {
                step =  [[BezierStep alloc]init];
                step->color = currColor.CGColor;
                step->strokeWidth = self.sliderValue;
                step->startPoint  = point;
                step->status = BezierStepStatusSetControl;
                [bezierSteps addObject:step];
            }
                break;
                
            default:
                break;
        }
        
    }else{
        step =  [[BezierStep alloc]init];
        step->color = currColor.CGColor;
        step->strokeWidth = self.sliderValue;
        step->startPoint  = point;
        step->status = BezierStepStatusSetControl;
        [bezierSteps addObject:step];
    }
    
    
}

-(void)bezierModeTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    BezierStep *step = [bezierSteps lastObject];
    CGPoint point =[[touches anyObject]locationInView:self];
    step->status = BezierStepStatusSetControl;
    switch (step->status) {
            
        case BezierStepStatusSetStart:
        case BezierStepStatusSetControl:
        {
            step->controlPoint = point;
            step->endPoint = point;
        }
            
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
    
}

-(void)bezierModeTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    BezierStep *step = [bezierSteps lastObject];
    CGPoint point =[[touches anyObject]locationInView:self];
    switch (step->status) {
        case BezierStepStatusSetStart:
        case BezierStepStatusSetControl:
        {
            step->endPoint = point;
            step->status = BezierStepStatusSetEnd;
        }
            break;
            
        default:
            break;
    }
    [self setNeedsDisplay];
    
    
}


- (UIImage *)getImage{
    NSLog(@"getImage");
    CGImageRef imgRef = self.image.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //以大图大小为底图
    //以showImg的图大小为画布创建上下文
    //UIGraphicsBeginImageContext(CGSizeMake(w, h));
    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, 0);
    //先把大图 绘制到上下文中
    [self.image drawInRect:CGRectMake(0, 0, w, h)];
    //再把小图放到上下文中
    //[self.locationLabel drawInRect:CGRectMake(100, 100, 100, 50)];
    [self drawViewHierarchyInRect:CGRectMake(0,0, w, h) afterScreenUpdates:YES];

    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    //CGImageRelease(imgRef);//imageView.image不需要释放
    
    return resultImg;
}
- (void)deleteLastDrawing{
    [bezierSteps removeLastObject];
    [self setNeedsDisplay];
}

@end
