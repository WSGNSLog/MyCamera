//
//  NSString+Common.h
//  BabyDaily
//
//  Created by 宣佚 on 15/4/24.
//  Copyright (c) 2015年 &#23459;&#20314;. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "EasyCameraTextView.h"
@interface NSString (Common)

/**
 *  对字符串进行MD5加密
 *
 *  @param topInfo 需要加密的文字
 *  @param encode 编码类型 OA为16little
 *  @param IsLower 是否为小写
 *
 *  @return 加密后的内容
 */
-(NSString *)MD5:(NSString *)topInfo StringCode:(NSStringEncoding)encode IsLower:(BOOL)IsLower
;

/**
 *  对字符串进行SHA1加密
 *
 *  @param const_Str 常量盐值
 *  @param IsLower 是否为小写
 *
 *  @return 加密后的内容
 */
-(NSString *)SHA1Const_Str:(NSString *)const_Str IsLower:(BOOL)IsLower;

- (NSURL *)urlWithCodePath;
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte;

- (NSString *)trimWhitespace;
- (BOOL)isEmpty;
//判断是否为整形
- (BOOL)isPureInt;
//判断是否为浮点形
- (BOOL)isPureFloat;

- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringForImageRatioURL:(int32_t)ratio;
-(bool)isImageRatioURL:(int32_t)ratio;

- (CGSize)sizeWithFontEx:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGSize)sizeWithFontEx:(UIFont *)font;
/**
 ** yy-MM-dd HH:mm
 */
+(NSString *)stringWithTS:(int64_t)TS formate:(NSString *)formate;
//字符串导出图片
+(UIImage *)imageWithStr:(NSString *)str StrRect:(CGRect)strRect  fontSize:(CGFloat)fontSize  TextColor:(UIColor *)textColor Rotate:(CGFloat)rotate MaxWidth:(CGFloat)maxWidth;

@end
