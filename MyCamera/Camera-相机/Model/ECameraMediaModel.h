//
//  ECameraMediaModel.h
//  eCamera
//
//  Created by shiguang on 2018/1/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum:int{
    ECameraMediaTypeImage = 1,
    ECameraMediaTypeVideo = 2,
    
} ECameraMediaType;

@interface ECameraMediaModel : NSObject

@property(nonatomic,assign)ECameraMediaType type;
@property(nonatomic,retain)NSString * thumbFileName;
@property(nonatomic,retain)NSString *thumbFilePath;
@property(nonatomic,assign)CGFloat duration;


@property(nonatomic,retain)NSString * fileName;

@property(nonatomic,retain)NSDate * dateInfo;
@property(nonatomic,retain)NSString * phoneNum;
@property(nonatomic,retain)NSString * isEdited;


-(NSString *)dateStr;
-(NSString *)filePath;
-(NSString *)videoPath;
-(NSURL*) videoURL;
@end
