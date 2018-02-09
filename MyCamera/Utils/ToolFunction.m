//
//  ToolFunction.m
//  AndonFunction
//
//  Created by 宣佚 on 14/11/30.
//  Copyright (c) 2014年 刘宣佚. All rights reserved.
//

#import "ToolFunction.h"
#import <CommonCrypto/CommonDigest.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>
#import "AppDelegate.h"
//#import "Login.h"
//#import "OpenAppManage.h"
//#import "wanshanxinxitipview.h"
//#import "Alg_BabyGrowthDay.h"
//#import "NSString+Common.h"
//#import "Tool_AppInfo.h"
//#import "RequestApiManage.h"
//#import "Tool_UserDefaultInfo.h"
//#import "SwiftHeader.h"
#import "AVFoundation/AVFoundation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
//空字符串
#define     LocalStr_None           @""
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation ToolFunction

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

//获取农历
+(NSString *)getChineseDateStr:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSCalendarUnit calenderUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:calenderUnit fromDate:date];
    NSArray * monthArr = [NSArray arrayWithObjects:
                @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                @"九月", @"十月", @"冬月", @"腊月", nil];
    
        NSArray *dayArr = [NSArray arrayWithObjects:
              @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
              @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
              @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    if(components.isLeapMonth == NO){
        return [NSString stringWithFormat:@"%@年%@%@",chineseYears[components.year -1],monthArr[components.month - 1],dayArr[components.day -1]];
    }else{
        return [NSString stringWithFormat:@"%@年闰%@%@",chineseYears[components.year -1],monthArr[components.month - 1],dayArr[components.day -1]];

    }
}
+ (UIImage *)clipWithImageRect:(CGSize)clipSize clipImage:(UIImage *)clipImage

