//
//  CameraVC.m
//  MyCamera
//  
//  Created by shiguang on 2018/1/11.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "CameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMedia/CoreMedia.h>
#import <Photos/Photos.h>
#import "Helper.h"
#import "PhotoView.h"
#import "RecordView.h"
#import "CustomPicker.h"
#import "EButton.h"
#import "CameraModePickView.h"
#import "EasyCameraMedia.h"
#import "EasyCameraSQL.h"

@interface CameraVC ()<AVCaptureFileOutputRecordingDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CameraPickerViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) AVCaptureDevice *captureDevice;
@property (strong,nonatomic) AVCaptureDeviceInput *captureInput;
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property (strong,nonatomic) AVCaptureSession *captureSession;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *preview;

@property(nonatomic,retain) UIView *previewView;
@property(nonatomic,retain) UIView *operationView;
//@property(nonatomic,retain) UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

//@property(nonatomic,retain) EasyCameraPhotoBtn * photoBtn;
@property(nonatomic,retain) UIButton *flashLightBtn;
@property(nonatomic,retain) UIButton *camaraRotationBtn;
@property(nonatomic,retain) UIButton *thumbnailBtn;
@property(nonatomic,retain) UILabel *locationLabel;

@property(nonatomic,retain) NSString *city;
@property(nonatomic,retain) NSString *locationName;
@property(nonatomic,retain)NSString * country;
@property(nonatomic,retain)NSString * longtitude;
@property(nonatomic,retain)NSString * latitude;
@property(nonatomic,retain)NSString * district;

//@property(nonatomic,retain)CLLocationManager * locationManager;
@property(nonatomic,retain)NSTimer * videoTimer;
@property(nonatomic,assign)NSInteger videoTimeCountDown;
@property(nonatomic,assign) BOOL isCancelVideo;

@property(nonatomic,assign)BOOL isRecording;

@property(nonatomic,assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识

@property (nonatomic,retain) PhotoView *photoView;
@property (nonatomic,retain) RecordView *recordView;
@property(nonatomic,retain) UIButton *cameraRotationBtn;
@property (nonatomic,weak) CustomPicker *pickerView;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIButton *photoModeBtn;
@property (nonatomic,weak) UIButton *videoModeBtn;
@property (nonatomic,weak) UIScrollView *pickerScrollV;
@property (nonatomic,weak) UIView *pickerBaseView;
@property (nonatomic,weak) CameraModePickView *camModeBaseView;


@end

@implementation CameraVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.captureSession startRunning];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
//    _preview.frame = self.previewView.layer.bounds;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
//    EasyCameraMedia * media = [EasyCameraSQL selectLastMedia];
//    if (media == nil) {
//        self.thumbnailBtn.hidden = YES;
//    }else{
//        self.thumbnailBtn.hidden = NO;
//    }
//
//    UIImage * thumbImage = [UIImage imageWithContentsOfFile:[media filePath]];
//    [self.thumbnailBtn setImage:thumbImage forState:UIControlStateNormal];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    WEAKSELF
//    self.photoBtn.tipLabel.hidden = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (weakSelf.videoTimer == nil) {
//            weakSelf.photoBtn.tipLabel.hidden = YES;
//        }
//    });
}
- (void)applicationDidBecomeActive:(UIApplication *)application {

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.captureSession stopRunning];
    
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAKSELF
    if([Helper checkCameraAuthorizationStatus]){
        [self setupCamera];
    }
    RecordView *recView = [[RecordView alloc]init];
    CGFloat height = 96;
    recView.frame = CGRectMake(LL_ScreenWidth, 0, LL_ScreenWidth, height);
    recView.duration = 15;
    [recView setRecordClick:^(RecordAction action) {
        switch (action) {
            case RecordActionPhoto:
            {
                [weakSelf photoBtnClick];
            }
                break;
            case RecordActionVideoBegin:
            {
                [weakSelf videoStart];
            }
                break;
            case RecordActionVideoEnd:
            {
                [weakSelf videoEnd];
            }
                break;
            case RecordActionVideoCancel:
            {
                [weakSelf videoCancel];
                
            }
                break;
            default:
                break;
        }
        
    } ];
    #pragma mark - 录像状态相册点击
    recView.thumbClickBlock = ^{
        
    };
    self.recordView = recView;

    
    PhotoView *photoView = [[PhotoView alloc]init];
    photoView.frame = CGRectMake(0, 0, LL_ScreenWidth, height);
    
    
    self.photoView = photoView;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = CGRectMake(0, LL_ScreenHeight - height - PickerBarH, LL_ScreenWidth, height);
    scrollView.contentSize = CGSizeMake(LL_ScreenWidth * 2, height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    [scrollView addSubview:photoView];
    [scrollView addSubview:recView];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self initPreviewView];
    //TODO: photoBtnClick
    photoView.photoBtnClick = ^(){
        [weakSelf photoBtnClick];
    };
