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
        //[self paintViewInit];
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
- (NSArray *)calRectPoint11:(BezierStep *)step{
    
    CGPoint point1 = CGPointZero;
    CGPoint point2 = CGPointZero;
    if (step->startPoint.x <=step->endPoint.x && step->startPoint.y <= step->endPoint.y) {
        point1 = CGPointMake(step->startPoint.x, step->endPoint.y);
        point2 = CGPointMake(step->endPoint.x, step->startPoint.y);
        
    }else if (step->startPoint.x < step->endPoint.x  && step->startPoint.y > step->endPoint.y ){//right-up
        point1 = CGPointMake(step->endPoint.x, step->startPoint.y);
        point2 = CGPointMake(step->startPoint.x, step->endPoint.y);
    }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y > step->endPoint.y ){//left-up
        point1 = CGPointMake(step->startPoint.x, step->endPoint.y);
        point2 = CGPointMake(step->endPoint.x, step->startPoint.y);
    }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y < step->endPoint.y ){//left-down
        point1 = CGPointMake(step->startPoint.x, step->endPoint.y);
        point2 = CGPointMake(step->endPoint.x, step->startPoint.y);
    }
    return @[[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2]];
}
- (CGRect)calRect:(BezierStep *)step{
    
    CGRect rect = CGRectZero;
    double w = roundf(fabs(step->endPoint.x - step->startPoint.x));
    double h = roundf(fabs(step->endPoint.y - step->startPoint.y));
    if (step->startPoint.x <=step->endPoint.x && step->startPoint.y <= step->endPoint.y) {
        rect = CGRectMake(roundf(step->startPoint.x), roundf(step->startPoint.y), w, h);
    }else if (step->startPoint.x < step->endPoint.x  && step->startPoint.y > step->endPoint.y ){
        rect = CGRectMake(roundf(step->startPoint.x), roundf(step->endPoint.y), w, h);
    }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y > step->endPoint.y ){
        rect = CGRectMake(roundf(step->endPoint.x), roundf(step->endPoint.y), w, h);
    }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y < step->endPoint.y ){
        rect = CGRectMake(roundf(step->endPoint.x), roundf(step->startPoint.y), w, h);
    }
    return rect;
}
-(CGPoint)calPoint1:(BezierStep *)step{
    CGFloat newX = 0;
    CGFloat newY = 0;
    
    CGFloat length = hypot(step->endPoint.x-step->startPoint.x, step->endPoint.y-step->startPoint.y);
    
    double angle = atan((step->endPoint.y - step->startPoint.y) / (step->endPoint.x - step->startPoint.x));
    if (angle == 0) {
        NSLog(@"error");
    }
    if (!isnan(angle)) {//right-down
        if (step->startPoint.x <=step->endPoint.x && step->startPoint.y <= step->endPoint.y) {
            newX = cos(angle + M_PI / 3 ) * length + step->startPoint.x;
            newY = sin(angle + M_PI / 3 ) * length + step->startPoint.y;
            NSLog(@"1111");
        }
        else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y > step->endPoint.y ){//left-up
            NSLog(@"2222");
            newX = step->startPoint.x - cos(angle + M_PI / 3 ) * length;
            newY = step->startPoint.y - sin(angle + M_PI / 3 ) * length;
        }else if (step->startPoint.x < step->endPoint.x  && step->startPoint.y > step->endPoint.y ){//right-up
            NSLog(@"3333");
            newX = cos(angle + M_PI / 3 ) * length + step->startPoint.x;
            newY = step->startPoint.y - sin(angle + M_PI / 3 ) * length ;
        }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y < step->endPoint.y ){//left-down
            NSLog(@"4444");
            newX = step->startPoint.x - cos(angle + M_PI / 3 ) * length;
            newY = sin(angle + M_PI / 3 ) * length + step->startPoint.y;
        }
    }
    return CGPointMake(newX, newY);
}
- (CGPoint)calPoint1_OriginMethod:(BezierStep *)step{
    CGFloat newX1 = 0;
    CGFloat newY1 = 0;
    CGFloat newX2 = 0;
    CGFloat newY2 = 0;
    
    CGFloat length = hypot(step->endPoint.x-step->startPoint.x, step->endPoint.y-step->startPoint.y);
    
    double angle = atan((step->endPoint.y - step->startPoint.y) / (step->endPoint.x - step->startPoint.x));
    if (!isnan(angle)) {
        newX2 = cos(angle - M_PI / 3) * length + step->endPoint.x;
        newY2 = sin(angle - M_PI / 3) * length + step->endPoint.y;
        newX1 = cos(M_PI - angle - M_PI / 3 - M_PI_2) * length + step->endPoint.x;
        newY1 = sin(M_PI - angle - M_PI / 3 - M_PI_2) * length + step->endPoint.y;
    }
    double length1 = hypot((step->endPoint.x - newX2) ,(step->endPoint.y - newY2));
    double length2 = hypot((step->endPoint.x - newX1) ,(step->endPoint.y - newY1));
    NSLog(@"=====%f, %f,%f",length,length1,length2);
    return CGPointMake(newX1, newY1);
}
#pragma mark - 尖始终向上
- (CGPoint)calPoint2:(BezierStep *)step{
    
    double length = hypot(step->endPoint.x-step->startPoint.x, step->endPoint.y-step->startPoint.y);
    double x1 =step->startPoint.x + length*cos(M_PI/3.0);
    //double y1 = step->startPoint.y - sqrt(pow(length, 2) - pow(length/2, 2));
    double y1 = step->startPoint.y - length*sin(M_PI/3.0);
    return CGPointMake(x1,  y1);
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
        //        UIColor *color = [UIColor colorWithCGColor:step->color];
        //        [color set];
        if (step.paintMode == PaintModeCircle) {
            CGPoint centerPoint = CGPointMake((step->startPoint.x+step->endPoint.x)/2, (step->startPoint.y+step->endPoint.y)/2);
            //hypot(double x,double y);已知直角三角形两个直角边长度，求斜边长度
            double a1 = centerPoint.x - step->startPoint.x;
            double a2 = centerPoint.y - step->startPoint.y;
            double radius = hypot(a1, a2);
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
            path.lineWidth = step->strokeWidth;
            if (step.paintLineType == PaintLineType1) {
                CGFloat dashLineConfig[] = {4.0,2.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }else if (step.paintLineType == PaintLineType2){
                CGFloat dashLineConfig[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
                [path setLineDash:dashLineConfig count:6 phase:0];
            }else if (step.paintLineType == PaintLineType3){
                CGFloat dashLineConfig[] = {1.0,1.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }
            [path stroke];
        }
        if (step.paintMode == PaintModeTriangle) {
            double ab = hypot(step->endPoint.x-step->startPoint.x, step->endPoint.y-step->startPoint.y);
            
            /*
            CGFloat am = step->endPoint.y-step->startPoint.y;
            CGFloat bm = step->endPoint.x-step->startPoint.x;

            double asinA = asin(bm/ab);
            //atan(bm/am)
            if (isnan(asinA)) {
                NSLog(@"error");
                NSLog(@"atan:%f,%f",atan(bm/am),atan(am/bm));
            }
            double asina = (asinA - M_PI/3.0);
            if (asina<=0) {
                NSLog(@"-----");
            }
            CGFloat an = ab * sin(asina);
            CGFloat cn =  ab * cos(asina);
            CGPoint c = CGPointMake(step->startPoint.x+cn, step->startPoint.y-an);
            */
            /*
            CGPoint c = [self calPoint2:step];
            CGPoint b = CGPointMake(step->startPoint.x+ab, step->startPoint.y);
            UIBezierPath *path = [UIBezierPath bezierPath];
            path.lineWidth = step->strokeWidth;
            [path moveToPoint:step->startPoint];
            [path addLineToPoint:b];
            [path moveToPoint:b];
            [path addLineToPoint:c];
            [path moveToPoint:c];
            [path addLineToPoint:step->startPoint];
            [path closePath];
            [path stroke];
            
            */
            
            CGPoint c = [self calPoint1:step];;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            path.lineWidth = step->strokeWidth;
            if (step.paintLineType == PaintLineType1) {
                CGFloat dashLineConfig[] = {4.0,2.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }else if (step.paintLineType == PaintLineType2){
                CGFloat dashLineConfig[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
                [path setLineDash:dashLineConfig count:6 phase:0];
            }else if (step.paintLineType == PaintLineType3){
                CGFloat dashLineConfig[] = {1.0,1.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }
            [path moveToPoint:step->startPoint];
            [path addLineToPoint:step->endPoint];
            [path moveToPoint:step->endPoint];
            [path addLineToPoint:c];
            [path moveToPoint:c];
            [path addLineToPoint:step->startPoint];
            [path closePath];///[path closePath]
            [path stroke];
        }
        if (step.paintMode == PaintModeSquare) {
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:[self calRect:step]];
            if (step.paintLineType == PaintLineType1) {
                CGFloat dashLineConfig[] = {4.0,2.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }else if (step.paintLineType == PaintLineType2){
                CGFloat dashLineConfig[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
                [path setLineDash:dashLineConfig count:6 phase:0];
            }else if (step.paintLineType == PaintLineType3){
                CGFloat dashLineConfig[] = {1.0,1.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }
            path.lineWidth = step->strokeWidth;
            [path stroke];
            
        }
        
        if (step.paintMode == PaintModeLine) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            if (step.paintLineType == PaintLineType1) {
                CGFloat dashLineConfig[] = {4.0,2.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }else if (step.paintLineType == PaintLineType2){
                CGFloat dashLineConfig[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
                [path setLineDash:dashLineConfig count:6 phase:0];
            }else if (step.paintLineType == PaintLineType3){
                CGFloat dashLineConfig[] = {1.0,1.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }
            path.lineWidth = step->strokeWidth;
            [path moveToPoint:step->startPoint];
            [path addLineToPoint:step->endPoint];
            
            [path stroke];
        }
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
    
    switch (self.drawMode) {
            //笔画模式
        case DrawModeFree:
            [self strokeModeTouchesBegan:touches withEvent:event];
            break;
            //曲线模式
        case DrawModeCircle:
        case DrawModeTriangle:
        case DrawModeLine:
        case DrawModeSquare:
            [self bezierModeTouchesBegan:touches withEvent:event];
            break;
        default:
            break;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    switch (self.drawMode) {
            //笔画模式
        case DrawModeFree:
            [self strokeModeTouchesMoved:touches withEvent:event];
            break;
            //曲线模式
        case DrawModeCircle:
        case DrawModeTriangle:
        case DrawModeLine:
        case DrawModeSquare:
            [self bezierModeTouchesMoved:touches withEvent:event];
            break;
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (self.drawMode) {
            //笔画模式
        case DrawModeFree:
            [self strokeModeTouchesEnded:touches withEvent:event];
            break;
            //曲线模式
        case DrawModeCircle:
        case DrawModeTriangle:
        case DrawModeLine:
        case DrawModeSquare:
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
                step.paintMode = (int)self.drawMode;
                step.paintLineType = (int)self.drawLineType;
                if (!currColor || !currColor.CGColor) {
                    NSLog(@"error");
                }
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
        step.paintMode = (int)self.drawMode;
        step.paintLineType = (int)self.drawLineType;
        if (!currColor || !currColor.CGColor) {
            NSLog(@"error");
        }
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
            
             if (point.x == step->startPoint.x && point.y==step->endPoint.y) {
                [bezierSteps removeLastObject];
             }
        }
            break;
            
        default:
            break;
    }
    [self setNeedsDisplay];
    
    
}


- (UIImage *)getImage{
    NSLog(@"getImage");
//    CGImageRef imgRef = self.image.CGImage;
//    CGFloat w = CGImageGetWidth(imgRef);
//    CGFloat h = CGImageGetHeight(imgRef);
    
    CGFloat w = self.image.size.width;
    CGFloat h = self.image.size.height;
    //以大图大小为底图
    //以showImg的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    //UIGraphicsBeginImageContextWithOptions(self.image.size, NO, 0);
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
    if (bezierSteps.count >0) {
        [bezierSteps removeLastObject];
        [self setNeedsDisplay];
    }
    
}

@end
