//
//  AlbumVideoPreviewVC.h
//  eCamera
//
//  Created by shiguang on 2018/3/29.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class AlbumItemModel;
@interface AlbumVideoPreviewVC : UIViewController

@property (nonatomic,strong) PHAsset *asset;


@property (nonatomic,strong) AlbumItemModel *model;
@end
