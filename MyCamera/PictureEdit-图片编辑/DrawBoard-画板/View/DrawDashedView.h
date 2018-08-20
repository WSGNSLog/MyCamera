//
//  DrawDashedView.h
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LineTypeDefault = 0,
    LineType1 = 1,
    LineType2 = 2,
    LineType3 = 3,
}LineType;
@interface DrawDashedView : UIView

@property (nonatomic,copy) void(^LineTypeChangeBlock)(LineType shape);
@property (nonatomic,assign) LineType shape;
- (instancetype)initWithFrame:(CGRect)frame DefaultType:(LineType)shape;
@end
