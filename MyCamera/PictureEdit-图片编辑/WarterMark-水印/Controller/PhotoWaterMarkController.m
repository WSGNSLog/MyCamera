//
//  PhotoWaterMarkController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/23.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoWaterMarkController.h"
#import "PhotoLocationController.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
//#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "ActionSheetDatePicker.h"

@interface PhotoWaterMarkController ()<BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>
{
    BMKPoiSearch* _searcher;
    BMKLocationService* _locService;
    CLLocation *_userLocation;
    BMKGeoCodeSearch* _geocodesearch;
}
@property (weak, nonatomic) IBOutlet UIView *picBgView;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain,nonatomic) UIImage *showImg;
@property (nonatomic,copy) NSString *originLocStr;
@property (nonatomic,copy) NSString *locationNameStr;
@property (nonatomic,copy) NSString *addressStr;
@property (weak, nonatomic) IBOutlet UIButton *logoBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (nonatomic,retain) UILabel *locationLabel;
@property (nonatomic,retain) UILabel *logoLabel;
@property (nonatomic,retain) UILabel *dateLabel;
@property (nonatomic, copy) NSMutableAttributedString *locAttributeStr;
@property (nonatomic, copy) NSString *logoStr;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, readonly) CGRect imageRect;

@end

@implementation PhotoWaterMarkController
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        _imageView.image = self.showImg;
    }
    return _imageView;
}
- (void)addLocationLabel{
    WEAKSELF
    if (self.locationLabel) {
        [self.locationLabel removeFromSuperview];
        self.locationLabel = nil;
    }
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont systemFontOfSize:13];
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.textAlignment = NSTextAlignmentRight;
    [self.imageView addSubview:self.locationLabel];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.imageView).offset(-((weakSelf.picBgView.size.width-weakSelf.imageRect.size.width)/2+10));
        make.top.equalTo(@((weakSelf.picBgView.size.height-weakSelf.imageRect.size.height)/2+10));
    }];
}
- (void)addLogoLabel{
    if (self.logoLabel) {
        [self.logoLabel removeFromSuperview];
        self.logoLabel = nil;
    }
    WEAKSELF
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.logoStr];
    
    [attributedString addAttributes:@{
                                      NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-bold" size:18],NSForegroundColorAttributeName:[UIColor whiteColor]}
                              range:NSMakeRange(0, 4)];
    
    self.logoLabel = [[UILabel alloc]init];
    //CGFloat logoW = 150;
    //CGFloat logoH = 20;
    //self.logoLabel.frame = CGRectMake((weakSelf.picBgView.size.width-(weakSelf.picBgView.size.width-weakSelf.imageRect.size.width)/2-10-logoW), (weakSelf.picBgView.size.height-(weakSelf.picBgView.size.height-weakSelf.imageRect.size.height)/2-10-logoH), logoW, logoH);
    self.logoLabel.textAlignment = NSTextAlignmentRight;
    self.logoLabel.attributedText = attributedString;
    [self.imageView addSubview:self.logoLabel];
    self.logoLabel.font = [UIFont systemFontOfSize:13];
    self.logoLabel.textColor = [UIColor whiteColor];
    self.logoLabel.textAlignment = NSTextAlignmentRight;
    self.logoLabel.attributedText = attributedString;
    [self.imageView addSubview:self.logoLabel];
    
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.imageView).offset(-((weakSelf.picBgView.size.width-weakSelf.imageRect.size.width)/2+10));
        make.bottom.equalTo(@(-((weakSelf.picBgView.size.height-weakSelf.imageRect.size.height)/2+10)));
    }];
}
- (void)addLogoLabe2{
    WEAKSELF
    if (self.logoLabel) {
        [self.logoLabel removeFromSuperview];
        self.logoLabel = nil;
    }
    //通过NSTextAttachment将水印图片添加到富文本中，再将富文本显示到label上
    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
    attachment.image = [UIImage imageNamed:@"watermark_logo_pic"];
    attachment.bounds = CGRectMake(0, -3, 33, 23);
    NSDictionary *attributeDic =@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" by%@",@"shiguang"] attributes:attributeDic];
    [attributedString insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
    
    self.logoLabel = [[UILabel alloc]init];
    //    self.logoLabel.font = [UIFont systemFontOfSize:13];
    //    self.logoLabel.textColor = [UIColor whiteColor];
    CGFloat logoW = 150;
    CGFloat logoH = 20;
    self.logoLabel.frame = CGRectMake((weakSelf.picBgView.size.width-(weakSelf.picBgView.size.width-weakSelf.imageRect.size.width)/2-10-logoW), (weakSelf.picBgView.size.height-(weakSelf.picBgView.size.height-weakSelf.imageRect.size.height)/2-10-logoH), logoW, logoH);
    self.logoLabel.textAlignment = NSTextAlignmentRight;
    self.logoLabel.attributedText = attributedString;
    [self.imageView addSubview:self.logoLabel];
    
    //    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(weakSelf.imageView).offset(-((weakSelf.picBgView.size.width-weakSelf.imageRect.size.width)/2+10));
    //        make.bottom.equalTo(@(-((weakSelf.picBgView.size.height-weakSelf.imageRect.size.height)/2+10)));
    //    }];
}
- (void)addDateLabel{
    WEAKSELF
    if (self.dateLabel) {
        [self.dateLabel removeFromSuperview];
        self.dateLabel = nil;
    }
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:13];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    [self.imageView addSubview:self.dateLabel];
    
    self.dateLabel.text = self.dateStr;
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageView).offset((weakSelf.picBgView.size.width-weakSelf.imageRect.size.width)/2+10);
        make.bottom.equalTo(@(-((weakSelf.picBgView.size.height-weakSelf.imageRect.size.height)/2+10)));
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    WEAKSELF
    [self.picBgView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakSelf.picBgView);
    }];
    
    if (self.locAttributeStr) {
        [self addLocationLabel];
        self.locationLabel.attributedText= self.locAttributeStr;
    }else{
        [self.locationLabel removeFromSuperview];
        self.locationLabel = nil;
    }
    if (self.dateStr) {
        [self addDateLabel];
    }else{
        [self.dateLabel removeFromSuperview];
        self.dateLabel = nil;
    }
    if (self.logoStr) {
        [self addLogoLabel];
    }else{
        [self.logoLabel removeFromSuperview];
        self.logoLabel = nil;
    }
    
    _geocodesearch.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    _locService.delegate = nil;
    _searcher.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    /*
     _geocodesearch = [[BMKGeoCodeSearch alloc]init];
     _geocodesearch.delegate = self;
     CLLocation *assetLocation = self.asset.location;
     CLLocationCoordinate2D originCoor = (CLLocationCoordinate2D){0, 0};//原始坐标
     if (assetLocation.coordinate.latitude && assetLocation.coordinate.longitude) {
     originCoor = (CLLocationCoordinate2D){assetLocation.coordinate.latitude, assetLocation.coordinate.longitude};
     }
     
     //转换WGS84坐标至百度坐标(加密后的坐标)
     NSDictionary* testdic = BMKConvertBaiduCoorFrom(originCoor,BMK_COORDTYPE_GPS);
     
     NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
     //解密加密后的坐标字典
     
     CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
     BMKReverseGeoCodeSearchOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
     reverseGeocodeSearchOption.location = baiduCoor;
     reverseGeocodeSearchOption.isLatestAdmin = YES;
     BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
     if(flag)
     {
     NSLog(@"反geo检索发送成功");
     }
     else
     {
     NSLog(@"反geo检索发送失败");
     }
     */
    
    self.showImg = [self.originImg copy];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:self.asset.location.coordinate.latitude longitude:self.asset.location.coordinate.longitude];
    
    //反向地理编码的请求 -> 根据经纬度 获取 位置
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark *placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSArray *location_Arr = [addressDic objectForKey:@"FormattedAddressLines"];//系统格式化后的位置
            
            self.originLocStr = [location_Arr firstObject];
            NSLog(@"位置: %@",[location_Arr firstObject]);
        }
        if (error) {
            NSLog(@"位置error:%@",error);
        }
    }];
    
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    [_locService startUserLocationService];
}
- (IBAction)locationBtnClick:(UIButton *)sender {
    
    PhotoLocationController *locationVC = [[PhotoLocationController alloc]init];

    WEAKSELF
    locationVC.locationStr = self.originLocStr;
    locationVC.locationBlock = ^(NSString * _Nullable locationNameStr, NSString * _Nullable addressStr){
        weakSelf.locationNameStr = locationNameStr;
        weakSelf.addressStr = addressStr;
        
        if (locationNameStr || addressStr) {
            //watermark_locationicon
            NSMutableAttributedString *muAttr;
            NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
            attachment.image = [UIImage imageNamed:@"wartermark_location_white"];
            attachment.bounds = CGRectMake(0, -3, 16.5, 18.5);
            NSDictionary *attributeDic =@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]};
            if (locationNameStr&&addressStr) {
                muAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",locationNameStr,addressStr] attributes:attributeDic];
            }else if(addressStr){
                muAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",addressStr] attributes:attributeDic];
            }else{
                muAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",locationNameStr] attributes:attributeDic];
            }
            [muAttr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
            weakSelf.locAttributeStr = muAttr;
        }else{
            weakSelf.locAttributeStr = nil;
        }
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (IBAction)logoBtnClick:(UIButton *)sender {
    NSString *userStr = @"shiguang";
    NSString *logoStr = [NSString stringWithFormat:@"Demo by%@",userStr];
    self.logoStr = logoStr;
    [self addLogoLabel];
}
- (IBAction)picLogoBtnClick:(UIButton *)sender {
    [self addLogoLabe2];
}

- (IBAction)timeClick:(UIButton *)sender {
    WEAKSELF
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:[NSDate new] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [format stringFromDate:selectedDate];
        weakSelf.dateStr = dateStr;
        [weakSelf addDateLabel];
        NSLog(@"=====%@",dateStr);
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        NSLog(@"cancelBlock");
        
    } origin:self.view];
    
    int64_t tLow = 0;
    
    [picker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:tLow]];
    [picker setMaximumDate:[NSDate new]];
    [picker showActionSheetPicker];
}



- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage *)composeImg {
    
    CGImageRef imgRef = self.imageView.image.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //以大图大小为底图
    //以showImg的图大小为画布创建上下文
    //UIGraphicsBeginImageContext(CGSizeMake(w, h));
    UIGraphicsBeginImageContextWithOptions(self.showImg.size, NO, 0);
    //先把大图 绘制到上下文中
    [self.imageView.image drawInRect:CGRectMake(0, 0, w, h)];
    //再把小图放到上下文中
    //[self.locationLabel drawInRect:CGRectMake(100, 100, 100, 50)];
    
    CGFloat scaleW = self.showImg.size.width/self.imageRect.size.width;
    CGFloat scaleH = self.showImg.size.height/self.imageRect.size.height;
    if (self.locationLabel) {
        CGFloat locLabelW = scaleW * self.locationLabel.width;
        CGFloat locLabelH = scaleH * self.locationLabel.height;
        [self.locationLabel drawViewHierarchyInRect:CGRectMake(w-locLabelW-10*scaleW,10*scaleH, locLabelW, locLabelH) afterScreenUpdates:YES];
    }
    if (self.logoLabel) {
        CGFloat logoW = scaleW * self.logoLabel.width;
        CGFloat logoH = scaleH * self.logoLabel.height;
        [self.logoLabel drawViewHierarchyInRect:CGRectMake(w-logoW-10*scaleW, h-20*scaleH, logoW, logoH) afterScreenUpdates:YES];
    }
    
    if (self.dateLabel) {
        CGFloat dateW = scaleW * self.dateLabel.width;
        CGFloat dateH = scaleH * self.dateLabel.height;
        [self.dateLabel drawViewHierarchyInRect:CGRectMake(10*scaleW, h-20*scaleH, dateW, dateH) afterScreenUpdates:YES];
    }
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    //CGImageRelease(imgRef);//imageView.image不需要释放
    
    
    return resultImg;
}

