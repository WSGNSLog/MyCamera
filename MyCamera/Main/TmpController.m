//
//  TmpController.m
//  MyCamera
//
//  Created by shiguang on 2018/7/25.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "TmpController.h"
#import "MenuInfo.h"
#import "AlbumController.h"

@interface TmpController ()
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation TmpController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    self.magicView.itemScale = 1.2;
    //    self.magicView.headerHeight = 40;
    //    self.magicView.navigationHeight = 44;
    //    self.magicView.againstStatusBar = YES;
    //    self.magicView.headerView.backgroundColor = RGBCOLOR(243, 40, 47);
    //    self.magicView.navigationColor = [UIColor whiteColor];
    //    self.magicView.layoutStyle = VTLayoutStyleDefault;
    //    self.edgesForExtendedLayout = UIRectEdgeAll;
    //
    //    [self integrateComponents];
    //    [self configSeparatorView];
    //    [self generateTestData];
    //    [self.magicView reloadData];
}

#pragma mark - actions
- (void)subscribeAction {
    NSLog(@"subscribeAction");
    // against status bar or not
    //    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    //    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
}
- (void)generateTestData {
    NSString *title = @"推荐";
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:24];
    [menuList addObject:[MenuInfo menuInfoWithTitl:title]];
    for (int index = 0; index < 20; index++) {
        title = [NSString stringWithFormat:@"省份%d", index];
        MenuInfo *menu = [MenuInfo menuInfoWithTitl:title];
        [menuList addObject:menu];
    }
    _menuList = menuList;
}
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
    for (MenuInfo *menu in _menuList) {
        [titleList addObject:menu.title];
    }
    return titleList;
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    // 默认会自动完成赋值
    //    MenuInfo *menuInfo = _menuList[itemIndex];
    //    [menuItem setTitle:menuInfo.title forState:UIControlStateNormal];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
//    MenuInfo *menuInfo = _menuList[pageIndex];
    //    if (0 == pageIndex) {
    //        static NSString *recomId = @"recom.identifier";
    //        AlbumController *recomViewController = [magicView dequeueReusablePageWithIdentifier:recomId];
    //        if (!recomViewController) {
    //            recomViewController = [[AlbumController alloc] init];
    //        }
    //        //recomViewController.menuInfo = menuInfo;
    //        return recomViewController;
    //    }
    //
    //    static NSString *gridId = @"grid.identifier";
    //    VTGridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    //    if (!viewController) {
    //        viewController = [[VTGridViewController alloc] init];
    //    }
    //    viewController.menuInfo = menuInfo;
    AlbumController *viewController = [[AlbumController alloc]init];
    return viewController;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    //    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

- (void)integrateComponents {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}
#pragma mark - 设置分割条
- (void)configSeparatorView {
    UIImageView *separatorView = [[UIImageView alloc] init];
    [self.magicView setSeparatorView:separatorView];
    //分割条高度
    self.magicView.separatorHeight = .0f;
    self.magicView.separatorColor = RGBCOLOR(22, 146, 211);
    self.magicView.navigationView.layer.shadowColor = RGBCOLOR(22, 146, 211).CGColor;
    self.magicView.navigationView.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.magicView.navigationView.layer.shadowOpacity = 0.8;
    self.magicView.navigationView.clipsToBounds = NO;
}

@end
