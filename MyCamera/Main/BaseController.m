//
//  BaseController.m
//  MyCamera
//
//  Created by shiguang on 2018/6/15.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "BaseController.h"
#import "MainTabBarController.h"

@interface BaseController ()

@end

@implementation BaseController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *needHiddenViews = @[@"PhotoCIFilterController"];
    
    if (self.tabBarController) {
        MainTabBarController *tabVC = (MainTabBarController *)self.tabBarController;
        NSString *myClassString = NSStringFromClass([self class]);
        if ([needHiddenViews containsObject:myClassString]) {
            [tabVC setTabBarHidden:YES];
        }else{
            [tabVC setTabBarHidden:NO];
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


@end
