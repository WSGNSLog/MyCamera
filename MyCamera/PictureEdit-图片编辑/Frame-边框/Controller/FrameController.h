//
//  FrameController.h
//  MyCamera
//
//  Created by shiguang on 2018/7/30.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameController : UIViewController

@property (nonatomic,strong) UIImage *originImg;

@property (copy,nonatomic) void(^ImageBlock)(UIImage *image);

@end
