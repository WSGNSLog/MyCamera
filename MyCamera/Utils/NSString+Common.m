//
//  NSString+Common.m
//  BabyDaily
//
//  Created by 宣佚 on 15/4/24.
//  Copyright (c) 2015年 &#23459;&#20314;. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
//#import "SwiftHeader.h"
//#import "SysConfig.h"
@implementation NSString (Common)

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
{
    NSData *data = [topInfo dataUsingEncoding:encode];
    Byte * myByte = (Byte *)[data bytes];
    unsigned char result[16];
    CC_MD5( myByte, (CC_LONG)[data length], result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    if (IsLower) {
        return [hash lowercaseString];
    } else {
        return [hash uppercaseString];
    }
}

/**
 *  对字符串进行SHA1加密
 *
 *  @param topInfo 需要加密的文字
 *  @param const_Str 常量盐值
 *  @param IsLower 是否为小写
 *
 *  @return 加密后的内容
 */
-(NSString *)SHA1Const_Str:(NSString *)const_Str IsLower:(BOOL)IsLower
{
    NSString *tempMd5 = [NSString stringWithFormat:@"%@%@",const_Str,self];
    NSString *md5 = [self MD5:tempMd5 StringCode:NSUTF8StringEncoding IsLower:YES];
    
    NSString *tempSH = [NSString stringWithFormat:@"%@%@",md5,self];
    
    const char *cstr = [tempSH cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:tempSH.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    if (IsLower) {
        return [output lowercaseString];
    } else {
        return [output uppercaseString];
    }
    return output;
}
//
//- (NSURL *)urlWithCodePath{
//    NSString *urlStr;
//    if (!self || self.length <= 0) {
//        return nil;
//    }else{
//        if (![self hasPrefix:@"http"]) {
//
//            NSString *url = [SysConfig GetValueByKey:CONFIG_BASEURL];
//            urlStr = [NSString stringWithFormat:@"%@%@", url, self];
//        }else{
//            urlStr = self;
//        }
//        return [NSURL URLWithString:urlStr];
//    }
//}


- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
 
    resultSize = [self boundingRectWithSize:size
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font}
                                    context:nil].size;

    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}

+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte{
    NSString *sizeDisplayStr;
    if (sizeOfByte < 1024) {
        sizeDisplayStr = [NSString stringWithFormat:@"%.2f bytes", sizeOfByte];
    }else{
        CGFloat sizeOfKB = sizeOfByte/1024;
        if (sizeOfKB < 1024) {
            sizeDisplayStr = [NSString stringWithFormat:@"%.2f KB", sizeOfKB];
        }else{
            CGFloat sizeOfM = sizeOfKB/1024;
            if (sizeOfM < 1024) {
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f M", sizeOfM];
            }else{
                CGFloat sizeOfG = sizeOfKB/1024;
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f G", sizeOfG];
            }
        }
    }
    return sizeDisplayStr;
}

- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (BOOL)isEmpty
{
    return [[self trimWhitespace] isEqualToString:@""];
}

//判断是否为整形
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (location = 0; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    return NSMakeRange(location, length - location);
}
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = [self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    return NSMakeRange(location, length - location);
}

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    return [self substringWithRange:[self rangeByTrimmingLeftCharactersInSet:characterSet]];
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    return [self substringWithRange:[self rangeByTrimmingRightCharactersInSet:characterSet]];
}

-(NSString *)stringForImageRatioURL:(int32_t)ratio
{
    NSArray *arr = [self componentsSeparatedByString:@"/"];
    NSString *picName = [arr lastObject];
    NSString *b = [self substringToIndex:(self.length - picName.length)];
    NSMutableString *st = [[NSMutableString alloc] init];
    [st appendString:b];
    [st appendString:[NSString stringWithFormat:@"%d",ratio]];
    [st appendString:@"/"];
    [st appendString:picName];
    NSString *t = [[NSString alloc] initWithString:st];
    return t;
}

-(bool)isImageRatioURL:(int32_t)ratio
{
    NSArray *arr = [self componentsSeparatedByString:@"/"];
    if (arr != nil) {
        if(arr.count > 1){
            if ([[arr objectAtIndex:arr.count-2] isEqualToString:[NSString stringWithFormat:@"%d", ratio]]) {
                return true;
            }
        }
    }
    return false;
}

#pragma mark 其他方法
/**
 * 计算text的尺寸变种版;
 */
- (CGSize)sizeWithFontEx:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT); // MAXFLOAT是float可用最大值;
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}
/**
 * 计算text的尺寸;
 */
- (CGSize)sizeWithFontEx:(UIFont *)font
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT); // MAXFLOAT是float可用最大值;
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

+(NSString *)stringWithTS:(int64_t)TS formate:(NSString *)formate{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formate];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:TS/1000];
    NSString * result = [formatter stringFromDate:date];
    return result;
    
}

//字符串导出图片
+(UIImage *)imageWithStr:(NSString *)str StrRect:(CGRect)strRect  fontSize:(CGFloat)fontSize  TextColor:(UIColor *)textColor Rotate:(CGFloat)rotate MaxWidth:(CGFloat)maxWidth{
    // 获得一个位图图形上下文
    UIGraphicsBeginImageContextWithOptions (strRect.size, YES , 0.0 );
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );

    CGContextTranslateCTM(context, strRect.size.width/2, strRect.size.height/2);
    CGContextRotateCTM(context, rotate);
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName :[ UIFont systemFontOfSize:fontSize ]} context:nil];
    [str drawInRect:CGRectMake(-rect.size.width/2, -rect.size.height/2, rect.size.width, rect.size.height) withAttributes:@{ NSFontAttributeName :[ UIFont systemFontOfSize:fontSize ], NSForegroundColorAttributeName :textColor} ];
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
}

@end
