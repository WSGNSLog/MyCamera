//
//  Tool_DateInfo.m
//  AndonFunction
//
//  Created by 宣佚 on 14/11/30.
//  Copyright (c) 2014年 刘宣佚. All rights reserved.
//

#import "Utils_DateInfo.h"

@implementation Utils_DateInfo

/**
 *  获取从1970年开始到现在的秒数（时间戳毫秒级）
 *
 *  @return 时间戳
 */
+(long long)GetCurrentTimeSP {
    
    NSDate *datenow = [NSDate date];
    long long timeSp = [datenow timeIntervalSince1970]*1000;
    return timeSp;
}

/**
 *  获取当前时区
 *
 *  @return 时区
 */
+(int)GetCurrentTimeZone {
    NSString *zone = [[NSTimeZone localTimeZone] description];
    NSString *time = [[zone componentsSeparatedByString:@"offset"] objectAtIndex:1];
    int inv = [time intValue];
    int result = inv / (60 * 60);
    if (result>0) {
        return result;
    }
    return result;
}

/**
 *  Date转为String
 *
 *  @param date        要转成字符串的日期
 *  @param FormatStyle 格式化字符串
 *
 *  @return 字符串
 */
+(NSString *)stringFromDate:(NSDate *)date Format:(NSString *)FormatStyle {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:FormatStyle];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
+(NSDate *)dateFromString:(NSString *)date Format:(NSString *)FormatStyle{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:FormatStyle];
    
    NSDate *destDateString = [dateFormatter dateFromString:date];
    
    return destDateString;
}
+ (NSString *)dateStringWithTS:(long long)TS withFormatter:(NSString *)format{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:TS/1000];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSString *)dateStringFromURL:(NSString *)recordURL{
    /*
     URL = "http://leyu-dev-livestorage.b0.upaiyun.com/leyulive.pull.dev.iemylife.com/leyu/09ad208563ac46ab85a3394999f9afef/recorder20171016140151.m3u8";
     */
    NSString *lastComponent = [recordURL componentsSeparatedByString:@"/"].lastObject;
    NSString *totalDateStr = [lastComponent substringWithRange:NSMakeRange(8, 14)];
    NSString *year = [totalDateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [totalDateStr substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [totalDateStr substringWithRange:NSMakeRange(6, 2)];
    NSString *hour = [totalDateStr substringWithRange:NSMakeRange(8, 2)];
    NSString *minute = [totalDateStr substringWithRange:NSMakeRange(10, 2)];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
    
    return dateStr;
}
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%dday%dh%d''%d'",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%dh%d''%d'",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d''%d'",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%d'",second];
    }
    return str;
}
+ (NSString *)dateTimeWithDuration:(long long)duration{
    
    long long totalSeconds = duration/1000000 ;
    int second = (long) totalSeconds %60;//秒
    int minute = (long)totalSeconds /60%60;
    int hour = (long)totalSeconds / 3600%24;
    int day = (long)totalSeconds / (24 * 3600);
    NSString *str;
//    if (day != 0) {
//        str = [NSString stringWithFormat:@"%dday%dh%d''%d'",day,hour,minute,second];
//    }else if (day==0 && hour != 0) {
//        str = [NSString stringWithFormat:@"%dh%d''%d'",hour,minute,second];
//    }else if (day== 0 && hour== 0 && minute!=0) {
//        str = [NSString stringWithFormat:@"%d''%d'",minute,second];
//    }else{
//        str = [NSString stringWithFormat:@"%d'",second];
//    }
    if (day==0 && hour != 0) {
        str = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    }else if (day== 0 && hour== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"00:%02d:%02d",minute,second];
    }else{
        str = [NSString stringWithFormat:@"00:00:%02d",second];
    }
    return str;
}
//秒数转换成时分秒

+(NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

@end
