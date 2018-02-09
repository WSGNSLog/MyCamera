//
//  EasyCameraSQL.h
//  BabyDaily
//
//  Created by Alice on 2017/8/1.
//  Copyright © 2017年 Andon Health Co,.Ltd;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyCameraMedia.h"
@interface EasyCameraSQL : NSObject
+(void)insertEasyCameraMediaWith:(EasyCameraMedia *)info;
+(void)deleteEasyCameraMediaWith:(EasyCameraMedia * )info;
+(EasyCameraMedia *)selectLastMedia;
+(NSArray *)getAll;
+(NSArray *)getAllImages;
@end
