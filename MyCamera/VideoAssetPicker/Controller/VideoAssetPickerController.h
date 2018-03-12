//
//  VideoAssetPickerController.h
//  CustomCamera
//
//  Created by shiguang on 2018/3/9.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, PickerMediaType) {
    PickerMediaTypeAny = 0,
    PickerMediaTypeImage,
    PickerMediaTypeVideo
};

@class PHAssetCollection;
@interface VideoAssetPickerController : UIViewController

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, assign) PickerMediaType mediaType;

@end
