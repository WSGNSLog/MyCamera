//
//  PHAsset+ECamera.h
//  eCamera
//
//  Created by shiguang on 2018/1/26.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (ECamera)
/**
 *  获取最新一张图片
 */
+ (PHAsset *)latestAsset;
@end
