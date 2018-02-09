//
//  EasyCameraMedia.h
//  BabyDaily
//
//  Created by Alice on 2017/8/1.
//  Copyright © 2017年 Andon Health Co,.Ltd;. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum:int{
    EasyCameraMediaTypeImage = 1,
    EasyCameraMediaTypeVideo = 2,

} EasyCameraMediaType;
@interface EasyCameraMedia : NSObject
@property(nonatomic,assign)EasyCameraMediaType type;
@property(nonatomic,retain)NSString * thumbPath;
@property(nonatomic,assign)CGFloat duration;
@property(nonatomic,retain)NSString * locationName;
@property(nonatomic,retain)NSString * country;
@property(nonatomic,retain)NSString * fileName;
@property(nonatomic,retain)NSString * city;
@property(nonatomic,retain)NSDate * dateInfo;
@property(nonatomic,retain)NSString * phoneNum;
@property(nonatomic,retain)NSString * isEdited;
@property(nonatomic,retain)NSString  *  longitude;//经度
@property(nonatomic,retain) NSString  * latitude;//纬度
@property(nonatomic,retain)NSString * district;//区
-(NSString *)dateStr;
-(NSString *)filePath;
-(NSString *)videoPath;
-(NSURL*) videoURL;
-(BOOL)isSameBlockWithAnother:(EasyCameraMedia *)media;

@end
