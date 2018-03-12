//
//  QBVideoIndicatorView.h
//  MyCamera
//
//  Created by shiguang on 2018/3/12.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBVideoIconView.h"
#import "QBSlomoIconView.h"

@interface QBVideoIndicatorView : UIView

@property (weak,nonatomic) IBOutlet UILabel *timelabel;
@property (weak,nonatomic) IBOutlet UIView* videoicon;
@property (weak,nonatomic) IBOutlet UIView* slomoicon;

@end
