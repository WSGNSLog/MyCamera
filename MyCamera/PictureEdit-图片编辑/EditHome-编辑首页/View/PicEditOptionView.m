
//
//  PicEditOptionView.m
//  MyCamera
//
//  Created by shiguang on 2018/6/21.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PicEditOptionView.h"

@implementation PicEditOptionView



- (IBAction)photoCropClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(picEditOptionCropClick)]) {
        [self.delegate picEditOptionCropClick];
    }
}
- (IBAction)rotateAndMirrorClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(picEditOptionRotateAndMirrorClick)]) {
        [self.delegate picEditOptionRotateAndMirrorClick];
    }
}


@end
