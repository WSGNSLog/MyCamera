//
//  UIButton+category.h
//  MyCamera
//
//  Created by shiguang on 2018/1/11.
//  Copyright © 2018年 shiguang. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIButton (category)
+(UIButton *)initWithFrame:(CGRect)frame normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectImage;
+(UIButton *)initWithFrame:(CGRect)frame title:(NSString *)text color:(UIColor *)color fontSize:(int)size;
@end
