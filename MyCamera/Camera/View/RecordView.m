//
//  RecordView.m
//  MyCamera
//
//  Created by shiguang on 2018/1/16.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "RecordView.h"
#import "EasyCamerPercentCycle.h"
#import "RecordButton.h"
#import "RecordTimePickView.h"

@interface RecordView()<UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>
{
    UIView *_outerView;
    UIView *_centerView;
    CAShapeLayer *_progressLayer;
    NSTimer *_timer;
    CGFloat _progress;
    
    CGFloat progress;
}
@property (nonatomic,strong) UIProgressView *progressV ;
@property (nonatomic,strong) NSTimer *recordTimer;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,weak) RecordTimePickView *timePickView;

@end
@implementation RecordView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        WEAKSELF
        
        CGFloat height = 20;
        CGFloat width = 100;
        
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.frame = CGRectMake(LL_ScreenWidth/2-width, LL_ScreenHeight - height - PickerBarH, width, height);
        scrollView.contentSize = CGSizeMake(LL_ScreenWidth * 2, height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        //scrollView.scrollEnabled = NO;
        scrollView.delegate = self;
        
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        
        CGFloat outV_Y = 27;
        CGFloat outV_H = 60;
        CGFloat outVBorder_W = 5;
        _outerView = [[UIView alloc] init];
        _outerView.frame = CGRectMake(LL_ScreenWidth/2-30, outV_Y, outV_H, outV_H);

        _outerView.alpha = 0.7;
        _outerView.layer.cornerRadius = _outerView.width/2;
        _outerView.layer.borderWidth = outVBorder_W;
        _outerView.layer.borderColor = [UIColor transformWithHexString:@"#fdcccc"].CGColor;
        _outerView.clipsToBounds = YES;
        [self addSubview:_outerView];
        
        
        CGFloat centerImgV_W = outV_H - outVBorder_W*2;
        UIImageView *centerImgV = [[UIImageView alloc]init];
        centerImgV.image = [UIImage imageNamed:@"camera_recordCenterImg"];
        centerImgV.frame = CGRectMake(LL_ScreenWidth/2-30 + outVBorder_W, outV_Y + outVBorder_W, centerImgV_W, centerImgV_W);
        centerImgV.userInteractionEnabled = YES;
        centerImgV.layer.cornerRadius = centerImgV_W/2;
        centerImgV.clipsToBounds = YES;
        [self addSubview:centerImgV];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [centerImgV addGestureRecognizer:longPress];
        
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
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        }];
        
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
    }
    return self;
}
- (void)thumbnailBtnClick{
    self.thumbClickBlock();
}
- (void)longPress:(UIGestureRecognizer *)longPress {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(smartVideoControl:gestureRecognizer:)]) {
//        [self.delegate smartVideoControl:self gestureRecognizer:longPress];
//    }
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            [UIView animateWithDuration:0.2 animations:^{
                _outerView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }];
            if (self.RecordClick) {
                self.RecordClick(RecordActionVideoBegin);
            }
            [self startRecord];
        }
            break;
            
        case UIGestureRecognizerStateCancelled:{
            [UIView animateWithDuration:0.2 animations:^{
                _outerView.transform = CGAffineTransformMakeScale(1, 1);
            }];
            self.RecordClick(RecordActionVideoCancel);
            [self stopRecord];
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            
            [UIView animateWithDuration:0.2 animations:^{
                _outerView.transform = CGAffineTransformMakeScale(1, 1);
            }];
            self.RecordClick(RecordActionVideoEnd);
            [self stopRecord];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
            break;
        default:
            break;
    }
}

#pragma mark - Progress

- (void)stopRecord{
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
}

- (void)setUpProgressView{
    //实例化一个进度条，有两种样式，一种是UIProgressViewStyleBar一种是UIProgressViewStyleDefault，然并卵-->>几乎无区别
    UIProgressView *progressV=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
    progressV.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2);
    progressV.transform = CGAffineTransformMakeScale(1.0, 2.0);
    //设置进度条颜色
    progressV.trackTintColor=[UIColor whiteColor];
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    //pro.progress=0.7;
    //设置进度条上进度的颜色
    progressV.progressTintColor=[UIColor transformWithHexString:@"#2fb9c3"];
    //设置进度条的背景图片
    // pro.trackImage=[UIImage imageNamed:@"1"];
    //设置进度条上进度的背景图片 IOS7后好像没有效果了)
    //  pro.progressImage=[UIImage imageNamed:@"1.png"];
    //设置进度值并动画显示
    //  [pro setProgress:0.7 animated:YES];
    
    //由于pro的高度不变 使用放大的原理让其改变
    //pro.transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    //自己设置的一个值 和进度条作比较 其实为了实现动画进度
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
    self.progressV.progress += 1.0/_duration/100.0;
    if (self.progressV.progress >= progress) {
        [timer invalidate];
    }
}


#pragma mark - pickerView  delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return pickerView.frame.size.height*3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"666";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    CGAffineTransform rotateItem = CGAffineTransformMakeRotation(M_PI/2);
    rotateItem = CGAffineTransformScale(rotateItem, 1, 10);
    
    CGFloat width = self.frame.size.height;
    
    
    
    UILabel *labelPhoto = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, width-60, width)];
    labelPhoto.text = @"拍照";
//    labelPhoto.backgroundColor = [UIColor redColor];
    labelPhoto.font = [UIFont systemFontOfSize:13];
    CGPoint pointPhoto = labelPhoto.center;
    pointPhoto.y = self.center.y;
    labelPhoto.center = pointPhoto;
    
    UILabel *labelVideo = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, width-60, width)];
    labelVideo.text = @"录像";
    labelVideo.font = [UIFont systemFontOfSize:13];
//    labelVideo.backgroundColor = [UIColor blueColor];
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"==%ld",row);
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
