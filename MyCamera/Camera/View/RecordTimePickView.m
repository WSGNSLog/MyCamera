//
//  RecordTimePickView.m
//  eCamera
//
//  Created by shiguang on 2018/1/26.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "RecordTimePickView.h"
#import "EButton.h"

#define ModeBtnWidth 30
#define ModeBtnMargin 30
#define btn_Y 5
@interface RecordTimePickView()

@property (nonatomic,weak) EButton *leftBtn;
@property (nonatomic,weak) EButton *rightBtn;
@property (nonatomic,weak) UIView *pickerBaseView;

@end

@implementation RecordTimePickView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat btn_H = 20;
        CGFloat scroolV_W = ModeBtnWidth * 2+ModeBtnMargin;
        CGFloat btnFontSize = 13;
        CGFloat scroll_x = LL_ScreenWidth/2 - ModeBtnWidth/2;
        
        
        UIView *pickerBaseV = [[UIView alloc]init];
        pickerBaseV.frame = CGRectMake(scroll_x, 0, scroolV_W, PickerBarH);
        [self addSubview:pickerBaseV];
        self.pickerBaseView = pickerBaseV;
        
        EButton *leftBtn = [EButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, btn_Y, ModeBtnWidth, btn_H);
        [leftBtn setTitle:@"15s" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:btnFontSize];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor transformWithHexString:@"#2fb9c3"] forState:UIControlStateSelected];
        [leftBtn setTitleColor:[UIColor transformWithHexString:@"#2fb9c3"] forState:UIControlStateHighlighted];
        leftBtn.selected = YES;
        [leftBtn addTarget:self action:@selector(photoModeClick) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn = leftBtn;
        
        EButton *rightBtn = [EButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(ModeBtnWidth+ModeBtnMargin, btn_Y, ModeBtnWidth, btn_H);
        [rightBtn setTitle:@"30s" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:btnFontSize];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor transformWithHexString:@"#2fb9c3"] forState:UIControlStateSelected];
        [rightBtn setTitleColor:[UIColor transformWithHexString:@"#2fb9c3"] forState:UIControlStateHighlighted];
        [rightBtn addTarget:self action:@selector(videoModeClick) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn = rightBtn;
        
        [pickerBaseV addSubview:leftBtn];
        [pickerBaseV addSubview:rightBtn];
        self.pickerBaseView = pickerBaseV;
        
    }
    return self;
}
- (void)videoModeClick{
    
    CGFloat scroolV_W = ModeBtnWidth * 2 + ModeBtnMargin;
    CGFloat scroll_x = LL_ScreenWidth/2 - scroolV_W + ModeBtnWidth/2;
    
    if (self.leftBtn.isSelected) {
        self.recordTimeSetBlock(RecordTime15);
        self.rightBtn.selected = YES;
        self.leftBtn.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.pickerBaseView.frame = CGRectMake(scroll_x, 0, scroolV_W, PickerBarH);
        }];
        
    }
}
- (void)photoModeClick{
    
    CGFloat scroolV_W = ModeBtnWidth * 2 + ModeBtnMargin;
    CGFloat scroll_x = LL_ScreenWidth/2 - ModeBtnWidth/2;
    
    if (self.rightBtn.isSelected) {
        self.recordTimeSetBlock(RecordTime30);
        self.leftBtn.selected = YES;
        self.rightBtn.selected = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.pickerBaseView.frame = CGRectMake(scroll_x, 0, scroolV_W, PickerBarH);
        }];
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}


@end
