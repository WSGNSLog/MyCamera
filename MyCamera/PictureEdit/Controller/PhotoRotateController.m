//
//  PhotoRotateController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/21.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoRotateController.h"
#import "UIImage+Rotate.h"

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)
@interface PhotoRotateController ()<UIGestureRecognizerDelegate>
{
    ImageBlock _block;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign,nonatomic) CGFloat rotateAngle;
@end

@implementation PhotoRotateController
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
    self.imageView.userInteractionEnabled = YES;
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
- (IBAction)leftRotate:(UIButton *)sender {
    _imageView.image = [_imageView.image rotate:UIImageOrientationLeft];
}
- (IBAction)rightRotate:(UIButton *)sender {
    _imageView.image = [_imageView.image rotate:UIImageOrientationRight];
}
- (IBAction)vRotate:(UIButton *)sender {
    _imageView.image = [_imageView.image flipHorizontal];
}
- (IBAction)hRotate:(id)sender {
    _imageView.image = [_imageView.image flipVertical];
    
}
- (IBAction)resetClick:(id)sender {
    self.imageView.image = self.image;
}
- (void)addRotateGesture
{
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    
    rotate.delegate = self;
    [self.imageView addGestureRecognizer:rotate];
}
- (void)rotate:(UIRotationGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //        _rotateAngle = self.originAngle;
        self.rotateAngle = 0;
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        CGAffineTransform transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
        
        recognizer.view.transform = transform;
        CGFloat rotation = recognizer.rotation;
        _rotateAngle += rotation;
        NSLog(@"angle:%f rotation:%f",_rotateAngle,rotation);
        recognizer.rotation = 0.0;
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        //self.imageView.transform = CGAffineTransformIdentity;
        //        if ((_rotateAngle-self.originAngle)>0) {
        //            self.imageView.image = [self.imageView.image rotate:UIImageOrientationRight];
        //
        //        }else if((_rotateAngle-self.originAngle)<0){
        //            self.imageView.image = [self.imageView.image rotate:UIImageOrientationLeft];
        //        }
        
        
        __block CGAffineTransform transform = CGAffineTransformIdentity;
        NSLog(@"***:%f %f",self.rotateAngle,kDegreesToRadian(90)-(self.rotateAngle));
        
        
        [UIView animateWithDuration:0.25 animations:^{
            if ((self.rotateAngle)>0) {
                
                transform = CGAffineTransformRotate(recognizer.view.transform, kDegreesToRadian(90)-(self.rotateAngle));
            }else if((self.rotateAngle)<0){
                transform = CGAffineTransformRotate(recognizer.view.transform, kDegreesToRadian(-90)-(self.rotateAngle));
            }
            recognizer.view.transform = transform;
            CGFloat rotation = recognizer.rotation;
            _rotateAngle += rotation;
            NSLog(@"angle:%f rotation:%f",_rotateAngle,rotation);
            recognizer.rotation = 0.0;
            //            self.originAngle = _rotateAngle;
        } completion:^(BOOL finished) {
            recognizer.view.transform = CGAffineTransformIdentity;
            if ((self.rotateAngle)>0) {
                self.imageView.image = [self.imageView.image rotate:UIImageOrientationRight];
            }else if((self.rotateAngle)<0){
                self.imageView.image = [self.imageView.image rotate:UIImageOrientationLeft];
            }
        }];
        
        
    }
    
}
-(void)addFinishBlock:(ImageBlock)block
{
    _block = block;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
