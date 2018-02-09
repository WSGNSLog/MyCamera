//
//  CameraModePickView.m
//  MyCamera
//
//  Created by shiguang on 2018/1/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "CameraModePickView.h"
#import "EButton.h"

#define ModeBtnWidth 30
#define ModeBtnMargin 30
@interface CameraModePickView()

@property (nonatomic,weak) UIButton *photoModeBtn;
@property (nonatomic,weak) UIButton *videoModeBtn;
@property (nonatomic,weak) UIView *pickerBaseView;
@end

@implementation CameraModePickView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor lightGrayColor];
        //CGFloat bottomV_H = 90;
        CGFloat btn_H = 20;
        CGFloat scroolV_W = ModeBtnWidth * 2+ModeBtnMargin;
        CGFloat btnFontSize = 13;
        CGFloat scroll_x = LL_ScreenWidth/2 - ModeBtnWidth/2;
        
        
        UIView *pickerBaseV = [[UIView alloc]init];
        pickerBaseV.frame = CGRectMake(scroll_x, 0, scroolV_W, PickerBarH);
        [self addSubview:pickerBaseV];
        self.pickerBaseView = pickerBaseV;
        
        EButton *photoBtn = [EButton buttonWithType:UIButtonTypeCustom];
        photoBtn.frame = CGRectMake(0, 0, ModeBtnWidth, btn_H);
        [photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
        photoBtn.titleLabel.font = [UIFont systemFontOfSize:btnFontSize];
        [photoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [photoBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        [photoBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateHighlighted];
        photoBtn.selected = YES;
        [photoBtn addTarget:self action:@selector(photoModeClick) forControlEvents:UIControlEventTouchUpInside];
        self.photoModeBtn = photoBtn;
        
        EButton *videoBtn = [EButton buttonWithType:UIButtonTypeCustom];
        videoBtn.frame = CGRectMake(ModeBtnWidth+33, 0, ModeBtnWidth, btn_H);
        [videoBtn setTitle:@"录像" forState:UIControlStateNormal];
        videoBtn.titleLabel.font = [UIFont systemFontOfSize:btnFontSize];
        [videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [videoBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
        [videoBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateHighlighted];
        [videoBtn addTarget:self action:@selector(videoModeClick) forControlEvents:UIControlEventTouchUpInside];
        self.videoModeBtn = videoBtn;
        
        [pickerBaseV addSubview:photoBtn];
        [pickerBaseV addSubview:videoBtn];
        self.pickerBaseView = pickerBaseV;

    }
    return self;
}
- (void)videoModeClick{
    CGFloat scroolV_W = ModeBtnWidth * 2 + ModeBtnMargin;
    CGFloat scroll_x = LL_ScreenWidth/2 - scroolV_W + ModeBtnWidth/2;
    //CGFloat scroll_y = LL_ScreenHeight - bottomV_H-5;
    if (self.photoModeBtn.isSelected) {
        self.videoModeClickBlock();
        self.videoModeBtn.selected = YES;
        self.photoModeBtn.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.pickerBaseView.frame = CGRectMake(scroll_x, 0, scroolV_W, PickerBarH);
        }];
        
    }
}
- (void)photoModeClick{
    CGFloat scroolV_W = ModeBtnWidth * 2 + ModeBtnMargin;
    CGFloat scroll_x = LL_ScreenWidth/2 - ModeBtnWidth/2;
    if (self.videoModeBtn.isSelected) {
        self.photoModeClickBlock();
        self.photoModeBtn.selected = YES;
        self.videoModeBtn.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.pickerBaseView.frame = CGRectMake(scroll_x, 0, scroolV_W, PickerBarH);
        }];
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
