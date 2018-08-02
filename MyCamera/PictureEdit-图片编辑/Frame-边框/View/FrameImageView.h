//
//  FrameImageView.h
//  MyCamera
//
//  Created by shiguang on 2018/7/31.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameImageView : UIImageView
/** 设置图片后的回调 */
@property (nonatomic,copy) void (^ImageSetBlock)(UIImage *image);


@property (nonatomic,assign) CGRect calF;

@end
