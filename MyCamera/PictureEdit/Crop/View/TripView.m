//
//  TripView.m
//  BabyDaily
//
//  Created by 刘秀红 on 2017/12/18.
//  Copyright © 2017年 Andon Health Co,.Ltd. All rights reserved.
//

#import "TripView.h"

@interface TripView()
@property(nonatomic,retain)UIImageView * topBar;
@property(nonatomic,retain)UIView * leftBar;
@property(nonatomic,retain)UIView * rightBar;
@property(nonatomic,retain)UIView * bottomBar;
@property(nonatomic,retain)UIView * topLeftBar;
@property(nonatomic,retain)UIView * topRightBar;
@property(nonatomic,retain)UIView * bottomLeftBar;
@property(nonatomic,retain)UIView * bottomRightBar;

@property(nonatomic,retain)CALayer * tripLayer;

@end

@implementation TripView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //中上
        self.topBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trip_h_bar"]];
        self.topBar.contentMode = UIViewContentModeTop;
        self.topBar.frame = CGRectMake((frame.size.width-40)/2 , 0, 40, 19);
        self.topBar.userInteractionEnabled = YES;
        UIPanGestureRecognizer * barPan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(barPanGesture:)];
        [self.topBar addGestureRecognizer:barPan1];
        [self addSubview:self.topBar];
        //中下
        self.bottomBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trip_h_bar"]];
        self.bottomBar.contentMode = UIViewContentModeBottom;
        self.bottomBar.frame = CGRectMake((frame.size.width-40)/2 , frame.size.height -19, 40, 19);
        self.bottomBar.userInteractionEnabled = YES;
        UIPanGestureRecognizer * barPan2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(barPanGesture:)];
        [self.bottomBar addGestureRecognizer:barPan2];
        [self addSubview:self.bottomBar];
        //左中
        self.leftBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trip_v_bar"]];
        self.leftBar.frame = CGRectMake(0 , (frame.size.height - 40)/2, 19, 40);
        self.leftBar.contentMode = UIViewContentModeLeft;
        self.leftBar.userInteractionEnabled = YES;
        UIPanGestureRecognizer * barPan3 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(barPanGesture:)];
        [self.leftBar addGestureRecognizer:barPan3];
        [self addSubview:self.leftBar];
        //右中
        self.rightBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trip_v_bar"]];
        self.rightBar.contentMode = UIViewContentModeRight;
        self.rightBar.frame = CGRectMake(frame.size.width - 19 , (frame.size.height - 40)/2, 19, 40);
        self.rightBar.userInteractionEnabled = YES;
        UIPanGestureRecognizer * barPan4 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(barPanGesture:)];
        [self.rightBar addGestureRecognizer:barPan4];
        [self addSubview:self.rightBar];
        
        self.topLeftBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_top_left"]];
        self.topLeftBar.frame = CGRectMake(0, 0, 19, 19);
        self.topLeftBar.userInteractionEnabled = YES;
        UIPanGestureRecognizer * pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerPanGesture:)];
        [self.topLeftBar addGestureRecognizer:pan1];
        [self addSubview:self.topLeftBar];
        
        self.topRightBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_top_right"]];
        self.topRightBar.userInteractionEnabled = YES;
        self.topRightBar.frame = CGRectMake(frame.size.width - 19, 0, 19, 19);
        UIPanGestureRecognizer * pan2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerPanGesture:)];
        [self.topRightBar addGestureRecognizer:pan2];
        [self addSubview:self.topRightBar];

        
        self.bottomLeftBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_bottom_left"]];
        self.bottomLeftBar.frame = CGRectMake(0, frame.size.height - 19, 19, 19);
        self.bottomLeftBar.userInteractionEnabled = YES;
        UIPanGestureRecognizer * pan3 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerPanGesture:)];
        [self.bottomLeftBar addGestureRecognizer:pan3];
        [self addSubview:self.bottomLeftBar];
        
        self.bottomRightBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_bottom_right"]];
        self.bottomRightBar.frame = CGRectMake(frame.size.width - 19, frame.size.height - 19, 19, 19);
        self.bottomRightBar.userInteractionEnabled = YES;
        UIPanGestureRecognizer * pan4 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cornerPanGesture:)];
        [self.bottomRightBar addGestureRecognizer:pan4];
        [self addSubview:self.bottomRightBar];
        
        UIPanGestureRecognizer * viewPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPanGesture:)];
        [self addGestureRecognizer:viewPan];
          
    }
    return self;
}

