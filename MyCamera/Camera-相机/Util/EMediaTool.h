//
//  EMediaTool.h
//  eCamera
//
//  Created by shiguang on 2018/2/5.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECameraAsset.h"
typedef void(^EPhotoCallBack)(ECameraAsset *_Nullable asset);

@interface EMediaTool : NSObject

+ (void)getLatestAsset:(EPhotoCallBack _Nullable)callBack;

@end
