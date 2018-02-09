//
//  EasyCameraMedia.m
//  BabyDaily
//
//  Created by Alice on 2017/8/1.
//  Copyright © 2017年 Andon Health Co,.Ltd;. All rights reserved.
//

#import "EasyCameraMedia.h"

@implementation EasyCameraMedia
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"easycamera"];
    NSString * filePath;
    switch (self.type) {
        case EasyCameraMediaTypeVideo:
            filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,self.thumbPath] ;
            break;
        case EasyCameraMediaTypeImage:
            filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,self.fileName] ;
            break;
        default:
            break;
    }
    return filePath;
}
-(NSString *)videoPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"easycamera"];
    NSString * filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,self.fileName] ;
    return filePath;
}


-(NSURL *)videoURL{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"easycamera"];
    NSString * filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,self.fileName] ;
    return [NSURL fileURLWithPath:filePath];
    
}
-(NSString *)dateStr{
    NSDate * date = self.dateInfo;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString * string = [formatter stringFromDate:date];
    return string;
}

-(BOOL)isSameBlockWithAnother:(EasyCameraMedia *)another{
 
    if (self.country == nil && another.country == nil) {
        if ([self isIn5MileBetwenA:self AndB:another]) {//无城市信息只判断距离
            return YES;
        }else{
            return NO;
        }
    }else if (self.country == nil || another.country == nil){
        return NO;
    }
    if (self.city == nil && another.city == nil) {//两个照片都无城市信息
        if ([self isIn5MileBetwenA:self AndB:another]) {//无城市信息只判断距离
            return YES;
        }else{
            return NO;
        }
    }else if (self.city == nil || another.city == nil){//一个有城市信息、一个无城市信息
        return NO;
    }else{//两个都有城市信息
        if([self.city isEqualToString:another.city] == NO){//不同城市
            return NO;
        }
        if ([self isIn5MileBetwenA:self AndB:another]) {//相同城市5公里内
            return YES;
        }
    }

    return NO;
}

-(BOOL)isIn5MileBetwenA:(EasyCameraMedia *)a AndB:(EasyCameraMedia *)b{

//    CLLocation * a1 = [[CLLocation alloc]initWithLatitude:[a.latitude doubleValue] longitude:[a.longitude doubleValue]];
//    CLLocation * b1 = [[CLLocation alloc]initWithLatitude:[b.latitude doubleValue] longitude:[b.longitude doubleValue]];;
//  CLLocationDistance  dis =  [a1 distanceFromLocation:b1];
//   
//    if (dis < 5000) {
//        return YES;
//    }
    return NO;
}



@end
