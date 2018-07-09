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
            make.center.equalTo(weakSelf.contentView );
        }];
    }
    return self;
}
@end