{
    CGSize oldSize = clipImage.size;
    CGSize newSize ;
    if (oldSize.width > oldSize.height) {
        CGFloat  height = oldSize.height/oldSize.width * clipSize.width;
        newSize = CGSizeMake( clipSize.width, height);
    }else{
        CGFloat width = oldSize.width/oldSize.height * clipSize.height;
        newSize = CGSizeMake(width, clipSize.height);
        
    }
    UIGraphicsBeginImageContext(newSize);
    
    [clipImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
//获得是今天，昨天，或者是周几
+(NSString *)getWeekInfoWithDate:(NSDate *)newsDate
{
    NSString *dateContent;
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today=[[NSDate alloc] init];
    NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];

    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents* comp = [calendar components:unitFlags fromDate:newsDate];
    
    NSDateComponents* compYesterday= [calendar components:unitFlags fromDate:yearsterDay];
    NSDateComponents* compToday = [calendar components:unitFlags fromDate:today];
    
    if ( comp.year == compYesterday.year && comp.month == compYesterday.month && comp.day == compYesterday.day) {
        dateContent = @"昨天";
    }
    else if (comp.year == compToday.year && comp.month == compToday.month && comp.day == compToday.day)
    {
        dateContent = @"今天";
    }
    else
    {
        NSArray * weekdays = @[@"",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        //显示星期几
        dateContent = [weekdays objectAtIndex:comp.weekday];
    }
    return dateContent;
}
/**
 *  获取GUID
 *
 *  @param IsLower 是否为小写
 *
 *  @return GUID
 */
+(NSString *)GetGUID_IsLower:(BOOL)IsLower
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    NSString *str = [uuidString stringByReplacingOccurrencesOfString:@"-"
                                                          withString:@""];
    NSString *lowerStr = @"";
    if (IsLower) {
        lowerStr = [str lowercaseString];
    } else {
        lowerStr = [str uppercaseString];
    }
    return lowerStr;
}

/**
 *  对字符串进行MD5加密
 *
 *  @param topInfo 需要加密的文字
 *  @param encode 编码类型 OA为16little
 *  @param IsLower 是否为小写
 *
 *  @return 加密后的内容
 */
+(NSString *)MD5:(NSString *)topInfo StringCode:(NSStringEncoding)encode IsLower:(BOOL)IsLower
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
+(NSString *)SHA1:(NSString *)topInfo const_Str:(NSString *)const_Str IsLower:(BOOL)IsLower
{
    NSString *tempMd5 = [NSString stringWithFormat:@"%@%@",const_Str,topInfo];
    NSString *md5 = [ToolFunction MD5:tempMd5 StringCode:NSUTF8StringEncoding IsLower:YES];
    
    NSString *tempSH = [NSString stringWithFormat:@"%@%@",md5,topInfo];
    
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

/**
 *  解QueryString成NSDictionary
 *
 *  @param queryString queryString
 *
 *  @return 解成的NSDictionary
 */
+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if (elements.count == 2)
        {
            NSString *key = elements[0];
            NSString *value = elements[1];
            NSString *decodedKey = [self URLDecodedString:key];
            NSString *decodedValue = [self URLDecodedString:value];
            
            if (![key isEqualToString:decodedKey])
                key = decodedKey;
            
            if (![value isEqualToString:decodedValue])
                value = decodedValue;
            
            [dictionary setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

/**
 *  字典变成QueryString
 *
 *  @param topInfo 数据字典
 *
 *  @return QueryString
 */
+ (NSString *)queryStringValue:(NSDictionary *)topInfo {
    
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [topInfo keyEnumerator])
    {
        id value = [topInfo objectForKey:key];
        NSString *escapedValue = [self URLEncodedString:value];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escapedValue]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

/**
 *  URL Encoded
 *
 *  @param URLString URLString
 *
 *  @return Encoded String
 */
+ (NSString *)URLEncodedString:(id)URLString {
    __autoreleasing NSString *encodedString;
    NSString *originalString = (NSString *)URLString;
    encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (__bridge CFStringRef)originalString,
                                                                                          NULL,
                                                                                          (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                          kCFStringEncodingUTF8
                                                                                          );
    return encodedString;
}

/**
 *  URL Decoded
 *
 *  @param URLString URLString
 *
 *  @return Decoded String
 */
+ (NSString *)URLDecodedString:(id)URLString {
    __autoreleasing NSString *decodedString;
    NSString *originalString = (NSString *)URLString;
    decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                          NULL,
                                                                                                          (__bridge CFStringRef)originalString,
                                                                                                          CFSTR(""),
                                                                                                          kCFStringEncodingUTF8
                                                                                                          );
    return decodedString;
}

/**
 *  获取网络状态
 *
 *  @return ENUM_NETSTATUS_TYPE 连接状态
 */
+(ENUM_NETSTATUS_TYPE)getNetWorkIsExistence{
    
    struct sockaddr_in zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    
    zeroAddress.sin_len = sizeof(zeroAddress);
    
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    
    CFRelease(defaultRouteReachability);
    
    
    if (!didRetrieveFlags){
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable && !needsConnection) ? NETSTATUS_TYPE_ISREACHABLE : NETSTATUS_TYPE_NONE;
}
/**
 *  改变图片尺寸
 *
 *  @return
 */
+(UIImage*)ScaleImage:(UIImage *)image Size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

+(BOOL)isOkCharForPhone:(NSString*)chr{
    if ([chr isEqualToString:@"0"]) {
        return TRUE;
    }
    else if ([chr isEqualToString:@"1"]){
        return TRUE;
    }
    else if ([chr isEqualToString:@"2"]){
        return TRUE;
    }
    else if ([chr isEqualToString:@"3"]){
        return TRUE;
    }
    else if ([chr isEqualToString:@"4"]){
        return TRUE;
    }
    else if ([chr isEqualToString:@"5"]){
        return TRUE;
    }
    else if ([chr isEqualToString:@"6"]){
        return TRUE;
    }
    else if ([chr isEqualToString:@"7"]){
        return TRUE;
    }
    else if ([chr isEqualToString:@"8"]){
        return TRUE;
    }
    else if ([chr isEqualToString:@"9"]){
        return TRUE;
    }
    return FALSE;
}
/**
 *  处理特殊格式的手机号为标准格式
 *
 *  @return
 */
//+(NSString*)dealWithPhone:(NSString*)strPhone{
//    NSString *newStr = strPhone;
//    NSString *temp = nil;
//    NSString *strRet = @"";
//    for(int i =0; i < [newStr length]; i++)
//    {
//        temp = [newStr substringWithRange:NSMakeRange(i, 1)];
//        if ([self isOkCharForPhone:temp]) {
//            strRet = [strRet stringByAppendingString:temp];
//        }
//    }
//    return strRet;
//}
+(NSString*)dealWithPhone:(NSString*)strPhone{
    NSString *newStr = strPhone;
    NSString *temp = nil;
    NSString *strRet = @"";
    for(int i = (int)([newStr length])-1; i >= 0; i--)
    {
        temp = [newStr substringWithRange:NSMakeRange(i, 1)];
        if ([self isOkCharForPhone:temp]) {
            strRet = [NSString stringWithFormat:@"%@%@", temp, strRet];
        }
        if (strRet.length == 11) {
            break;
        }
    }
    return strRet;
}
/**
 *  判断手机号格式是否正确
 *
 *  @return
 */
+(BOOL)checkPhoneNumInput:(NSString*)mobileNum{

    NSString * MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL res = [regextestmobile evaluateWithObject:mobileNum];
    return res;
}
/**
 *  计算一个view相对于屏幕(去除顶部statusbar的20像素)的坐标
 *  iOS7下UIViewController.view是默认全屏的，要把这20像素考虑进去
 *
 *  @return
 */
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    int iCalCount = 0;
    while (view.frame.size.width != 320 || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
        iCalCount++;
        if (iCalCount > 10) {
            return v.frame;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}
/**
 *  获取顶层UIViewController
 *
 *
 *  @return
 */
+ (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
/**
 *  复制字符串到剪贴板
 *
 *
 *  @return
 */
+(void)CopyTextToPasteboard:(NSString*)copyed{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = copyed;
}

/**
 *  取得非nil对象
 *
 *
 *  @return
 */
+(instancetype)GetObjectNotNil:(id)object class:(NSString*)name{
    if (object == nil) {
         return [[NSClassFromString(name) alloc] init];
    }
    else{
        return object;
    }
}

/**
 *  使用safari打开页面
 *
 *
 *  @return
 */
+(void)OpenUrlWithSafari:(NSString*)stringURL{
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}
/**
 *  删除所有子视图
 *
 *
 *  @return
 */
+(void)clearSubViews:(UIView*)supView{
    for (int i = (int)(supView.subviews.count)-1; i >= 0; i--) {
        id vw = [supView.subviews objectAtIndex:i];
        [ToolFunction clearSubViews:vw];
        [vw removeFromSuperview];
        vw = nil;
    }
}
/**
 *  取得沙盒路径
 *
 *
 *  @return
 */
+(NSString*)getAppLocalPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    return (NSString*)[paths objectAtIndex:0];
}
+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}



+(NSDictionary*)stringToDictionary:(NSString*)str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

+(void)doLogout{
//    [Login doLogout];
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    delegate.window.rootViewController = [[OpenAppManage sharedHandler] ShowLoginView];
}

+(void)setTakeBigVedioToumingNavigateBar:(UINavigationBar*)navigationBar{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [ToolFunction setToumingNavigateBar:navigationBar];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[navigationBar setTranslucent:YES];
    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([navigationBar respondsToSelector:@selector(shadowImage)])
    {
//                [navigationBar setShadowImage:[ToolFunction ScaleImage:[UIImage imageNamed:@"HalfTranNavBackground"] Size:navigationBar.frame.size]];
        [navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [navigationBar setBackgroundImage:[ToolFunction ScaleImage:[UIImage imageNamed:@"HalfTranNavBackground"] Size:navigationBar.frame.size] forBarMetrics:UIBarMetricsDefault];
}

+(void)setVedioPlayerToumingNavigateBar:(UINavigationBar*)navigationBar{
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [ToolFunction setToumingNavigateBar:navigationBar];
    //[navigationBar setTranslucent:YES];
    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([navigationBar respondsToSelector:@selector(shadowImage)])
    {
        //                [navigationBar setShadowImage:[ToolFunction ScaleImage:[UIImage imageNamed:@"HalfTranNavBackground"] Size:navigationBar.frame.size]];
        [navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [navigationBar setBackgroundImage:[ToolFunction ScaleImage:[UIImage imageNamed:@"HalfTranNavBackground"] Size:navigationBar.frame.size] forBarMetrics:UIBarMetricsDefault];
}

+(void)setPaiZhaoToumingNavigateBar:(UINavigationBar*)navigationBar{
    //[navigationBar setTranslucent:YES];
    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([navigationBar respondsToSelector:@selector(shadowImage)])
    {
//        [navigationBar setShadowImage:[ToolFunction ScaleImage:[UIImage imageNamed:@"logo_paizhao"] Size:navigationBar.frame.size]];
    }
    [navigationBar setBackgroundImage:[ToolFunction ScaleImage:[UIImage imageNamed:@"logo_paizhao"] Size:navigationBar.frame.size] forBarMetrics:UIBarMetricsDefault];
}

+(void)setToumingNavigateBar:(UINavigationBar*)navigationBar{
    [navigationBar setTranslucent:YES];
    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

+(void)SetNavigateBarStyle:(UINavigationBar*)navigationBar{
    [navigationBar setTranslucent:NO];
    UIImage *image = LXY_STRETCH_IMAGE([UIImage imageNamed:@"babyInfo-nav"], UIEdgeInsetsMake(0, 1, 0, 1));
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

+(void)SetNavigateBarStyle_White:(UINavigationBar*)navigationBar{
    [navigationBar setTranslucent:NO];
    UIImage *image = LXY_STRETCH_IMAGE([UIImage imageNamed:@"gerenxinxi_nav"], UIEdgeInsetsMake(0, 1, 0, 1));
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    if ([navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

+(NSURL*)String2Url:(NSString*)str{
    if ([str hasPrefix:@"http"] == TRUE) {
        return [NSURL URLWithString:str];
    }
    else{
        return [NSURL fileURLWithPath:str];
    }
}

+(NSURL*)orgPotoStringToThumUrl:(NSString*)str{
    if ([str hasPrefix:@"http"] == TRUE) {
        return [NSURL URLWithString:[str stringForImageRatioURL:480]];
    }
    else{
        if ([[NSFileManager defaultManager] fileExistsAtPath:str]) {
            return [NSURL fileURLWithPath:str];
        }
        else{
            return [NSURL fileURLWithPath:[[ToolFunction getAppLocalPath] stringByAppendingPathComponent:str]];
        }
    }
}

+(NSURL*)orgPotoStringToThumUrl_100:(NSString*)str{
    return [self orgPotoStringToThumUrl:str imgSize:100];
}

+(NSURL*)orgPotoStringToThumUrl:(NSString*)str imgSize:(int32_t)imgSize{
    if ([str hasPrefix:@"http"] == TRUE) {
        return [NSURL URLWithString:[str stringForImageRatioURL:imgSize]];
    }
    else{
        if ([[NSFileManager defaultManager] fileExistsAtPath:str]) {
            return [NSURL fileURLWithPath:str];
        }
        else{
            return [NSURL fileURLWithPath:[[ToolFunction getAppLocalPath] stringByAppendingPathComponent:str]];
        }
    }
}


+(void)TableSectionBuTingLiu:(UIScrollView*)scrollView sectionHeaderHeight:(CGFloat)sectionHeaderHeight
{
    scrollView.showsVerticalScrollIndicator = false;
    
    CGFloat topTemp = scrollView.contentInset.top - 64;
    CGFloat yTemp = scrollView.contentOffset.y + 64;
    CGFloat heightTemp = sectionHeaderHeight + 64;
    
    if ( yTemp <= heightTemp && yTemp >= topTemp ) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (yTemp>=heightTemp) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 64, 0);
    }
}

//+(NSString *)AccordingPanyDayMathPanyDay_Formmat:(int64_t)date startdate:(int64_t)startdate
//{
//    @try {
//        Alg_BabyGrowthDay *alg = [[Alg_BabyGrowthDay alloc] init];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
//        NSDate *panDate = [NSDate dateWithTimeIntervalSince1970:date];
//        NSTimeInterval interval = 280 * 24 * 60 * 60;
//        NSTimeInterval ts = -interval;
//        NSString *preString = [dateFormatter stringFromDate:[panDate initWithTimeInterval:ts sinceDate:panDate]];
//        NSDate *destDate= [dateFormatter dateFromString:preString];
//        int64_t prets = [destDate timeIntervalSince1970];
//        NSString *reString = [alg ComDateToString_Week:prets startdate:startdate];
//        return reString;
//    }
//    @catch (NSException *exception) {
//        MsgBoxTool(exception);
//        return nil;
//    }
//}

//+(long)AccordingPanyDayMathPanyDay_Formmat_GetWeek:(int64_t)date startdate:(int64_t)startdate
//{
//    @try {
//        Alg_BabyGrowthDay *alg = [[Alg_BabyGrowthDay alloc] init];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
//        NSDate *panDate = [NSDate dateWithTimeIntervalSince1970:date];
//        NSTimeInterval interval = 280 * 24 * 60 * 60;
//        NSTimeInterval ts = -interval;
//        NSString *preString = [dateFormatter stringFromDate:[panDate initWithTimeInterval:ts sinceDate:panDate]];
//        NSDate *destDate= [dateFormatter dateFromString:preString];
//        int64_t prets = [destDate timeIntervalSince1970];
//        return [alg ComDateToString_Week_GetWeek:prets startdate:startdate];
//    }
//    @catch (NSException *exception) {
//        MsgBoxTool(exception);
//        return 0;
//    }
//}

//+(void)resetCell:(UITableViewCell*)cell{
//    if (cell.detailTextLabel != nil) {
//        cell.detailTextLabel.text = @"";
//        [ToolFunction clearSubViews:cell.detailTextLabel];
//        cell.detailTextLabel.textColor = [UIColor colorWithRed:Table_FuBiaoTi_ColorValue green:Table_FuBiaoTi_ColorValue blue:Table_FuBiaoTi_ColorValue alpha:1.0];
//        cell.detailTextLabel.font = [UIFont fontWithName:System_Font size:Table_FuBiaoTi_FontSize];
//    }
//    if (cell.imageView != nil) {
//        if (cell.imageView.frame.size.height > 0 && cell.imageView.frame.size.width > 0) {
//            cell.imageView.image = [[UIImage alloc] init];
//            [ToolFunction clearSubViews:cell.imageView];
//        }
//    }
//    if (cell.textLabel != nil) {
//        cell.textLabel.text = @"";
//        [ToolFunction clearSubViews:cell.textLabel];
//        cell.textLabel.textColor = [UIColor colorWithRed:Table_ZhuBiaoTi_ColorValue green:Table_ZhuBiaoTi_ColorValue blue:Table_ZhuBiaoTi_ColorValue alpha:1.0];
//        cell.textLabel.font = [UIFont fontWithName:System_Font size:Table_ZhuBiaoTi_FontSize];
//    }
//}


+(NSString*)VersionNumberFromLongToString:(long)ver{
    NSString* strThird = [NSString stringWithFormat:@"%ld", ver % 1000];
    NSString* strSecond = [NSString stringWithFormat:@"%ld", (ver / 1000) % 1000];
    NSString* strFirst = [NSString stringWithFormat:@"%ld", (ver/1000000) % 1000];
    return [NSString stringWithFormat:@"%@.%@.%@", strFirst, strSecond, strThird];
}


+(void)FangZhiLianDianEvent:(NSObject*)target todoSomething:(SEL)todoSomething Sender:(NSObject*)Sender{
    //先将未到时间执行前的任务取消。
    [[NSObject class] cancelPreviousPerformRequestsWithTarget:target selector:todoSomething object:Sender];
    [target performSelector:todoSomething withObject:Sender afterDelay:0.2f];
}


+(NSString*)GetLoadingGifPath{
    return [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
}

+(NSString *)GetLocalScreenShotByDailyId:(NSString *)dailyid{
    @try {
        NSString *recorderPath = @"";
        recorderPath = [recorderPath stringByAppendingFormat:@"%@.png",dailyid];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:recorderPath];
        return filePath;
    }
    @catch (NSException *exception) {
//        MsgBoxTool(exception);
        return @"";
    }
}

/**
 *判断是否适App Store版本
 *
 *
 *  @return
 */
+(BOOL)isAppStore{
#if TARGET_VERSION ==3
#ifdef APPSTORE
    return YES;
#endif
#endif
    return NO;
}

+(int64_t)getYestodayStartTime{
    NSTimeInterval interval = [[NSDate new] utcTimeStamp] - 24*3600;
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:interval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:timeDate];
    long year = [comps year];
    long month = [comps month];
    long day = [comps day];
    NSString* strDateTime = [NSString stringWithFormat:@"%ld-%ld-%ld %d:%d:%d", year, month, day, 0, 0, 0];
    return [[NSDate dateFromString:strDateTime withFormat:@"yyyy-MM-dd HH:mm:ss"] utcTimeStamp]*1000;
}

+(UIImage *)cropImage:(UIImage *)oldImage Rect:(CGRect)Rect{
    CGRect rect = Rect;
    CGSize boundSize = oldImage.size;
    float heightFactor = boundSize.width * (rect.size.height/rect.size.width);
    CGRect factoredRect = CGRectMake(0,0, boundSize.width, heightFactor);
    if (oldImage.imageOrientation == UIImageOrientationLeft || oldImage.imageOrientation == UIImageOrientationRight || oldImage.imageOrientation == UIImageOrientationLeftMirrored || oldImage.imageOrientation == UIImageOrientationRight) {
        factoredRect = CGRectMake(0,0, heightFactor, boundSize.width);
    }
    UIImage *croppedImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([oldImage CGImage], factoredRect) scale:oldImage.scale orientation:oldImage.imageOrientation];
    return croppedImage;
}

#if 1
+(void)cutVideoWithFinished:(NSString*)_betaCompressionDirectory ExportPath:(__weak NSString*)_outputFilePathLow finished:(void (^)(void))finished{
    _outputFilePathLow = _betaCompressionDirectory;
    finished();
}
#else
+(void)cutVideoWithFinished:(NSString*)_betaCompressionDirectory ExportPath:(NSString*)_outputFilePathLow finished:(void (^)(void))finished
{
    //设置时间
    
    CMTime totalDuration = kCMTimeZero;
    
    //视频配置
    
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    //视频内容集合
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:_betaCompressionDirectory]];
    
    //音频具体内容集合
    
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // 裁剪,rangtime .前面的是开始时间,后面是裁剪多长
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:kCMTimeZero error:nil];
    
    //视频内容集合
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //视频内容集合首位内容
    
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    //这块是剪裁
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    
    
    //设置视频图层信息
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    //持续时间
    
    totalDuration = CMTimeAdd(totalDuration, asset.duration);
    
    //设置大小，可以自己设置
    
    CGSize renderSize = CGSizeMake(400, 400);
    
    renderSize.width = MAX(renderSize.width, videoAssetTrack.naturalSize.height);
    
    renderSize.height = MAX(renderSize.height, videoAssetTrack.naturalSize.width);
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    
    //设置比率
    
    CGFloat rate;
    
    rate = renderW / MIN(videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.height);
    
    //设置旋转，缩放
    
    CGAffineTransform layerTransform = CGAffineTransformMake(videoAssetTrack.preferredTransform.a, videoAssetTrack.preferredTransform.b, videoAssetTrack.preferredTransform.c, videoAssetTrack.preferredTransform.d, videoAssetTrack.preferredTransform.tx * rate, videoAssetTrack.preferredTransform.ty * rate);
    
    layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(videoAssetTrack.naturalSize.width - videoAssetTrack.naturalSize.height) / 2.0));
    
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
    
    [layerInstruction setTransform:layerTransform atTime:kCMTimeZero];
    
    [layerInstruction setOpacity:1.0 atTime:totalDuration];
    
    
    
    //设置instruction
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    
    instruction.layerInstructions = @[layerInstruction];
    
    
    
    // 这个视频大小可以由你自己设置。
    
    AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoComposition];
    
    mainComposition.instructions = @[instruction];
    
    mainComposition.frameDuration = CMTimeMake(1, 30);
    
    //这边设置生成视频大小
    
    mainComposition.renderSize = CGSizeMake(renderW, renderW);
    
    NSError *error = nil;
    
    //设置存储路径并开始录制
    
    NSString *outputFielP=_outputFilePathLow;
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    if ([fm fileExistsAtPath:outputFielP]) {
        
        NSLog(@"video is have. then delete that");
        
        if ([fm removeItemAtPath:outputFielP error:&error]) {
            
            NSLog(@"delete is ok");
            
        }else {
            
            NSLog(@"delete is no error = %@",error.description);
            
        }
        
    }
    
    
    
    // 导出视频
    
    AVAssetExportSession* _exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    
    _exporter.videoComposition = mainComposition;
    
    _exporter.outputURL = [NSURL fileURLWithPath:outputFielP];
    
    _exporter.outputFileType = AVFileTypeMPEG4;
    
    _exporter.shouldOptimizeForNetworkUse = YES;
    
    [_exporter exportAsynchronouslyWithCompletionHandler:^{
        
        finished();
        
    }];
    
}
#endif

+(UIViewController*)viewController:(UIView*)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+(unsigned long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


+(NSString*)NotNilString:(NSString*)str{
    return (str == nil ? @"" : str);
}

+(NSDate*) convertDateFromString:(NSString*)uiDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image2.size);
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    // Draw image1
//    CGFloat ftSpace = 60;
    CGFloat ftSpace = image2.size.width * 180/500;
    CGFloat ftX = 0, ftY = 0, ftWidth = 0, ftHeight = 0;
    if (image1.size.width > image1.size.height) {
        ftX = ftSpace;
        ftWidth = image2.size.width - 2*ftSpace;
        ftHeight = ftWidth * (image1.size.height/image1.size.width);
        ftY = (image2.size.height - ftHeight) / 2.0;
    }
    else{
        ftY = ftSpace;
        ftHeight = image2.size.width - 2*ftSpace;
        ftWidth = ftHeight * (image1.size.width/image1.size.height);
        ftX = (image2.size.width - ftWidth) / 2.0;
    }
    [image1 drawInRect:CGRectMake(ftX, ftY, ftWidth, ftHeight)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


// 设置圆形UIView圆角;
+(void)makeCircleView:(UIView *)viewIn
{
    float cornerRadius = viewIn.frame.size.width * 0.5;
    viewIn.layer.masksToBounds = YES; //没这句话它圆不起来
    viewIn.layer.cornerRadius = cornerRadius; //设置图片圆角的尺度
}

// 设置UIView圆角;
+(void)makeCornerView:(UIView *)viewIn cornerRadius:(float)cornerRadius
{
    viewIn.layer.masksToBounds = YES; //没这句话它圆不起来
    viewIn.layer.cornerRadius = cornerRadius; //设置图片圆角的尺度
}

+(int)judgeTipNetDisconnect
{
    if (![ToolFunction getNetWorkIsExistence]) {
        [MBProgressHUD showError:@"网络不给力，操作失败！"];
        return 1;
    }
    return 0;
}

+(int)judgeTipNetDisconnectNoTit
{
    if (![ToolFunction getNetWorkIsExistence]) {
        return 1;
    }
    return 0;
}

+(void)beginScreenRotation
{
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = YES;
}

+(void)endScreenRotation
{
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = NO;
//
//    //强制归正：
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val =UIInterfaceOrientationPortrait;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
}

/**
 * 将NSDictionary或NSArray转化为NSString
 */
+ (NSString *)toJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length] > 0 && error == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else
    {
        return nil;
    }
}

/**
 * 将NSString转化为NSDictionary或NSArray
 */
+ (id)toArrayOrNSDictionary:(NSString *)jsonString
{
    // 将NSString转化为NSData
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

/**
 * 获取本地时间戳
 */
+ (NSInteger)getLocalTs
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSInteger ii = a / 1;
    
    return ii;
}

/**
 * 获取本地时间戳
 */
+ (NSString *)getLocalTs_str
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long ii = a / 1;
    
    NSNumber *longlongNumber = [NSNumber numberWithLongLong:ii];
    NSString *longlongStr = [longlongNumber stringValue];
    return longlongStr;
}

