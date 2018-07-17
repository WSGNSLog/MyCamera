
//
//  PhotoCutView.m
//  MyCamera
//
//  Created by shiguang on 2018/5/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PhotoCutView.h"
typedef NS_ENUM(NSUInteger, Position) {
    Position_Left_Top = 0,
    Position_Left_Bottom,
    Position_Right_Top,
    Position_Right_Bottom,
};

@interface PhotoCutView()
{
    UIButton *testBtn;
    CGPoint touchPoint;
    CGPoint recordCenter;
    Position position;
}
@property(nonatomic,strong)UIView *areaView;
@end

@implementation PhotoCutView

-(instancetype)initWithFrame:(CGRect)frame cutArea:(CGRect)cutArea{
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _cutArea = cutArea;
        [self addSubview:self.areaView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(zoomArea:)];
        pan.maximumNumberOfTouches = 1;
        
        [self addGestureRecognizer:pan];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    
    rect = self.areaView.frame;
    CGPoint origin = rect.origin;
    CGSize size = rect.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor]setStroke];
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] setFill];
    CGContextSetLineWidth(context, 3.0);
    //2.设置当前上下问路径
    //设置起始点
    CGContextMoveToPoint(context, origin.x,origin.y);
    //增加点
    CGContextAddLineToPoint(context, size.width+origin.x,origin.y);
    CGContextAddLineToPoint(context, size.width+origin.x,size.height+origin.y);
    CGContextAddLineToPoint(context, origin.x,size.height+origin.y);
    //关闭路径
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    for (int i = 1 ; i<3; i++) {
        
        CGContextMoveToPoint(context, size.width/3*i+origin.x,origin.y);
        CGContextAddLineToPoint(context,size.width/3*i+origin.x,size.height+origin.y);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    for (int i = 1 ; i<3; i++) {
        CGContextMoveToPoint(context, origin.x,origin.y+size.height/3*i);
        CGContextAddLineToPoint(context,origin.x+size.width,origin.y+size.height/3*i);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathStroke);
        
    }
    
    [[UIColor whiteColor]setFill];
    CGContextSetLineWidth(context, 1.0);
    
    CGContextAddArc(context,origin.x, origin.y,10, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddArc(context,origin.x+size.width, origin.y,10, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddArc(context,origin.x+size.width, origin.y+size.height,10, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddArc(context,origin.x, origin.y+size.height,10, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
}
-(UIView *)areaView{
    if(!_areaView){
        _areaView = [[UIView alloc]initWithFrame:self.cutArea];
        _areaView.center = self.center;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveArea:)];
        pan.maximumNumberOfTouches = 1;
        
        [_areaView addGestureRecognizer:pan];
    }
    return _areaView;
}
-(void)moveArea:(UIPanGestureRecognizer *)sender{
    
    CGPoint translation = [sender translationInView:self.areaView];
    
    if(sender.state == UIGestureRecognizerStateChanged){
        recordCenter = CGPointMake(translation.x-recordCenter.x, translation.y-recordCenter.y);
        // 上
        bool top = ((self.areaView.center.y + recordCenter.y-self.areaView.frame.size.height/2)<self.cutArea.origin.y);
        //下
        bool bottom = ((self.areaView.center.y + recordCenter.y+self.areaView.frame.size.height/2) >self.cutArea.size.height+self.cutArea.origin.y);
        //左
        bool left = ((self.areaView.center.x + recordCenter.x-self.areaView.frame.size.width/2)<self.cutArea.origin.x);
        //右
        bool right = ((self.areaView.center.x + recordCenter.x+self.areaView.frame.size.width/2)>self.cutArea.size.width + self.cutArea.origin.x);
        
        float x,y;
        
        if(CGRectContainsRect(self.areaView.frame, self.cutArea)){
            
            return;
        }else if (self.areaView.frame.size.width == self.cutArea.size.width && top){
            x = self.cutArea.origin.x+self.areaView.frame.size.width/2;
            y = self.cutArea.origin.y+self.areaView.frame.size.height/2;
        }else if (self.areaView.frame.size.width == self.cutArea.size.width && bottom){
            x = self.cutArea.origin.x+self.areaView.frame.size.width/2;
            y = self.cutArea.origin.y + self.cutArea.size.height - self.areaView.frame.size.height/2;
        }else if (self.areaView.frame.size.height == self.cutArea.size.height && left){
            x = self.cutArea.origin.x+self.areaView.frame.size.width/2;
            y = self.cutArea.origin.y+self.areaView.frame.size.height/2;
        }else if (self.areaView.frame.size.height == self.cutArea.size.height && right){
            x = self.cutArea.origin.x+self.cutArea.size.width - self.areaView.frame.size.width/2;
            y = self.cutArea.origin.y + self.areaView.frame.size.height - self.areaView.frame.size.height/2;
        }else if(top && bottom){
            x = self.areaView.center.x + recordCenter.x;
            y = self.areaView.center.y;
        }else if(top && left){
            x = self.cutArea.origin.x + self.areaView.frame.size.width/2;
            y = self.cutArea.origin.y + self.areaView.frame.size.height/2;
        }else if(top && right){
            x = self.cutArea.origin.x+self.cutArea.size.width - self.areaView.frame.size.width/2;
            y = self.cutArea.origin.y+self.areaView.frame.size.height/2;
        }else if(top){
            x = self.areaView.center.x + recordCenter.x;
            y = self.cutArea.origin.y+self.areaView.frame.size.height/2;
        }else if(bottom && left){
            x = self.cutArea.origin.x + self.areaView.frame.size.width/2;
            y = self.cutArea.origin.y + self.cutArea.size.height - self.areaView.frame.size.height/2;
        }else if(bottom && right){
            x = self.cutArea.origin.x+self.cutArea.size.width - self.areaView.frame.size.width/2;
            y = self.cutArea.origin.y + self.cutArea.size.height - self.areaView.frame.size.height/2;
        }else if(bottom){
            x = self.areaView.center.x + recordCenter.x;
            y = self.cutArea.origin.y + self.cutArea.size.height - self.areaView.frame.size.height/2;
        }else if(left && right){
            x = self.areaView.center.x;
            y = self.areaView.center.y + recordCenter.y;
        }else if(left){
            x = self.cutArea.origin.x + self.areaView.frame.size.width/2;
            y = self.areaView.center.y + recordCenter.y;
        }else if(right){
            x = self.cutArea.origin.x+self.cutArea.size.width - self.areaView.frame.size.width/2;
            y = self.areaView.center.y + recordCenter.y;
        }else{
            x = self.areaView.center.x + recordCenter.x;
            y = self.areaView.center.y + recordCenter.y;
        }
        CGPoint center = CGPointMake(x, y);
        self.areaView.center = center;
        recordCenter = translation;
        [self setNeedsDisplay];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        recordCenter = CGPointZero;
    }
}

-(void)zoomArea:(UIPanGestureRecognizer *)sender{
    
    CGPoint translation = [sender translationInView:self];
    CGPoint isPositionPoint = [sender locationInView:self];
    if(sender.state == UIGestureRecognizerStateBegan){
        touchPoint = translation;
        if(isPositionPoint.x < self.frame.size.width/2){
            if(isPositionPoint.y < self.frame.size.height/2){
                position = Position_Left_Top;
            }else{
                position = Position_Left_Bottom;
            }
        }else{
            if(isPositionPoint.y < self.frame.size.height/2){
                position = Position_Right_Top;
            }else{
                position = Position_Right_Bottom;
            }
        }
    }else if (sender.state == UIGestureRecognizerStateChanged){
        
        if(position == Position_Left_Top){
            [self leftAndTop:translation];
        }else if(position == Position_Left_Bottom){
            [self leftAndBottom:translation];
        }else if(position == Position_Right_Top){
            [self rightAndTop:translation];
        }else{
            [self rightAndBottom:translation];
        }
        touchPoint = translation;
    }else if(sender.state == UIGestureRecognizerStateEnded){
        
        NSLog(@"===============");
    }
    
}
-(CGSize)getCutViewSize:(float)displacementX displacementY:(float)displacementY{
    
    float width,height;
    if((self.cutArea.size.width - (self.areaView.frame.size.width+displacementX))<0.1){
        width = self.cutArea.size.width;
    }else{
        width = self.areaView.frame.size.width+displacementX;
    }
    if(width - self.cutArea.size.width*0.2 < 0.1){
        width = self.cutArea.size.width*0.2;
    }
    
    if(self.cutArea.size.height - (self.areaView.frame.size.height+displacementY)<0.1){
        height = self.cutArea.size.height;
    }else{
        height = self.areaView.frame.size.height+displacementY;
    }
    if(height - self.cutArea.size.height*0.2 < 0.1){
        height = self.cutArea.size.height*0.2;
    }
    
    return CGSizeMake(width, height);
}
-(void)leftAndTop:(CGPoint)translation{
    float displacementX = touchPoint.x - translation.x;
    float displacementY = touchPoint.y - translation.y;
    
    
    
    CGSize cutViewSize = [self getCutViewSize:displacementX displacementY:displacementY];
    
    float width = cutViewSize.width;
    float height = cutViewSize.height;
    
    if(self.areaView.frame.origin.x + self.areaView.frame.size.width - width < self.cutArea.origin.x){
        
        width = self.areaView.frame.origin.x + self.areaView.frame.size.width - self.areaView.frame.origin.x;
    }
    if(self.areaView.frame.origin.y + self.areaView.frame.size.height - height < self.cutArea.origin.y){
        height = self.areaView.frame.origin.y + self.areaView.frame.size.height - self.cutArea.origin.y;
    }
    
    float x = self.areaView.frame.origin.x + self.areaView.frame.size.width - width/2;
    float y = self.areaView.frame.origin.y + self.areaView.frame.size.height - height/2;
    
    self.areaView.frame = CGRectMake(0,0,width,height);
    
    self.areaView.center = CGPointMake(x,y);
    [self setNeedsDisplay];
}
-(void)leftAndBottom:(CGPoint)translation{
    float displacementX = touchPoint.x - translation.x;
    float displacementY = translation.y - touchPoint.y;
    
    CGSize cutViewSize = [self getCutViewSize:displacementX displacementY:displacementY];
    
    float width = cutViewSize.width;
    float height = cutViewSize.height;
    
    if(self.areaView.frame.origin.x + self.areaView.frame.size.width - width < self.cutArea.origin.x){
        
        width = self.areaView.frame.origin.x + self.areaView.frame.size.width - self.areaView.frame.origin.x;
    }
    if(self.areaView.frame.origin.y + height > self.cutArea.origin.y + self.cutArea.size.height){
        height = self.cutArea.origin.y + self.cutArea.size.height - self.areaView.frame.origin.y;
    }
    float x = self.areaView.frame.origin.x + self.areaView.frame.size.width - width/2;
    float y = self.areaView.frame.origin.y + height/2;
    
    self.areaView.frame = CGRectMake(0,0,width,height);
    
    self.areaView.center = CGPointMake(x,y);
    
    [self setNeedsDisplay];
}
-(void)rightAndTop:(CGPoint)translation{
    float displacementX = translation.x - touchPoint.x;
    float displacementY = touchPoint.y - translation.y;
    
    CGSize cutViewSize = [self getCutViewSize:displacementX displacementY:displacementY];
    
    float width = cutViewSize.width;
    float height = cutViewSize.height;
    if(self.areaView.frame.origin.x+width > self.cutArea.origin.x+self.cutArea.size.width){
        
        width = self.cutArea.origin.x+self.cutArea.size.width-self.areaView.frame.origin.x;
    }
    if(self.areaView.frame.origin.y+self.areaView.frame.size.height - height < self.cutArea.origin.y){
        height = self.areaView.frame.origin.y+self.areaView.frame.size.height - self.areaView.frame.origin.y;
    }
    float x = self.areaView.frame.origin.x + width/2;
    float y = self.areaView.frame.origin.y + self.areaView.frame.size.height - height/2;
    
    self.areaView.frame = CGRectMake(0,0,width,height);
    
    self.areaView.center = CGPointMake(x,y);
    
    [self setNeedsDisplay];
}
-(void)rightAndBottom:(CGPoint)translation{
    float displacementX = translation.x - touchPoint.x;
    float displacementY = translation.y - touchPoint.y;
    
    CGSize cutViewSize = [self getCutViewSize:displacementX displacementY:displacementY];
    
    float width = cutViewSize.width;
    float height = cutViewSize.height;
    if(self.areaView.frame.origin.x+width > self.cutArea.origin.x+self.cutArea.size.width){
        
        width = self.cutArea.origin.x+self.cutArea.size.width-self.areaView.frame.origin.x;
    }
    if(self.areaView.frame.origin.y + height > self.cutArea.origin.y + self.cutArea.size.height){
        height = self.cutArea.origin.y + self.cutArea.size.height - self.areaView.frame.origin.y;
    }
    float x = self.areaView.frame.origin.x + width/2;
    float y = self.areaView.frame.origin.y + height/2;
    
    self.areaView.frame = CGRectMake(0,0,width,height);
    
    self.areaView.center = CGPointMake(x,y);
    [self setNeedsDisplay];
}
-(void)chaneAreaView:(float)displacementX displacementY:(float)displacementY {
    
    float width = MIN(self.areaView.frame.size.width+displacementX, self.cutArea.size.width);
    
    width = MAX(width, self.cutArea.size.width*0.2);
    
    float height = MIN(self.areaView.frame.size.height+displacementY, self.cutArea.size.height);
    
    height = MAX(height, self.cutArea.size.height*0.2);
    
    if(position == Position_Left_Top){
        self.areaView.frame = CGRectMake(self.areaView.frame.size.width+self.areaView.frame.origin.x-width,self.areaView.frame.size.height+self.areaView.frame.origin.y-height,width,height);
    }else if (position == Position_Right_Top){
        self.areaView.frame = CGRectMake(self.areaView.frame.origin.x,self.areaView.frame.origin.y-displacementY,width,height);
    }else if(position ==  Position_Left_Bottom){
        self.areaView.frame = CGRectMake(self.areaView.frame.origin.x-displacementX,self.areaView.frame.origin.y,width,height);
    }else if(position ==  Position_Right_Bottom){
        self.areaView.frame = CGRectMake(self.areaView.frame.origin.x,self.areaView.frame.origin.y,width,height);
    }
    [self setNeedsDisplay];
}
-(UIButton *)createButton:(CGPoint)center{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    
    button.frame = CGRectMake(100, 100, 20, 20);
    button.center = center;
    button.layer.cornerRadius = 10;
    return button;
}


@end