-(void)setType:(TripType)type{
    _type = type;
    if (type != TripTypeFree) {
        self.leftBar.hidden = YES;
        self.rightBar.hidden = YES;
        self.topBar.hidden = YES;
        self.bottomBar.hidden = YES;
    }
    double scale = 1;
    switch (type) {
        case TripType11:
            scale = 1;
            break;
        case TripType34:
            scale = 3.0/4.0;
            break;
        case TripType43:
            scale = 4.0/3.0;
            break;
         case TripType169:
            scale = 16.0/9.0;
            break;
        case TripType916:
            scale = 9.0/16.0;
            break;
        default:
            scale = self.frame.size.width/self.frame.size.height;
            break;
    }
    if (self.frame.size.width/self.frame.size.height > scale ) {
        CGFloat offsetX = (self.frame.size.width - self.frame.size.height * scale)/2;
        self.topLeftBar.center = CGPointMake(self.topLeftBar.center.x + offsetX, self.topLeftBar.center.y);
        self.bottomLeftBar.center = CGPointMake(self.bottomLeftBar.center.x + offsetX, self.bottomLeftBar.center.y);
        self.leftBar.center = CGPointMake(self.leftBar.center.x + offsetX, self.leftBar.center.y);
        self.rightBar.center = CGPointMake(self.rightBar.center.x - offsetX, self.rightBar.center.y);
        self.topRightBar.center = CGPointMake(self.topRightBar.center.x - offsetX, self.topRightBar.center.y);
        self.bottomRightBar.center = CGPointMake(self.bottomRightBar.center.x - offsetX, self.bottomRightBar.center.y);
        [self setNeedsDisplay];
    }else{
        CGFloat offsetY = (self.frame.size.height - self.frame.size.width/scale)/2;
        self.topLeftBar.center = CGPointMake(self.topLeftBar.center.x, self.topLeftBar.center.y + offsetY);
        self.topRightBar.center = CGPointMake(self.topRightBar.center.x, self.topRightBar.center.y + offsetY);
        self.bottomLeftBar.center = CGPointMake(self.bottomLeftBar.center.x, self.bottomLeftBar.center.y - offsetY);
        self.bottomRightBar.center = CGPointMake(self.bottomRightBar.center.x, self.bottomRightBar.center.y - offsetY);
        self.topBar.center =CGPointMake(self.topBar.center.x, self.topBar.center.y + offsetY);
        self.bottomBar.center =CGPointMake(self.bottomBar.center.x, self.bottomBar.center.y - offsetY);
        [self setNeedsDisplay];
        
    }
}
-(void)viewPanGesture:(UIPanGestureRecognizer*)panGesture{
    CGPoint translation = [panGesture translationInView:self];
    CGRect currentRect = [self tripRect];
    if (CGRectGetMinX(currentRect) + translation.x < 0 || CGRectGetMaxX(currentRect) + translation.x > self.bounds.size.width) {
        translation.x = 0;
    }
    if (CGRectGetMinY(currentRect) + translation.y < 0 || CGRectGetMaxY(currentRect) + translation.y > self.bounds.size.height) {
        translation.y = 0;
    }

    for (UIView * view in self.subviews) {
        view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    }
    [self setNeedsDisplay];
    
    [panGesture setTranslation:CGPointZero inView:self];
}

