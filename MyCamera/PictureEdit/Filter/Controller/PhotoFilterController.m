//
//  PhotoFilterController.m
//  MyCamera
//
//  Created by shiguang on 2018/6/15.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoFilterController.h"
#import "FilterCell.h"
#import "PasterCell.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"

#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 90
#define ItemWidth 60
#define ItemHeight 90
@interface PhotoFilterController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) NSArray *pasterImgArr;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**原始图片*/
@property (nonatomic, strong) UIImage *originCellImg;
@property (nonatomic, strong) UIImage *originImg;
@property (nonatomic,strong) PHCachingImageManager *imageManager;
@end

static NSString *const FilterCellID = @"FilterCell";
@implementation PhotoFilterController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (PHCachingImageManager *)imageManager{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    return _imageManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pasterImgArr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    self.dataSource = [NSMutableArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"瑞华",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色",nil];
    
    [self.imageManager requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.originImg = result;
        self.imageView.image = result;
        
    }];
    
    UIButton *rightBarBtn = [[UIButton alloc]init];
    rightBarBtn.frame = CGRectMake(0, 0, 50, 30);
    [rightBarBtn setTitle:@"save" forState:UIControlStateNormal];
    [rightBarBtn setBackgroundColor:[UIColor cyanColor]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.imageView.image = self.image;
    
    [self initBottomView];
    
    
    self.originCellImg = [UIImage imageNamed:@"gao4"];
}
- (void)initBottomView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (BottomViewHeight-CollectionHeight)/2, LL_ScreenWidth, CollectionHeight) collectionViewLayout:flowLayout];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FilterCell class]) bundle:nil] forCellWithReuseIdentifier:FilterCellID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
    [self.bottomView addSubview:collectionView];
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
    
    
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCellID forIndexPath:indexPath];
    UIImage *filterImage;
    switch (indexPath.row)
    {
        case 0:
        {
            filterImage = self.originCellImg;
        }
            break;
        case 1:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_lomo];
        }
            break;
        case 2:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_ruise];
        }
            break;
        case 6:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_danya];
        }
            break;
        case 7:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_jiuhong];
        }
            break;
        case 8:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_qingning];
        }
            break;
        case 9:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_langman];
        }
            break;
        case 10:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_guangyun];
        }
            break;
        case 11:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_landiao];
        }
            break;
        case 12:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_menghuan];
        }
            break;
        case 13:
        {
            filterImage = [ImageUtil imageWithImage:self.originCellImg withColorMatrix:colormatrix_yese];
        }
            break;
            
        default:
            break;
    }
    cell.filterImgView.image = filterImage;
    cell.filterNameLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *filterImg;
    switch (indexPath.row) {
        case 0:
        {
            filterImg = self.originImg;
            
        }
            break;
        case 1:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_lomo];
        }
            break;
        case 2:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_ruise];
        }
            break;
        case 6:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_danya];
        }
            break;
        case 7:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_jiuhong];
        }
            break;
        case 8:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_qingning];
        }
            break;
        case 9:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_langman];
        }
            break;
        case 10:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_guangyun];
        }
            break;
        case 11:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_landiao];
        }
            break;
        case 12:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_menghuan];
        }
            break;
        case 13:
        {
            filterImg = [ImageUtil imageWithImage:self.originImg withColorMatrix:colormatrix_yese];
        }
            break;
        default:
            break;
    }
//    self.imageView.image = filterImg;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
