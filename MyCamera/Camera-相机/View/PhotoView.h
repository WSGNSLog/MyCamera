//
//  PhotoView.h
//  MyCamera
//
//  Created by shiguang on 2018/1/16.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhotoBtnClick)(void);
typedef void(^ThumbClick)(void);
typedef void(^MoreBtnClick)(void);

@interface PhotoView : UIView

@property (nonatomic,retain) UIButton * thumbnailBtn;
@property (nonatomic,retain) UIImageView * imageV;

@property (nonatomic,retain) UIImageView *thumbnailImgV;
@property (nonatomic,retain) UIButton * moreBtn;
@property (nonatomic,copy) ThumbClick thumClickBlock;

@property (nonatomic,copy) PhotoBtnClick photoBtnClick;

@property (nonatomic,copy) MoreBtnClick moreClickBlock;
@end