/**
 * 获取本地时间戳(精确到毫秒)
 */
+ (NSInteger)getLocalTs_ms
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000;
    NSInteger ii = a / 1;
    
    return ii;
}

+ (NSInteger)getLocalLongTs
{
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[dat timeIntervalSince1970]*10000000;
    NSInteger ii = a / 1;
    return ii;
}

+(void)openWifiSetting{
    CGFloat deviceVersion  = [[UIDevice currentDevice].systemVersion floatValue];
    if (deviceVersion <10.0)
    {
        NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
        [[UIApplication sharedApplication] openURL:url];
    }else if(deviceVersion < 11.0){
        NSString * defaultWork = [self getDefaultWork];
        NSString * openURLMethod = [self openURLMethod];
        Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
        NSURL*url=[NSURL URLWithString:@"Prefs:root=WIFI"];
        [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]   performSelector:NSSelectorFromString(openURLMethod) withObject:url  withObject:nil];
    }else{
            NSString * defaultWork = [self getDefaultWork];
            NSString * openURLMethod = [self openURLMethod];
            NSURL*url=[NSURL URLWithString:@"App-Prefs:root=General"];
            Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
            [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]   performSelector:NSSelectorFromString(openURLMethod) withObject:url     withObject:nil];
            

    }
}

+(NSString *) getDefaultWork{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
    NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return method;
}

