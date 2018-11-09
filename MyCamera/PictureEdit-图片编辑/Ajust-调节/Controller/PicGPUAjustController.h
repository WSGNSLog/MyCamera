//
//  PicGPUAjustController.h
//  MyCamera
//
//  Created by shiguang on 2018/11/5.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicGPUAjustController : UIViewController
@property (strong,nonatomic) UIImage *originImg;
@property (nonatomic,copy) void(^ImageBlock)(UIImage *image);


@end
