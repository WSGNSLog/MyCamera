//
//  MyImageHelper.h
//  MyCamera
//
//  Created by shiguang on 2018/8/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyImageHelper : NSObject
//2.保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
