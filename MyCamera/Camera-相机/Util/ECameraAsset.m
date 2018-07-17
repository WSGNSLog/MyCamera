
//
//  ECameraAsset.m
//  eCamera
//
//  Created by shiguang on 2018/1/26.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "ECameraAsset.h"
#import "PHAsset+ECamera.h"

@implementation ECameraAsset
- (instancetype _Nonnull)initWithPHAsset:(PHAsset * _Nonnull)asset image:(UIImage * _Nonnull)image {
    return [self initWithCreation:asset.creationDate.timeIntervalSince1970 image:image];
}
- (instancetype _Nonnull)initWithCreation:(NSTimeInterval)creation image:(UIImage * _Nonnull)image {
    if (self = [super init] ) {
        _image = image;
        _creationTimeInterval = creation;
    }
    return self;
}
@end
