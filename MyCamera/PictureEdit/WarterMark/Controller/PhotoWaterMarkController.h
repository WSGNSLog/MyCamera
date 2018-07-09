//
//  PhotoWaterMarkController.h
//  MyCamera
//
//  Created by shiguang on 2018/5/23.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^ImageBlock)(UIImage *image);

@interface PhotoWaterMarkController : UIViewController
@property (nonatomic,strong) PHAsset *asset;
@property (nonatomic,strong) UIImage *originImg;

@property (copy,nonatomic) ImageBlock imageBlock;


@end
