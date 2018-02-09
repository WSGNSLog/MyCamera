//
//  NSDate+Util.h
//  BabyDaily
//
//  Created by 宣佚 on 15/4/25.
//  Copyright (c) 2015年 Andon Health Co,.Ltd;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

+ (void)initializeStatics;

+ (NSCalendar *)sharedCalendar;
+ (NSDateFormatter *)sharedDateFormatter;
- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;
- (NSUInteger)weekNumber;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)year;
- (int64_t)utcTimeStamp; //full seconds since
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;
- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;
-(NSString *)dateStringFromDate;

@end
