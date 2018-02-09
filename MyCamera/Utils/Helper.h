//
//  Helper.h
//  MyCamera
//
//  Created by shiguang on 2018/1/11.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject
+ (BOOL)checkPhotoLibraryAuthorizationStatus;
+ (BOOL)checkCameraAuthorizationStatus;
+ (BOOL)checkMicAuthorizationStatus;
+ (void)showSettingAlertStr:(NSString *)tipStr;
@end
