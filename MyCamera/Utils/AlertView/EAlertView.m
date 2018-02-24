//
//  EAlertView.m
//  eCamera
//
//  Created by wuxue on 2017/5/15.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "EAlertView.h"

@interface EAlertView ()
{
    EALERT_VIEW_BLOCK _okBlock;
    EALERT_VIEW_BLOCK _cancelBlock;
}
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation EAlertView

- (void)confirmWithMessage:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock{
    _okBlock = okBlock;
    _cancelBlock = cancelBlock;
    [self.leftBtn setTitle:leftBtnName forState:UIControlStateNormal];
    [self.rightBtn setTitle:rightBtnName forState:UIControlStateNormal];
    self.messgeLabel.text = message;
    self.alertView.layer.cornerRadius = 5;
    self.alertView.clipsToBounds = YES;
}
- (IBAction)okBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
    if (_okBlock) {
        _okBlock(sender);
    }
}
- (IBAction)cancleBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
    if (_cancelBlock) {
        _cancelBlock(sender);
    }
}
-(void)removeAlert{
    [self removeFromSuperview];
}
@end
