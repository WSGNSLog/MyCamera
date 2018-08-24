//
//  CustomTextView.h
//  MyCamera
//
//  Created by shiguang on 2018/8/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTextView;

/**
 字幕输入view，进行文字输入，拖动，放大，旋转等
 */

@interface VideoTextBubble
@property(nonatomic , strong) UIImage *image;
@property(nonatomic , assign) CGRect  textNormalizationFrame;
@end

@protocol VideoTextFieldDelegate <NSObject>
- (void)onBubbleTap;
- (void)onTextInputDone:(NSString*)text textField:(CustomTextView*)textField;
- (void)onRemoveTextField:(CustomTextView*)textField;

@end
@interface CustomTextView : UIView
@property (nonatomic, weak) id<VideoTextFieldDelegate> delegate;
@property (nonatomic, copy, readonly) NSString* text;
@property (nonatomic, readonly) UIImage* textImage;             //生成字幕image

- (void)setTextBubbleImage:(UIImage *)image textNormalizationFrame:(CGRect)frame;

- (CGRect)textFrameOnView:(UIView*)view;

//关闭键盘
- (void)resignFirstResponser;

@end
