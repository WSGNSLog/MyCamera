//
//  RecordView.h
//  MyCamera
//
//  Created by shiguang on 2018/1/16.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:int{
    RecordActionPhoto= 0,
    RecordActionVideoBegin= 1,
    RecordActionVideoEnd= 2,
    RecordActionVideoCancel= 3,
    RecordActionTimeTooShort = 4,
    RecordActionResignActive = 5,
    RecordActionResignTimeTooShort = 6,
    
}RecordAction;

typedef void(^MoreBtnClick)(void);
typedef void(^ThumbClick)(void);
typedef void(^RecordConfimBlock)(void);
typedef void(^RemakeClickBlock)(void);

@interface RecordView : UIView

@property(nonatomic,copy)void (^RecordClick)(RecordAction action);

@property (nonatomic,copy) MoreBtnClick moreBtnClickBlock;
@property (nonatomic,copy) ThumbClick thumbClickBlock;
@property (nonatomic,copy) RecordConfimBlock recordConfimBlock;
@property (nonatomic,copy) RecordConfimBlock remakeBlock;
@property(nonatomic,retain)UIImageView *thumbImgV;

@property (nonatomic, assign)NSInteger duration;

- (void)videoExportFailHandle;

@end

