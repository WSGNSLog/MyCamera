//
//  RecordView.m
//  MyCamera
//
//  Created by shiguang on 2018/1/16.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "RecordView.h"
#import "RecordTimePickView.h"

typedef enum {
    RecordStateRecording,
    RecordStateOver
}RecordState;

@interface RecordView ()
{
    CAShapeLayer *_progressLayer;
    NSTimer *_timer;
    CGFloat progress;
}
@property (nonatomic,strong) NSTimer *recordTimer;
@property (nonatomic,weak) UIProgressView *progressV ;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIButton *moreBtn;
@property (nonatomic,weak) UIButton *confirmBtn;
@property (nonatomic,weak) RecordTimePickView *timePickView;
@property (nonatomic,weak) UIButton *remakeBtn;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UIView *outView;
@property (nonatomic,weak) UIImageView *centerView;
@property (nonatomic,assign) RecordState recordState;
@end

@implementation RecordView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WEAKSELF
        //CGFloat outV_Y = 27;
        CGFloat outV_H = 60;
        CGFloat outVBorder_W = 5;
        //最外层圈
        UIView *outerView = [[UIView alloc] init];
        outerView.alpha = 0.7;
        outerView.layer.cornerRadius = outV_H/2;
        outerView.layer.borderWidth = outVBorder_W;
        outerView.layer.borderColor = [UIColor transformWithHexString:@"#fdcccc"].CGColor;
        outerView.clipsToBounds = YES;
        //_outerView.frame = CGRectMake(LL_ScreenWidth/2-30, outV_Y, outV_H, outV_H);
        [self addSubview:outerView];
        self.outView = outerView;
        [outerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(outV_H));
            make.centerX.equalTo(weakSelf);
            make.centerY.equalTo(weakSelf).offset = 6;
        }];
        
        //内层圈
        CGFloat centerImgV_W = outV_H - outVBorder_W*2;
        UIImageView *centerImgV = [[UIImageView alloc]init];
        centerImgV.image = [UIImage imageNamed:@"camera_recordCenterImg"];
        //centerImgV.frame = CGRectMake(LL_ScreenWidth/2-30 + outVBorder_W, outV_Y + outVBorder_W, centerImgV_W, centerImgV_W);
        centerImgV.userInteractionEnabled = YES;
        centerImgV.layer.cornerRadius = centerImgV_W/2;
        centerImgV.clipsToBounds = YES;
        [self addSubview:centerImgV];
        self.centerView = centerImgV;
        [centerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(centerImgV_W));
            make.centerX.equalTo(outerView);
            make.centerY.equalTo(outerView);
        }];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [centerImgV addGestureRecognizer:longPress];
        
        //预览图
        UIImageView *photoImgV = [[UIImageView alloc]init];
        photoImgV.image = [UIImage imageNamed:@"PhotoLibDefaultImg"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thumbnailBtnClick)];
        [photoImgV addGestureRecognizer:tap];
        [self addSubview:photoImgV];
        photoImgV.userInteractionEnabled = YES;
        self.thumbImgV = photoImgV;
        [photoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@23);
            make.width.height.equalTo(@55);
            make.centerY.equalTo(centerImgV);
        }];
        UIButton *remakeBtn = [[UIButton alloc]init];
        [remakeBtn setImage:[UIImage imageNamed:@"camera_remakeBtnImg"] forState:UIControlStateNormal];
        [remakeBtn addTarget:self action:@selector(remakeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:remakeBtn];
        self.remakeBtn = remakeBtn;
        [self.remakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@25);
            make.width.height.equalTo(@35);
            make.centerY.equalTo(photoImgV);
        }];
        remakeBtn.hidden = YES;
        //更多按钮
        UIButton *moreBtn = [[UIButton alloc]init];
        [moreBtn setImage:[UIImage imageNamed:@"cameraMoreBtnPic"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
        self.moreBtn = moreBtn;
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-23);
            make.width.height.equalTo(@25);
            make.centerY.equalTo(centerImgV);
        }];
        //保存按钮
        UIButton *confirmBtn = [[UIButton alloc]init];
        [confirmBtn setImage:[UIImage imageNamed:@"CompleteBtnImg"] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        self.confirmBtn = confirmBtn;
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-23);
            make.width.height.equalTo(@35);
            make.centerY.equalTo(centerImgV);
        }];
        confirmBtn.hidden = YES;
        
        [self setUpProgressView];
        
        RecordTimePickView *timePickView = [[RecordTimePickView alloc]init];
        [self addSubview:timePickView];
        self.timePickView = timePickView;
        [timePickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf);
            make.height.equalTo(@30);
        }];
        timePickView.recordTimeSetBlock = ^(RecordTime recordTime) {
            switch (recordTime) {
                case RecordTime15:
                    weakSelf.duration = 15;
                    break;
                case RecordTime30:
                    weakSelf.duration = 30;
                default:
                    break;
            }
        };
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.text = @"0:00'";
        timeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(timePickView);
        }];
        self.timeLabel = timeLabel;
        timeLabel.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        
        self.recordState = RecordStateOver;
    }
    return self;
}
#pragma mark - 预览图点击
- (void)thumbnailBtnClick{
    self.thumbClickBlock();
}
#pragma mark - 更多按钮点击
- (void)moreBtnClick{
    self.moreBtnClickBlock();
}
#pragma mark - 完成按钮点击
- (void)confirmBtnClick{
    self.recordConfimBlock();
    self.outView.alpha = 1;
    self.centerView.alpha = 1;
    self.outView.userInteractionEnabled = YES;
    self.centerView.userInteractionEnabled = YES;
    [self endRecord];
}
#pragma mark - 结束录制、取消录制
- (void)endRecord{
    [self stopTimer];
    self.remakeBtn.hidden = YES;
    self.confirmBtn.hidden = YES;
    self.moreBtn.hidden = NO;
    self.timeLabel.hidden = YES;
    self.timeLabel.text = @"0.00'";
    self.thumbImgV.hidden = NO;
    self.timePickView.hidden = NO;
    self.outView.alpha = 1;
    self.centerView.alpha = 1;
    self.outView.userInteractionEnabled = YES;
    self.centerView.userInteractionEnabled = YES;
    [self.progressV setProgress:0.0];
}
#pragma mark - 完成录制
- (void)finishRecord{
    self.timeLabel.hidden = NO;
    self.remakeBtn.hidden = NO;
    self.confirmBtn.hidden = NO;
    self.outView.alpha = 0.4;
    self.centerView.alpha = 0.4;
    self.outView.userInteractionEnabled = NO;
    self.centerView.userInteractionEnabled = NO;
    self.RecordClick(RecordActionVideoEnd);
    [self stopTimer];
}
#pragma mark - 重新拍摄
- (void)remakeBtnClick{
    WEAKSELF
    [ECustomAlertView confirmWithTitle:@"重新拍摄" message:@" 拍摄视频还未保存，\r确定重新拍摄视频?" leftBtnName:@"取消" rightBtnName:@"确定" ok:^(id sender) {
        [weakSelf endRecord];
        weakSelf.remakeBlock();
    } cancel:^(id sender) {
    }];
    
}
- (void)longPress:(UIGestureRecognizer *)longPress {
    //
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            self.timePickView.hidden = YES;
            self.thumbImgV.hidden = YES;
            self.moreBtn.hidden = YES;
            self.timeLabel.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.outView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }];
            self.recordState = RecordStateRecording;
            if (self.RecordClick) {
                self.RecordClick(RecordActionVideoBegin);
            }
            [self startRecord];
        }
            break;
            
        case UIGestureRecognizerStateCancelled:{
            
            if (self.recordState == RecordStateRecording) {
                self.recordState = RecordStateOver;
                if (self.progressV.progress*self.duration < 3){
                    self.RecordClick(RecordActionResignTimeTooShort);
                }else{
                    self.RecordClick(RecordActionResignActive);
                }
                [self endRecord];
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.outView.transform = CGAffineTransformMakeScale(1, 1);
                }];
                
            }
            
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            
            if (self.recordState == RecordStateRecording) {
                self.recordState = RecordStateOver;
                if (self.progressV.progress*self.duration < 3) {
                    
                    self.RecordClick(RecordActionTimeTooShort);
                    
                    [self endRecord];
                    
                }else{
                    [self finishRecord];
                }
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.outView.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
            
        }
            break;
            
        case UIGestureRecognizerStateChanged:
            break;
        default:
            break;
    }
}


