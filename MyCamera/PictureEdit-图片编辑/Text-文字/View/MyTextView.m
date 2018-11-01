//
//  MyTextView.m
//  MyCamera
//
//  Created by shiguang on 2018/8/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "MyTextView.h"

@interface MyTextView ()<UIGestureRecognizerDelegate>
{
   
}
@property(nonatomic,retain)CALayer * deleteLayer;
@property(nonatomic,retain)CALayer * editLayer;
@property(nonatomic,retain)CALayer * rotateLayer;
@property(nonatomic,retain)CAShapeLayer * border;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,copy) NSString *fontName;
@end

@implementation MyTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 18;
        self.textLabel = [[UILabel alloc]init];
        [self addSubview:self.textLabel];
        self.textLabel.frame = CGRectMake(24, 24, frame.size.width - 48, frame.size.height - 48);
        self.textLabel.preferredMaxLayoutWidth = LL_ScreenWidth - 48;
        self.textLabel.font = [UIFont systemFontOfSize:self.fontSize];
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
        
    }else{
        self.border.hidden = NO;
        self.editLayer.hidden = !_canEdit;
        self.deleteLayer.hidden = !_canDelete;
    
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
        if ([view isKindOfClass:[MyTextView class]]) {
            [(MyTextView *) view  setIsPreview:YES];
        }
    }
    self.isPreview = NO;
}

-(void)panAction:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:self.superview];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translation.x,
                                    recognizer.view.center.y + translation.y);//    限制屏幕范围：
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self.superview];
    
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
