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
#import <ImageIO/ImageIO.h>
#import "Helper.h"
#import "PhotoView.h"
#import "RecordView.h"
#import "EButton.h"
#import "CameraModePickView.h"
#import "ECameraMediaModel.h"
#import "ECameraSQL.h"

#import "ECustomAlertView.h"
#import "EMediaTool.h"
#import "Utils_DeviceInfo.h"

#define btn_W 40

typedef enum {
    CameraModePhoto,
    CameraModeRecord
}CameraMode;
typedef enum{
    RecordStateBegin,
    RecordStateEnd,
    RecordStateCancel,
    RecordStateTimeTooShort,
    RecordStateResignActive,
    RecordStateResignTimeTooShort
}RecordState;


@interface CameraVC ()<AVCaptureFileOutputRecordingDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,CAAnimationDelegate>
{
    NSMutableArray *_barViewArray;
}
@property (strong,nonatomic) AVCaptureDevice *captureDevice;
@property (strong,nonatomic) AVCaptureDeviceInput *captureInput;
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property (strong,nonatomic) AVCaptureSession *captureSession;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *preview;

@property(nonatomic,retain) UIView *previewView;
@property(nonatomic,retain) UIView *operationView;

@property(nonatomic,retain) UIButton *flashLightBtn;
@property(nonatomic,retain) UIButton *camaraRotationBtn;

@property(nonatomic,retain) UILabel *locationLabel;

@property(nonatomic,retain) NSString *city;
@property(nonatomic,retain) NSString *locationName;
@property(nonatomic,retain) NSString * country;
@property(nonatomic,retain) NSString * longtitude;
@property(nonatomic,retain) NSString * latitude;
@property(nonatomic,retain) NSString * district;

//@property(nonatomic,retain)CLLocationManager * locationManager;
@property(nonatomic,retain) NSTimer * videoTimer;
@property(nonatomic,assign) NSInteger videoTimeCountDown;
@property(nonatomic,assign) BOOL isCancelVideo;

@property(nonatomic,assign) BOOL isRecording;

@property(nonatomic,assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识

@property (nonatomic,retain) PhotoView *photoView;
@property (nonatomic,retain) RecordView *recordView;
@property(nonatomic,retain) UIButton *cameraRotationBtn;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) CameraModePickView *camModeBaseView;
@property (nonatomic,weak) UIButton *closeBtn;
@property (copy,nonatomic) NSString *filePath;
@property (nonatomic,assign) int flashTag;
@property (nonatomic,assign) BOOL isTimeTooShort;

@property (nonatomic,assign) CameraMode cameraMode;
@property (nonatomic,strong) ECameraMediaModel *tmpMedia;
@property (nonatomic,assign) RecordState recordState;

@end

