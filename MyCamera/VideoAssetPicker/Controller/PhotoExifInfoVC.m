//
//  PhotoExifInfoVC.m
//  MyCamera
//
//  Created by shiguang on 2018/5/15.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoExifInfoVC.h"
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import "NSDictionary+CLLocation.h"
#import "WGS84TOGCJ02.h"
#import "PhotoEditController.h"
#import "PhotoCutController.h"

@interface PhotoExifInfoVC ()<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSURL *imgUrl;
@property (nonatomic, strong) CLLocationManager *locationManager;//拍照定位
@property (nonatomic, copy)NSString *cachePicPath;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageV;


@end

@implementation PhotoExifInfoVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *dir = [NSString stringWithFormat:@"%@/Documents/PicInfoChange",NSHomeDirectory()];
    BOOL isDir;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL exist = [manager fileExistsAtPath:dir isDirectory:&isDir];
    if (!(exist && isDir)) {
        [manager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.cachePicPath = [NSString stringWithFormat:@"%@/infoPic.png",dir];
}
- (IBAction)openAlbum:(UIButton *)sender {
    
    UIImagePickerController *pickVC = [[UIImagePickerController alloc]init];
    pickVC.delegate = self;
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickVC animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.photoImageV.image = image;
        
        NSData* imageData = UIImagePNGRepresentation(image);
        BOOL result = [imageData writeToFile:self.cachePicPath atomically:YES];
        NSLog(@"=====%d",result);;
        [picker dismissViewControllerAnimated:YES completion:nil];
        self.imgUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    }
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//拍照
        
        //照片mediaInfo
        NSDictionary * imageMetadata = info[@"UIImagePickerControllerMediaMetadata"];
        
        NSDictionary *tIFFDictionary =  [imageMetadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
        
        NSString * pictureTime = tIFFDictionary[@"DateTime"];//2016:01:05 11:45:36
        
        //self.time.text = pictureTime;
        NSLog(@"时间: %@",pictureTime);
        if ([CLLocationManager locationServicesEnabled]) {
            
            //获取经纬度
            [self getLocation];
            
        }else {
            NSLog(@"请开启定位功能！");
        }
        
    } else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){//相册
        
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        __block NSMutableDictionary *imageMetadata_GPS = nil;
  
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            
            //获取时间
            NSDate* pictureDate = [asset valueForProperty:ALAssetPropertyDate];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy:MM:dd HH:mm:ss";
            formatter.timeZone = [NSTimeZone localTimeZone];
            NSString * pictureTime = [formatter stringFromDate:pictureDate];
            //weakSelf.time.text = pictureTime;
            NSLog(@"时间: %@",pictureTime);
            //获取GPS
            imageMetadata_GPS = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
            
            NSDictionary *GPSDict=[imageMetadata_GPS objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
            
            if (GPSDict!=nil) {
                
                CLLocation *loc=[GPSDict locationFromGPSDictionary];
                
                //weakSelf.weidu.text = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
                //weakSelf.jingdu.text = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
                
                CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
                
                CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:loc.coordinate.latitude longitude:loc.coordinate.longitude];
                
                //反向地理编码的请求 -> 根据经纬度 获取 位置
                [clGeoCoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
                    for (CLPlacemark *placeMark in placemarks)
                    {
                        NSDictionary *addressDic=placeMark.addressDictionary;
                        
                        NSArray *location_Arr = [addressDic objectForKey:@"FormattedAddressLines"];//系统格式化后的位置
                        
                        //weakSelf.location.text = [location_Arr firstObject];
                        NSLog(@"位置: %@",[location_Arr firstObject]);
                    }
                }];
                
            }else{
                NSLog(@"此照片没有GPS信息");
                //weakSelf.weidu.text = @"此照片没有GPS信息";
                //weakSelf.jingdu.text = @"此照片没有GPS信息";
                //weakSelf.location.text = @"此照片没有拍摄位置";
            }
            
        }
         
         failureBlock:^(NSError *error) {
             
         }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"点击了取消按钮");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getPhotoInfo:(UIButton *)sender {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library assetForURL:self.imgUrl resultBlock:^(ALAsset *asset) {
        NSDictionary *imageInfo = [asset defaultRepresentation].metadata;
        NSLog(@"**info: %@",imageInfo);
    } failureBlock:^(NSError *error) {
        
    }];
}
- (IBAction)changePicInfo:(UIButton *)sender {
    //2.创建CGImageSourceRef
    NSURL *fileUrl = [NSURL URLWithString:self.cachePicPath];
//    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
//    UIImage *img = [UIImage imageWithContentsOfFile:self.cachePicPath];
//    //3.利用imageSource获取全部ExifData
//
//    CFDictionaryRef imageInfo = CGImageSourceCopyPropertiesAtIndex(imageSource, 0,NULL);
//    //4.从全部ExifData中取出EXIF文件
//
//    NSDictionary *exifDic = (__bridge NSDictionary *)CFDictionaryGetValue(imageInfo, kCGImagePropertyExifDictionary) ;
//    //5.打印全部Exif信息及EXIF文件信息
//
//
//    NSLog(@"All Exif Info:%@",imageInfo);
//    NSLog(@"EXIF:%@",exifDic);


//    写入Exif信息

    //1. 获取图片中的EXIF文件和GPS文件

    NSData *imageData = UIImageJPEGRepresentation(self.photoImageV.image, 1);

    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);

    NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
