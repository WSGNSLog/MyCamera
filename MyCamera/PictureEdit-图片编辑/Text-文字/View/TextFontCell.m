//
//  TextFontCell.m
//  MyCamera
//
//  Created by shiguang on 2018/8/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "TextFontCell.h"

@implementation TextFontCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:bgView];
        WEAKSELF
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf.contentView);
            make.height.equalTo(@(weakSelf.contentView.height-15));
            
        }];
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgView);
            make.left.right.equalTo(bgView);
        }];
        
        self.fontNameLabel = [[UILabel alloc]init];
        self.fontNameLabel.font = [UIFont systemFontOfSize:13];
        self.fontNameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.fontNameLabel];
        [self.fontNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_bottom);
            make.left.right.equalTo(bgView);
            make.bottom.equalTo(weakSelf.contentView);
        }];
    }
    return self;
}
@end