@implementation CameraVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.captureSession startRunning];
    //    _preview.frame = self.previewView.layer.bounds;
    self.preview.frame = [UIScreen mainScreen].bounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(handleDeviceOrientationDidChange:)
    //                                                 name:UIDeviceOrientationDidChangeNotification
    //                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(h5PageOpenDisissSelf) name:@"H5PageJumpNotiFication" object:nil];
    //显示上一次的预览图
    //    ECameraMediaModel * mediaModel = [ECameraSQL selectLastMedia];
    //    if (mediaModel != nil) {
    //        UIImage * thumbImage = [UIImage imageWithContentsOfFile:[mediaModel filePath]];
    //        self.photoView.thumbnailImgV.image = thumbImage;
    //        self.recordView.thumbImgV.image = thumbImage;
    //    }
    //显示预览图
    [EMediaTool getLatestAsset:^(ECameraAsset * _Nullable asset) {
        if (asset) {
            UIImage *thumbImage = asset.image;
            self.photoView.thumbnailImgV.image = thumbImage;
            self.recordView.thumbImgV.image = thumbImage;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.cameraMode == CameraModeRecord) {
        if (self.flashTag == 2) {//设置手电筒
            [self turnTorchOnWithMode:AVCaptureTorchModeAuto];
        }else if(self.flashTag == 1){
            [self turnTorchOnWithMode:AVCaptureTorchModeOn];
        }else{
            [self turnTorchOnWithMode:AVCaptureTorchModeOff];
        }
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application{
    if(![Helper checkCameraAuthorizationStatus]){
        [self showSettingAlertStr:@"请在手机设置中打开乐鱼相机、照片及麦克风的访问权限"];
        return;
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    [self.captureSession startRunning];
    
    WEAKSELF
    //点击锁屏键时结束录制，结束前小于3s提示“录制时间太短”，大于3s提示“保存失败”。
    if (self.recordState == RecordActionResignActive) {
        [MBProgressHUD showText:@"保存失败"];
    }else if (self.recordState == RecordActionResignTimeTooShort){
        [MBProgressHUD showText:@"录制时间太短"];
    }
    self.recordState = RecordStateEnd;
    [EMediaTool getLatestAsset:^(ECameraAsset * _Nullable asset) {
        if (asset) {
            UIImage *thumbImage = asset.image;
            weakSelf.photoView.thumbnailImgV.image = thumbImage;
            weakSelf.recordView.thumbImgV.image = thumbImage;
        }
    }];
    if ([Utils_DeviceInfo deviceSize] != iPhone58inch) {
        if (self.cameraMode == CameraModeRecord) {
            if (self.flashTag == 2) {//设置手电筒
                [self turnTorchOnWithMode:AVCaptureTorchModeAuto];
            }else if(self.flashTag == 1){
                [self turnTorchOnWithMode:AVCaptureTorchModeOn];
            }else{
                [self turnTorchOnWithMode:AVCaptureTorchModeOff];
            }
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.cameraMode == CameraModeRecord) {
                if (self.flashTag == 2) {//设置手电筒
                    [self turnTorchOnWithMode:AVCaptureTorchModeAuto];
                }else if(self.flashTag == 1){
                    [self turnTorchOnWithMode:AVCaptureTorchModeOn];
                }else{
                    [self turnTorchOnWithMode:AVCaptureTorchModeOff];
                }
            }
        });
    }
    
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
    
    
    //self.navigationController.delegate = self;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isRequestAlertFirstTimeShow"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isRequestAlertFirstTimeShow"];
        //第一次进来请求权限
        [self requestAuthorization];
    }else{
        if([Helper checkCameraAuthorizationStatus]){
            [self setupCamera];
        }else{
            [self showSettingAlertStr:@"请在手机设置中打开乐鱼相机、照片及麦克风的访问权限"];
        }
    }
    
    [self initFunctionViewsAndButtons];
}
- (void)initFunctionViewsAndButtons{
    WEAKSELF
    RecordView *recView = [[RecordView alloc]init];
    CGFloat height = 105;
    recView.frame = CGRectMake(LL_ScreenWidth, 0, LL_ScreenWidth, height);
    recView.duration = 15;
    
    self.recordView = recView;
#pragma mark - 录像功能
    [recView setRecordClick:^(RecordAction action) {
        switch (action) {
            case RecordActionPhoto:
                [weakSelf photoBtnClick];
                break;
            case RecordActionVideoBegin:
                
                weakSelf.camModeBaseView.hidden = YES;
                [weakSelf videoStart];
                break;
            case RecordActionVideoEnd:
                [weakSelf videoEnd];
                break;
            case RecordActionVideoCancel:
                weakSelf.camModeBaseView.hidden = NO;
                [weakSelf videoCancel];
            case RecordActionTimeTooShort:
                weakSelf.camModeBaseView.hidden = NO;
                [MBProgressHUD showText:@"录制时间太短"];
                weakSelf.isTimeTooShort = YES;
                [weakSelf videoEnd];
                break;
            case RecordActionResignActive:
                weakSelf.recordState = RecordActionResignActive;
                weakSelf.camModeBaseView.hidden = NO;
                [weakSelf videoCancel];
                break;
            case RecordActionResignTimeTooShort:
                weakSelf.recordState = RecordActionResignTimeTooShort;
                weakSelf.camModeBaseView.hidden = NO;
                [weakSelf videoCancel];
                break;
            default:
                break;
        }
        
    } ];
#pragma mark - 录像状态更多按钮点击
    recView.moreBtnClickBlock = ^{
        
    };
#pragma mark - 录像状态相册点击
    recView.thumbClickBlock = ^{
        [weakSelf thumbnailBtnClick];
    };
#pragma mark - 保存按钮点击
    recView.recordConfimBlock = ^{
        
        weakSelf.camModeBaseView.hidden = NO;
        [MBProgressHUD showMessage:@"正在保存文件"];
        if (weakSelf.filePath) {
            [weakSelf setRecordThumbnail];
            [weakSelf saveRecordFileToCustomLibrary];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf setRecordThumbnail];
                [weakSelf saveRecordFileToCustomLibrary];
            });
        }
        
    };
