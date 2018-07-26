//
//  DrawView.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//
/*
 // 圆弧
 // Center：圆心
 // startAngle:弧度
 // clockwise:YES:顺时针 NO：逆时针
 
 // 扇形
 CGPoint center = CGPointMake(125, 125);
 UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:100 startAngle:0 endAngle:M_PI_2 clockwise:YES];
 
 // 添加一根线到圆心
 [path addLineToPoint:center];
 
 // 封闭路径，关闭路径：从路径的终点到起点
 //    [path closePath];
 
 
 //    [path stroke];
 
 // 填充：必须是一个完整的封闭路径,默认就会自动关闭路径
 [path fill];
 */

#import "DrawView.h"
#import "PaintStep.h"
#import "BezierStep.h"


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
//    WEAKSELF
//    self.imageView =  [[UIImageView alloc]init];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.imageView.image = self.image;
//    [self addSubview:self.imageView];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(weakSelf);
//    }];
    //初始化路径集合
    paintSteps = [[NSMutableArray alloc]init];
    bezierSteps = [[NSMutableArray alloc]init];
    
}


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
        //路径参考线
        CGContextMoveToPoint(ctx, step->startPoint.x, step->startPoint.y);
        CGContextAddQuadCurveToPoint(ctx, step->controlPoint.x, step->controlPoint.y, step->endPoint.x, step->endPoint.y);
        //描边
        CGContextStrokePath(ctx);
        
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
    
    switch (self.paintViewMode) {
            //笔画模式
        case PaintViewModeStroke:
            [self strokeModeTouchesBegan:touches withEvent:event];
            break;
            //曲线模式
        case PaintViewModeBezier:
            [self bezierModeTouchesBegan:touches withEvent:event];
            break;
        default:
            break;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    switch (self.paintViewMode) {
            //笔画模式
        case PaintViewModeStroke:
            [self strokeModeTouchesMoved:touches withEvent:event];
            break;
            //曲线模式
        case PaintViewModeBezier:
            [self bezierModeTouchesMoved:touches withEvent:event];
            break;
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (self.paintViewMode) {
            //笔画模式
        case PaintViewModeStroke:
            [self strokeModeTouchesEnded:touches withEvent:event];
            break;
            //曲线模式
        case PaintViewModeBezier:
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
    NSLog(@"touchesMoved     x:%f,y:%f",movePoint.x,movePoint.y);
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
            {
                step->endPoint = point;
                step->status = BezierStepStatusSetControl;
            }
                break;
            case BezierStepStatusSetEnd:
            {
                step =  [[BezierStep alloc]init];
                step->color = currColor.CGColor;
                step->strokeWidth = self.sliderValue;
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
        [bezierSteps addObject:step];
    }
    
    
}

-(void)bezierModeTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    BezierStep *step = [bezierSteps lastObject];
    CGPoint point =[[touches anyObject]locationInView:self];
    switch (step->status) {
            
        case BezierStepStatusSetControl:
        {
            step->controlPoint = point;
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
        {
            step->startPoint = point;
            //            step->status = BezierStepStatusSetControl;
        }
            break;
        case BezierStepStatusSetControl:
        {
            step->controlPoint = point;
            step->status = BezierStepStatusSetEnd;
        }
            break;
            
        default:
            break;
    }
    
    
    
}


- (UIImage *)getImage{
    return self.imageView.image;
}
- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
}

@end
