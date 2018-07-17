//
//  AlbumSectionModel.m
//  eCamera
//
//  Created by shiguang on 2018/3/28.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "AlbumSectionModel.h"

@implementation AlbumSectionModel
- (NSArray *)itemsArr{
    if (!_itemsArray) {
        _itemsArray = [NSArray array];
    }
    return _itemsArray;
}
@end
