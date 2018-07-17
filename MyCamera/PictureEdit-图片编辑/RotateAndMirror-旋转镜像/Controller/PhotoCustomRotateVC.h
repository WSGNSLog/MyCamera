//
//  PhotoCustomRotateVC.h
//  MyCamera
//
//  Created by shiguang on 2018/6/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoEditController.h"

@interface PhotoCustomRotateVC : UIViewController
@property (nonatomic,strong) PHAsset *asset;
@property (nonatomic,strong) UIImage *image;

-(void)addFinishBlock:(ImageBlock)block;

@end
