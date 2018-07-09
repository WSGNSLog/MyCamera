//
//  PhotoSecondCropController.m
//  MyCamera
//
//  Created by shiguang on 2018/6/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoSecondCropController.h"
#import "PECropView.h"
#import "PhotoEditOptionCell.h"

#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 60
#define ItemWidth 50
#define ItemHeight 60
typedef enum:NSInteger{
    TripTypeFree = 0,
    TripType11 = 1,
    TripType34 = 2,
    TripType43 = 3,
    TripType916 = 4,
    TripType169 = 5,
}TripType;

@interface PhotoSecondCropController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    PECropView *_cropView;
    ImageBlock _block;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (assign,nonatomic) CGFloat rotateAngle;

@property (nonatomic,assign) CGAffineTransform originTransform;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *imageArr;

@property (strong,nonatomic) NSArray *imageNameArr;
@property (nonatomic,assign) TripType tripType;

@end

@implementation PhotoSecondCropController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cropView = [[PECropView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50 - 110)];
    _cropView.image = self.image;
    //_cropView.rotationGestureRecognizer.enabled = false;
    //    _cropView.keepingCropAspectRatio = true;
    _cropView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_cropView];
    self.imageArr = [NSArray arrayWithObjects:@"camera_edit_trip_free",@"camera_edit_trip_11",@"camera_edit_trip_34",@"camera_edit_trip_43",@"camera_edit_trip_916",@"camera_edit_trip_169", nil];
    self.tripType = TripTypeFree;
    [self.view bringSubviewToFront:self.bottomView];
    self.imageNameArr = [NSMutableArray arrayWithObjects:@"free",@"1:1",@"4:3",@"3:4",@"16:9",@"9:16",nil];
    [self initBottomView];
}


- (IBAction)saveClick:(UIButton *)sender {
    if (_block) {
        _block(_cropView.croppedImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)initBottomView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing =  (LL_ScreenWidth - 6 * 50)/5;
    flowLayout.itemSize = CGSizeMake(50, 66);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (BottomViewHeight-CollectionHeight)/2, LL_ScreenWidth, CollectionHeight) collectionViewLayout:flowLayout];
    [collectionView registerClass:[PhotoEditOptionCell class] forCellWithReuseIdentifier:@"cell"];
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
    
    PhotoEditOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item == self.tripType) {
        UIImage * image= [UIImage imageNamed:[self.imageArr[indexPath.item]stringByAppendingString:@"_s"]];
        cell.iconView.image = image;
    }else{
        UIImage * image= [UIImage imageNamed:self.imageArr[indexPath.item]];
        cell.iconView.image = image;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tripType = indexPath.row;
    if (indexPath.row == 0) {
        [_cropView resetCropRect];
        self.tripType = TripTypeFree;
    }else{
        [self changeRatio:[self scaleFromTitle:self.imageNameArr[indexPath.row]]];
    }
    [self.collectionView reloadData];
}
-(void)changeRatio:(CGFloat)ratio
{
    [_cropView resetCropRect];
    _cropView.cropAspectRatio = ratio;
}
-(CGFloat)scaleFromTitle:(NSString*)title
{
    CGFloat width = [[title componentsSeparatedByString:@":"].firstObject floatValue];
    CGFloat height = [[title componentsSeparatedByString:@":"].lastObject floatValue];
    return width/height;
}
-(void)addFinishBlock:(ImageBlock)block
{
    _block = block;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}


@end
