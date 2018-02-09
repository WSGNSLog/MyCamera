//
//  UIImage+Common.h
//  BabyDaily
//
//  Created by 宣佚 on 15/4/26.
//  Copyright (c) 2015年 Andon Health Co,.Ltd;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
-(UIImage *)fixOrientation;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end
