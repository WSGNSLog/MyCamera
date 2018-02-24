//
//  ECustomAlertView.h
//  eCamera
//
//  Created by wuxue on 2017/5/15.
//  Copyright © 2017年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAlertView.h"
#import "EAlertTitleView.h"
#import "EAlertErrorView.h"
@interface ECustomAlertView : NSObject

+ (void)confirmWithMessage:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock;

+ (void)confirmWithTitle:(NSString *)title message:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock;

+ (void)confirmWithTitle:(NSString *)title message:(NSString *)errorMessage detailMessage:(NSString *)detailErrorMessage btnName:(NSString *)btnName  ok:(EALERT_VIEW_BLOCK)okBlock;


/**
 带复选框
 */
+ (void)confirmWithCheckBoxMessage:(NSString *)checkBoxMessage Title:(NSString *)title message:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock;
+ (void)removeAlert;
@end
