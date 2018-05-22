//
//  PhotoRotateController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/21.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoRotateController.h"
#import "UIImage+Rotate.h"


@interface PhotoRotateController ()
{
    ImageBlock _block;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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
-(void)addFinishBlock:(ImageBlock)block
{
    _block = block;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
