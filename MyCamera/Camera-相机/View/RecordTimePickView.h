//
//  RecordTimePickView.h
//  eCamera
//
//  Created by shiguang on 2018/1/26.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:int{
    RecordTime15 = 0,
    RecordTime30 = 1,
}RecordTime;

typedef void (^RecordTimeSetBlock)(RecordTime recordTime);
@interface RecordTimePickView : UIView

@property (nonatomic,copy) RecordTimeSetBlock recordTimeSetBlock;

@end
