//
//  DrawThicknessView.h
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawThicknessView : UIView

@property (nonatomic,copy) void(^SliderChangeBlock)(CGFloat sliderValue);


@end