//    [self intiOperationView];
   

    [self.view bringSubviewToFront:self.closeBtn];
    [self.view bringSubviewToFront:scrollView];
    
    [self initCameraModePickView];
}
- (void)initCameraModePickView{
    CGFloat bottomV_H = 34;
    CGFloat btn_W = 60;

    CameraModePickView *modePickView = [[CameraModePickView alloc]init];
    modePickView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    modePickView.frame = CGRectMake(0, LL_ScreenHeight - PickerBarH, LL_ScreenWidth, bottomV_H);
    [self.view addSubview:modePickView];
    self.camModeBaseView = modePickView;
    
    WEAKSELF
    modePickView.photoModeClickBlock = ^{
        [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    };
    modePickView.videoModeClickBlock = ^{
        [weakSelf.scrollView setContentOffset:CGPointMake(LL_ScreenWidth, 0) animated:YES];
    };
    
}

-(void)initPickerView{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    CGFloat pk_h = 30;
    CustomPicker *pickerView  = [[CustomPicker alloc]initWithFrame:CGRectMake(0, LL_ScreenHeight - pk_h, LL_ScreenWidth, pk_h)];
    pickerView.delegate = self;
    pickerView.dataModel = dataArray;
    pickerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [pickerView scrollToIndex:([dataArray count]*1000)/2];
    self.pickerView = pickerView;
    
    [self.view addSubview:pickerView];
    
}
#pragma - mark pickerView选中item代理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row{

}
- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupCamera{
    
    // 视频设备
    if ([self cameraWithPosition:AVCaptureDevicePositionBack]) {
        self.captureDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    }else if ([self cameraWithPosition:AVCaptureDevicePositionFront]){
        self.captureDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }else{
        [MBProgressHUD showError:@"相机不可用"];
        return;
    }
    
    NSError * error;
    WEAKSELF
    // 视频输入
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
    if (error) {
        UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertContr addAction:cancleAction];
        [self presentViewController:alertContr animated:YES completion:nil];
        
    }
    //音频设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    //音频输入
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        WEAKSELF
        UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertContr addAction:cancleAction];
        [self presentViewController:alertContr animated:YES completion:nil];
        
        return;
    }
    
    // 拍照图片输出
    self.captureStillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [self.captureStillImageOutput setOutputSettings:outputSettings];
    //视频输出
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
    self.captureMovieFileOutput.movieFragmentInterval = kCMTimeInvalid;
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([captureConnection isVideoStabilizationSupported ]) {
        captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
    }
    
    // 初始化会话
    self.captureSession = [[AVCaptureSession alloc]init];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    //给设备添加输入
    if ([self.captureSession canAddInput:self.captureInput])
    {
        [self.captureSession addInput:self.captureInput];//视频输出
        [self.captureSession addInput:audioCaptureDeviceInput];//音频输出
    }
    
    //将图片输出添加到会话中
    if ([self.captureSession canAddOutput:self.captureStillImageOutput])
    {
        [self.captureSession addOutput:self.captureStillImageOutput];
    }
    //将音频输出添加到会话中
    if ([self.captureSession canAddOutput:self.captureMovieFileOutput]) {
        [self.captureSession addOutput:self.captureMovieFileOutput];
        AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    // 预览层
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.preview.videoGravity=AVLayerVideoGravityResizeAspect;//填充模式
}

#pragma mark - 视图初始化
-(void)initPreviewView{
    self.previewView = [[UIView alloc]init];
    self.previewView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.previewView];
    WEAKSELF
    [self.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    
    [self.previewView.layer addSublayer:_preview];
}