+(NSString *) openURLMethod{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
    NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
    NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
    NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
    return method;
}

+(NSString *)displayNumberWithVersion:(int64_t )version{
    NSString * str = [NSString stringWithFormat:@"%zd",version];
    NSUInteger a = str.length;
    if (a < 9) {
        for (NSUInteger i = a; i<9; i++) {
            str = [@"0" stringByAppendingString:str];
        }
    }
    NSString * str1 = [str substringToIndex:3];
    NSString * str2 = [str substringWithRange:NSMakeRange(3, 3)];
    NSString * str3 = [str substringFromIndex:6];
    str = [NSString stringWithFormat:@"%d.%d.%d",[str1 intValue],[str2 intValue],[str3 intValue]];
    return str;
}




+(void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(weakSelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

+(void)saveRecordFileWithPath:(NSString *)videoPath
              customAlbumName:(NSString *)customAlbumName
              completionBlock:(void (^)(void))completionBlock
                 failureBlock:(void (^)(NSError *error))failureBlock{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
  
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(weakSelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}
+(void)createAlbumWithName:(NSString *)name{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            BOOL haveHDRGroup = NO;
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name1 =[gp valueForProperty:ALAssetsGroupPropertyName];
                if ([name1 isEqualToString:name])
                {
                    haveHDRGroup = YES;
                }
            }
            if (!haveHDRGroup)
            {
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
                } error:nil];

                haveHDRGroup = YES;
            }
        }
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
}

