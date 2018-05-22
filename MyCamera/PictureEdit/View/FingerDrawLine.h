//
//  ZYJDrawLine.h
//  photoEdit
//
//  Created by 赵彦杰 on 2016/10/24.
//  Copyright © 2016年 赵彦杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FingerDrawLineInfo.h"

@interface FingerDrawLine : UIView

//所有的线条信息，包含了颜色，坐标和粗细信息 @see DrawPaletteLineInfo
@property(nonatomic,strong) NSMutableArray  *allMyDrawPaletteLineInfos;
//从外部传递的 笔刷长度和宽度，在包含画板的VC中 要是颜色、粗细有所改变 都应该将对应的值传进来
@property (nonatomic,strong)UIColor *currentPaintBrushColor;
@property (nonatomic)float currentPaintBrushWidth;

#pragma mark  外部调用的清空画板和撤销上一步

//清空画板
- (void)cleanAllDrawBySelf;
//撤销上一条线条
- (void)cleanFinallyDraw;

@end
