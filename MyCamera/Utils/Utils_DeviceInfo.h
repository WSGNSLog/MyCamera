//
//  Tool_DeviceInfo.h
//  AndonFunction
//
//  Created by 宣佚 on 14/11/30.
//  Copyright (c) 2014年 刘宣佚. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceSize){
    iPhone35inch = 1,
    iPhone4inch = 2,
    iPhone47inch = 3,
    iPhone55inch = 4,
    iPhone58inch = 5
};

@interface Utils_DeviceInfo : NSObject

/**
 *  获取手机类型
 *
 *  @return 手机类型
 */
+(NSString *)GetMobileDeviceName;

/**
 *  获取系统版本
 *
 *  @return 系统版本
 */
+(NSString *)GetDeviceVersion;

/**
 *  获取系统名称
 *
 *  @return 系统名称
 */
+(NSString *)GetDeviceSystemName;

/**
 *  获取系统语言
 *
 *  @return 系统语言（en）
 */
+(NSString *)GetSystemLanguage;

/**
 *  获取系统国际区域
 *
 *  @return 系统国际区域
 */
+(NSString*)GetSystemNation;

/**
 *  获取系统区域
 *
 *  @return 系统区域
 */
+(NSString *)GetSystemLocale;

+(DeviceSize)deviceSize;

@end
