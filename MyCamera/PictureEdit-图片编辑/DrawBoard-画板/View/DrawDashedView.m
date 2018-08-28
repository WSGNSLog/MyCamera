
//
//  DrawDashedView.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "DrawDashedView.h"

#import "PhotoBeautyParam.h"

#define EdgeMargin 20
#define btnWH 30
@implementation DrawDashedView

- (instancetype)initWithFrame:(CGRect)frame DefaultType:(LineType)type{
    if (self = [super initWithFrame:frame]) {
        self.lineType = LineTypeDefault;
        [self createDashedTypeOption];
        self.backgroundColor = FuncViewBGColor
    }
    
    return self;
}
- (void)createDashedTypeOption{
    
    NSArray *imgArr = @[@"lineShape_line",@"icon_dashLineOne",@"icon_dashLineTwo",@"icon_dashLineThree"];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"线型";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.frame = CGRectMake(20, (self.height-15)/2, 30, 15);
    [self addSubview:label];
    
    for (int i=0; i<imgArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(label.x+label.width+EdgeMargin*(i+1)+btnWH*i, (self.height-btnWH)/2.0, btnWH, btnWH);
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highLight",imgArr[i]]] forState:UIControlStateSelected];
        btn.selected = (i==self.lineType? YES:NO);
        [btn addTarget:self action:@selector(lineTypeChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
- (void)lineTypeChange:(UIButton *)btn{
    btn.selected = YES;
    for (UIView *subV in self.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subV;
            if (subBtn.tag != btn.tag) {
                subBtn.selected = NO;
            }
        }
    }
    if (self.LineTypeChangeBlock) {
        self.LineTypeChangeBlock((int)btn.tag);
    }
}
@end
