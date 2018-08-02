//
//  MeituFrameVC.m
//  MyCamera
//
//  Created by shiguang on 2018/7/31.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "MeituFrameVC.h"
#import "FrameImageView.h"
#import "FrameCell.h"

#define CellMargin 5
#define CellW 65

@interface MeituFrameVC ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    CGFloat _zoomScale;
}

@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic, readonly) CGRect imageRect;
@property (nonatomic,strong) NSMutableArray *frameArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 展示照片的视图 */
@property (nonatomic,strong) FrameImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *optionView;

@end
static NSString *const CellID = @"FrameCellID";

@implementation MeituFrameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.photoImageView.image = self.originImg;
    self.photoImageView.frame = self.photoImageView.calF;
    self.scrollView.contentSize = self.photoImageView.frame.size;
    
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.delegate = self;
//    [self initBottomView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    NSLog(@"%@",touch.view);
}

- (void)initBottomView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, LL_ScreenWidth, self.optionView.height-10) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.optionView addSubview:collectionView];
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
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 99;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = self.optionView.height-CellMargin*2;
    return CGSizeMake(w, CellW);
}
/*
 *  代理方法区
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.photoImageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if(scrollView.zoomScale <=0.3) scrollView.zoomScale = 0.3f;
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.photoImageView setCenter:CGPointMake(xcenter, ycenter)];
}


- (CGRect)itemImageViewFrame{
    
    return self.photoImageView.frame;
}

-(CGFloat)zoomScale{
    return self.scrollView.zoomScale;
}

-(void)setZoomScale:(CGFloat)zoomScale{
    _zoomScale = zoomScale;
    [self.scrollView setZoomScale:zoomScale animated:YES];
}
-(FrameImageView *)photoImageView{
    
    if(_photoImageView == nil){
        
        _photoImageView = [[FrameImageView alloc] init];
        
        _photoImageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:_photoImageView];
    }
    
    return _photoImageView;
}
- (IBAction)closeClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveClick:(id)sender {
    if (self.ImageBlock) {
        self.ImageBlock(self.photoImageView.image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
