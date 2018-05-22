//
//  PhotoPasterController.h
//  MyCamera
//
//  Created by shiguang on 2018/5/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoEditController.h"

@interface PhotoPasterController : UIViewController
@property (nonatomic,strong) PHAsset *asset;
@property (nonatomic,strong) UIImage *image;


-(void)addFinishBlock:(ImageBlock)block;

@end
