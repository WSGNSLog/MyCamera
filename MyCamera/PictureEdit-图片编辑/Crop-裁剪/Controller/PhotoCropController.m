//
//  PhotoCropController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/21.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoCropController.h"
#import "TripView.h"
#import "CropRatioOptionCell.h"
#import "UIImage+SubImage.h"

#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 60
#define ItemWidth 50
#define ItemHeight 60
@interface PhotoCropController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    ImageBlock _block;
}
@property (nonatomic,assign) TripType selectedCripType;
@property (nonatomic,retain) TripView * tripView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong,nonatomic) NSArray *imageArr;
@property (nonatomic,strong) PHCachingImageManager *imageManager;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,retain) UIImage * editOriginalImage;
@property(nonatomic,retain) UIImage * editResetImage;
@property (weak, nonatomic) IBOutlet UIView *imageBg;


@end

@implementation PhotoCropController
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
    
    self.selectedCripType = TripTypeFree;
    [self.imageManager requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        self.imageView.image = result;
        self.editOriginalImage = self.imageView.image;
        self.editResetImage = self.imageView.image;
        //???
        [self setupOriginalImageView];
        [self tripBtnClick];
    }];
    self.imageArr = [NSArray arrayWithObjects:@"camera_edit_trip_free",@"camera_edit_trip_11",@"camera_edit_trip_34",@"camera_edit_trip_43",@"camera_edit_trip_916",@"camera_edit_trip_169", nil];
    
    [self initNav];
    [self initBottomView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //[self tripTextWithFrame:self.imageView.bounds Scale:oldScale/newScale];
    
}
- (void)initNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarClick)];
}
- (void)leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick{
    [self tripConfirmClick];
    
    if (_block) {
        _block(_imageView.image);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tripBtnClick{
    [self removeTripView];
    self.tripView = [[TripView alloc]initWithFrame:self.imageView.bounds];
    self.tripView.type = self.selectedCripType;
    [self.imageView addSubview:self.tripView];
  
    self.editResetImage = self.imageView.image; //记录可复位图片
    //记录文字可复位位置
//    for (EasyCameraTextView * view in self.imageView.subviews) {
//        if ([view isKindOfClass:[EasyCameraTextView class]] == NO) {
//            return;
//        }
//        view.resetCenter = view.center;
//    }
    
}

-(void)tripConfirmClick{

    double scale =  self.imageView.image.size.width/self.imageView.frame.size.width;
    CGRect tripRect = [self.tripView tripRect];
    CGRect imageRect = CGRectMake(tripRect.origin.x * scale, tripRect.origin.y * scale, tripRect.size.width * scale, tripRect.size.height * scale);
    UIImage * image = [self.imageView.image subImageWithRect: imageRect];
    self.imageView.image = image;
    //[self setImageViewFrame:YES];
    [self setUpTripImageView];
    
    [self removeTripView];
    
    self.tripView = [[TripView alloc]initWithFrame:self.imageView.bounds];
    self.tripView.type = TripTypeFree;
    [self.imageView addSubview:self.tripView];
    //处理文字缩放与位置
    //double  newScale = self.imageView.image.size.width /self.imageView.frame.size.width;
    //[self tripTextWithFrame:tripRect Scale:scale/newScale];
    
}
-(void)saveEditBtnClick{
    
//    self.editOriginalImage = nil;
//    [self.tripView removeFromSuperview];
 
    double newHeight =  LL_ScreenHeight - LL_NavigationBarHeight - LL_TabbarHeight;
    double oldHeight = LL_ScreenHeight - LL_TabbarHeight - 115;
    if (LL_iPhoneX) {
        oldHeight -= LL_StatusBarHeight;
        newHeight -= LL_StatusBarHeight;
    }
    double scale = newHeight/oldHeight;
    self.imageBg.transform = CGAffineTransformScale(self.imageBg.transform,  scale,  scale);
    CGRect rect =CGRectMake(0, LL_NavigationBarHeight, LL_ScreenWidth, newHeight);
    if (LL_iPhoneX) {
        rect =CGRectMake(0, LL_StatusBarAndNavigationBarHeight, LL_ScreenWidth, newHeight);
    }
    self.imageBg.frame = rect;
    
    double oldScale = self.imageView.image.size.width/self.imageView.frame.size.width;
    [self setImageViewFrame:NO];
    //复位文字缩放
    double newScale = self.imageView.image.size.width/self.imageView.frame.size.width;
    [self tripTextWithFrame:CGRectZero Scale:oldScale/newScale];
    //恢复文字点击
//    for (EasyCameraTextView * view in self.imageView.subviews) {
//        if ([view isKindOfClass:[EasyCameraTextView class]] == NO) {
//            return;
//        }
//        view.userInteractionEnabled = YES;
//    }
    
}
//文字处理：图片裁剪
- (void)tripTextWithFrame:(CGRect)frame Scale:(double)scale{
    for (UIView * view in self.imageView.subviews) {
//        if ([view isKindOfClass:[EasyCameraTextView class]] == NO) {
//            return;
//        }
        double centerX = view.center.x;
        double centerY = view.center.y;
        double newCenterX = (centerX - frame.origin.x) * scale;
        double newCenterY = (centerY - frame.origin.y) * scale;
        view.center = CGPointMake(newCenterX, newCenterY);
        view.transform = CGAffineTransformScale(view.transform, scale, scale);
    }
}

- (void)setImageViewFrame:(BOOL)edit{
    self.imageView.image = self.image;
    
    
    CGSize imageSize = self.imageView.image.size;
    double imageViewHeight;
    double imageViewWidth;
    double imageBgHeigt = self.imageBg.bounds.size.height;
    double imageBgWidth = self.imageBg.bounds.size.width;
    if (imageSize.width/imageSize.height > imageBgWidth/imageBgHeigt) {
        imageViewWidth = imageBgWidth;
        imageViewHeight = imageSize.height/imageSize.width * imageViewWidth;
        self.imageView.frame = CGRectMake(0, (imageBgHeigt - imageViewHeight)/2.0, imageViewWidth, imageViewHeight);
    }else{
        imageViewHeight = imageBgHeigt;
        imageViewWidth = imageSize.width/imageSize.height * imageViewHeight;
        
        self.imageView.frame = CGRectMake((imageBgWidth - imageViewWidth)/2.0,0, imageViewWidth, imageViewHeight);
    }
    
}
- (void)setUpTripImageView{
    
    CGSize imageSize = self.imageView.image.size;
    double imageViewHeight;
    double imageViewWidth;
    double imageBgHeigt = self.imageBg.bounds.size.height;
    double imageBgWidth = self.imageBg.bounds.size.width;
    if (imageSize.width/imageSize.height > imageBgWidth/imageBgHeigt) {
        imageViewWidth = imageBgWidth;
        imageViewHeight = imageSize.height/imageSize.width * imageViewWidth;
        self.imageView.frame = CGRectMake(0, (imageBgHeigt - imageViewHeight)/2.0, imageViewWidth, imageViewHeight);
    }else{
        imageViewHeight = imageBgHeigt;
        imageViewWidth = imageSize.width/imageSize.height * imageViewHeight;
        
        self.imageView.frame = CGRectMake((imageBgWidth - imageViewWidth)/2.0,0, imageViewWidth, imageViewHeight);
    }
    
}
-(void)setupOriginalImageView{
    
   
    self.imageView.image = self.image;
    
    
    CGSize imageSize = self.imageView.image.size;
    double imageViewHeight;
    double imageViewWidth;
    double imageBgHeigt = self.imageBg.bounds.size.height;
    double imageBgWidth = self.imageBg.bounds.size.width;
    if (imageSize.width/imageSize.height > imageBgWidth/imageBgHeigt) {
        imageViewWidth = imageBgWidth;
        imageViewHeight = imageSize.height/imageSize.width * imageViewWidth;
        self.imageView.frame = CGRectMake(0, (imageBgHeigt - imageViewHeight)/2.0, imageViewWidth, imageViewHeight);
    }else{
        imageViewHeight = imageBgHeigt;
        imageViewWidth = imageSize.width/imageSize.height * imageViewHeight;
        
        self.imageView.frame = CGRectMake((imageBgWidth - imageViewWidth)/2.0,0, imageViewWidth, imageViewHeight);
    }

    
    
}
- (void)removeTripView{
    if (self.tripView) {
        [self.tripView removeFromSuperview];
        self.tripView = nil;
    }
}
- (void)initBottomView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing =  (LL_ScreenWidth - 6 * 50)/5;
    flowLayout.itemSize = CGSizeMake(50, 66);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (BottomViewHeight-CollectionHeight)/2, LL_ScreenWidth, CollectionHeight) collectionViewLayout:flowLayout];
    [collectionView registerClass:[CropRatioOptionCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
    [self.bottomView addSubview:collectionView];
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(ItemWidth, ItemHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CropRatioOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item == self.selectedCripType) {
        UIImage * image= [UIImage imageNamed:[self.imageArr[indexPath.item]stringByAppendingString:@"_s"]];
        cell.iconView.image = image;
    }else{
        UIImage * image= [UIImage imageNamed:self.imageArr[indexPath.item]];
        cell.iconView.image = image;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self removeTripView];
    self.tripView = [[TripView alloc]initWithFrame:self.imageView.bounds];
    self.tripView.type = indexPath.item;
    [self.imageView addSubview:self.tripView];
    self.selectedCripType = indexPath.item;
    [collectionView reloadData];
}
-(void)addFinishBlock:(ImageBlock)block
{
    _block = block;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
