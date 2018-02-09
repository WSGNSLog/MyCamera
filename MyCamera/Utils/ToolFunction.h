//
//  ToolFunction.h
//  AndonFunction
//
//  Created by 宣佚 on 14/11/30.
//  Copyright (c) 2014年 刘宣佚. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(BOOL, ENUM_NETSTATUS_TYPE) {
    
    //未连接
    NETSTATUS_TYPE_NONE    = NO,
    
    //已连接
    NETSTATUS_TYPE_ISREACHABLE = YES
};

@interface ToolFunction : NSObject
//获取当前视图
+ (UIViewController *)topViewController ;

//获取农历
+(NSString *)getChineseDateStr:(NSDate*)date;

/**
 *判断是否适App Store版本
 *
 *
 *  @return
 */

+(BOOL)isAppStore;

//裁剪图片
+ (UIImage *)clipWithImageRect:(CGSize)clipSize clipImage:(UIImage *)clipImage;
//获得是今天，昨天，或者是周几
+(NSString *)getWeekInfoWithDate:(NSDate *)newsDate;

/**
 *  获取GUID
 *
 *  @param IsLower 是否为小写
 *
 *  @return GUID
 */
+(NSString *)GetGUID_IsLower:(BOOL)IsLower;



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
;

/**
 *  对字符串进行SHA1加密
 *
 *  @param topInfo 需要加密的文字
 *  @param const_Str 常量盐值
 *  @param IsLower 是否为小写
 *
 *  @return 加密后的内容
 */
+(NSString *)SHA1:(NSString *)topInfo const_Str:(NSString *)const_Str IsLower:(BOOL)IsLower;

/**
 *  解QueryString成NSDictionary
 *
 *  @param queryString queryString
 *
 *  @return 解成的NSDictionary
 */
+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString;

/**
 *  字典变成QueryString
 *
 *  @param topInfo 数据字典
 *
 *  @return QueryString
 */
+ (NSString *)queryStringValue:(NSDictionary *)topInfo;

/**
 *  URL Encoded
 *
 *  @param URLString URLString
 *
 *  @return Encoded String
 */
+ (NSString *)URLEncodedString:(NSString *)URLString;

/**
 *  URL Decoded
 *
 *  @param URLString URLString
 *
 *  @return Decoded String
 */
+ (NSString *)URLDecodedString:(NSString *)URLString;

/**
 *  获取网络状态
 *
 *  @return ENUM_NETSTATUS_TYPE 连接状态
 */
+(ENUM_NETSTATUS_TYPE)getNetWorkIsExistence;
/**
 *  改变图片尺寸
 *
 *  @return
 */
+(UIImage*)ScaleImage:(UIImage *)image Size:(CGSize)size;
/**
 *  处理特殊格式的手机号为标准格式
 *
 *  @return
 */
+(NSString*)dealWithPhone:(NSString*)strPhone;
/**
 *  判断手机号格式是否正确
 *
 *  @return
 */
+(BOOL)checkPhoneNumInput:(NSString*)mobileNum;

/**
 *  计算一个view相对于屏幕(去除顶部statusbar的20像素)的坐标
 *  iOS7下UIViewController.view是默认全屏的，要把这20像素考虑进去
 *
 *  @return
 */
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v;
/**
 *  获取顶层UIViewController
 *
 *
 *  @return
 */
+ (UIViewController *)appRootViewController;
/**
 *  复制字符串到剪贴板
 *
 *
 *  @return
 */
+(void)CopyTextToPasteboard:(NSString*)copyed;
/**
 *  取得非nil对象
 *
 *
 *  @return
 */
+(instancetype)GetObjectNotNil:(id)object class:(NSString*)name;
/**
 *  使用safari打开页面
 *
 *
 *  @return
 */
+(void)OpenUrlWithSafari:(NSString*)stringURL;
/**
 *  删除所有子视图
 *
 *
 *  @return
 */
+(void)clearSubViews:(UIView*)supView;
/**
 *  取得沙盒路径
 *
 *
 *  @return
 */
+(NSString*)getAppLocalPath;
/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;


+(NSDictionary*)stringToDictionary:(NSString*)str;

+(void)doLogout;

+(void)setToumingNavigateBar:(UINavigationBar*)navigationBar;

+(NSURL*)String2Url:(NSString*)str;

+(BOOL)wanshanInfoTipView:(UIViewController*)vc;

//+(void)setTabbarTitleFont:(CGFloat)iSize Tabbar:(UITabBarItem*)Tabbar;

