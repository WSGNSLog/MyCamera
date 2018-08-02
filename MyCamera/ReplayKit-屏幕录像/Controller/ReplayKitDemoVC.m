//
//  ReplayController.m
//  MyCamera
//
//  Created by shiguang on 2018/7/24.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ReplayKitDemoVC.h"
#import <ReplayKit/ReplayKit.h>
@interface ReplayKitDemoVC ()<RPPreviewViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;

@end

@implementation ReplayKitDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //应用内屏幕录制功能,iOS9之后使用原生ReplayKit进行录制,iOS8及以后使用截图方式保存视频.
    self.switchBtn.selected = [RPScreenRecorder sharedRecorder].recording;
    
    [self createImageView];
}
- (void)createImageView {
    self.imageView.animationImages = @[[UIImage imageNamed:@"img_01"], [UIImage imageNamed:@"img_02"], [UIImage imageNamed:@"img_03"], [UIImage imageNamed:@"img_04"]];
    self.imageView.animationDuration = 1;
    [self.imageView startAnimating];
}


//启动或者停止录制回放
- (IBAction)replayKitBtnClick:(UIButton *)sender {
    
    if (@available(iOS 9.0, *)) {
        //判断是否已经开始录制回放
        if (sender.isSelected) {
            //停止录制回放，并显示回放的预览，在预览中用户可以选择保存视频到相册中、放弃、或者分享出去
            [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error);
                    //处理发生的错误，如磁盘空间不足而停止等
                }
                if (previewViewController) {
                    //设置预览页面到代理
                    previewViewController.previewControllerDelegate = self;
                    [self presentViewController:previewViewController animated:YES completion:nil];
                }
            }];
            sender.selected = NO;
            return;
        }
        
        //如果还没有开始录制，判断系统是否支持
        if ([RPScreenRecorder sharedRecorder].available) {
            NSLog(@"开始OK");
            sender.selected = YES;
            //如果支持，就使用下面的方法可以启动录制回放
            [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"error:%@", error);
                }
                //处理发生的错误，如设用户权限原因无法开始录制等
            }];
        } else {
            NSLog(@"录制回放功能不可用");
        }
    } else {
        NSLog(@"不可用");
    }
    
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//回放预览界面的代理方法
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    //用户操作完成后，返回之前的界面
    [previewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
