//
//  AlbumController.h
//  CustomCamera
//
//  Created by shiguang on 2018/3/9.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImagePickerMediaType) {
    ImagePickerMediaTypeAny = 0,
    ImagePickerMediaTypeImage,
    ImagePickerMediaTypeVideo
};

@interface AlbumController : UIViewController

@property (nonatomic, assign) ImagePickerMediaType mediaType;

@end
