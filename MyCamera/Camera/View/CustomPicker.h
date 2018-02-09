//
//  CustomPicker.h
//  MyCamera
//
//  Created by shiguang on 2018/1/16.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CameraPickerViewDelegate <NSObject>

@optional

/**
 pickerView选中item代理
 @param row 选中的row
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row;
/**
 * pickerView开始滚动
 */
- (void)pickerViewBeginScroll;
@end
@interface CustomPicker : UIView

/** <#description#> */
@property (nonatomic,strong) UIImageView * PTZMiddleLineImgV;
/** PickerView 数据源 */
@property (nonatomic,strong) NSArray *dataModel;
/** 当前选择器选择的元素 （NSDictionary 类型， name：选择元素名称  index：选择元素位置）*/
@property (nonatomic,strong,readonly) NSDictionary *selectedItem;
/** 滑动到指定位置 */
@property (nonatomic,assign,setter=scrollToIndex:) NSInteger scrollToIndex;
/** pickerView代理 */
@property (nonatomic,weak) id<CameraPickerViewDelegate> delegate;
@end
