//
//  FrameController.m
//  MyCamera
//
//  Created by shiguang on 2018/7/30.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "FrameController.h"
#import "FrameView.h"
#import "FrameCell.h"

#define CellMargin 5
#define CellW 65
@interface FrameController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic)  UIView *bgView;
@property (weak, nonatomic)  UIView *bottomView;

@property (nonatomic,strong) FrameView *frameView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic, readonly) CGRect imageRect;
@property (nonatomic,strong) NSMutableArray *frameArray;


@end


static NSString *const CellID = @"FrameCellID";

@implementation FrameController

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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat height = 105;
    CGFloat bgY = 64;
    if (LL_iPhoneX) {
        bgY+=24;
    }
    self.bottomView.frame = CGRectMake(0, LL_ScreenHeight-height, LL_ScreenWidth, height);
    self.bgView.frame = CGRectMake(0, bgY, LL_ScreenWidth, LL_ScreenHeight-self.bottomView.height-bgY);
    [self.bgView addSubview:self.frameView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initBottomView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"save" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick)];
}
- (void)saveClick{
    self.ImageBlock([self.frameView getImage]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBottomView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, LL_ScreenWidth, self.bottomView.height-10) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.bottomView addSubview:collectionView];
    collectionView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [collectionView registerClass:[FrameCell class] forCellWithReuseIdentifier:CellID];
    self.collectionView = collectionView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FrameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    UIImage *frameImg = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%lu",indexPath.row]];
//    cell.imageView.image = [MyImageHelper thumbnailWithImageWithoutScale:frameImg size:CGSizeMake(70, 70)];
    cell.imageView.image = frameImg;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *frameImg = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%lu",indexPath.row]];
    UIImage *scaleImg = [self scaleImageWithOriginImage:frameImg scaleToSize:self.frameView.bounds.size];
    
    self.frameView.frameImg = scaleImg;
//    self.frameView.frameImg = [scaleImg stretchableImageWithLeftCapWidth:scaleImg.size.width/4.0f topCapHeight:frameImg.size.height/4.0];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 99;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = self.bottomView.height-CellMargin*2;
    return CGSizeMake(w, CellW);
}

- (UIView *)bgView{
    if (!_bgView) {
        UIView *bgView = [[UIView alloc]init];
        _bgView = bgView;
        [self.view addSubview:bgView];
    }
    return _bgView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc]init];
        _bottomView = bottomView;
        [self.view addSubview:bottomView];
    }
    return _bottomView;
}
- (FrameView *)frameView{
    if (!_frameView) {
        self.frameView  = [[FrameView alloc]initWithFrame:CGRectMake(self.imageRect.origin.x, self.imageRect.origin.y, self.imageRect.size.width, self.imageRect.size.height) showImage:self.originImg];
    }
    return _frameView;
}
- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.originImg.size, self.bgView.bounds);
}

-(UIImage*)scaleImageWithOriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
