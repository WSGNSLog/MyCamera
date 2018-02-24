//
//  Tool_DeviceInfo.m
//  AndonFunction
//
//  Created by 宣佚 on 14/11/30.
//  Copyright (c) 2014年 刘宣佚. All rights reserved.
//

#import "Utils_DeviceInfo.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>

@implementation Utils_DeviceInfo

/**
 *  获取手机类型
 *
 *  @return 手机类型
 */
+(NSString *)GetMobileDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];
    NSArray *modelArray = @[@"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,1",
                            @"iPhone7,2",
                            @"iPhone8,1",
                            @"iPhone8,2",
                            @"iPhone8,4",
                            @"iPhone9,1",
                            @"iPhone9,3",
                            @"iPhone9,2",
                            @"iPhone9,4",
                            @"iPhone10,1",
                            @"iPhone10,4",
                            @"iPhone10,2",
                            @"iPhone10,5",
                            @"iPhone10,3",
                            @"iPhone10,6",
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[@"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iphone 6(GSM)",
                                @"iphone 6(Global)",
                                @"iphone 6 Plus(GSM)",
                                @"iphone 6 Plus(Global)",
                                @"iPhone SE",
                                @"iPhone 7",
                                @"iPhone 7",
                                @"iPhone 7 Plus",
                                @"iPhone 7 Plus",
                                @"iPhone 8",
                                @"iPhone 8",
                                @"iPhone 8 Plus",
                                @"iPhone 8 Plus",
                                @"iPhone X",
                                @"iPhone X",
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelName = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelName = [modelNameArray objectAtIndex:modelIndex];
    }
    else {
        modelName = @"Unknown Device";
    }
    return modelName;
}

/**
 *  获取系统版本
 *
 *  @return 系统版本
 */
+(NSString *)GetDeviceVersion {
    float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *returnString = [NSString stringWithFormat:@"%f",deviceVersion];
    return returnString;
}

/**
 *  获取系统名称
 *
 *  @return 系统名称
 */
+(NSString *)GetDeviceSystemName {
    NSString *DeviceSystemName = [UIDevice currentDevice].systemName;
    return DeviceSystemName;
}

/**
 *  获取系统语言
 *
 *  @return 系统语言（en）
 */
+(NSString *)GetSystemLanguage {
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    if(language==nil){
        language = @"en";
    }
    return language;
}

/**
 *  获取系统国际区域
 *
 *  @return 系统国际区域
 */
+(NSString*)GetSystemNation {
    NSString *nation = [[NSLocale currentLocale]objectForKey:NSLocaleCountryCode];
    if(nation==nil){
        nation = @"US";
    }
    return nation;
}

/**
 *  获取系统区域
 *
 *  @return 系统区域
 */
+(NSString *)GetSystemLocale {
    NSLocale *locale1 = [NSLocale currentLocale];
    NSString *locale = [locale1 localeIdentifier];
    if(locale==nil){
        locale = @"en_US";
    }
    return locale;
}

+(DeviceSize)deviceSize {
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == 480)
        return iPhone35inch;
    else if(screenHeight == 568)
        return iPhone4inch;
    else if(screenHeight == 667)
        return  iPhone47inch;
    else if(screenHeight == 736)
        return iPhone55inch;
    else if(screenHeight == 812)
        return iPhone58inch;
    else
        return 0;
}

@end
