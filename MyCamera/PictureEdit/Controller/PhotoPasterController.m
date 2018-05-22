
//
//  PhotoPasterController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoPasterController.h"
#import "PhotoEditOptionCell.h"

#import "VideoPasterView.h"

#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 60
#define ItemWidth 50
#define ItemHeight 60

@interface PhotoPasterController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,VideoPasterViewDelegate>
{
    ImageBlock _block;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *imageArr;
@property (strong,nonatomic) NSMutableArray *dataSource;
@end

@implementation PhotoPasterController
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
    self.imageArr = [NSArray arrayWithObjects:@"paster_wow",@"paster_housailei",@"paster_goodmode", nil];
    self.dataSource = [NSMutableArray arrayWithObjects:@"camera_edit_trip_free",@"camera_edit_trip_11",@"camera_edit_trip_34",nil];
    self.imageView.image = self.image;
    [self initNav];
    [self initBottomView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
  
}
- (void)initNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarClick)];
}
- (void)leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick{
    if (_block) {
        _block(_imageView.image);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBottomView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing =  10;
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
    return self.dataSource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(ItemWidth, ItemHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoEditOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImage * image= [UIImage imageNamed:self.dataSource[indexPath.item]];
    cell.iconView.image = image;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = 170;
    int height = self.imageView.frame.size.height / self.imageView.frame.size.width * width;
    VideoPasterView *pasterView = [[VideoPasterView alloc] initWithFrame:CGRectMake((self.imageView.frame.size.width - width) / 2, (self.imageView.frame.size.height - height) / 2, width, height)];
    pasterView.delegate = self;
    [pasterView setImageList:@[[UIImage imageNamed:self.imageArr[indexPath.row]]] imageDuration:0];
    [self.imageView addSubview:pasterView];
    
}
- (void)onPasterViewTap{
    NSLog(@"%s",__func__);
}
- (void)onRemovePasterView:(VideoPasterView*)pasterView{
    NSLog(@"%s",__func__);
}
-(void)addFinishBlock:(ImageBlock)block
{
    _block = block;
}
@end