//    NSDictionary *imageInfo1 = (__bridge NSDictionary*)CGImageSourceCopyProperties(source, NULL);
    NSDictionary *metaInfo = (__bridge NSDictionary *)CGImageSourceCopyMetadataAtIndex(source, 0, NULL);
    NSLog(@"===:%@",imageInfo);
    NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    
    
    //2. 修改EXIF文件和GPS文件中的部分信息

    [exifDic setObject:[NSNumber numberWithFloat:1234.3] forKey:(NSString *)kCGImagePropertyExifExposureTime];
    [exifDic setObject:@"SenseTime" forKey:(NSString *)kCGImagePropertyExifLensModel];

    [GPSDic setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [GPSDic setObject:[NSNumber numberWithFloat:116.29353] forKey:(NSString*)kCGImagePropertyGPSLatitude];

    [metaDataDic setObject:exifDic forKey:(NSString*)kCGImagePropertyExifDictionary];
//    [metaDataDic setObject:GPSDic forKey:(NSString*)kCGImagePropertyGPSDictionary];

    //3. 将修改后的文件写入至图片中

    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *newImageData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1,NULL);

    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metaDataDic);
    CGImageDestinationFinalize(destination);

    //4. 保存图片

//    UIImage *newImg = [UIImage imageWithData:newImageData];
//    NSString *directoryDocuments =  NSTemporaryDirectory();
//    [newImageData writeToFile: directoryDocuments atomically:YES];
//    UIImageWriteToSavedPhotosAlbum(newImg, self, NULL, NULL);
    //存到手机相册
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary writeImageDataToSavedPhotosAlbum:newImageData metadata:metaDataDic completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"***error:%@",error);
        }
    }];
}
- (IBAction)saveClick:(UIButton *)sender {
}
- (IBAction)cancelClick:(UIButton *)sender {
}

- (IBAction)photoCutClick:(UIButton *)sender {
    
    PhotoCutController *cutVC = [[PhotoCutController alloc]init];
    [self.navigationController pushViewController:cutVC animated:YES];
    
}
#pragma mark 拍照定位

-(void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        
        [self.locationManager requestWhenInUseAuthorization];
        
        //设置寻址精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 5.0;
        [self.locationManager startUpdatingLocation];
    }
}
//获取一次定位，然后关掉manager
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //防止多次调用
    
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 5.0) return;
    
    if (currentLocation.horizontalAccuracy < 0) return;
    
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[currentLocation coordinate]]) {
        //转换后的coord
        coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[currentLocation coordinate]];
    }
    
    //当前经纬度
    //self.jingdu.text = [NSString stringWithFormat:@"%f", coord.longitude];
    //self.weidu.text = [NSString stringWithFormat:@"%f", coord.latitude];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    //__weak typeof(self)weakSelf = self;
    
    //反向地理编码的请求 -> 根据经纬度 获取 位置
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
        
        for (CLPlacemark *placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSArray *location_Arr = [addressDic objectForKey:@"FormattedAddressLines"];//系统格式化后的位置
            
            //weakSelf.location.text = [location_Arr firstObject];
            NSLog(@"位置: %@",[location_Arr firstObject]);
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
    
}
-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000.0f;
    }
    return _locationManager;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