+(void)transMovToMP4:(NSString*)strInput Output:(NSString*)path{
    @try {
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:strInput] options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]){
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
            exportSession.outputURL = [NSURL fileURLWithPath:path];
            exportSession.outputFileType = AVFileTypeMPEG4;
            exportSession.shouldOptimizeForNetworkUse = YES;
            CMTime time = [avAsset duration];
            CMTime start = CMTimeMakeWithSeconds(0.0, time.timescale);
            CMTime duration = CMTimeMakeWithSeconds(ceil(time.value/time.timescale), time.timescale);
            CMTimeRange range = CMTimeRangeMake(start, duration);
            exportSession.timeRange = range;
            
            NSCondition * mainThreadCondition = [[NSCondition alloc] init];
            NSFileManager * fileManager = [NSFileManager defaultManager];

            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                switch ([exportSession status]) {
                    case AVAssetExportSessionStatusFailed:
                        LLog(@"将视频从mov导出到mp4失败: %@", [[exportSession error] localizedDescription]);
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        LLog(@"导出视频被终了");
                        break;
                    case AVAssetExportSessionStatusCompleted:
                        if ([fileManager fileExistsAtPath:path]) {
                            LLog(@"导出视频成功");
                        }
                        else{
                            LLog(@"将视频从mov导出到mp4失败: %@", [[exportSession error] localizedDescription]);
                        }
                        break;
                    default:
                        LLog(@"将视频从mov导出到mp4失败: %@", [[exportSession error] localizedDescription]);
                        break;
                }
                [mainThreadCondition signal];
            }];
            [mainThreadCondition lock];
            [mainThreadCondition wait];
            [mainThreadCondition unlock];
        }
    }
    @catch (NSException *exception) {
//        MsgBoxTool(exception);
    }
    
}



@end
