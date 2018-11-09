//
//  PicAjustController.h
//  eCamera
//
//  Created by shiguang on 2018/10/25.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "BaseViewController.h"

@interface PicAjustController : BaseViewController

@property (strong,nonatomic) UIImage *originImg;
@property (nonatomic,copy) void(^ImageBlock)(UIImage *image);

@end