-(void)intiOperationView{
//    self.operationView = [[UIView alloc]init];
//    self.operationView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.operationView];
//

    
    self.flashLightBtn = [[UIButton alloc]init];
    [self.flashLightBtn setImage:[UIImage imageNamed:@"easy_camera_flashlight_0"] forState:UIControlStateNormal];
    [self.flashLightBtn addTarget:self action:@selector(flashLightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.operationView addSubview:self.flashLightBtn];
    [self.view addSubview:self.flashLightBtn];
    
    self.cameraRotationBtn = [[UIButton alloc]init];
    [self.cameraRotationBtn setImage:[UIImage imageNamed:@"easy_camera_rotation"] forState:UIControlStateNormal];
    [self.cameraRotationBtn addTarget:self action:@selector(cameraRotationBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.operationView addSubview:self.cameraRotationBtn];
    [self.view addSubview:self.cameraRotationBtn];
    
    
    WEAKSELF
    
//    self.photoView = [[PhotoView alloc]init];
    [self.photoView setVideoState:NO];
    
//    [self.photoView setPhotoBtnClick:^(PhotoBtnActionPhoto action) {
//        switch (action) {
//            case PhotoBtnActionPhoto:
//            {
//                [weakSelf photoBtnClick];
//            }
//                break;
//            case PhotoBtnActionVideoBegin:
//            {
//                [weakSelf videoStart];
//            }
//                break;
//            case PhotoBtnActionVideoEnd:
//            {
//                [weakSelf videoEnd];
//            }
//                break;
//            case PhotoBtnActionVideoCancel:
//            {
//                [weakSelf videoCancel];
//                
//            }
//                break;
//            default:
//                break;
//        }
//    }];
//    [self.operationView addSubview:self.photoBtn];
    [self.view addSubview:self.photoView];
    
//    self.thumbnailBtn = [[UIButton alloc]init];
//    self.thumbnailBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.thumbnailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.thumbnailBtn.layer.borderWidth = 3;
//    [self.thumbnailBtn setBackgroundColor:[UIColor darkGrayColor]];
//    [self.thumbnailBtn addTarget:self action:@selector(thumbnailBtnClick) forControlEvents:UIControlEventTouchUpInside];
////    [self.operationView addSubview:self.thumbnailBtn];
//    [self.photoView addSubview:self.thumbnailBtn];
    
//    if (LL_iPhoneX) {
//        [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.view).offset(LL_StatusBarHeight +20);
//            make.bottom.equalTo(weakSelf.view).offset(-LL_TabbarSafeBottomMargin);
//            make.left.right.equalTo(weakSelf.view);
//        }];
//    }else{
//        [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.view);
//            make.bottom.equalTo(weakSelf.view).offset(-LL_TabbarSafeBottomMargin);
//            make.left.right.equalTo(weakSelf.view);
//        }];
//    }
    
    
//    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.operationView).offset(-15);
//        make.top.equalTo(@18);
//        make.left.equalTo(weakSelf.cameraRotationBtn.mas_right).offset(10);
//
//    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.left.equalTo(@15);
        make.height.width.equalTo(@32);
    }];
    
    [self.flashLightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.closeBtn);
        make.left.equalTo(weakSelf.closeBtn.mas_right).offset(20);
        make.height.width.equalTo(@32);
    }];
    
    [self.cameraRotationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.closeBtn);
        make.height.width.equalTo(@32);
        make.left.equalTo(weakSelf.flashLightBtn.mas_right).offset(20);
    }];
    
//    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.operationView.mas_bottom).offset(-85);
//        make.centerX.equalTo(weakSelf.operationView);
//    }];
    [self.thumbnailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.photoView);
        make.left.equalTo(@23);
        make.width.height.equalTo(@55);
    }];
}
#pragma mark - 按钮事件

