//
//  DrawBordController.h
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(UIImage *image);
@interface DrawBordController : UIViewController


@property (nonatomic,strong) UIImage *originImg;

@property (copy,nonatomic) ImageBlock imageBlock;
@end
