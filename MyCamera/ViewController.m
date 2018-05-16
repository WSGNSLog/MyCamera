//
//  ViewController.m
//  MyCamera
//
//  Created by shiguang on 2018/1/11.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import "CameraVC.h"
#import "AlbumController.h"
#import "MenuInfo.h"
#import "PhotoPreviewController.h"
@interface ViewController ()

@property (nonatomic, strong)  NSArray *menuList;

@end

@implementation ViewController
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
    
    UIButton *openCamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openCamBtn.frame = CGRectMake(150, 200, 80, 50);
    [openCamBtn setTitle:@"openCam" forState:UIControlStateNormal];
    [openCamBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [openCamBtn addTarget:self action:@selector(openCamBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openCamBtn];
    
    UIButton *openAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openAlbumBtn.frame = CGRectMake(150, 300, 80, 50);
    [openAlbumBtn setTitle:@"打开相册视频" forState:UIControlStateNormal];
    [openAlbumBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [openAlbumBtn addTarget:self action:@selector(openAlbumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openAlbumBtn];
    
    UIButton *openAlbumPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openAlbumPhotoBtn.frame = CGRectMake(150, 400, 80, 50);
    [openAlbumPhotoBtn setTitle:@"打开相册" forState:UIControlStateNormal];
    [openAlbumPhotoBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [openAlbumPhotoBtn addTarget:self action:@selector(openAlbumPhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openAlbumPhotoBtn];
    
    
    
    
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

- (void)openAlbumPhotoBtnClick{
    PhotoPreviewController *albumVC = [[PhotoPreviewController alloc]init];
    [self.navigationController pushViewController:albumVC animated:YES];
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
    MenuInfo *menuInfo = _menuList[pageIndex];
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
- (void)openCamBtnClick{
//    [Helper checkCameraAuthorizationStatus];
    CameraVC *camVC = [[CameraVC alloc]init];
    
//    [self presentViewController:camVC animated:YES completion:nil];
}

- (void)openAlbumBtnClick{
    AlbumController *albumVC = [[AlbumController alloc]init];
    [self.navigationController pushViewController:albumVC animated:YES];
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


- (void)openGeneralSetting{
    NSString * defaultWork = [self getDefaultWork];
    NSString * bluetoothMethod = [self getBluetoothMethod];
    NSURL*url=[NSURL URLWithString:@"App-Prefs:root=General"];
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]   performSelector:NSSelectorFromString(bluetoothMethod) withObject:url     withObject:nil];
    
}
-(void)openWifiSetting{
    NSString * defaultWork = [self getDefaultWork];
    NSString * bluetoothMethod = [self getBluetoothMethod];
    NSURL*url=[NSURL URLWithString:@"Prefs:root=WIFI"];
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]   performSelector:NSSelectorFromString(bluetoothMethod) withObject:url     withObject:nil];
}

-(NSString *) getDefaultWork{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
    NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return method;
}

-(NSString *) getBluetoothMethod{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
    NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
    NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
    NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
    return method;
}

@end
