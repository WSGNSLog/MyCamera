//
//  NewTestView.h
//  MyCamera
//
//  Created by shiguang on 2018/8/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTestView : UIView
@property(nonatomic,assign)BOOL canEdit;
@property(nonatomic,assign)BOOL canDelete;
@property(nonatomic,copy)NSString * text;
@property(nonatomic,assign)BOOL isPreview;
@property(nonatomic,retain)UIColor * textColor;
@property(nonatomic,copy)void(^editTextBlock)(NewTestView * textView);
@property(nonatomic,retain)UILabel * textLabel;
@property(nonatomic,assign)CGPoint resetCenter;
@property(nonatomic,assign)CGPoint editOriginalCenter;
@property(nonatomic,copy)void(^editDateBlock)(void);
@property(nonatomic,assign)CGFloat rotate;
@end
