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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *openCamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openCamBtn.frame = CGRectMake(150, 200, 80, 50);
    [openCamBtn setTitle:@"openCam" forState:UIControlStateNormal];
    [openCamBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [openCamBtn addTarget:self action:@selector(openCamBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openCamBtn];
    UIButton *openAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openAlbumBtn.frame = CGRectMake(150, 300, 80, 50);
    [openAlbumBtn setTitle:@"打开相册" forState:UIControlStateNormal];
    [openAlbumBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [openAlbumBtn addTarget:self action:@selector(openAlbumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openAlbumBtn];
    
}
- (void)openCamBtnClick{
//    [Helper checkCameraAuthorizationStatus];
    CameraVC *camVC = [[CameraVC alloc]init];
    
//    [self presentViewController:camVC animated:YES completion:nil];
}

- (void)openAlbumBtnClick{
    AlbumController *albumVC = [[AlbumController alloc]init];
    [self.navigationController pushViewController:albumVC animated:YES];
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

@end