- (IBAction)saveClick:(UIButton *)sender {
    
    
    
    //    UIGraphicsBeginImageContextWithOptions(self.showImg.size, NO, 0);
    //    [self.imageView drawViewHierarchyInRect:CGRectMake(0, 0, self.imageView.size.width, self.imageView.size.height) afterScreenUpdates:YES];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    
    if (self.imageBlock) {
        self.imageBlock([[self composeImg] copy]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//图片加文字
- (UIImage *)shuiYinOne{
    
    //开启上下文
    
    //size新图片的大小
    
    //opaque YES不透明 NO透明
    
    CGFloat w = self.showImg.size.width;
    
    UIGraphicsBeginImageContextWithOptions(self.showImg.size,NO, 0.0);
    
    [self.showImg drawAtPoint:CGPointZero];
    
    //    NSString *str =self.locAttributeStr;
    //
    //    NSDictionary *dict =@{
    //
    //                          NSFontAttributeName :self.bubbleView.textView.font,
    //
    //                          NSForegroundColorAttributeName :Color(158,194, 24)
    //
    //                          };
    //
    //    [str drawAtPoint:self.bubbleView.center withAttributes:dict];
    
    CGFloat scaleW = self.showImg.size.width/self.imageRect.size.width;
    CGFloat scaleH = self.showImg.size.height/self.imageRect.size.height;
    CGFloat locLabelW = scaleW * self.locationLabel.width;
    
    [self.locAttributeStr drawAtPoint:CGPointMake(w-locLabelW-10*scaleW, 10*scaleH)];
    
    //获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

// 将UIView转成UIImage
- (UIImage *)getImageFromView:(UIView *)theView
{
    //CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(self.imageRect.size, NO, 1);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()]   ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext()    ;
    UIGraphicsEndImageContext() ;
    
    return image ;
}

- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.originImg.size, self.picBgView.bounds);
}
- (void)dealloc{
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    NSLog(@"%s",__func__);
}
@end
