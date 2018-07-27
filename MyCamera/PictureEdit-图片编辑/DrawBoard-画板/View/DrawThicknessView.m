//
//  DrawThicknessView.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "DrawThicknessView.h"

@implementation DrawThicknessView
{
    //当前笔触粗细选择器
    UISlider *slider;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createStrokeWidthSlider];
    }
    
    return self;
}

//创建笔触粗细选择器
-(void)createStrokeWidthSlider{
    slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    slider.maximumValue = 20;
    slider.minimumValue = 1;
    if (self.SliderChangeBlock) {
        self.SliderChangeBlock(1);
    }
    [self addSubview:slider];
}
- (void)sliderValueChange{
    if (self.SliderChangeBlock) {
        self.SliderChangeBlock(1);
    }
}

@end
