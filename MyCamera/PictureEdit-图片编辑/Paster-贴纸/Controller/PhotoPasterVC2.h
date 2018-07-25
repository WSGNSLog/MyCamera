//
//  PhotoPasterVC2.h
//  MyCamera
//
//  Created by shiguang on 2018/7/24.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoEditController.h"

@interface PhotoPasterVC2 : UIViewController

@property (nonatomic,strong) PHAsset *asset;
@property (nonatomic,strong) UIImage *image;


-(void)addFinishBlock:(ImageBlock)block;

@end
