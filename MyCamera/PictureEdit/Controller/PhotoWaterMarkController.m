//
//  PhotoWaterMarkController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/23.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoWaterMarkController.h"
#import "PhotoLocationController.h"

@interface PhotoWaterMarkController ()

@end

@implementation PhotoWaterMarkController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.imageView.image = self.image;
}
- (IBAction)locationBtnClick:(UIButton *)sender {
    
    PhotoLocationController *location = [[PhotoLocationController alloc]init];
    [self.navigationController pushViewController:location animated:YES];
    
}

- (IBAction)logoBtnClick:(UIButton *)sender {
    
}

- (IBAction)timeClick:(UIButton *)sender {
    
}

@end
