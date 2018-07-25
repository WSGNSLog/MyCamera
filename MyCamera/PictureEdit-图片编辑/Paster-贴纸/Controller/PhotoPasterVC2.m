//
//  PhotoPasterVC2.m
//  MyCamera
//
//  Created by shiguang on 2018/7/24.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoPasterVC2.h"
#import "PasterCell.h"

#import "PhotoPasterView.h"

#define BottomViewHeight 120
#define CellMargin 5
#define CollectionHeight 60
#define ItemWidth 60
#define ItemHeight 60
#define defaultPasterViewW_H 120

@interface PhotoPasterVC2 ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PasterViewDelegate>
{
    ImageBlock _block;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UICollectionView *collectionView;
/**贴纸*/
@property (nonatomic, strong) PhotoPasterView *pasterView;
@property (strong,nonatomic) NSMutableArray *dataSource;

@end

@implementation PhotoPasterVC2

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

    self.dataSource = [NSMutableArray arrayWithObjects:@"paster_1",@"paster_2",@"paster_3",@"paster_4",@"paster_5",nil];
    self.imageView.image = self.image;
    
    [self initNav];
    [self initBottomView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageView.userInteractionEnabled = YES;
}
- (void)initNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarClick)];
}
- (void)leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick{
    UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, 0);
    [self.imageView drawViewHierarchyInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (_block) {
        _block(image);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBottomView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing =  10;
    flowLayout.itemSize = CGSizeMake(50, 66);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (BottomViewHeight-CollectionHeight)/2, LL_ScreenWidth, CollectionHeight) collectionViewLayout:flowLayout];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PasterCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = self.bottomView.backgroundColor;
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
    
    PasterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImage * image= [UIImage imageNamed:self.dataSource[indexPath.item]];
    cell.pasterImgView.image = image;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.pasterView) {
        [self.pasterView removeFromSuperview];
        self.pasterView = nil;
    }
    PhotoPasterView *pasterView = [[PhotoPasterView alloc]initWithFrame:CGRectMake(0, 0, defaultPasterViewW_H, defaultPasterViewW_H)];
    pasterView.center = CGPointMake(self.imageView.frame.size.width/2, self.imageView.frame.size.height/2);
    pasterView.pasterImage = [UIImage imageNamed:self.dataSource[indexPath.row]];
    pasterView.delegate = self;
    [self.imageView addSubview:pasterView];
    self.pasterView = pasterView;
    
}

-(void)addFinishBlock:(ImageBlock)block
{
    _block = block;
}

@end
