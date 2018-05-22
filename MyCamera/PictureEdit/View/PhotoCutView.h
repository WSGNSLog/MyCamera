//
//  PhotoCutView.h
//  MyCamera
//
//  Created by shiguang on 2018/5/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCutView : UIView
@property(nonatomic,assign)CGRect cutArea;

-(instancetype)initWithFrame:(CGRect)frame cutArea:(CGRect)cutArea;

@end
