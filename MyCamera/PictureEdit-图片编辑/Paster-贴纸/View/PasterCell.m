//
//  PasterCell.m
//  MyCamera
//
//  Created by shiguang on 2018/6/15.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PasterCell.h"

@implementation PasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
}

@end
