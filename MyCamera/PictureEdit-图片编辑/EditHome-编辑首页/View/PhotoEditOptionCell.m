//
//  PhotoEditOptionCell.m
//  MyCamera
//
//  Created by shiguang on 2018/5/21.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoEditOptionCell.h"

@implementation PhotoEditOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iconView];
        WEAKSELF
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-5);
            make.top.left.equalTo(weakSelf).offset(5);
            make.height.equalTo(weakSelf.mas_width).offset(-10);
        }];
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = [UIFont systemFontOfSize:11];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.text = @"name";
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf.iconView.mas_bottom);
            make.bottom.equalTo(weakSelf.mas_bottom);
        }];
    }
    return self;
}
@end