+(void)TableSectionBuTingLiu:(UIScrollView*)scrollView sectionHeaderHeight:(CGFloat)sectionHeaderHeight;

+(NSString *)AccordingPanyDayMathPanyDay_Formmat:(int64_t)date startdate:(int64_t)startdate;

+(void)resetCell:(UITableViewCell*)cell;

+(NSURL*)orgPotoStringToThumUrl:(NSString*)str;

+(NSURL*)orgPotoStringToThumUrl_100:(NSString*)str;

+(NSURL*)orgPotoStringToThumUrl:(NSString*)str imgSize:(int32_t)imgSize;

//检查版本更新
+(void)ShengJiCondition:(void (^)(BOOL blnHasUpdate))Finished;

+(void)pushRegisterSyn;

+(void)FangZhiLianDianEvent:(NSObject*)target todoSomething:(SEL)todoSomething Sender:(NSObject*)Sender;


+(NSString*)GetLoadingGifPath;

+(void)SetNavigateBarStyle:(UINavigationBar*)navigationBar;

+(NSString *)GetLocalScreenShotByDailyId:(NSString *)dailyid;

+(void)StopShengYinBoFang;


+(long)AccordingPanyDayMathPanyDay_Formmat_GetWeek:(int64_t)date startdate:(int64_t)startdate;

+(NSString*)getApiVersionNumber;

+(void)setTakeBigVedioToumingNavigateBar:(UINavigationBar*)navigationBar;

+(NSString*)getApiVersionNumber2;

+(NSString*)VersionNumberFromLongToString:(long)ver;

+(int64_t)getYestodayStartTime;

+(void)setPaiZhaoToumingNavigateBar:(UINavigationBar*)navigationBar;

+(UIImage *)cropImage:(UIImage *)oldImage Rect:(CGRect)Rect;

+(void)cutVideoWithFinished:(NSString*)_betaCompressionDirectory ExportPath:(NSString*)_outputFilePathLow finished:(void (^)(void))finished;

+(UIViewController*)viewController:(UIView*)view;

+(NSData*) loadFileContentsIntoTextView:(NSString*)filePath StartPos:(int64_t)StartPos;

+(unsigned long long) fileSizeAtPath:(NSString*) filePath;

+(int32_t)getNetworkStatus;

+(void)setVedioPlayerToumingNavigateBar:(UINavigationBar*)navigationBar;
+(NSString*)NotNilString:(NSString*)str;

+(void)SetNavigateBarStyle_White:(UINavigationBar*)navigationBar;

+(NSDate*) convertDateFromString:(NSString*)uiDate;

+(NSString *)stringFromDate:(NSDate *)date;

+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;


/**
 * 设置圆形UIView圆角;
 */
+(void)makeCircleView:(UIView *)viewIn;
/**
 * 设置UIView圆角;
 */
+(void)makeCornerView:(UIView *)viewIn cornerRadius:(float)cornerRadius;

+(int)judgeTipNetDisconnect;
+(int)judgeTipNetDisconnectNoTit;

/**
 * 开启屏幕旋转
 */
+(void)beginScreenRotation;
/**
 * 结束屏幕旋转
 */
+(void)endScreenRotation;

/**
 * 将NSDictionary或NSArray转化为JSON串
 */
+ (NSString *)toJSONData:(id)theData;
/**
 * 将NSString转化为NSDictionary或NSArray
 */
+ (id)toArrayOrNSDictionary:(NSString *)jsonString;

/**
 * 获取本地时间戳
 */
+ (NSInteger)getLocalTs;
/**
 * 获取本地时间戳(精确到毫秒)
 */
+ (NSInteger)getLocalTs_ms;
+ (NSInteger)getLocalLongTs;
/**
 * 获取本地时间戳
 */
+ (NSString *)getLocalTs_str;


+(void)openWifiSetting;

+(NSString *)displayNumberWithVersion:(int64_t )version;

+(void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                     imageData:(NSData *)imageData
               customAlbumName:(NSString *)customAlbumName
               completionBlock:(void (^)(void))completionBlock
                  failureBlock:(void (^)(NSError *error))failureBlock;

+(void)saveRecordFileWithPath:(NSString *)videoPath
              customAlbumName:(NSString *)customAlbumName
              completionBlock:(void (^)(void))completionBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;
+(void)createAlbumWithName:(NSString *)name;
+(void)transMovToMP4:(NSString*)strInput Output:(NSString*)path;

+(NSDictionary *)readDatFileWithPath:(NSString * )path;

@end
