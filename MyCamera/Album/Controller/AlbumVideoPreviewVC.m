//
//  AlbumVideoPreviewVC.m
//  eCamera
//
//  Created by shiguang on 2018/3/29.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "AlbumVideoPreviewVC.h"
#import "AlbumItemModel.h"
#import "Utils_DateInfo.h"
#define PlayStatusKey @"PlayItemStatusKey"
@interface AlbumVideoPreviewVC (){
    CGFloat toolBarBottom;
    CGFloat navigationHeight;
}
@property (nonatomic, assign) BOOL hideStatusBar;

@property (nonatomic, weak) IBOutlet UIView * statusView;
@property (nonatomic, weak) IBOutlet UILabel * dateLabel;
@property (nonatomic, weak) IBOutlet UILabel * timeLabel;
@property (nonatomic, weak) IBOutlet UIButton * backBtn;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UILabel * playTimeLb;
@property (nonatomic, weak) IBOutlet UILabel * durationLb;
@property (nonatomic, weak) IBOutlet UISlider * progressSlider;
@property (nonatomic, weak) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBottom;
@property (weak, nonatomic) IBOutlet UIView * playStatusView;
/** 单击 */
@property (nonatomic,strong) UITapGestureRecognizer *tap_single_viewGesture;

/** 双击 */
@property (nonatomic,strong) UITapGestureRecognizer *tap_double_imageViewGesture;

/** 双击放大 */
@property (nonatomic,assign) BOOL isDoubleClickZoom;
/** 单击 */
@property (nonatomic,copy) void (^ItemViewSingleTapBlock)();
@property (nonatomic, assign) BOOL hiddenBar;
@property (nonatomic, assign) BOOL sliding;
@property (nonatomic, strong) NSString * playUrl;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) AVPlayerItem * playerItem;
@end

@implementation AlbumVideoPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"beautify_base"] forState:UIControlStateNormal];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"beautify_base"] forState:UIControlStateSelected];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"beautify_base"] forState:UIControlStateHighlighted];
    [_progressSlider addTarget:self action:@selector(sliderEnd:) forControlEvents:(UIControlEventTouchUpInside)];
    [_progressSlider addTarget:self action:@selector(sliderEnd:) forControlEvents:(UIControlEventTouchUpOutside)];
    [_progressSlider addTarget:self action:@selector(playProgressSliderTouchDown:) forControlEvents:(UIControlEventTouchDown)];
    [_progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    
//    _vodPlayer = [TXVodPlayer new];
//    _vodPlayer.vodDelegate = self;
////    _vodPlayer.isAutoPlay = NO;
//    [_vodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
//    [_vodPlayer setupVideoWidget:self.view insertIndex:0];
    
    self.navigationController.navigationBarHidden = YES;
    _hideStatusBar = NO;
    
    
    if (LL_iPhoneX) {
        navigationHeight = 88;
        toolBarBottom = -34;
    }else{
//        _statusHeight.constant = 64;
        navigationHeight = 64;
        toolBarBottom = 0;
    }
    
    _statusHeight.constant = navigationHeight;
    _toolBottom.constant = toolBarBottom;
    
    
    [self.view addGestureRecognizer:self.tap_single_viewGesture];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _asset = _model.asset;
    self.dateLabel.text = [self dateSubstringInsertDataString:[NSMutableString stringWithString:[self.model.creationDate substringFromIndex:4]]];
    self.timeLabel.text = [self.model.creationTime substringToIndex:5];

    PHImageManager *phManage = [PHImageManager defaultManager];
    [phManage requestPlayerItemForVideo:_asset options:PHVideoRequestOptionsDeliveryModeAutomatic resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _playerItem = playerItem;
            AVAsset *set = _playerItem.asset;
            _avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
            _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
            _playerLayer.frame = self.view.bounds;
            [self.view.layer insertSublayer:_playerLayer below:_centerBtn.layer];
            int duration = ceil(CMTimeGetSeconds(set.duration));
            if (set) {
                _progressSlider.maximumValue = CMTimeGetSeconds(set.duration);
            }else{
                _progressSlider.maximumValue = 0;
            }

            int seconds = (int)duration % 60;
            int minutes = (int)(duration / 60) % 60;
            int hours = duration / 3600;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _durationLb.text =   [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
                
            });
            
            WEAKSELF
            [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 5) queue:nil usingBlock:^(CMTime time) {
                int duration = ceil(CMTimeGetSeconds(weakSelf.playerItem.currentTime));
                weakSelf.progressSlider.value = CMTimeGetSeconds(weakSelf.playerItem.currentTime);
                int seconds = (int)duration % 60;
                int minutes = (int)(duration / 60) % 60;
                int hours = duration / 3600;
                weakSelf.playTimeLb.text =   [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
                
            }];
        });
        
        //            _centerBtn.selected = YES;
        
        

        //        Print(@"%@",info);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _hiddenBar = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return _hiddenBar;
}

