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
    [self addOneChildVC:find title:@"首页" imageName:@"11" selectedImageName:@"22"];
    
    
    ViewController *noteMake = [ViewController new];
    [self addOneChildVC:noteMake title:@"热门" imageName:@"13" selectedImageName:@"14"];
    
    
    ViewController *micMake = [ViewController new];
    [self addOneChildVC:micMake title:@"发现" imageName:@"15" selectedImageName:@"16"];
    
    
    ViewController *mine = [[ViewController alloc]init];
    [self addOneChildVC:mine title:@"我的" imageName:@"17" selectedImageName:@"18"];
    
    
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
//隐藏tabbar
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.view;
    
    if ([tab.subviews count] < 2) {
        return;
    }
    UIView *view;
    
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
    }
    
    self.selectedViewController.view.frame = view.frame;
    
    self.tabBar.hidden = hidden;
    //    self.cameraBtn.hidden = hidden;
}
- (BOOL)shouldAutorotate
{
    if ([self.selectedViewController isKindOfClass:[UIViewController class]]) {
        return [self.selectedViewController shouldAutorotate];
    }
    return YES;
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if ([self.selectedViewController isKindOfClass:[UIViewController class]]) {
        return [self.selectedViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;//只支持这所有方向(正常的方向)
}
@end