#pragma mark - 重新拍摄
    recView.remakeBlock = ^{
        weakSelf.camModeBaseView.hidden = NO;
        if (weakSelf.filePath) {
            [[NSFileManager defaultManager] removeItemAtPath:weakSelf.filePath error:nil];
            weakSelf.filePath = nil;
        }
    };
    PhotoView *photoView = [[PhotoView alloc]init];
    photoView.frame = CGRectMake(0, 0, LL_ScreenWidth, height);
    self.photoView = photoView;
    UIView *operationView = [[UIView alloc]init];
    operationView.frame = CGRectMake(0, LL_ScreenHeight - height - PickerBarH, LL_ScreenWidth, height+PickerBarH);
    operationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:operationView];
    
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
#pragma mark - 拍照点击
    photoView.photoBtnClick = ^(){
        [weakSelf photoBtnClick];
    };
#pragma mark - 预览图点击
    photoView.thumClickBlock = ^{
        [weakSelf thumbnailBtnClick];
    };
#pragma mark - 拍照状态更多按钮点击
    photoView.moreClickBlock = ^{
        
    };
    [self.view bringSubviewToFront:operationView];
    [self.view bringSubviewToFront:scrollView];
    
    [self initCameraModePickView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 20, 30, 30);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"CameraCloseIcon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(CloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: closeBtn];
    self.closeBtn = closeBtn;
    
    [self intiCameraFunctionBtn];
}
- (void)requestAuthorization{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            if (!granted) {
                [self dismissViewControllerAnimated:YES completion:nil];
                return ;
            } else {
                NSLog(@"摄像头权限 ok");
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        if (!granted) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                            return;
                        } else {
                            NSLog(@"麦克风权限 ok");
                            
                            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if (status == PHAuthorizationStatusAuthorized) {
                                        NSLog(@"相册权限 ok");
                                        
                                    }else{
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        return;
                                    }
                                });
                                
                            }];
                        }
                        
                    });
                }];
                
            }
            
        });
    }];
    [self setupCamera];
}
#pragma mark - 拍照与录像按钮
- (void)initCameraModePickView{
    CGFloat bottomV_H = 34;
    
    CameraModePickView *modePickView = [[CameraModePickView alloc]init];
    modePickView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    modePickView.frame = CGRectMake(0, LL_ScreenHeight - PickerBarH, LL_ScreenWidth, bottomV_H);
    [self.view addSubview:modePickView];
    self.camModeBaseView = modePickView;
    
    WEAKSELF
    modePickView.photoModeClickBlock = ^{
        weakSelf.cameraMode = CameraModePhoto;
        [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        if (weakSelf.flashTag == 1) {
            [weakSelf turnTorchOnWithMode:AVCaptureTorchModeOff];
        }
    };
    modePickView.videoModeClickBlock = ^{
        weakSelf.cameraMode = CameraModeRecord;
        if (weakSelf.flashTag == 2) {//设置手电筒
            [weakSelf turnTorchOnWithMode:AVCaptureTorchModeAuto];
        }else if(weakSelf.flashTag == 1){
            [weakSelf turnTorchOnWithMode:AVCaptureTorchModeOn];
        }else{
            [weakSelf turnTorchOnWithMode:AVCaptureTorchModeOff];
        }
        [weakSelf.scrollView setContentOffset:CGPointMake(LL_ScreenWidth, 0) animated:NO];
    };
    
}
#pragma mark - 关闭按钮点击
- (void)CloseBtnClick{
    
    WEAKSELF
    if (self.filePath) {
        [ECustomAlertView confirmWithTitle:@"放弃拍摄" message:@"确定放弃此次拍摄吗?" leftBtnName:@"取消" rightBtnName:@"确定" ok:^(id sender) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            return;
        } cancel:^(id sender) {
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}
-(void)setupCamera{
    
    self.cameraMode = CameraModePhoto;
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
    if ([weakSelf.captureSession canAddOutput:weakSelf.captureMovieFileOutput]) {
        [weakSelf.captureSession addOutput:weakSelf.captureMovieFileOutput];
        AVCaptureConnection *captureConnection=[weakSelf.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    // 预览层
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.preview.videoGravity=AVLayerVideoGravityResizeAspect;//填充模式
    
    if([Helper checkCameraAuthorizationStatus] == NO){
        return;
    }
}

#pragma mark - 视图初始化
-(void)initPreviewView{
    self.previewView = [[UIView alloc]init];
    self.previewView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.previewView];
    WEAKSELF
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    [self.previewView.layer addSublayer:_preview];
}
#pragma mark - 闪光灯与摄像头切换按钮
-(void)intiCameraFunctionBtn{
    
    self.flashLightBtn = [[UIButton alloc]init];
    [self.flashLightBtn setImage:[UIImage imageNamed:@"cameraFlashBtnMode_0"] forState:UIControlStateNormal];
    [self.flashLightBtn addTarget:self action:@selector(flashLightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashLightBtn];
    //默认闪光灯为关闭
    [self changeFlashlight:0];
    
    self.cameraRotationBtn = [[UIButton alloc]init];
    [self.cameraRotationBtn setImage:[UIImage imageNamed:@"camera_rotation"] forState:UIControlStateNormal];
    [self.cameraRotationBtn addTarget:self action:@selector(cameraRotationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cameraRotationBtn];
    
    
    WEAKSELF
    //TODO:适配 iPhoneX
    //if (LL_iPhoneX) {}
    
    [self.flashLightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.scrollView.mas_top).offset(-10);
        make.left.equalTo(weakSelf.view.mas_left).offset(18);
        make.height.width.equalTo(@32);
    }];
    
    [self.cameraRotationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.flashLightBtn);
        make.height.width.equalTo(@32);
        make.right.equalTo(weakSelf.view.mas_right).offset(-18);
    }];
    
}
#pragma mark - 开始录制
-(void)videoStart{
    
    if([Helper checkCameraAuthorizationStatus] == NO){
        return;
    }
    if([Helper checkMicAuthorizationStatus] == NO){
        return;
    }
    self.isRecording = YES;
    
    //修改UI显示
    self.closeBtn.hidden = YES;
    self.cameraRotationBtn.hidden = YES;
    self.flashLightBtn.hidden = YES;
    
    
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
#pragma mark - 结束录制
-(void)videoEnd{
    if (self.isRecording == YES) {
        self.isRecording = NO;
        NSLog(@"结束录制");
        [_captureMovieFileOutput stopRecording];
    }
    
}
#pragma mark - 取消录制
-(void)videoCancel{
    if (self.isRecording == YES) {
        NSLog(@"取消录制");
        self.isRecording = NO;
        self.isCancelVideo = YES;
        [_captureMovieFileOutput stopRecording];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
        }
        self.filePath = nil;
    }
}
#pragma mark - 打开相册
-(void)thumbnailBtnClick{
    if ([[Utils_DeviceInfo GetDeviceVersion] integerValue] < 10) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"PHOTOS://"]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"photos-redirect://"] options:@{@"jn":@"s"} completionHandler:nil];
    }
    
}

