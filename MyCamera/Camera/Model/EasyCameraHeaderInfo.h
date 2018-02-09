//
//  EasyCameraHeaderInfo.h
//  BabyDaily
//
//  Created by Alice on 2018/1/10.
//  Copyright © 2018年 Andon Health Co,.Ltd;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyCameraMedia.h"
@interface EasyCameraHeaderInfo : NSObject
@property(nonatomic,retain)EasyCameraMedia * baseMedia;
@property(nonatomic,retain)NSString * dateInfo;;//日期，包括星期信息
@property(nonatomic,retain)NSString * city;
@property(nonatomic,retain)NSString * country;
@property(nonatomic,retain)NSString * locationName;
@property(nonatomic,retain)NSString * districtName;
@property(nonatomic,retain)NSString * dateStr;//日期，不包括星期信息
@end
