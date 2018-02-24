//
//  EMediaTool.m
//  eCamera
//
//  Created by shiguang on 2018/2/5.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "EMediaTool.h"
#import "PHAsset+ECamera.h"

@implementation EMediaTool
+ (void)getLatestAsset:(EPhotoCallBack)callBack{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            PHAsset *asset = [PHAsset latestAsset];
            // 在资源的集合中获取第一个集合，并获取其中的图片
            if (asset) {
                PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
                [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    ECameraAsset *photoAsset = nil;
                    if (imageData) {
                        UIImage * image = [UIImage imageWithData:imageData];
                        photoAsset = [[ECameraAsset alloc]initWithPHAsset:asset image:image];
                    }
                    if (callBack) {
                        callBack(photoAsset);
                    }
                }];
            } else {
                if (callBack) {
                    callBack(nil);
                }
            }
        } else {
            NSLog(@"status %ld",(long)status);
            if (callBack) {
                callBack(nil);
            }
        }
    }];
}
@end