#pragma mark - 拍照
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
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
            //写入文件
            NSDate * now = [NSDate date];
            NSString * fileName = [NSString stringWithFormat:@"%zd.jpg",[now timeIntervalSince1970] * 1000];
            NSFileManager * fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"ecamera"];
            if (![fileManager fileExistsAtPath:diskCachePath]) {
                [fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            NSString * filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,fileName] ;
            [UIImageJPEGRepresentation(image, 0.75) writeToFile:filePath atomically:YES];
            
            //写入数据库
            ECameraMediaModel * media = [[ECameraMediaModel alloc]init];
            media.type = ECameraMediaTypeImage;
            media.fileName = fileName;
            media.dateInfo = now;
            media.phoneNum = @"110";
            [ECameraSQL insertEasyCameraMediaWith:media];
            
            //保存到自定义相册
            [ToolFunction saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(image) customAlbumName:@"乐鱼" completionBlock:^{
                //[MBProgressHUD showSuccess:@"保存成功"];
            } failureBlock:^(NSError *error) {
                [MBProgressHUD showError:@"保存失败"];
            }];
            //缩略图动画
            weakSelf.photoView.thumbnailImgV.image = image;
            weakSelf.recordView.thumbImgV.image = image;
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
    
    NSLog(@"开始录制");
    
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    WEAKSELF
    [self.videoTimer invalidate];
    self.videoTimer = nil;
    
    self.closeBtn.hidden = NO;
    self.cameraRotationBtn.hidden = NO;
    self.flashLightBtn.hidden = NO;
    
    if (self.isCancelVideo == YES) {
        self.isCancelVideo = NO;
        NSLog(@"取消录制 finish");
        return;
    }
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:outputFileURL];
    CMTime time = [avUrl duration];
    CGFloat duration = CMTimeGetSeconds(time);
    NSLog(@"duration:%f",duration);
    if(self.isTimeTooShort){
        self.isTimeTooShort = NO;
        return;
    }
    
    //    if(duration < 3 ){
    //        [MBProgressHUD showText:@"录制时间太短"];
    //        return;
    //    }
    
    
    //视频文件转换后存到本地
    NSDate * now = [NSDate date];
    NSString * fileName = [NSString stringWithFormat:@"%zd.mp4",[now timeIntervalSince1970] * 1000];
    NSString * thumbFileName = [NSString stringWithFormat:@"%zd.jpg",[now timeIntervalSince1970] * 1000];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"ecamera"];
    if (![fileManager fileExistsAtPath:diskCachePath]) {
        [fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString * filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,fileName] ;
    NSString * thumbFilePath = [NSString stringWithFormat:@"%@/%@",diskCachePath,thumbFileName];
    [ToolFunction transMovToMP4:outputFileURL.absoluteString Output:filePath exportStatusHandler:^(AVAssetExportSessionStatus exportStatus) {
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                [weakSelf.recordView videoExportFailHandle];
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"导出视频被终了");
                break;
            case AVAssetExportSessionStatusCompleted:
                if ([fileManager fileExistsAtPath:filePath]) {
                    NSLog(@"导出视频成功");
                }else{
                    [weakSelf.recordView videoExportFailHandle];
                }
                break;
            default:
                break;
        }
    }];
    NSLog(@"transMovToMP4:%f",duration);
    self.filePath = filePath;
    
    //写数据库
    ECameraMediaModel * media = [[ECameraMediaModel alloc]init];
    media.type = ECameraMediaTypeVideo;
    media.fileName = fileName;
    media.thumbFileName = thumbFileName;
    media.thumbFilePath = thumbFilePath;
    media.dateInfo = now;
    media.phoneNum = @"110";
    media.duration = duration;
    self.tmpMedia = media;
    
}
- (void)setRecordThumbnail{
    
    //写数据库
    [ECameraSQL insertEasyCameraMediaWith:self.tmpMedia];
    UIImage * thumbImage = [self getVideoPreViewImage:[NSURL fileURLWithPath:self.filePath]];
    self.photoView.thumbnailImgV.image = thumbImage;
    self.recordView.thumbImgV.image = thumbImage;
    [UIImageJPEGRepresentation(thumbImage, 0.75) writeToFile:self.tmpMedia.thumbFilePath atomically:YES];
    
}
- (void)saveRecordFileToCustomLibrary{
    WEAKSELF
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [ToolFunction saveRecordFileWithPath:self.filePath customAlbumName:@"乐鱼" completionBlock:^{
        NSLog(@"finish 保存文件");
        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"保存成功"];
        weakSelf.filePath = nil;
    } failureBlock:^(NSError *error) {
        NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"保存失败"];
    } ];
}
- (void)saveRecordToPhotoLibrary{
    
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    //存到手机相册
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:self.filePath] completionBlock:^(NSURL *assetURL, NSError *error ) {
        
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

#pragma mark - 打开/关闭手电筒
- (void)turnTorchOnWithMode:(AVCaptureTorchMode)mode{
    NSLog(@"手电筒:%ld",(long)mode);
    if ([self.captureDevice hasTorch] && [self.captureDevice hasFlash]){
        [self.captureSession beginConfiguration];
        [self.captureDevice lockForConfiguration:nil];
        
        [self.captureDevice setTorchMode:mode];
        
        [self.captureDevice unlockForConfiguration];
        [self.captureSession commitConfiguration];
    } else {
        
    }
}

#pragma mark - 切换闪光灯模式
-(void)flashLightBtnClick{
    if([Helper checkCameraAuthorizationStatus] == NO){
        return;
    }
    if(self.captureDevice){
        if (self.captureDevice.position == AVCaptureDevicePositionFront) {
            [MBProgressHUD showError:@"前置摄像头不支持闪光灯"];
            return;
        }
    }
    
    NSInteger mode =  self.captureDevice.flashMode;
    mode += 1;
    if (mode == 3) {
        mode = 0;
    }
    
    [self changeFlashlight:(AVCaptureFlashMode)mode];
    if (self.cameraMode == CameraModeRecord) {
        [self turnTorchOnWithMode:(AVCaptureTorchMode)mode];
    }
    [self.flashLightBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cameraFlashBtnMode_%zd",mode]] forState:UIControlStateNormal];
}

-(void)changeFlashlight:(int32_t)flag{
    self.flashTag = flag;
    [self.captureSession beginConfiguration];
    [self.captureInput.device lockForConfiguration:nil];
    
    // Set torch to on
    [self.captureInput.device setFlashMode:flag];
    //[self.captureInput.device setTorchMode:flag];
    
    [self.captureInput.device unlockForConfiguration];
    [self.captureSession commitConfiguration];
}
#pragma mark - 切换前后摄像头
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
            //录像状态重新设置手电筒
            if (position == AVCaptureDevicePositionFront && self.cameraMode == CameraModeRecord) {
                if (self.flashTag == 2) {//设置手电筒
                    [self turnTorchOnWithMode:AVCaptureTorchModeAuto];
                }else if(self.flashTag == 1){
                    [self turnTorchOnWithMode:AVCaptureTorchModeOn];
                }else{
                    [self turnTorchOnWithMode:AVCaptureTorchModeOff];
                }
            }
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
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation{
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
        self.preview.frame = self.previewView.bounds;
        
    }
}
-(void)applicationDidEnterBackground{
    if(self.videoTimer){
        [self.videoTimer invalidate];
        self.videoTimer = nil;
        [self.captureMovieFileOutput stopRecording];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application{
    [self.captureSession stopRunning];
}

- (void)showSettingAlertStr:(NSString *)tipStr{
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"无访问权限" message:tipStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertContr addAction:cancleAction];
        UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIApplication *app = [UIApplication sharedApplication];
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([app canOpenURL:settingsURL]) {
                [app openURL:settingsURL];
            }
            
        }];
        [alertContr addAction:setAction];
        [self presentViewController:alertContr animated:YES completion:nil];
        
    }else{
        kTipAlert(@"%@", tipStr);
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end

