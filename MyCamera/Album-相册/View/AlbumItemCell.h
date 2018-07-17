//
//  AlbumItemCell.h
//  eCamera
//
//  Created by shiguang on 2018/3/28.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *previewImgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *videoIndicator;

@end
