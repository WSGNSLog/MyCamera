//
//  AlbumItemModel.h
//  eCamera
//
//  Created by shiguang on 2018/3/28.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface AlbumItemModel : NSObject

@property (nonatomic,strong) PHAsset *asset;

@property (nonatomic,strong) UIImage *photoImg;

@property (nonatomic,copy) NSString *creationDate;
@property (nonatomic,copy) NSString *creationTime;

@end
