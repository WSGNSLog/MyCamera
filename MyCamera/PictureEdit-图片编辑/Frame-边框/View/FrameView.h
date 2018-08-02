//
//  FrameView.h
//  MyCamera
//
//  Created by shiguang on 2018/7/30.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameView : UIView

@property (nonatomic,strong) UIImage *frameImg;

- (instancetype)initWithFrame:(CGRect)frame showImage:(UIImage *)image;

- (UIImage *)getImage;

@end
