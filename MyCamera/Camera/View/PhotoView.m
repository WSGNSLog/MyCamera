//
//  PhotoView.m
//  MyCamera
//
//  Created by shiguang on 2018/1/16.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoView.h"
#import "EasyCamerPercentCycle.h"
@interface PhotoView()
@property(nonatomic,retain)EasyCamerPercentCycle * cycle;


@end
@implementation PhotoView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        WEAKSELF
        
        CGFloat outV_Y = 27;
        CGFloat outV_H = 60;
        CGFloat outVBorder_W = 5;
        
        self.cycle = [[EasyCamerPercentCycle alloc]init];
        [self addSubview:self.cycle];
        [self.cycle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
            make.width.height.equalTo(@117);
        }];
        self.cycle.hidden  = YES;
        
        
//        self.imageV = [[UIImageView alloc]init];
//        self.imageV.image = [UIImage imageNamed:@"easy_camera_photo"];
//        [self addSubview:self.imageV];
//        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@60);
//            make.centerX.equalTo(weakSelf);
//            make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
//        }];
//        self.imageV.userInteractionEnabled = YES;
//
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//        [self.imageV addGestureRecognizer:tap];
        
        UIImageView *photoImgV = [[UIImageView alloc]init];
        photoImgV.layer.borderColor = [UIColor whiteColor].CGColor;
        photoImgV.layer.borderWidth = 3;
        [photoImgV setBackgroundColor:[UIColor darkGrayColor]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thumbnailBtnClick)];
        [photoImgV addGestureRecognizer:tap];
        [self addSubview:photoImgV];
        self.thumbnailImgV = photoImgV;
        [photoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@23);
            make.width.height.equalTo(@55);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        }];

        UIButton *centerBtn = [[UIButton alloc]init];
        centerBtn.frame = CGRectMake(LL_ScreenWidth/2-30, outV_Y, outV_H, outV_H);
        [centerBtn setImage:[UIImage imageNamed:@"cameraImgNormal"] forState:UIControlStateNormal];
        [centerBtn setImage:[UIImage imageNamed:@"cameraImgSelected"] forState:UIControlStateSelected];
        [centerBtn addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:centerBtn];
        
        
//        self.thumbnailBtn = [[UIButton alloc]init];
//        self.thumbnailBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.thumbnailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.thumbnailBtn.layer.borderWidth = 3;
//        [self.thumbnailBtn setBackgroundColor:[UIColor darkGrayColor]];
//        [self.thumbnailBtn addTarget:self action:@selector(thumbnailBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        //    [self.operationView addSubview:self.thumbnailBtn];
//        [self addSubview:self.thumbnailBtn];
//
//        [self.thumbnailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@23);
//            make.width.height.equalTo(@55);
//            make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
//        }];
        
        self.moreBtn = [[UIButton alloc]init];
        self.moreBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.moreBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.moreBtn.layer.borderWidth = 3;
        [self.moreBtn setBackgroundColor:[UIColor darkGrayColor]];
        [self.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //    [self.operationView addSubview:self.thumbnailBtn];
        [self addSubview:self.moreBtn];
        
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-23);
            make.width.height.equalTo(@55);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        }];
    }
    return self;
}
- (void)thumbnailBtnClick{
    NSLog(@"thumbnailBtnClick");
}
- (void)moreBtnClick{
    
}
-(void)setVideoState:(BOOL)videoState{
    if (videoState == NO) {
        //self.image = [UIImage imageNamed:@"easy_camera_photo"];
        
        self.cycle.hidden = YES;
        
    }else{
        //self.image = [UIImage imageNamed:@"easy_camera_video_btn"];
        
        self.cycle.hidden = NO;
        self.cycle.progress = 0;
        
    }
}

-(void)setVideoPercent:(CGFloat)percent{
    self.cycle.progress = percent;
}
- (void)takePhotoBtnClick{
    self.photoBtnClick();
}
#pragma mark - 手势
-(void)tapClick:(UITapGestureRecognizer * )tap{
    NSLog(@"tap state = %zd",tap.state);
//    if (self.PhotoBtnClick) {
        self.photoBtnClick();
//    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
