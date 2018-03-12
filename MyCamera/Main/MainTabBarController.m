//
//  MainTabBarController.m
//  MyCamera
//
//  Created by shiguang on 2018/3/12.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "MainTabBarController.h"
#import "ViewController.h"
#import "AlbumController.h"
#import "VideoAssetPickerController.h"
#import "MyNavigationController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildVc];
}
- (void)addChildVc {
    
    
    
    ViewController *find = [[ViewController alloc] init];
    [self addOneChildVC:find title:@"首页" imageName:@"1" selectedImageName:@"2"];
    
    
    ViewController *noteMake = [ViewController new];
    [self addOneChildVC:noteMake title:@"热门" imageName:@"3" selectedImageName:@"4"];
    
    
    ViewController *micMake = [ViewController new];
    [self addOneChildVC:micMake title:@"发现" imageName:@"5" selectedImageName:@"6"];
    
    
    ViewController *mine = [[ViewController alloc]init];
    [self addOneChildVC:mine title:@"我的" imageName:@"7" selectedImageName:@"8"];
    
    
}
- (void)addOneChildVC:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    // 设置标题
    childVc.title = title;
    
    // 设置图标
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.image = image;
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 不要渲染
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    // 添加为tabbar控制器的子控制器
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBar.hidden = YES;
    [self addChildViewController:nav];
}

@end
