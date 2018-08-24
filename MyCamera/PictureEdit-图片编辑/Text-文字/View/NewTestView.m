//
//  NewTestView.m
//  MyCamera
//
//  Created by shiguang on 2018/8/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "NewTestView.h"

@interface NewTestView ()<UIGestureRecognizerDelegate>
{
    UIButton*       _scaleRotateBtn;            //单手操作放大，旋转按钮
    //己旋转角度
    CGFloat         _rotateAngle;
}
@property(nonatomic,retain)CALayer * deleteLayer;
@property(nonatomic,retain)CALayer * editLayer;
@property(nonatomic,retain)CALayer * rotateLayer;
@property(nonatomic,retain)CAShapeLayer * border;
@end

@implementation NewTestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc]init];
        [self addSubview:self.textLabel];
        self.textLabel.frame = CGRectMake(24, 24, frame.size.width - 48, frame.size.height - 48);
        self.textLabel.preferredMaxLayoutWidth = LL_ScreenWidth - 48;
        self.textLabel.font = [UIFont systemFontOfSize:20];
        self.textLabel.numberOfLines = 0;
        
        CAShapeLayer *border = [CAShapeLayer layer];
        //虚线的颜色
        border.strokeColor = [UIColor whiteColor].CGColor;
        //填充的颜色
        border.fillColor = [UIColor clearColor].CGColor;
        //虚线的宽度
        border.lineWidth = 1.f;
        //虚线的间隔
        border.lineDashPattern = @[@4, @2];
        [self.layer addSublayer:border];
        self.border = border;
        
        CGRect borderRect = CGRectMake(12, 12, self.frame.size.width - 24, self.frame.size.height - 24);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:borderRect];
        self.border.path = path.CGPath;
        self.border.frame = self.bounds;
        
        
        CALayer *deletlayer = [CALayer layer];
        deletlayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"camera_text_delete"].CGImage);
        deletlayer.frame = CGRectMake(0, 0, 24, 24);
        [self.layer addSublayer:deletlayer];
        self.deleteLayer = deletlayer;
        
        CALayer *editlayer = [CALayer layer];
        editlayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"camera_text_edit"].CGImage);
        editlayer.frame = CGRectMake(self.frame.size.width -24,0 , 24, 24);
        [self.layer addSublayer:editlayer];
        self.editLayer = editlayer;
        
        
        _scaleRotateBtn = [UIButton new];
        _scaleRotateBtn.frame = CGRectMake(self.frame.size.width -24,self.height -24, 24, 24);
        [_scaleRotateBtn setImage:[UIImage imageNamed:@"videotext_rotate"] forState:UIControlStateNormal];
        UIPanGestureRecognizer* panGensture = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector (panAction:)];
        [self addSubview:_scaleRotateBtn];
        [_scaleRotateBtn addGestureRecognizer:panGensture];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
        UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
        rotationGestureRecognizer.delegate = self;
        [self addGestureRecognizer:rotationGestureRecognizer];
        
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
        pinchGestureRecognizer.delegate = self;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.textLabel.textColor = textColor;
}

-(void)setText:(NSString *)text{
    _text = text;
    self.textLabel.text = text;
}

-(void)setIsPreview:(BOOL)isPreview{
    _isPreview = isPreview;
    if (self.isPreview) {
        self.editLayer.hidden = YES;
        self.deleteLayer.hidden = YES;
        self.border.hidden = YES;
        _scaleRotateBtn.hidden = YES;
    }else{
        self.border.hidden = NO;
        self.editLayer.hidden = !_canEdit;
        self.deleteLayer.hidden = !_canDelete;
        _scaleRotateBtn.hidden = self.editLayer.isHidden;
    }
}


-(void)setCanEdit:(BOOL)canEdit{
    _canEdit = canEdit;
    self.editLayer.hidden = !canEdit;
}
-(void)setCanDelete:(BOOL)canDelete{
    _canDelete = canDelete;
    self.deleteLayer.hidden = !canDelete;
}