-(void)videoTimerAction{
    self.videoTimeCountDown -= 1;
    if (self.videoTimeCountDown <= 0) {
        NSLog(@"时间结束，录制完成");
        self.isRecording = NO;
        [_captureMovieFileOutput stopRecording];
    }
    [self.photoView setVideoPercent:(30-self.videoTimeCountDown)/30.0];
}
-(void)videoStart{
    
    if([Helper checkCameraAuthorizationStatus] == NO){
        return;
    }
    if([Helper checkMicAuthorizationStatus] == NO){
        return;
    }
    self.isRecording = YES;
    
    //修改UI显示
    [self.photoView setVideoState:YES];
    
    self.closeBtn.hidden = YES;
    self.cameraRotationBtn.hidden = YES;
    self.flashLightBtn.hidden = YES;
    self.thumbnailBtn.hidden = YES;
    
    //开始录制
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //预览图层和视频方向保持一致
    captureConnection.videoOrientation = [self.preview connection].videoOrientation;
    
    NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFielPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputFielPath error:nil];
    }
    
    NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
    [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    
    //如果支持多任务则则开始多任务
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        self.backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
}
-(void)videoEnd{
    if (self.isRecording == YES) {
        self.isRecording = NO;
        NSLog(@"结束录制");
        [_captureMovieFileOutput stopRecording];
    }
    
}
-(void)videoCancel{
    if (self.isRecording == YES) {
        NSLog(@"取消录制");
        self.isRecording = NO;
        self.isCancelVideo = YES;
        [_captureMovieFileOutput stopRecording];
    }
}
//拍照
-(void)photoBtnClick{
    if([Helper checkCameraAuthorizationStatus] == NO){
        return;
    }
    NSLog(@"拍照");
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    WEAKSELF
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *imageTemp = [UIImage imageWithData:imageData];
            
            UIImage *image = [ToolFunction cropImage:imageTemp Rect:weakSelf.view.frame];
            
            image = [image fixOrientation];
            
            if([weakSelf.preview connection].videoOrientation == AVCaptureVideoOrientationLandscapeLeft){
                image = [UIImage image:image rotation:UIImageOrientationRight];
                
            }else if([weakSelf.preview connection].videoOrientation== AVCaptureVideoOrientationLandscapeRight){
                image = [UIImage image:image rotation:UIImageOrientationLeft];
                
            }else if([weakSelf.preview connection].videoOrientation == AVCaptureVideoOrientationPortraitUpsideDown){
                image = [UIImage image:image rotation:UIImageOrientationDown];
            }
            
            //保存到相册
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
            //写入文件
            NSDate * now = [NSDate date];
            NSString * fileName = [NSString stringWithFormat:@"%zd.jpg",[now timeIntervalSince1970] * 1000];
            NSFileManager * fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"easycamera"];
            if (![fileManager fileExistsAtPath:diskCachePath]) {
                [fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            NSString * filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,fileName] ;
            [UIImageJPEGRepresentation(image, 0.75) writeToFile:filePath atomically:YES];
            
            //写入数据库
            EasyCameraMedia * media = [[EasyCameraMedia alloc]init];
            media.type = EasyCameraMediaTypeImage;
            media.fileName = fileName;
            media.city = weakSelf.city ;
            media.country = weakSelf.country;
            media.locationName = weakSelf.locationName;
            media.latitude = weakSelf.latitude;
            media.longitude = weakSelf.longtitude;
            media.district = weakSelf.district;
            media.dateInfo = now;
//            media.phoneNum = [Login curLoginUser].phone;
//
//            [EasyCameraSQL insertEasyCameraMediaWith:media];
            
            //weakSelf.thumbnailBtn.hidden = NO;
            //[weakSelf.thumbnailBtn setImage:image forState:UIControlStateNormal];
            [ToolFunction saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(image) customAlbumName:@"乐鱼" completionBlock:^{
                //[MBProgressHUD showSuccess:@"保存成功"];
            } failureBlock:^(NSError *error) {
                [MBProgressHUD showError:@"保存失败"];
            }];
//            [weakSelf.photoView.thumbnailBtn setImage:image forState:UIControlStateNormal];
            weakSelf.photoView.thumbnailImgV.image = image;
            
            CGFloat kAnimationDuration = 0.3f;
            CAGradientLayer *contentLayer = (CAGradientLayer *)weakSelf.photoView.thumbnailImgV.layer;
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
            scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
            scaleAnimation.duration = kAnimationDuration;
            scaleAnimation.cumulative = NO;
            scaleAnimation.repeatCount = 1;
            [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            [contentLayer addAnimation: scaleAnimation forKey:@"myScale"];

        }
    }];
    
}
#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    //打开倒计时
    self.videoTimeCountDown = 30;
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimerAction) userInfo:nil repeats:YES];
    NSLog(@"开始录制");
    
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    [self.videoTimer invalidate];
    self.videoTimer = nil;
    //    [self.photoBtn setVideoState:NO];
    
    self.closeBtn.hidden = NO;
    self.cameraRotationBtn.hidden = NO;
    self.flashLightBtn.hidden = NO;
    EasyCameraMedia * lastMedia = [EasyCameraSQL selectLastMedia];
    if (lastMedia == nil) {
        self.thumbnailBtn.hidden = YES;
    }else{
        self.thumbnailBtn.hidden = NO;
    }
    
    if (self.isCancelVideo == YES) {
        self.isCancelVideo = NO;
        NSLog(@"取消录制 finish");
        return;
    }
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:outputFileURL];
    CMTime time = [avUrl duration];
    CGFloat duration = CMTimeGetSeconds(time);
    if(duration <1 ){
        [MBProgressHUD showText:@"录制时间太短"];
        return;
    }
    [MBProgressHUD showMessage:@"正在保存文件"];
    
    //视频文件转换后存到本地
    NSDate * now = [NSDate date];
    NSString * fileName = [NSString stringWithFormat:@"%zd.mp4",[now timeIntervalSince1970] * 1000];
    NSString * thumbFileName = [NSString stringWithFormat:@"%zd.jpg",[now timeIntervalSince1970] * 1000];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"easycamera"];
    if (![fileManager fileExistsAtPath:diskCachePath]) {
        [fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString * filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,fileName] ;
    NSString * thumbFilePath = [NSString stringWithFormat:@"%@/%@",diskCachePath,thumbFileName] ;
    [ToolFunction transMovToMP4:outputFileURL.absoluteString Output:filePath];
    
    
    //写数据库
    EasyCameraMedia * media = [[EasyCameraMedia alloc]init];
    media.type = EasyCameraMediaTypeVideo;
    media.fileName = fileName;
    media.thumbPath = thumbFileName;
    media.city = self.city ;
    media.country = self.country;
    media.locationName = self.locationName;
    media.dateInfo = now;
    media.phoneNum = @"15000000000";
    media.duration = duration;
    media.latitude = self.latitude;
    media.longitude = self.longtitude;
    media.district = self.district;
    
    [EasyCameraSQL insertEasyCameraMediaWith:media];
    
    UIImage * thumbImage = [self getVideoPreViewImage:[NSURL fileURLWithPath:filePath]];
    [self.thumbnailBtn setImage:thumbImage forState:UIControlStateNormal];
    self.thumbnailBtn.hidden = NO;
    [UIImageJPEGRepresentation(thumbImage, 0.75) writeToFile:thumbFilePath atomically:YES];
    
    
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier=self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
    //存到手机相册
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:filePath] completionBlock:^(NSURL *assetURL, NSError *error ) {
        
        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
        [MBProgressHUD hideHUD];
        
        if (error) {
            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
            [MBProgressHUD showError:@"保存失败"];
        }else{
            NSLog(@"finish 保存文件");
            [MBProgressHUD showSuccess:@"保存成功"];
        }
    }];
}

- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}
#pragma mark - 打开相册
-(void)thumbnailBtnClick{
//    EasyCameraAlbumListViewController * vc = [[EasyCameraAlbumListViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}
//关闭拍照界面
-(void)closeBtnClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//切换闪光灯模式
-(void)flashLightBtnClick{
    if([Helper checkCameraAuthorizationStatus] == NO){
        return;
    }
    if(self.captureDevice){
        if (self.captureDevice.position == AVCaptureDevicePositionFront) {
            [MBProgressHUD showError:@"前置摄像头不支持闪关灯"];
            return;
        }
    }
    
    NSInteger mode =  self.captureDevice.flashMode;
    mode += 1;
    if (mode == 3) {
        mode = 0;
    }
    
    [self changeFlashlight:(AVCaptureFlashMode)mode];
    [self.flashLightBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"easy_camera_flashlight_%zd",mode]] forState:UIControlStateNormal];
}

-(void)changeFlashlight:(int32_t)flag{
    
    [self.captureSession beginConfiguration];
    [self.captureInput.device lockForConfiguration:nil];
    
    // Set torch to on
    [self.captureInput.device setFlashMode:flag];
    
    [self.captureInput.device unlockForConfiguration];
    [self.captureSession commitConfiguration];
}
//切换前后摄像头
-(void)cameraRotationBtnClick{
    if([Helper checkCameraAuthorizationStatus] == NO){
        return;
    }
    NSArray *inputs = self.captureSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront){
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }
            else{
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            
            NSError * error;
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&error];
            if (error) {
                [MBProgressHUD showError:@"切换失败"];
                return;
            }
            self.captureDevice = newCamera;
            
            self.captureInput = newInput;
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.captureSession beginConfiguration];
            
            [self.captureSession removeInput:input];
            [self.captureSession addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.captureSession commitConfiguration];
            break;
        }
    }
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

#pragma mark - 通知事件

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    //    self.deviceOrientation = [UIDevice currentDevice] .orientation;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation >= 1 && orientation <= 4) {
        
        if([[self.preview connection] isVideoOrientationSupported])
        {
            [[self.preview connection] setVideoOrientation:(AVCaptureVideoOrientation)orientation];
        }
        switch (orientation) {
            case UIDeviceOrientationPortrait:
                self.preview.transform = CATransform3DIdentity;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                self.preview.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                break;
            case UIDeviceOrientationLandscapeLeft:
                self.preview.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
                break;
            case UIDeviceOrientationLandscapeRight:
                self.preview.transform = CATransform3DMakeRotation(M_PI_2 * 3, 0, 0, 1);
                break;
            default:
                break;
        }
        self.preview.frame = self.view.bounds;
        
    }
    
}

-(void)applicationDidEnterBackground{
    if(self.videoTimer){
        [self.videoTimer invalidate];
        self.videoTimer = nil;
        [self.captureMovieFileOutput stopRecording];
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
