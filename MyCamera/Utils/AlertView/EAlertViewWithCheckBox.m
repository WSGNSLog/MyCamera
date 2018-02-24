//
//  EAlertViewWithCheckBox.m
//  eCamera
//
//  Created by wuxue on 2017/6/8.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "EAlertViewWithCheckBox.h"

@interface EAlertViewWithCheckBox ()
{
    EALERT_VIEW_BLOCK _okBlock;
    EALERT_VIEW_BLOCK _cancelBlock;
}
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *checkBoxMsg;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation EAlertViewWithCheckBox

- (void)confirmWithCheckBoxMessage:(NSString *)checkBoxMessage Title:(NSString *)title message:(NSString *)message leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName ok:(EALERT_VIEW_BLOCK)okBlock cancel:(EALERT_VIEW_BLOCK)cancelBlock{
    _okBlock = okBlock;
    _cancelBlock = cancelBlock;
    [self.cancleBtn setTitle:leftBtnName forState:UIControlStateNormal];
    [self.okBtn setTitle:rightBtnName forState:UIControlStateNormal];
    self.alertView.layer.cornerRadius = 5;
    self.alertView.clipsToBounds = YES;
    _checkBoxMsg.text = checkBoxMessage;
    _message.text = message;
    _title.text = title;
}

- (IBAction)cancleBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
    if (_okBlock) {
        _okBlock(sender);
    }
    
}
- (IBAction)confirmBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
    if (_cancelBlock) {
        _cancelBlock(sender);
    }
    
}
-(void)removeAlert{
    [self removeFromSuperview];
}


@end
