//
//  ProgressBtnView.h
//  MyCamera
//
//  Created by shiguang on 2018/1/15.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBtnView : UIView
@property (assign, nonatomic) NSInteger timeMax;

- (void)clearProgress;

@end
