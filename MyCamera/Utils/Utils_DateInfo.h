//
//  Tool_DateInfo.h
//  AndonFunction
//
//  Created by 宣佚 on 14/11/30.
//  Copyright (c) 2014年 刘宣佚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils_DateInfo : NSObject
/**
 *  获取从1970年开始到现在的秒数（时间戳）
 *
 *  @return 时间戳
 */
+(long long)GetCurrentTimeSP;

/**
 *  获取当前时区
 *
 *  @return 时区
 */
+(int)GetCurrentTimeZone;

/**
 *  Date转为String
 *
 *  @param date        要转成字符串的日期
 *  @param FormatStyle 格式化字符串
 *
 *  @return 字符串
 */
+(NSString *)stringFromDate:(NSDate *)date Format:(NSString *)FormatStyle;
/**
 *  String转为Date
 *
 *  @param date        要转成Date的日期
 *  @param FormatStyle 格式化字符串
 *
 *  @return 时间戳
 */
+(NSDate *)dateFromString:(NSString *)date Format:(NSString *)FormatStyle;

//
+ (NSString *)dateStringWithTS:(long long)TS withFormatter:(NSString *)format;
+ (NSString *)dateStringFromURL:(NSString *)recordURL;

//l两个时间相减
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (NSString *)dateTimeWithDuration:(long long)duration;
+(NSString *)timeFormatted:(int)totalSeconds;
@end
