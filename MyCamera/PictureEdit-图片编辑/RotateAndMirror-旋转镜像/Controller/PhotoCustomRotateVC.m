//
//  PhotoCustomRotateVC.m
//  MyCamera
//
//  Created by shiguang on 2018/6/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoCustomRotateVC.h"

@interface PhotoCustomRotateVC ()<UIGestureRecognizerDelegate>
{
    ImageBlock _block;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, assign) CGFloat rotateAngle;
@end

@implementation PhotoCustomRotateVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.imageView.image = self.image;
    
    [self initNav];
    
//    UIPanGestureRecognizer* panGensture = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector (handlePanGesture:)];
//    panGensture.delegate = self;
//    [self.imageView addGestureRecognizer:panGensture];
    [self addRotateGesture];
}
- (void)initNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarClick)];
}
- (void)leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick{
    if (_block) {
        _block(_imageView.image);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addRotateGesture
{
    //创建缩放 旋转并添加手势的监听事件
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    //设置控制器为缩放手势的代理  可以实现同时识别两个手势
    rotate.delegate = self;
    //添加手势
    [self.imageView addGestureRecognizer:rotate];
}
- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.view == self.imageView) {
        CGPoint translation = [recognizer translationInView:self.imageView];
        
//        //放大
        if (recognizer.state == UIGestureRecognizerStateChanged) {
//            CGFloat delta = translation.x;
//            self.imageView.bounds = CGRectMake(0, 0, self.imageView.bounds.size.width + delta, self.imageView.bounds.size.height + delta);
        }
        [recognizer setTranslation:CGPointZero inView:self.imageView];

        //旋转
        CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        CGPoint anthorPoint = self.imageView.center;
        CGFloat height = newCenter.y - anthorPoint.y;
        CGFloat width = newCenter.x - anthorPoint.x;
        CGFloat angle1 = atan(height / width);
        height = recognizer.view.center.y - anthorPoint.y;
        width = recognizer.view.center.x - anthorPoint.x;
        CGFloat angle2 = atan(height / width);
        CGFloat angle = angle1 - angle2;
        
        recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, angle);
//        _rotateAngle += angle;
    }
    
}

//识别到旋转手势后的回调方法
- (void)rotate:(UIRotationGestureRecognizer *)recognizer
{
    //图片旋转
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    
    //将手势识别的旋转角度复位
    recognizer.rotation = 0.0;  //非常重要  角度也会叠加
}

-(void)addFinishBlock:(ImageBlock)block
{
    _block = block;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
