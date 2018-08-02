//
//  ImageCutoutVC.h
//  MyCamera
//
//  Created by shiguang on 2018/7/31.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCutoutVC : UIViewController
@property(strong,nonatomic) UIImage * image;

@property (nonatomic,copy) void (^ImageBlock)(UIImage *image);

@end
