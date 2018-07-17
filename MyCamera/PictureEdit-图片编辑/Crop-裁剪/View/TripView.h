//
//  TripView.h
//  BabyDaily
//
//  Created by 刘秀红 on 2017/12/18.
//  Copyright © 2017年 Andon Health Co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum:NSInteger{
    TripTypeFree = 0,
    TripType11 = 1,
    TripType34 = 2,
    TripType43 = 3,
    TripType916 = 4,
    TripType169 = 5,
}TripType;
@interface TripView : UIView
@property(nonatomic,assign)TripType type;
@property(nonatomic,assign)CGRect tripRect;
@end
