//
//  PhotoPreviewController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/15.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoPreviewController.h"
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import "NSDictionary+CLLocation.h"
#import "WGS84TOGCJ02.h"
#import "PhotoEditController.h"
#import "PhotoCutController.h"

@interface PhotoPreviewController ()<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageV;
@property (strong, nonatomic) NSURL *imgUrl;
@property (nonatomic, strong) CLLocationManager *locationManager;//拍照定位

@end

@implementation PhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        
        __weak typeof(self)weakSelf = self;
        
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
    
    __weak typeof(self)weakSelf = self;
    
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
