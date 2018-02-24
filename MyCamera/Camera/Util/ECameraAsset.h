//
//  ECameraAsset.h
//  eCamera
//
//  Created by shiguang on 2018/1/26.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;
@class PHAsset;
@interface ECameraAsset : NSObject
@property (assign, nonatomic, readonly) NSTimeInterval creationTimeInterval;//创建时间戳
@property (strong, nonatomic, readonly, nonnull) UIImage *image;//原图
/**
 *  初始化
 *
 *  @param asset 相片信息 ALAsset PHAsset
 *
 *  @return
 */
- (instancetype _Nonnull)initWithPHAsset:(PHAsset * _Nonnull)asset image:(UIImage * _Nonnull)image;
- (instancetype _Nonnull)initWithCreation:(NSTimeInterval)creation image:(UIImage * _Nonnull)image;
@end
