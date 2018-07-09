//
//  PicEditOptionView.h
//  MyCamera
//
//  Created by shiguang on 2018/6/21.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicEditOptionDelegate <NSObject>

- (void)picEditOptionCropClick;
- (void)picEditOptionRotateAndMirrorClick;

@end

@interface PicEditOptionView : UIView

@property (weak,nonatomic) id<PicEditOptionDelegate>delegate;

@end
