//
//  CustomPicker.m
//  MyCamera
//
//  Created by shiguang on 2018/1/16.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "CustomPicker.h"

#define itemHeight 20

@interface CustomPicker()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,assign)NSInteger indexOne;
@property (nonatomic,assign)NSInteger indexTwo;
@end


@implementation CustomPicker

{
    UIButton *upButton;
    UIButton *downButton;
    UIPickerView *picker;
    NSArray *dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self performSelector:@selector(initPickerView)];
    }
    return self;
}
/**
 *  初始化 选择器
 */
-(void)initPickerView{
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/2);
    rotate = CGAffineTransformScale(rotate, 0.1, 1);
    //旋转 -π/2角度
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height*10, self.frame.size.width)];
    
    [picker setTag: 10086];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = false;
    [picker setBackgroundColor:[UIColor clearColor]];
    
    [picker setTransform:rotate];
 
    picker.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
}
/**
 *  pickerView代理方法
 *
 *  @param component
 *
 *  @return pickerView有多少个元素
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
/**
 *  pickerView代理方法
 *
 *  @return pickerView 有多少列
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
/**
 *  pickerView代理方法
 *
 *  @param row row
 *  @param component component
 *  @param view view
 *
 *  @return 每个 item 显示的 视图
 */
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
    CGAffineTransform rotateItem = CGAffineTransformMakeRotation(M_PI/2);
    rotateItem = CGAffineTransformScale(rotateItem, 1, 10);
    
    CGFloat width = self.frame.size.height;
    
    
    
    UILabel *labelPhoto = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    labelPhoto.text = @"拍照";
    labelPhoto.backgroundColor = [UIColor redColor];
    labelPhoto.font = [UIFont systemFontOfSize:13];
    CGPoint pointPhoto = labelPhoto.center;
    pointPhoto.y = self.center.y;
    labelPhoto.center = pointPhoto;
    
    UILabel *labelVideo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    labelVideo.text = @"录像";
    labelVideo.font = [UIFont systemFontOfSize:13];
    labelVideo.backgroundColor = [UIColor blueColor];
    CGPoint pointVideo = labelVideo.center;
    pointVideo.y = self.center.y;
    labelVideo.center = pointVideo;
    
    labelPhoto.transform = rotateItem;
    labelVideo.transform = rotateItem;
    
    CGRect rect = labelPhoto.frame;
    rect.origin.y = 0;
  
    if (row == 0) {
        return labelPhoto;
    }else{
        return labelVideo;
    }
    
}

/**
 *  pickerVie代理方法
 *
 *  @return 每个item的宽度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return self.frame.size.height;
}
/**
 *  pickerView代理方法
 *
 *  @return 每个item的高度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return itemHeight;
}
/**
 *  数据源 Setter 方法
 *
 *  @param dataModel 数据数组
 */
-(void)setDataModel:(NSArray *)dataModel{
    dataArray = dataModel;
    [picker reloadAllComponents];
}

/**
 *  数据源 Getter 方法
 *
 *  @return 数据数组
 */
-(NSArray *)dataModel{
    return dataArray;
}

/**
 *  pickerView滑动到指定位置
 *
 *  @param scrollToIndex 指定位置
 */
-(void)scrollToIndex:(NSInteger)scrollToIndex{
    [picker selectRow:scrollToIndex inComponent:0 animated:true];
}
/**
 *  查询当前选择元素Getter方法
 *
 *  @return pickerView当前选择元素 （index：选择位置  name：元素名称）
 */
-(NSDictionary *)selectedItem{
    NSInteger index = [picker selectedRowInComponent:0];
    return @{@"index":[NSString stringWithFormat:@"%ld",index]};
}
/**
 * pickerView开始滚动
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.delegate pickerView:pickerView didSelectRow:row];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
