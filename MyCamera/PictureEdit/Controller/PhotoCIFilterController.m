//
//  PhotoCIFilterController.m
//  MyCamera
//
//  Created by shiguang on 2018/6/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoCIFilterController.h"
#import "FilterCell.h"


#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 90
#define ItemWidth 60
#define ItemHeight 90
@interface PhotoCIFilterController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *originCellImg;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *dataSource;
@end

static NSString *const FilterCellID = @"FilterCell";

@implementation PhotoCIFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    CLDefaultEmptyFilter,
    CISRGBToneCurveToLinear,
    CIVignetteEffect,
    CIPhotoEffectInstant,
    CIPhotoEffectProcess,
    CIPhotoEffectTransfer,
    CISepiaTone,
    CIPhotoEffectChrome,
    CIPhotoEffectFade,
    CILinearToSRGBToneCurve,
    CIPhotoEffectTonal,
    CIPhotoEffectNoir,
    CIPhotoEffectMono,
    CIColorInvert
     ("CIBloom", "Bloom"),
     ("CIColorControls", "Color Controls"),
     ("CIColorInvert", "Color Invert"),
     ("CIColorPosterize", "Color Posterize"),
     ("CIExposureAdjust", "Exposure Adjust"),
     ("CIGammaAdjust", "Gamma Adjust"),
     ("CIGaussianBlur", "Gaussian Blur"),
     ("CIGloom", "Gloom"),
     ("CIHighlightShadowAdjust", "Highlights and Shadows"),
     ("CIHueAdjust", "Hue Adjust"),
     ("CILanczosScaleTransform", "Lanczos Scale Transform"),
     ("CIMaximumComponent", "Maximum Component"),
     ("CIMinimumComponent", "Minimum Component"),
     ("CISepiaTone", "Sepia Tone"),
     ("CISharpenLuminance", "Sharpen Luminance"),
     ("CIStraightenFilter", "Straighten"),
     ("CIUnsharpMask", "Unsharp Mask"),
     ("CIVibrance", "Vibrance"),
     ("CIVignette", "Vignette")
    */
    self.dataSource = [NSMutableArray arrayWithObjects:
                       
                       @"CIBloom",
                       @"CIPhotoEffectChrome",
                       @"CIPhotoEffectFade",
                       @"CIPhotoEffectInstant",
                       @"CIPhotoEffectMono",
                       @"CIPhotoEffectNoir",
                       @"CIPhotoEffectProcess",
                       @"CIPhotoEffectTonal",
                       @"CIPhotoEffectTransfer",
                       @"CIColorControls",
                       @"CIColorInvert",
                       @"CIColorPosterize",
                       @"CIExposureAdjust",
                       @"CIGaussianBlur",
                       @"CIGloom",
                       @"CIHighlightShadowAdjust",
                       
                       nil
                       ];
    self.imageView.image = self.image;
    
    [self initBottomView];
    
    
    self.originCellImg = [UIImage imageNamed:@"gao4"];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
   
    filterImage = [self getNewImageFromFilterWithFilterName:self.dataSource[indexPath.row] originImage:self.originCellImg];
    cell.filterImgView.image = filterImage;
    cell.filterNameLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self changeImageFilter:self.dataSource[indexPath.row]];
}
-(void)changeImageFilter:(NSString *)FilterName
{
    
    _imageView.image = [self getNewImageFromFilterWithFilterName:FilterName originImage:_image];
    
    
}
- (UIImage *)getNewImageFromFilterWithFilterName:(NSString *)filterName
                                     originImage:(UIImage *)originImage
{
    CIImage *ciImage =[[CIImage alloc]initWithImage:originImage];
    
    //CIFilter 滤镜
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey,ciImage,nil];
    
    [filter setDefaults];
    
    CIContext *context =[CIContext contextWithOptions:nil];
    
    CIImage *outputImage =[filter outputImage];
    
    CGImageRef cgImage =[context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *image =[UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return image;
}


@end
