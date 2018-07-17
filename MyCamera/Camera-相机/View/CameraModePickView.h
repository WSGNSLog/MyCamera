//
//  CameraModePickView.h
//  MyCamera
//
//  Created by shiguang on 2018/1/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhotoModeBtnClickBlock)(void);
typedef void(^VideoModeBtnClickBlock)(void);

@interface CameraModePickView : UIView

@property (nonatomic,copy) PhotoModeBtnClickBlock photoModeClickBlock;
@property (nonatomic,copy) VideoModeBtnClickBlock videoModeClickBlock;

@end