-(void)handleBarView{
    
    BOOL show = _statusView.tag == 0;
    _statusView.tag = show?1:0;
    _hiddenBar = YES;
    if (show) {
        _hiddenBar = YES;
        _statusHeight.constant = 0;
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        _hiddenBar = NO;
        
        _statusHeight.constant = navigationHeight;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    _centerBtn.alpha = _hiddenBar ? 0.0 : 1.0;
    _centerBtn.hidden = _hiddenBar;
//    _toolBar.hidden = show;
    _toolBottom.constant = !_hiddenBar ? toolBarBottom:(44);
    _toolBar.hidden = _hiddenBar;
//    _toolBottom
    [UIView animateWithDuration:.25f animations:^{
        
        [_statusView setNeedsLayout];
        [_statusView layoutIfNeeded];
        
        [_toolBar setNeedsLayout];
        [_toolBar layoutIfNeeded];
        
        [_statusView setNeedsLayout];
        [_statusView layoutIfNeeded];
    }];
    
}
- (void)singleTapAction
{
    if (_centerBtn.isSelected) {
        [self handleBarView];
        
        [_avPlayer pause];
        _centerBtn.selected = NO;
    }
}
-(NSString *)dateSubstringInsertDataString:(NSMutableString *)string{
    [string insertString:@"月" atIndex:2];
    [string insertString:@"日" atIndex:5];
    return string;
}
-(void)playProgressSliderTouchDown:(UISlider *)slider{
    _sliding = YES;
    [_avPlayer pause];
}
-(void)progressSliderValueChanged:(UISlider *)slider{
//    self.playTimeLb.text = [Utils_DateInfo timeFormatted:slider.value / slider.maximumValue ];
    int seconds = (int)slider.value % 60;
    int minutes = (int)(slider.value / 60) % 60;
    int hours = slider.value / 3600;
    //            _centerBtn.selected = YES;
    _playTimeLb.text =   [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];

}

-(void)playProgressSliderSeekTime:(UISlider *)slider{
//    if (_sliding) {
//        [_avPlayer seekToTime:CMTimeMultiplyByFloat64(_playerItem.duration, slider.value)];

//    }
//        [_avPlayer play];
//    if ([_vodPlayer isPlaying]) {
//        Print(@"重新开始");
//        [_vodPlayer resume];
//        _centerBtn.selected = YES;
//    }
    //    [_player seekToTime:slider.value];
    _sliding = NO;
}
- (void)sliderEnd:(UISlider *)slider
{
    [_avPlayer seekToTime:CMTimeMultiplyByFloat64(_playerItem.duration, slider.value/CMTimeGetSeconds(_playerItem.duration)) completionHandler:^(BOOL finished) {
        if (finished && _centerBtn.isSelected) {
            [_avPlayer play];
        }
    }];
    
}
#pragma mark - action

- (IBAction)back:(id)sender{
//    [_vodPlayer stopPlay];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)playClick:(UIButton *)sender{
    _autoPlay = YES;
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        if (_progressSlider.value == CMTimeGetSeconds(_playerItem.duration)) {
            _progressSlider.value = 0;
            [_avPlayer seekToTime:CMTimeMultiplyByFloat64(_playerItem.duration, _progressSlider.value/CMTimeGetSeconds(_playerItem.duration))];
        }
        [_avPlayer play];
        [self handleBarView];
    }else{
        [_avPlayer pause];
    }
}
#pragma mark - play delegate

- (void)playEnd:(NSNotification *)noti
{
    [_avPlayer pause];
    _centerBtn.selected = NO;
    _centerBtn.alpha = 1.0;
    [self handleBarView];
}
#pragma mark - set
-(UITapGestureRecognizer *)tap_single_viewGesture{
    
    if(_tap_single_viewGesture == nil){
        
        _tap_single_viewGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
//        [_tap_single_viewGesture requireGestureRecognizerToFail:self.tap_double_imageViewGesture];
    }
    
    return _tap_single_viewGesture;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