-(void)cornerPanGesture:(UIPanGestureRecognizer*)panGesture
{
    UIView * view = panGesture.view;
 
    CGPoint translation = [panGesture translationInView:self];
    CGPoint newCenter = CGPointMake(panGesture.view.center.x+ translation.x,
                                    panGesture.view.center.y + translation.y);
    newCenter.y = MAX(panGesture.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(self.frame.size.height - panGesture.view.frame.size.height/2,  newCenter.y);
    newCenter.x = MAX(panGesture.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.frame.size.width - panGesture.view.frame.size.width/2,newCenter.x);
    
    CGFloat offsetX = newCenter.x - panGesture.view.center.x;
    CGFloat offsetY = newCenter.y - panGesture.view.center.y;
   
    CGSize currentSize = [self tripRect].size;
    
    if ([view isEqual:self.topLeftBar]) {
        if (self.type != TripTypeFree) {
            if (offsetX * offsetY < 0) {
                [panGesture setTranslation:CGPointZero inView:self];
                return;
            }
            if (fabs(offsetX/offsetY) < currentSize.width/currentSize.height) {
                offsetX = currentSize.width/currentSize.height * offsetY;
                if (offsetX + view.center.x - 9.5  < 0) {
                    [panGesture setTranslation:CGPointZero inView:self];
                    return;
                }
            }else{
                offsetY = currentSize.height /currentSize.width * offsetX;
                if (offsetY + view.center.y - 9.5  < 0) {
                    [panGesture setTranslation:CGPointZero inView:self];
                    return;
                    
                }
            }
        }
      
        CGPoint new = CGPointMake(panGesture.view.center.x+ offsetX,
                                  panGesture.view.center.y +offsetY);
        CGPoint refCenter = self.bottomRightBar.center;
        if (new.x + 59 > refCenter.x || new.y + 59 > refCenter.y) {
            [panGesture setTranslation:CGPointZero inView:self];
            return;
        }
   
        panGesture.view.center = new;

        self.bottomLeftBar.center = CGPointMake(self.bottomLeftBar.center.x + offsetX, self.bottomLeftBar.center.y);
        self.topRightBar.center = CGPointMake(self.topRightBar.center.x  , self.topRightBar.center.y + offsetY);
        self.topBar.center = CGPointMake(self.topBar.center.x + offsetX * 0.5, self.topBar.center.y + offsetY);
        self.bottomBar.center = CGPointMake(self.bottomBar.center.x + offsetX * 0.5, self.bottomBar.center.y);
        self.leftBar.center = CGPointMake(self.leftBar.center.x + offsetX, self.leftBar.center.y + offsetY * 0.5);
        self.rightBar.center = CGPointMake(self.rightBar.center.x, self.rightBar.center.y + offsetY * 0.5);
    }else if ([view isEqual:self.bottomRightBar]){
        if (self.type != TripTypeFree) {
            if (offsetX * offsetY < 0) {
                [panGesture setTranslation:CGPointZero inView:self];
                return;
            }
            if ( fabs(offsetX/offsetY) < currentSize.width/currentSize.height) {
                offsetX = currentSize.width/currentSize.height * offsetY;
                if (offsetX + view.center.x + 9.5  > self.frame.size.width) {
                    [panGesture setTranslation:CGPointZero inView:self];
                    return;
                }
            }else{
                offsetY = currentSize.height /currentSize.width * offsetX;
                if (offsetY + view.center.y + 9.5  > self.frame.size.height) {
                    [panGesture setTranslation:CGPointZero inView:self];
                    return;
                }
            }
           
        }
        
        CGPoint new = CGPointMake(panGesture.view.center.x + offsetX,
                                  panGesture.view.center.y + offsetY);
        CGPoint refCenter = self.topLeftBar.center;
        if (new.x - 59 < refCenter.x || new.y - 59 < refCenter.y) {
            [panGesture setTranslation:CGPointZero inView:self];
            return;
        }
 
        panGesture.view.center = new;
   
        self.topRightBar.center = CGPointMake(self.topRightBar.center.x + offsetX, self.topRightBar.center.y);
        self.bottomLeftBar.center = CGPointMake(self.bottomLeftBar.center.x, self.bottomLeftBar.center.y + offsetY);
        self.topBar.center = CGPointMake(self.topBar.center.x + offsetX * 0.5, self.topBar.center.y );
        self.bottomBar.center = CGPointMake(self.bottomBar.center.x + offsetX * 0.5 , self.bottomBar.center.y + offsetY);
        self.leftBar.center = CGPointMake(self.leftBar.center.x, self.leftBar.center.y + offsetY * 0.5);
        self.rightBar.center = CGPointMake(self.rightBar.center.x + offsetX, self.rightBar.center.y + offsetY * 0.5);
    }else if ([view isEqual:self.topRightBar]){
        if (self.type != TripTypeFree) {
            if(offsetY * offsetX > 0){
                [panGesture setTranslation:CGPointZero inView:self];
                return;
            }
            if ( fabs(offsetX/offsetY) < currentSize.width/currentSize.height) {
                offsetX = - currentSize.width/currentSize.height * offsetY;
                if (offsetX + view.center.x + 9.5  > self.frame.size.width) {
                    [panGesture setTranslation:CGPointZero inView:self];
                    return;
                }
            }else{
                offsetY = - currentSize.height /currentSize.width * offsetX;
                if (offsetY + view.center.y - 9.5 < 0) {
                    [panGesture setTranslation:CGPointZero inView:self];
                    return;
                }
            }
        }
      
        CGPoint new = CGPointMake(panGesture.view.center.x+ offsetX,
                                  panGesture.view.center.y +offsetY);
        CGPoint refCenter = self.bottomLeftBar.center;
        if (new.x - 59 < refCenter.x || new.y + 59 > refCenter.y) {
            [panGesture setTranslation:CGPointZero inView:self];
            return;
        }
        
        panGesture.view.center = new;
        self.bottomRightBar.center = CGPointMake(self.bottomRightBar.center.x + offsetX, self.bottomRightBar.center.y);
        self.topLeftBar.center = CGPointMake(self.topLeftBar.center.x  , self.topLeftBar.center.y + offsetY);
        self.topBar.center = CGPointMake(self.topBar.center.x + offsetX * 0.5 , self.topBar.center.y + offsetY );
        self.bottomBar.center = CGPointMake(self.bottomBar.center.x + offsetX * 0.5 , self.bottomBar.center.y );
        self.leftBar.center = CGPointMake(self.leftBar.center.x, self.leftBar.center.y + offsetY * 0.5);
        self.rightBar.center = CGPointMake(self.rightBar.center.x + offsetX, self.rightBar.center.y + offsetY * 0.5);
  
    }else if ([view isEqual:self.bottomLeftBar]){
        if (self.type != TripTypeFree) {
            if(offsetY * offsetX > 0){
                [panGesture setTranslation:CGPointZero inView:self];
                return;
            }
            if ( fabs(offsetX/offsetY) < currentSize.width/currentSize.height) {
                offsetX = - currentSize.width/currentSize.height * offsetY;
                if (offsetX + view.center.x - 9.5 < 0) {
                    [panGesture setTranslation:CGPointZero inView:self];
                    return;
                }
            }else{
                offsetY = - currentSize.height /currentSize.width * offsetX;
                if (offsetY + view.center.y + 9.5 > self.frame.size.height) {
                    [panGesture setTranslation:CGPointZero inView:self];
                    return;
                }
            }
        }
      
        CGPoint new = CGPointMake(panGesture.view.center.x+ offsetX,
                                  panGesture.view.center.y +offsetY);
        CGPoint refCenter = self.topRightBar.center;
        if (new.x + 59 > refCenter.x || new.y - 59 < refCenter.y) {
            [panGesture setTranslation:CGPointZero inView:self];
            return;
        }
  
        panGesture.view.center = new;
        self.topLeftBar.center = CGPointMake(self.topLeftBar.center.x + offsetX, self.topLeftBar.center.y);
        self.bottomRightBar.center = CGPointMake(self.bottomRightBar.center.x, self.bottomRightBar.center.y + offsetY);
        self.topBar.center = CGPointMake(self.topBar.center.x + offsetX * 0.5 , self.topBar.center.y );
        self.bottomBar.center = CGPointMake(self.bottomBar.center.x + offsetX * 0.5 , self.bottomBar.center.y + offsetY );
        self.leftBar.center = CGPointMake(self.leftBar.center.x + offsetX, self.leftBar.center.y + offsetY * 0.5);
        self.rightBar.center = CGPointMake(self.rightBar.center.x, self.rightBar.center.y + offsetY * 0.5);
    }
    [panGesture setTranslation:CGPointZero inView:self];

    [self setNeedsDisplay];
 
}

-(void)barPanGesture:(UIPanGestureRecognizer*)panGesture
{
    UIView * view = panGesture.view;
    
    CGPoint translation = [panGesture translationInView:self];
    
    if ([view isEqual:self.topBar]) {
        
        CGPoint newCenter = CGPointMake(panGesture.view.center.x,
                                        panGesture.view.center.y + translation.y);
        newCenter.y = MAX(panGesture.view.frame.size.height/2, newCenter.y);
        newCenter.y = MIN(self.frame.size.height - panGesture.view.frame.size.height/2,  newCenter.y);
        if (self.bottomBar.center.y - newCenter.y < 40 + 19) {
            [panGesture setTranslation:CGPointZero inView:self];
            return;
        }
        CGFloat offsetY = newCenter.y - panGesture.view.center.y;
        panGesture.view.center = newCenter;

        self.topLeftBar.center = CGPointMake(self.topLeftBar.center.x, self.topLeftBar.center.y + offsetY);
        self.topRightBar.center = CGPointMake(self.topRightBar.center.x, self.topRightBar.center.y + offsetY);
        self.leftBar.center = CGPointMake(self.leftBar.center.x, self.leftBar.center.y + 0.5 * offsetY);
        self.rightBar.center = CGPointMake(self.rightBar.center.x, self.rightBar.center.y + 0.5 * offsetY);

    }else if ([view isEqual:self.bottomBar]){
        
        CGPoint newCenter = CGPointMake(panGesture.view.center.x,
                                        panGesture.view.center.y + translation.y);
        newCenter.y = MAX(panGesture.view.frame.size.height/2, newCenter.y);
        newCenter.y = MIN(self.frame.size.height - panGesture.view.frame.size.height/2,  newCenter.y);
        if (newCenter.y - self.topBar.center.y <  40 + 19) {
            [panGesture setTranslation:CGPointZero inView:self];
            return;
        }
        CGFloat offsetY = newCenter.y - panGesture.view.center.y;
        panGesture.view.center = newCenter;

        self.bottomLeftBar.center = CGPointMake(self.bottomLeftBar.center.x, self.bottomLeftBar.center.y + offsetY);
        self.bottomRightBar.center = CGPointMake(self.bottomRightBar.center.x, self.bottomRightBar.center.y + offsetY);
        self.leftBar.center = CGPointMake(self.leftBar.center.x, self.leftBar.center.y + 0.5 * offsetY);
        self.rightBar.center = CGPointMake(self.rightBar.center.x, self.rightBar.center.y + 0.5 * offsetY);
    }else if ([view isEqual:self.leftBar]){
        CGPoint newCenter = CGPointMake(panGesture.view.center.x+ translation.x,
                                        panGesture.view.center.y);
        newCenter.x = MAX(panGesture.view.frame.size.width/2, newCenter.x);
        newCenter.x = MIN(self.frame.size.width - panGesture.view.frame.size.width/2,newCenter.x);
        if (self.rightBar.center.x - newCenter.x <  40 + 19) {
            [panGesture setTranslation:CGPointZero inView:self];
            return;
        }
        CGFloat offsetX = newCenter.x - panGesture.view.center.x;
        panGesture.view.center = newCenter;
        
        self.topLeftBar.center = CGPointMake(self.topLeftBar.center.x + offsetX, self.topLeftBar.center.y);
        self.bottomLeftBar.center = CGPointMake(self.bottomLeftBar.center.x + offsetX, self.bottomLeftBar.center.y);
        self.topBar.center = CGPointMake(self.topBar.center.x + 0.5 * offsetX, self.topBar.center.y  );
        self.bottomBar.center = CGPointMake(self.bottomBar.center.x + 0.5 * offsetX, self.bottomBar.center.y  );
    }else if ([view isEqual:self.rightBar]){
        CGPoint newCenter = CGPointMake(panGesture.view.center.x+ translation.x,
                                        panGesture.view.center.y);
        newCenter.x = MAX(panGesture.view.frame.size.width/2, newCenter.x);
        newCenter.x = MIN(self.frame.size.width - panGesture.view.frame.size.width/2,newCenter.x);
        if (newCenter.x - self.leftBar.center.x <  40 + 19) {
            [panGesture setTranslation:CGPointZero inView:self];
            return;
        }
        CGFloat offsetX = newCenter.x - panGesture.view.center.x;
        panGesture.view.center = newCenter;

        self.topRightBar.center = CGPointMake(self.topRightBar.center.x + offsetX, self.topRightBar.center.y);
        self.bottomRightBar.center = CGPointMake(self.bottomRightBar.center.x + offsetX, self.bottomRightBar.center.y);
        self.topBar.center = CGPointMake(self.topBar.center.x + 0.5 * offsetX, self.topBar.center.y );
        self.bottomBar.center = CGPointMake(self.bottomBar.center.x + 0.5 * offsetX, self.bottomBar.center.y );
    }
    [panGesture setTranslation:CGPointZero inView:self];

    [self setNeedsDisplay];
    
}


-(void)drawRect:(CGRect)rect
{
    [self.tripLayer removeFromSuperlayer];
    
    //中间镂空的矩形框
    CGRect myRect = [self tripRect];
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:myRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];

    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    self.tripLayer = fillLayer;
    [self.layer addSublayer:fillLayer];

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, myRect.origin.x, myRect.origin.y);
    CGContextAddLineToPoint(context, myRect.origin.x, CGRectGetMaxY(myRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(myRect), CGRectGetMaxY(myRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(myRect), myRect.origin.y);
    CGContextAddLineToPoint(context, myRect.origin.x, myRect.origin.y);

    CGContextMoveToPoint(context, myRect.origin.x + myRect.size.width/3.0, myRect.origin.y);
    CGContextAddLineToPoint(context, myRect.origin.x + myRect.size.width/3.0, CGRectGetMaxY(myRect));

    CGContextMoveToPoint(context, myRect.origin.x + myRect.size.width/3.0 * 2, myRect.origin.y);
    CGContextAddLineToPoint(context, myRect.origin.x + myRect.size.width/3.0 * 2, CGRectGetMaxY(myRect));
    
    CGContextMoveToPoint(context, myRect.origin.x, myRect.origin.y + myRect.size.height / 3.0);
    CGContextAddLineToPoint(context, CGRectGetMaxX(myRect), myRect.origin.y + myRect.size.height / 3.0);

    CGContextMoveToPoint(context, myRect.origin.x, myRect.origin.y + myRect.size.height / 3.0 * 2);
    CGContextAddLineToPoint(context, CGRectGetMaxX(myRect), myRect.origin.y + myRect.size.height / 3.0 * 2);
    
    
     //连接上面定义的坐标点，也就是开始绘图
    CGContextStrokePath(context);
}

-(CGRect)tripRect{
     CGRect myRect = CGRectMake(self.topLeftBar.frame.origin.x, self.topLeftBar.frame.origin.y, CGRectGetMaxX(self.bottomRightBar.frame)-self.topLeftBar.frame.origin.x, CGRectGetMaxY(self.bottomRightBar.frame)-self.topLeftBar.frame.origin.y);
    return myRect;
    
}

@end
