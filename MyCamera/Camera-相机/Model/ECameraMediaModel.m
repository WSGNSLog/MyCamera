//
//  ECameraMediaModel.m
//  eCamera
//
//  Created by shiguang on 2018/1/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "ECameraMediaModel.h"

@implementation ECameraMediaModel
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"ecamera"];
    NSString * filePath;
    switch (self.type) {
        case ECameraMediaTypeVideo:
            filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,self.thumbFileName] ;
            break;
        case ECameraMediaTypeImage:
            filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,self.fileName] ;
            break;
        default:
            break;
    }
    return filePath;
}
-(NSString *)videoPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"ecamera"];
    NSString * filePath =[NSString stringWithFormat:@"%@/%@",diskCachePath,self.fileName] ;
    return filePath;
}


-(NSURL *)videoURL{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [paths[0] stringByAppendingPathComponent:@"ecamera"];
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

@end
