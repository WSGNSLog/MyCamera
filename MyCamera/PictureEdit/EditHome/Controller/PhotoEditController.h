//
//  PhotoEditController.h
//  MyCamera
//
//  Created by shiguang on 2018/5/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(UIImage *image);

@interface PhotoEditController : UIViewController
@property (nonatomic,strong) PHAsset *asset;

@end
