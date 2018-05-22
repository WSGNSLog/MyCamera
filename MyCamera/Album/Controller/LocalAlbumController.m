//
//  LocalAlbumController.m
//  eCamera
//
//  Created by shiguang on 2018/3/28.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "LocalAlbumController.h"
#import "AlbumItemCell.h"
#import "AlbumSectionModel.h"
#import "AlbumItemModel.h"
#import <Photos/Photos.h>
#import "AlbumItemModel.h"
#import "Utils_DateInfo.h"
#import "AlbumPhotoPreviewVC.h"
#import "AlbumVideoPreviewVC.h"

static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@interface LocalAlbumController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSArray *fetchResults;
@property (nonatomic, copy) NSArray *assetCollections;
@property (nonatomic, strong) NSArray *assetCollectionSubtypes;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

static NSString *const cellID = @"AlbumItemCellID";
static NSString *const AlbumIHeaderID = @"AlbumIHeaderID";
@implementation LocalAlbumController
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (PHCachingImageManager *)imageManager{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    return _imageManager;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavBottomLineHidenWithOption:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setNavBottomLineHidenWithOption:YES];
}
- (void)setNavBottomLineHidenWithOption:(BOOL)yesOrNo{
    NSArray *list=self.navigationController.navigationBar.subviews;
    for (id obj in list) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *)obj;
            NSArray *list2=imageView.subviews;
            for (id obj2 in list2) {
                if ([obj2 isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView2=(UIImageView *)obj2;
                    imageView2.hidden=yesOrNo;
                }
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相机相册";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    
    if (@available(iOS 9.0, *)) {
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
    } else {
        // Fallback on earlier versions
    }
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LL_ScreenWidth, LL_ScreenHeight-64) collectionViewLayout:flowLayout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AlbumItemCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AlbumIHeaderID];
    
    self.assetCollectionSubtypes = [NSArray arrayWithObjects:@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                    @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                    @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                    @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                    @(PHAssetCollectionSubtypeSmartAlbumBursts), nil];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    self.fetchResults = @[smartAlbums, userAlbums];
    
    [self updateAssetCollections];
    
    [self loadData];
    
}
#pragma mark - 获取相册资源集合
- (void)updateAssetCollections
{
    // Filter albums
    NSArray *assetCollectionSubtypes = self.assetCollectionSubtypes;
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            
            if (subtype == PHAssetCollectionSubtypeAlbumRegular) {
                [userAlbums addObject:assetCollection];
            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    }
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];
    
    self.assetCollections = assetCollections;
}
#pragma mark - 获取相册资源、相册排序及分组
- (void)loadData{
    
    PHAssetCollection *assetCollection = _assetCollections[0];

    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d || mediaType == %d",PHAssetMediaTypeImage,PHAssetMediaTypeVideo];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
    NSMutableArray *sectionDateArray = [NSMutableArray array];
    for (int i=0; i<fetchResult.count; i++) {
        AlbumItemModel *model = [[AlbumItemModel alloc]init];
        PHAsset *asset = fetchResult[i];
        model.asset = asset;
        NSDate *date = asset.creationDate;
        model.creationDate = [Utils_DateInfo stringFromDate:date Format:@"yyyyMMdd"];
        model.creationTime = [Utils_DateInfo stringFromDate:date Format:@"HH:mm:ss"];
        if (![sectionDateArray containsObject:model.creationDate]) {
            [sectionDateArray addObject:model.creationDate];
        }
        [self.resultArray addObject:model];
    }
    for (NSString *date in sectionDateArray) {
        AlbumSectionModel *sectionModel = [[AlbumSectionModel alloc]init];
        NSMutableArray *secArray = [NSMutableArray array];
        [self.resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AlbumItemModel *model = (AlbumItemModel *)obj;
            if ([model.creationDate isEqualToString: date]) {
                [secArray addObject:model];
            }
        }];
        sectionModel.sectionTitle = [self dataSubstringInsertDataString:[NSMutableString stringWithString:date]];
        sectionModel.itemsArray = secArray;
        [self.dataSource addObject:sectionModel];
    }
    
    self.fetchResult = fetchResult;
}
-(NSString *)dataSubstringInsertDataString:(NSMutableString *)string{
    [string insertString:@"年" atIndex:4];
    [string insertString:@"月" atIndex:7];
    [string insertString:@"日" atIndex:10];
    return string;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[self.dataSource[section] itemsArray] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlbumItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.previewImgV.image = [UIImage imageNamed:@"head"];
    
    AlbumSectionModel *secModel = self.dataSource[indexPath.section];
    AlbumItemModel *model = secModel.itemsArray[indexPath.row];
    PHAsset *asset = model.asset;
    CGSize itemSize = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout itemSize];
    CGSize targetSize = CGSizeScale(itemSize, [[UIScreen mainScreen] scale]);
    [self.imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (cell.tag == indexPath.item) {
            if (result) {
                cell.previewImgV.image = result;
            }else{
//                cell.previewImgV.image = [UIImage imageNamed:@""];
            }
            
        }
    }];
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        cell.videoIndicator.hidden = NO;
        
        NSInteger minutes = (NSInteger)(asset.duration / 60.0);
        NSInteger seconds = (NSInteger)ceil(asset.duration - 60.0 * (double)minutes);
        cell.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
        
    } else {
        cell.videoIndicator.hidden = YES;
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        
        //PHAsset *asset = self.resultArray[indexPath.section];
        AlbumSectionModel *secModel = self.dataSource[indexPath.section];
//        AlbumItemModel *model = secModel.itemsArray[indexPath.row];
//        PHAsset *asset = model.asset;
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:AlbumIHeaderID forIndexPath:indexPath];
       
        if (header.subviews.lastObject!=nil) {
            [header.subviews.lastObject removeFromSuperview];
        }

        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LL_ScreenWidth, 44)];
        header.backgroundColor = [UIColor colorWithHexString:@"#e6e8e8" andAlpha:0.95];
        UILabel *sectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 30)];
        
        sectionTitleLabel.text = secModel.sectionTitle;
        sectionTitleLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:sectionTitleLabel];
        [header addSubview:headerView];
        return  header;
        
    }else{
        return nil;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AlbumSectionModel *secModel = self.dataSource[indexPath.section];
    AlbumItemModel *model = secModel.itemsArray[indexPath.row];
    
    PHAsset *asset = model.asset;
    if (asset.mediaType == PHAssetMediaTypeImage) {
        AlbumPhotoPreviewVC *previewVC = [[AlbumPhotoPreviewVC alloc]init];
        previewVC.model = model;
        [self.navigationController pushViewController:previewVC animated:YES];
    }else if (asset.mediaType == PHAssetMediaTypeVideo){
        AlbumVideoPreviewVC *previewVC = [[AlbumVideoPreviewVC alloc]init];
        previewVC.model = model;
        [self.navigationController pushViewController:previewVC animated:YES];
        
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((LL_ScreenWidth -5*5)/4, (LL_ScreenWidth -5*5)/4);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(LL_ScreenWidth, 44);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
