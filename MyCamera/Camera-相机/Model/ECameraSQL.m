//
//  ECameraSQL.m
//  eCamera
//
//  Created by shiguang on 2018/1/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "ECameraSQL.h"
#import "LHDB.h"

@implementation ECameraSQL
+(void)insertEasyCameraMediaWith:(ECameraMediaModel *)info{
    [info save];
}

+(void)deleteEasyCameraMediaWith:(ECameraMediaModel * )info{
    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"fileName = '%@'",info.fileName];
    NSArray * result = [ECameraMediaModel selectWithPredicate:predicate];
    if (result && result.count > 0) {
        //删除本地文件
        ECameraMediaModel * media = result.firstObject;
        
        NSString * filePath =[media filePath] ;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        
        [ECameraMediaModel deleteWithPredicate:predicate];
        
    }
}

+(ECameraMediaModel *)selectLastMedia{
    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@'",@"110"];
    NSArray * result = [ECameraMediaModel selectWithPredicate:predicate];
    return  result.lastObject;
}
+(NSArray *)getAll{
    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@'",@"110"];
    NSArray * result = [ECameraMediaModel selectWithPredicate:predicate];
    return result;
}
+(NSArray *)getAllImages{
    LHPredicate * predicate = [LHPredicate predicateWithFormat:@"phoneNum = '%@' and type = 1",@"110"];
    NSArray * result = [ECameraMediaModel selectWithPredicate:predicate];
    return result;
}
@end
