//
//  EAlertErrorView.h
//  eCamera
//
//  Created by wuxue on 2017/5/19.
//  Copyright © 2017年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^EALERT_VIEW_BLOCK)(id sender);
@interface EAlertErrorView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *detialErrorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;



-(void)confirmWithTitle:(NSString *)title message:(NSString *)errorMessage detailMessage:(NSString *)detailErrorMessage btnName:(NSString *)btnName  ok:(EALERT_VIEW_BLOCK)okBlock;

-(void)removeAlert;
@end
