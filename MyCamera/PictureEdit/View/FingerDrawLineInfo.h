//
//  ZYJDrawLineInfo.h
//  photoEdit
//
//  Created by 赵彦杰 on 2016/10/24.
//  Copyright © 2016年 赵彦杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface FingerDrawLineInfo : NSObject

@property (nonatomic,strong)NSMutableArray <__kindof NSValue *>*linePoints;//线条所包含的所有点
@property (nonatomic,strong)UIColor *lineColor;//线条的颜色
@property (nonatomic)float lineWidth;//线条的粗细

@end