- (void)stopTimer{
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
}
#pragma mark - 进度条
- (void)setUpProgressView{
    UIProgressView *progressV=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressV.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2);
    progressV.transform = CGAffineTransformMakeScale(1.0, 2.0);
    progressV.trackTintColor=[UIColor whiteColor];
    progressV.progressTintColor=[UIColor transformWithHexString:@"#2fb9c3"];
    
    progress= 1.0;
    [self addSubview:progressV];
    self.progressV =progressV;
    
}
- (void)startRecord{
    NSTimer *recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                            target:self
                                                          selector:@selector(progressChanged:)
                                                          userInfo:nil
                                                           repeats:YES];
    self.recordTimer = recordTimer;
}
-(void)progressChanged:(NSTimer *)timer
{
    self.progressV.progress += 1.0/self.duration/100.0;
    self.timeLabel.text = [NSString stringWithFormat:@"%.02f'",self.progressV.progress*self.duration];
    if (self.progressV.progress >= progress) {
        //结束录制
        [self finishRecord];
        [UIView animateWithDuration:0.2 animations:^{
            self.outView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application{
    if (self.recordState == RecordStateRecording) {
        self.recordState = RecordStateOver;
        if (self.progressV.progress*self.duration < 3) {
            
            self.RecordClick(RecordActionTimeTooShort);
            
            [self endRecord];
            
        }else{
            [self finishRecord];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.outView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}
#pragma mark - 视频导出失败处理
- (void)videoExportFailHandle{
    self.recordState = RecordStateOver;
    
    self.RecordClick(RecordActionResignActive);
    
    [self endRecord];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.outView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}
@end

