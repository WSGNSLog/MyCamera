//
//  TextInputController.h
//  MyCamera
//
//  Created by shiguang on 2018/8/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextView.h"

@interface TextInputController : UIViewController
@property(nonatomic,copy)void(^completeInputBlock)(NSString * text ,UIColor * textColor);
@property(nonatomic,copy)void(^completeEditBlock)(MyTextView * textView,NSString * text,UIColor * textColor);
@property(nonatomic,copy)void(^cancleEditBlock)(void);
@property(nonatomic,copy)NSString * text;
@property(nonatomic,retain)UIColor * textColor;
@property(nonatomic,retain) MyTextView * textView;

@end
