//
//  Recorder.h
//  MyCamera
//
//  Created by shiguang on 2018/7/25.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReplayKit/ReplayKit.h>
#import <MediaPlayer/MediaPlayer.h>
typedef void(^ScreenRecording)(NSTimeInterval duration);
typedef void(^ScreenRecordStop)(UIViewController *previewViewController,NSString *videoPath, NSError *error);

@interface Recorder : NSObject
//录屏状态
@property (nonatomic, readonly) BOOL recording;
//录屏时间
@property (nonatomic, readonly) NSTimeInterval duration;
//录屏是否可用
@property (nonatomic, readonly) BOOL available;
//iOS8之前视频存储路径
@property (nonatomic, readonly) NSString *videoPath;

//开始录屏 自动使用不同版本SDK API
- (void)startRecordingWithHandler:(void(^)(NSError *error))handler;
//使用最原始截图方式录制视频
- (void)startRecordingWithCapture;
//停止录屏
- (void)stopRecordingWithHandler:(ScreenRecordStop)handler;
//录屏进行中回调
- (void)screenRecording:(ScreenRecording)screenRecording;

@end
