//
//  FrameView.m
//  MyCamera
//
//  Created by shiguang on 2018/7/30.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "FrameView.h"

@interface FrameView ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *frameImgV;
@property (nonatomic,strong) UIImage *image;

@end

@implementation FrameView

- (instancetype)initWithFrame:(CGRect)frame showImage:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        [self initSubView];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)initSubView{
    if (self.imageView) {
        NSLog(@"=======");
    }
    self.imageView =  [[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    self.imageView.backgroundColor = self.backgroundColor;
    [self addSubview:self.imageView];
    self.frameImgV =  [[UIImageView alloc]initWithFrame:self.bounds];
    self.frameImgV.contentMode = UIViewContentModeScaleToFill;
//    self.frameImgV.backgroundColor = [UIColor clearColor];
    [self addSubview:self.frameImgV];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}
- (void)setFrameImg:(UIImage *)frameImg{
    _frameImg = frameImg;
    self.frameImgV.image = frameImg;
}

- (UIImage *)getImage{
    CGImageRef imgRef = self.image.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);

    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, 0);
    [self.image drawInRect:CGRectMake(0, 0, w, h)];
    [self.frameImg drawInRect:CGRectMake(0, 0, w, h)];

    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    
//    UIImage* image = nil;
//    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, 0);
//    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return resultImg;
}

@end
