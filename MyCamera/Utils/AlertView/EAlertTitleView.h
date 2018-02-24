//
//  EAlertTitleView.h
//  eCamera
//
//  Created by wuxue on 2017/5/15.
//  Copyright © 2017年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EALERT_VIEW_BLOCK)(id sender);

@interface EAlertTitleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
-(void)confirmWithTitle:(NSString *)title message:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock;
-(void)removeAlert;
@end
