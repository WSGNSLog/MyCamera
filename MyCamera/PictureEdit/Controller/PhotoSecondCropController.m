//
//  PhotoSecondCropController.m
//  MyCamera
//
//  Created by shiguang on 2018/6/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoSecondCropController.h"
#import "PECropView.h"

@interface PhotoSecondCropController ()
{
    PECropView *_cropView;
    
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (assign,nonatomic) CGFloat rotateAngle;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) CGAffineTransform originTransform;
@end

@implementation PhotoSecondCropController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cropView = [[PECropView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 40 - 70)];
    _cropView.image = self.image;
    //    _cropView.rotationGestureRecognizer.enabled = false;
    //    _cropView.keepingCropAspectRatio = true;
    _cropView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_cropView];
}


@end
