//
//  Helper.m
//  MyCamera
//
//  Created by shiguang on 2018/1/11.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "Helper.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Helper
+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (ALAuthorizationStatusDenied == authStatus ||
        ALAuthorizationStatusRestricted == authStatus) {
        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开成长日记的访问权限"];
        return NO;
    }
    return YES;
}
+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        kTipAlert(@"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开访问权限"];
            return NO;
        }
    }
    
    return YES;
}
+ (BOOL)checkMicAuthorizationStatus {
    __block BOOL bCanRecord = YES;
    //    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    //    {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            } else {
                [self showSettingAlertStr:@"请在iPhone的“设置->隐私->麦克风”中打开访问权限"];
                bCanRecord = NO;
            }
        }];
    }
    //    }
    return bCanRecord;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"提示" message:tipStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
        UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
        [vc presentViewController:alertContr animated:YES completion:nil];
       
    }else{
        kTipAlert(@"%@", tipStr);
    }
}
@end
