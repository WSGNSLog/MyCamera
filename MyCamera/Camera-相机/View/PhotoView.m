//
//  PhotoView.m
//  MyCamera
//
//  Created by shiguang on 2018/1/16.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView()

@end
@implementation PhotoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        WEAKSELF
        
        //CGFloat outV_Y = 27;
        //CGFloat outV_H = 60;
        //CGFloat outVBorder_W = 5;
        
        
        
        
        UIButton *centerBtn = [[UIButton alloc]init];
        //centerBtn.frame = CGRectMake(LL_ScreenWidth/2-30, outV_Y, outV_H, outV_H);
        [centerBtn setImage:[UIImage imageNamed:@"cameraImgNormal"] forState:UIControlStateNormal];
        [centerBtn setImage:[UIImage imageNamed:@"cameraImgSelected"] forState:UIControlStateSelected];
        [centerBtn addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:centerBtn];
        [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf).offset = 6;
            make.width.height.equalTo(@60);
        }];
        
        UIImageView *photoImgV = [[UIImageView alloc]init];
        photoImgV.image = [UIImage imageNamed:@"PhotoLibDefaultImg"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thumbnailBtnClick)];
        [photoImgV addGestureRecognizer:tap];
        [self addSubview:photoImgV];
        photoImgV.userInteractionEnabled = YES;
        self.thumbnailImgV = photoImgV;
        [photoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@23);
            make.width.height.equalTo(@55);
            make.centerY.equalTo(centerBtn);
        }];
        
        self.moreBtn = [[UIButton alloc]init];
        [self.moreBtn setImage:[UIImage imageNamed:@"cameraMoreBtnPic"] forState:UIControlStateNormal];
        [self.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreBtn];
        
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-23);
            make.width.height.equalTo(@25);
            make.centerY.equalTo(centerBtn);
        }];
    }
    return self;
}
#pragma mark - 缩略图点击
- (void)thumbnailBtnClick{
    self.thumClickBlock();
}
#pragma mark - 更多按钮点击
- (void)moreBtnClick{
    self.moreClickBlock();
}
#pragma mark - 拍照按钮点击
- (void)takePhotoBtnClick{
    self.photoBtnClick();
}
#pragma mark - 手势
-(void)tapClick:(UITapGestureRecognizer * )tap{
    self.photoBtnClick();
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end

