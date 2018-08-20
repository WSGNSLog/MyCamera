
//
//  DrawDashedView.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "DrawDashedView.h"

@implementation DrawDashedView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createDashedTypeOption];
    }
    
    return self;
}
- (void)createDashedTypeOption{
    
    NSArray *imgArr = @[@"lineShape_circle",@"lineShape_square",@"lineShape_line",@"lineShape_triangle",@"lineShape_free"];
    NSArray *imgSelectedArr = @[@"lineShape_circle_highLight",@"lineShape_square_highLight",@"lineShape_line_highLight",@"lineShape_triangle_highLight",@"lineShape_free_highLight"];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"样式";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.frame = CGRectMake(15, (self.height-15)/2, 30, 15);
    [self addSubview:label];
    CGFloat margin = 15;
    CGFloat btnWH = 30;
    for (int i=0; i<5; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(label.x+label.width+margin*(i+1)+btnWH*i, (self.height-btnWH)/2.0, btnWH, btnWH);
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgSelectedArr[i]] forState:UIControlStateSelected];
        btn.selected = (i==self.shape? YES:NO);
        [btn addTarget:self action:@selector(shapeChangeClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.clipsToBounds = YES;
        [self addSubview:btn];
    }
    
}
- (void)shapeChangeClick:(UIButton *)btn{
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
