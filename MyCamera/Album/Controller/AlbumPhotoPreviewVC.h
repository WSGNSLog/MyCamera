//
//  AlbumPhotoPreviewVC.h
//  eCamera
//
//  Created by shiguang on 2018/3/29.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PhotoImageView.h"

@class AlbumItemModel;
@interface AlbumPhotoPreviewVC : UIViewController

@property (nonatomic,strong) PHAsset *asset;

@property (nonatomic,strong) AlbumItemModel *model;

/** 展示照片的视图 */
@property (nonatomic,strong) PhotoImageView *photoImageView;


@end
