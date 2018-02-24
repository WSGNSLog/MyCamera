

//
//  EAlertErrorView.m
//  eCamera
//
//  Created by wuxue on 2017/5/19.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "EAlertErrorView.h"

@interface EAlertErrorView ()
{
    EALERT_VIEW_BLOCK _okBlock;
}
@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation EAlertErrorView

-(void)confirmWithTitle:(NSString *)title message:(NSString *)errorMessage detailMessage:(NSString *)detailErrorMessage btnName:(NSString *)btnName  ok:(EALERT_VIEW_BLOCK)okBlock{

    _okBlock = okBlock;
    self.title.text = title;
    self.errorMessageLabel.text = errorMessage;
    self.detialErrorMessageLabel.text = detailErrorMessage;
    [self.confirmBtn setTitle:btnName forState:UIControlStateNormal];
    self.alertView.layer.cornerRadius = 5;
    self.alertView.clipsToBounds = YES;
}
- (IBAction)confimBtnClick:(UIButton *)sender {
    
    [self removeFromSuperview];
    if (_okBlock) {
        _okBlock(sender);
    }
}
-(void)removeAlert{
    [self removeFromSuperview];
}

@end
