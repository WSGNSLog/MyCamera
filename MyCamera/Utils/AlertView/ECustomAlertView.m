//
//  ECustomAlertView.m
//  eCamera
//
//  Created by wuxue on 2017/5/15.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "ECustomAlertView.h"
#import "EAlertViewWithCheckBox.h"

@implementation ECustomAlertView

+ (void)confirmWithMessage:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[EAlertView class]] || [view isKindOfClass:[EAlertTitleView class]]||[view isKindOfClass:[EAlertErrorView class]]||[view isKindOfClass:[EAlertViewWithCheckBox class]]){
            [view removeFromSuperview];
            break;
        }
    }
    EAlertView *eAlertView = [[[NSBundle mainBundle]loadNibNamed:@"EAlertView" owner:self options:nil]lastObject];
    eAlertView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [eAlertView confirmWithMessage:message leftBtnName:leftBtnName rightBtnName:rightBtnName ok:okBlock cancel:cancelBlock];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:eAlertView.messgeLabel.text];
    eAlertView.messgeLabel.attributedText = content;
    [[UIApplication sharedApplication].keyWindow addSubview:eAlertView];
}

+ (void)confirmWithTitle:(NSString *)title message:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[EAlertView class]]||[view isKindOfClass:[EAlertTitleView class]]||[view isKindOfClass:[EAlertErrorView class]]||[view isKindOfClass:[EAlertViewWithCheckBox class]]){
            [view removeFromSuperview];
            break;
        }
    }
    EAlertTitleView *eAlertTitleView = [[[NSBundle mainBundle]loadNibNamed:@"EAlertTitleView" owner:self options:nil]lastObject];
    eAlertTitleView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [eAlertTitleView confirmWithTitle:title message:message leftBtnName:leftBtnName rightBtnName:rightBtnName ok:okBlock cancel:cancelBlock];
    [[UIApplication sharedApplication].keyWindow addSubview:eAlertTitleView];
}

+ (void)confirmWithTitle:(NSString *)title message:(NSString *)errorMessage detailMessage:(NSString *)detailErrorMessage btnName:(NSString *)btnName  ok:(EALERT_VIEW_BLOCK)okBlock{

    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[EAlertView class]] || [view isKindOfClass:[EAlertTitleView class]]||[view isKindOfClass:[EAlertErrorView class]]||[view isKindOfClass:[EAlertViewWithCheckBox class]]){
            [view removeFromSuperview];
            break;
        }
    }
    EAlertErrorView *eAlertView = [[[NSBundle mainBundle]loadNibNamed:@"EAlertErrorView" owner:self options:nil]lastObject];
    eAlertView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [eAlertView confirmWithTitle:title message:errorMessage detailMessage:detailErrorMessage btnName:btnName ok:okBlock];
    [[UIApplication sharedApplication].keyWindow addSubview:eAlertView];
}
+ (void)confirmWithCheckBoxMessage:(NSString *)checkBoxMessage Title:(NSString *)title message:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[EAlertView class]] || [view isKindOfClass:[EAlertTitleView class]]||[view isKindOfClass:[EAlertErrorView class]]||[view isKindOfClass:[EAlertViewWithCheckBox class]]){
            [view removeFromSuperview];
            break;
        }
    }
    EAlertViewWithCheckBox *eAlertView = [[[NSBundle mainBundle]loadNibNamed:@"EAlertViewWithCheckBox" owner:self options:nil]lastObject];
    eAlertView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [eAlertView confirmWithCheckBoxMessage:checkBoxMessage Title:title message:message leftBtnName:leftBtnName rightBtnName:rightBtnName ok:okBlock cancel:cancelBlock];
    [[UIApplication sharedApplication].keyWindow addSubview:eAlertView];
    
}

+ (void)removeAlert{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[EAlertView class]] || [view isKindOfClass:[EAlertTitleView class]]||[view isKindOfClass:[EAlertErrorView class]]||[view isKindOfClass:[EAlertViewWithCheckBox class]]){
            [view removeFromSuperview];
        }
    }
}
@end
