//
//  ZYJDrawLineInfo.m
//  photoEdit
//
//  Created by 赵彦杰 on 2016/10/24.
//  Copyright © 2016年 赵彦杰. All rights reserved.
//

#import "FingerDrawLineInfo.h"

@implementation FingerDrawLineInfo
- (instancetype)init {
    if (self=[super init]) {
        self.linePoints = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}
@end
