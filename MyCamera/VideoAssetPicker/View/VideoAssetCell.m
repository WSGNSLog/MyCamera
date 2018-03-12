//
//  VideoAssetCell.m
//  MyCamera
//
//  Created by shiguang on 2018/3/12.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "VideoAssetCell.h"

@interface VideoAssetCell()
@property (weak, nonatomic) IBOutlet UIView *overlayView;



@end

@implementation VideoAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    self.overlayView.hidden = !(selected && self.showsOverlayViewWhenSelected);
}
@end
