//
//  TakePhotoView.m
//  MyCamera
//
//  Created by shiguang on 2018/1/15.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "TakePhotoView.h"
#import "ProgressBtnView.h"
#import "Masonry.h"

@implementation TakePhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
        self.backgroundColor = [UIColor whiteColor];
        WEAKSELF
        ProgressBtnView *progressBtn = [[ProgressBtnView alloc]init];
        [self addSubview:progressBtn];
        [progressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.bottom.equalTo(weakSelf);
            make.centerX.equalTo(weakSelf);
        }];
    }
    
    return self;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
