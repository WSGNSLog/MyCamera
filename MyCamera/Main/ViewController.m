//
//  ViewController.m
//  MyCamera
//
//  Created by shiguang on 2018/1/11.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import "CameraVC.h"
#import "AlbumController.h"
#import "PhotoExifInfoVC.h"
#import "LocalAlbumController.h"
#import "ReplayKitDemoVC.h"
#import "ReplayController.h"
#import "CameraFaceDetectVC.h"
#import "ImageFaceDetectVC.h"

@interface ViewController ()

@property (nonatomic, strong)  NSArray *menuList;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isRequestAlertFirstTimeShow"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isRequestAlertFirstTimeShow"];
        //第一次进来请求权限
        [self requestAuthorization];
    }else{
        if([Helper checkCameraAuthorizationStatus]){
            
        }else{
            [self showSettingAlertStr:@"请在手机设置中打开乐鱼相机、照片及麦克风的访问权限"];
        }
    }
    
}
- (IBAction)openCamBtnClick:(UIButton *)sender {
    //    [Helper checkCameraAuthorizationStatus];
    CameraVC *camVC = [[CameraVC alloc]init];
    [self presentViewController:camVC animated:YES completion:nil];
}
- (IBAction)openAlbumBtnClick:(UIButton *)sender {
    AlbumController *albumVC = [[AlbumController alloc]init];
    [self.navigationController pushViewController:albumVC animated:YES];
}
- (IBAction)photoInfoBtnClick:(id)sender {
    PhotoExifInfoVC *ExifInfoVC = [[PhotoExifInfoVC alloc]init];
    [self.navigationController pushViewController:ExifInfoVC animated:YES];
}
- (IBAction)replayKitClick:(id)sender {
    
    ReplayController *replayVC = [[ReplayController alloc]init];
    [self presentViewController:replayVC animated:YES completion:nil];
}
- (IBAction)openAlbumPhotoBtnClick:(id)sender {
    LocalAlbumController *albumVC = [[LocalAlbumController alloc]init];
    [self.navigationController pushViewController:albumVC animated:YES];
}

- (IBAction)cameraFaceDetect:(UIButton *)sender {
    CameraFaceDetectVC *faceVC = [[CameraFaceDetectVC alloc]init];
    [self presentViewController:faceVC animated:YES completion:nil];
}
- (IBAction)imageFaceDetect:(UIButton *)sender {
    ImageFaceDetectVC *faceVC = [[ImageFaceDetectVC alloc]init];
    [self presentViewController:faceVC animated:YES completion:nil];
}
- (IBAction)videoEdit:(UIButton *)sender {
    
}



- (void)openGeneralSetting{
    NSString * defaultWork = [self getDefaultWork];
    NSString * bluetoothMethod = [self getBluetoothMethod];
    NSURL*url=[NSURL URLWithString:@"App-Prefs:root=General"];
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]   performSelector:NSSelectorFromString(bluetoothMethod) withObject:url     withObject:nil];
    
}
-(void)openWifiSetting{
    NSString * defaultWork = [self getDefaultWork];
    NSString * bluetoothMethod = [self getBluetoothMethod];
    NSURL*url=[NSURL URLWithString:@"Prefs:root=WIFI"];
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]   performSelector:NSSelectorFromString(bluetoothMethod) withObject:url     withObject:nil];
}

-(NSString *) getDefaultWork{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
    NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return method;
}

-(NSString *) getBluetoothMethod{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
    NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
    NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
    NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
    return method;
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
@end
