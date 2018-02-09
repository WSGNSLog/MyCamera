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
}RecordAction;
typedef void(^ThumbClick)(void);

@interface RecordView : UIView

@property(nonatomic,copy)void (^RecordClick)(RecordAction action);

@property (nonatomic,copy)ThumbClick thumbClickBlock;
@property(nonatomic,retain)UIImageView *thumbImgV;

-(void)setVideoState:(BOOL)videoState;

-(void)setVideoPercent:(CGFloat)percent;
@property (nonatomic, assign)NSInteger duration;

@end
