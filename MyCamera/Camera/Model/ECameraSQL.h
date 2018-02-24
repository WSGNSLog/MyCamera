//
//  ECameraSQL.h
//  eCamera
//
//  Created by shiguang on 2018/1/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECameraMediaModel.h"

@interface ECameraSQL : NSObject
+(void)insertEasyCameraMediaWith:(ECameraMediaModel *)info;
+(void)deleteEasyCameraMediaWith:(ECameraMediaModel * )info;
+(ECameraMediaModel *)selectLastMedia;
+(NSArray *)getAll;
+(NSArray *)getAllImages;
@end