#pragma mark - 按钮方法
-(void)editLayerClick{
    if (self.editTextBlock) {
        self.editTextBlock(self);
    }
    
}
-(void)deleteLayerClick{
    [self removeFromSuperview];
    if (self.editDateBlock) {
        self.editDateBlock();
    }
}

#pragma mark - 手势事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    CGPoint translation = [tap locationInView:self];
    
    if (self.deleteLayer.hidden == NO && CGRectContainsPoint(self.deleteLayer.frame, translation)) {
        [self deleteLayerClick];
        return;
    }else if (self.editLayer.hidden == NO && CGRectContainsPoint(self.editLayer.frame, translation)){
        [self editLayerClick];
        return;
    }
    
    for (UIView * view in self.superview.subviews) {
        if ([view isKindOfClass:[NewTestView class]]) {
            [(NewTestView *) view  setIsPreview:YES];
        }
    }
    self.isPreview = NO;
}

-(void)panAction:(UIPanGestureRecognizer *)recognizer{
    
    if (recognizer.view == self) {
        CGPoint translation = [recognizer translationInView:self.superview];
        CGPoint center = CGPointMake(recognizer.view.center.x + translation.x,
                                     recognizer.view.center.y + translation.y);
        if (center.x < 0) {
            center.x = 0;
        }
        else if (center.x > self.superview.width) {
            center.x = self.superview.width;
        }
        
        if (center.y < 0) {
            center.y = 0;
        }
        else if (center.y > self.superview.height) {
            center.y = self.superview.height;
        }
        
        recognizer.view.center = center;
        
        [recognizer setTranslation:CGPointZero inView:self.superview];
        
        
    }
    else if (recognizer.view == _scaleRotateBtn) {
        CGPoint translation = [recognizer translationInView:self];
        
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            //放大
            CGFloat delta = translation.x / 10;
            CGFloat newFontSize = MAX(10.0f, MIN(150.f, _textLabel.font.pointSize + delta));
            _textLabel.font = [UIFont systemFontOfSize:newFontSize];
            //            if (!_hasSetBubble) {
            _textLabel.bounds = [self textRect];
            self.bounds = CGRectMake(0, 0, _textLabel.bounds.size.width + 50, _textLabel.bounds.size.height + 40);
            //            }else{
            //                self.bounds = CGRectMake(0, 0, self.bounds.size.width + translation.x, self.bounds.size.height + translation.x);
            //            }
            
            //旋转
            CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            CGPoint anthorPoint = _textLabel.center;
            CGFloat height = newCenter.y - anthorPoint.y;
            CGFloat width = newCenter.x - anthorPoint.x;
            CGFloat angle1 = atan(height / width);
            height = recognizer.view.center.y - anthorPoint.y;
            width = recognizer.view.center.x - anthorPoint.x;
            CGFloat angle2 = atan(height / width);
            CGFloat angle = angle1 - angle2;
            
            self.transform = CGAffineTransformRotate(self.transform, angle);
            _rotateAngle += angle;
        }
        [recognizer setTranslation:CGPointZero inView:self];
    }
    //    CGPoint translation = [recognizer translationInView:self.superview];
    //    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
    //                                    recognizer.view.center.y + translation.y);//    限制屏幕范围：
    //    recognizer.view.center = newCenter;
    //    [recognizer setTranslation:CGPointZero inView:self.superview];
    
    if (self.editDateBlock) {
        self.editDateBlock();
    }
    
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer{
    
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        self.rotate += rotationGestureRecognizer.rotation;
        [rotationGestureRecognizer setRotation:0];
        
    }
    if (self.editDateBlock) {
        self.editDateBlock();
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer

{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform,  pinchGestureRecognizer.scale,  pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
        
    }
    if (self.editDateBlock) {
        self.editDateBlock();
    }
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (CGRect)textRect
{
    CGRect rect = [_textLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:_textLabel.font} context:nil];
    //限制最小的文字框大小
    if (rect.size.width < 30) {
        rect.size.width = 30;
    } else if (rect.size.height < 10) {
        rect.size.height = 10;
    }
    
    return rect;
}


@end
