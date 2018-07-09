//
//  PhotoLocationController.h
//  MyCamera
//
//  Created by shiguang on 2018/5/23.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LocationBlock)(NSString *_Nullable locationNameStr,NSString *_Nullable addressStr);

@interface PhotoLocationController : UIViewController

@property (copy,nonatomic) LocationBlock _Nullable locationBlock;

@property (nonatomic,copy) NSString * _Nullable locationStr;

@end
