//
//  PHAsset+ECamera.m
//  eCamera
//
//  Created by shiguang on 2018/1/26.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "PHAsset+ECamera.h"

@implementation PHAsset (ECamera)
+ (PHAsset *)latestAsset {
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return [assetsFetchResults firstObject];
}
@end
