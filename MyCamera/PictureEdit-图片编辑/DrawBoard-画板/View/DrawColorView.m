
//
//  DrawColorView.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "DrawColorView.h"

@implementation DrawColorView{
    UIButton *selectedBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createColorBord];
    }
    
    return self;
}

-(void)createColorBord{

    
    //色板样式
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    
    //创建每个色块
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor blackColor],[UIColor redColor],[UIColor blueColor],
                       [UIColor greenColor],[UIColor yellowColor],[UIColor brownColor],
                       [UIColor orangeColor],[UIColor whiteColor],[UIColor orangeColor],
                       [UIColor purpleColor],[UIColor cyanColor],[UIColor lightGrayColor], nil];
    for (int i =0; i<colors.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.width/colors.count)*i, 0, self.width/colors.count, 20)];
        [self addSubview:btn];
        [btn setBackgroundColor:colors[i]];
        [btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            selectedBtn = [[UIButton alloc]init];
            selectedBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
            selectedBtn.layer.cornerRadius = 5;
            selectedBtn.layer.borderColor = [UIColor colorWithRed:0.36f green:0.72f blue:0.76f alpha:1.0f].CGColor;
            selectedBtn.layer.borderWidth = 1.5;
            [self addSubview:selectedBtn];
            [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(btn).offset = 5;
                make.top.left.equalTo(btn).offset = -3;
            }];
        }
    }
    [self bringSubviewToFront:selectedBtn];
}
//切换颜色
-(void)changeColor:(id)target{
    UIButton *btn = (UIButton *)target;
    
    if (self.DrawColorBlock) {
        self.DrawColorBlock([btn backgroundColor]);
    }
    [selectedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(btn).offset = 5;
        make.top.left.equalTo(btn).offset = -3;
    }];
    
}
@end
