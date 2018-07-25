//
//  PhotoPasterView.h
//  MyCamera
//
//  Created by shiguang on 2018/7/24.
//  Copyright © 2018年 shiguang. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol PasterViewDelegate <NSObject>
@required;
@optional;
- (void)deleteThePaster;
@end

@interface PhotoPasterView : UIView

/**YBPasterViewDelegate*/
@property (nonatomic,weak) id<PasterViewDelegate> delegate;
/**图片，所要加成贴纸的图片*/
@property (nonatomic, strong) UIImage *pasterImage;
/**隐藏“删除”和“缩放”按钮*/
- (void)hiddenBtn;
/**显示“删除”和“缩放”按钮*/
- (void)showBtn;

@end
