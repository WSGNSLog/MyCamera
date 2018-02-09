//
//  EasyCameraSQL.m
//  BabyDaily
//
//  Created by Alice on 2017/8/1.
//  Copyright © 2017年 Andon Health Co,.Ltd;. All rights reserved.
//

#import "EasyCameraSQL.h"
#import "LHDB.h"

@implementation EasyCameraSQL
+(void)insertEasyCameraMediaWith:(EasyCameraMedia *)info{
    [info save];
}

+(void)deleteEasyCameraMediaWith:(EasyCameraMedia * )info{
    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"fileName = '%@'",info.fileName];
    NSArray * result = [EasyCameraMedia selectWithPredicate:predicate];
    if (result && result.count > 0) {
        //删除本地文件
        EasyCameraMedia * media = result.firstObject;
 
        NSString * filePath =[media filePath] ;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        
        [EasyCameraMedia deleteWithPredicate:predicate];
        
    }
}

+(EasyCameraMedia *)selectLastMedia{
//    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@'",[Login curLoginUser].phone];
    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@'",@"15600000000"];
    NSArray * result = [EasyCameraMedia selectWithPredicate:predicate];
    return  result.lastObject;
}
+(NSArray *)getAll{
//    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@'",[Login curLoginUser].phone];
    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@'",@"15600000000"];
    NSArray * result = [EasyCameraMedia selectWithPredicate:predicate];
    return result;
}
+(NSArray *)getAllImages{
//    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@' and type = 1",[Login curLoginUser].phone];
    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@' and type = 1",@"15600000000"];
    NSArray * result = [EasyCameraMedia selectWithPredicate:predicate];
    return result;
}


@end
