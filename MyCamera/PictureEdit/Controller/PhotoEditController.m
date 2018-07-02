//
//  PhotoEditController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoEditController.h"
#import "PhotoEditOptionCell.h"
#import "PhotoCropController.h"
#import "PhotoRotateController.h"
#import "PhotoPasterController.h"
#import "PhotoTextController.h"
#import "PhotoWaterMarkController.h"
#import "PhotoFilterController.h"
#import "PhotoCIFilterController.h"
#import "PhotoCustomRotateVC.h"
#import "PicEditOptionView.h"
#import "PhotoSecondCropController.h"

#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 60
#define ItemWidth 45
#define ItemHeight 60
@interface PhotoEditController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PicEditOptionDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) UIView *editView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) NSArray *imageArr;
@property (nonatomic,strong) PHCachingImageManager *imageManager;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,retain) UIImage *image;

@end

@implementation PhotoEditController
- (PHCachingImageManager *)imageManager{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    return _imageManager;
}
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
    
    [self.imageManager requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.imageView.image = result;
        self.image = result;
    }];

    
    self.dataSource = [NSMutableArray arrayWithObjects:@"编辑",@"文字",@"贴纸",@"边框",@"标记",@"涂鸦",@"滤镜",@"CI滤镜",@"水印",@"调节",@"裁剪2", nil];
    self.imageArr = [NSArray arrayWithObjects:@"camera_edit_edit",@"camera_edit_text",@"camera_edit_sticker",@"camera_edit_border",@"camera_edit_border",@"camera_edit_draw",@"camera_edit_filter",@"photoBeauty_filter",@"photoBeauty_watermark",@"photoBeauty_adjust",@"photoBeauty_clip", nil];
    
    UIButton *rightBarBtn = [[UIButton alloc]init];
    rightBarBtn.frame = CGRectMake(0, 0, 50, 30);
    [rightBarBtn setTitle:@"save" forState:UIControlStateNormal];
    [rightBarBtn setBackgroundColor:[UIColor cyanColor]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self initBottomView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)initBottomView{
    WEAKSELF

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (BottomViewHeight-CollectionHeight)/2, LL_ScreenWidth, CollectionHeight) collectionViewLayout:flowLayout];
    [collectionView registerClass:[PhotoEditOptionCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
    [self.bottomView addSubview:collectionView];
    
//    UIView *editView = [[UIView alloc]init];
//    editView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:editView];
//    self.editView = editView;
//    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bottomView).offset = CellMargin;
//        make.width.equalTo(@(ItemWidth));
//        make.height.equalTo(@80);
//        make.bottom.equalTo(collectionView.mas_top).offset = -10;
//    }];
//    UIButton *cropBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ItemWidth, 40)];
//    [cropBtn setTitle:@"crop" forState:UIControlStateNormal];
//    [cropBtn addTarget:self action:@selector(cropBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [cropBtn setBackgroundColor:[UIColor cyanColor]];
//    UIButton *rotateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 41, ItemWidth, 40)];
//    rotateBtn.titleLabel.numberOfLines = 0;
//    rotateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [rotateBtn setTitle:@"旋转&\n镜像" forState:UIControlStateNormal];
//    [rotateBtn addTarget:self action:@selector(rotateBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [rotateBtn setBackgroundColor:[UIColor cyanColor]];
//    [editView addSubview:cropBtn];
//    [editView addSubview:rotateBtn];
    PicEditOptionView *optionView = [[NSBundle mainBundle] loadNibNamed:@"PicEditOptionView" owner:self options:nil].lastObject;
    optionView.delegate = self;
    [self.view addSubview:optionView];
    [optionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomView).offset = CellMargin;
        make.bottom.equalTo(collectionView.mas_top).offset = -10;
    }];
    self.editView = optionView;
    self.editView.hidden = YES;
}
- (void)cropBtnClick{
    WEAKSELF
    PhotoCropController *crop = [[PhotoCropController alloc]init];
    crop.asset = self.asset;
    crop.image = self.image;
    [crop addFinishBlock:^(UIImage *image) {
        weakSelf.imageView.image = image;
    }];
    [self.navigationController pushViewController:crop animated:YES];
    self.editView.hidden = YES;
}
- (void)rotateBtnClick{
    self.editView.hidden = YES;
    PhotoRotateController *rotate = [[PhotoRotateController alloc]init];
    rotate.asset = self.asset;
    rotate.image = self.image;
    WEAKSELF
    [rotate addFinishBlock:^(UIImage *image) {
        weakSelf.imageView.image = image;
    }];
    [self.navigationController pushViewController:rotate animated:YES];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(ItemWidth, ItemHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, CellMargin, 0, CellMargin);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoEditOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.iconView.image = [UIImage imageNamed:self.imageArr[indexPath.item]];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WEAKSELF
    switch (indexPath.row) {
        case 0:
            self.editView.hidden = NO;
            break;
        case 1:
        {
            PhotoTextController *text = [[PhotoTextController alloc] init];
            text.image = self.image;
            text.asset = self.asset;
            [text addFinishBlock:^(UIImage *image) {
                weakSelf.imageView.image = image;
            }];
            [self.navigationController pushViewController:text animated:YES];
            self.editView.hidden = YES;
        }
            
            break;
        case 2:
        {
            PhotoPasterController *paster = [[PhotoPasterController alloc] init];
            paster.image = self.image;
            paster.asset = self.asset;
            [paster addFinishBlock:^(UIImage *image) {
                weakSelf.imageView.image = image;
            }];
            [self.navigationController pushViewController:paster animated:YES];
            self.editView.hidden = YES;
        }
            break;
        case 3://画框
            self.editView.hidden = YES;
            break;
        case 4://标记
            self.editView.hidden = YES;
            break;
        case 5://涂鸦
            self.editView.hidden = YES;
            break;
        case 6://滤镜
        {
            PhotoFilterController *filterVC = [[PhotoFilterController alloc]init];
            filterVC.image = self.image;
            filterVC.asset = self.asset;
            [self.navigationController pushViewController:filterVC animated:YES];
            self.editView.hidden = YES;
        }
            break;
        case 7://CI滤镜
        {
            PhotoCIFilterController *waterMark = [[PhotoCIFilterController alloc]init];
            waterMark.image = self.image;
            [self.navigationController pushViewController:waterMark animated:YES];
            self.editView.hidden = YES;
        }
            break;
        case 8://水印
        {
            PhotoWaterMarkController *waterMark = [[PhotoWaterMarkController alloc]init];
            waterMark.image = self.image;
            waterMark.asset = self.asset;
            [self.navigationController pushViewController:waterMark animated:YES];
            self.editView.hidden = YES;
        }
            break;
        case 9://调节
        {
            PhotoCustomRotateVC *rotateVC = [[PhotoCustomRotateVC alloc]init];
            rotateVC.image = self.image;
            rotateVC.asset = self.asset;
            [self.navigationController pushViewController:rotateVC animated:YES];
            self.editView.hidden = YES;
        }
            break;
        case 10://裁剪第二种
        {
            PhotoSecondCropController  *cropVC = [[PhotoSecondCropController alloc]init];
            cropVC.image = self.image;
            [cropVC addFinishBlock:^(UIImage *image) {
                weakSelf.imageView.image = image;
            }];
            [self presentViewController:cropVC animated:YES completion:nil];
            self.editView.hidden = YES;
        }
            break;
        default:
            break;
    }
}
- (void)picEditOptionCropClick{
    WEAKSELF
    PhotoCropController *crop = [[PhotoCropController alloc]init];
    crop.asset = self.asset;
    crop.image = self.image;
    [crop addFinishBlock:^(UIImage *image) {
        weakSelf.imageView.image = image;
    }];
    [self.navigationController pushViewController:crop animated:YES];
    self.editView.hidden = YES;
}
- (void)picEditOptionRotateAndMirrorClick{
    self.editView.hidden = YES;
    PhotoRotateController *rotate = [[PhotoRotateController alloc]init];
    rotate.asset = self.asset;
    rotate.image = self.image;
    WEAKSELF
    [rotate addFinishBlock:^(UIImage *image) {
        weakSelf.imageView.image = image;
    }];
    [self.navigationController pushViewController:rotate animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.editView.hidden = YES;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
