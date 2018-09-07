//
//  PhotoTextTwoController.m
//  MyCamera
//
//  Created by shiguang on 2018/8/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoTextTwoController.h"
#import "TextFontCell.h"
#import "CustomTextView.h"
#import "TextInputController.h"

#define CellWidth 60
#define CellHeight 75
#define CellMargin 8

@interface PhotoTextTwoController ()<TextFieldViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    ImageBlock _block;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *fontArr;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, weak) CustomTextView *textField ;
@property (nonatomic, readonly) CGRect imageRect;
@property (weak, nonatomic) IBOutlet UIView *imageBg;
@property (nonatomic,strong) NSMutableArray *textViewArray;
@end

@implementation PhotoTextTwoController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
    self.selectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.fontArr = [NSArray arrayWithObjects:@"Wawati SC", nil];
    
    [self initNav];
    [self initBottomView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *imgBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LL_ScreenWidth, LL_ScreenHeight-165)];
    [self.view addSubview:imgBgView];
    self.imageBg = imgBgView;
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.imageRect];
    imageV.userInteractionEnabled = YES;
    imageV.image = self.image;
    [self.imageBg addSubview:imageV];
    self.imageView = imageV;
    
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
        _block([self composeImage]);
    }
    //    self.ImageBlock(self.textField.textImage);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBottomView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing =  10;
    flowLayout.itemSize = CGSizeMake(50, 66);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LL_ScreenWidth, 80) collectionViewLayout:flowLayout];
    [collectionView registerClass:[TextFontCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
    [self.bottomView addSubview:collectionView];
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fontArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(CellWidth, CellHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFontCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath == self.selectIndex) {
        cell.fontNameLabel.backgroundColor = [UIColor colorWithRed:0.36f green:0.73f blue:0.77f alpha:1.00f];
        cell.fontNameLabel.textColor = [UIColor whiteColor];
    }else{
        cell.fontNameLabel.textColor = [UIColor colorWithRed:0.70f green:0.70f blue:0.68f alpha:1.00f];
        cell.fontNameLabel.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    }
    
    cell.textLabel.text = @"测试";
    cell.textLabel.font = [UIFont fontWithName:@"Wawati SC" size:17];
    cell.fontNameLabel.text = @"bbb";
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex) {
        TextFontCell *lastCell = (TextFontCell *)[collectionView cellForItemAtIndexPath:self.selectIndex];
        lastCell.fontNameLabel.textColor = [UIColor colorWithRed:0.70f green:0.70f blue:0.68f alpha:1.00f];
        lastCell.fontNameLabel.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    }
    self.selectIndex = indexPath;
    
    TextFontCell *selectedCell = (TextFontCell *)[collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.fontNameLabel.backgroundColor = [UIColor colorWithRed:0.36f green:0.73f blue:0.77f alpha:1.00f];
    selectedCell.fontNameLabel.textColor = [UIColor whiteColor];
    
}
- (IBAction)addNewTextView:(UIButton *)sender {
    for (CustomTextView *textV in self.textViewArray) {
        [textV setEditLayerAndButtonHidden:YES];
    }
    
    CustomTextView *textView = [[CustomTextView alloc] initWithFrame:CGRectMake((self.imageView.width - 170) / 2, (self.imageView.height - 50) / 2, 170, 50)];
    textView.delegate = self;
    textView.imageRect = self.imageRect;
    [self.imageView addSubview:textView];
    self.textField = textView;
    
}

//文字输入完成
- (void)textInputDone:(NSString *)text textField:(CustomTextView *)textView{
    //    CGRect rect = [text boundingRectWithSize:CGSizeMake((self.imageView.width - 170) / 2, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:@18.0} context:nil];
    //    textField.frame = rect;
//    [self.textField layoutSubviews];
}
- (void)textViewOnTap:(CustomTextView *)textView{
    for (CustomTextView *textV in self.textViewArray) {
        if ([textV isEqual:textView]) {
            [textV setEditLayerAndButtonHidden:NO];
        }else{
            [textV setEditLayerAndButtonHidden:YES];
        }
    }
}
//删除在文字操作view
- (void)textViewRemovedClick:(CustomTextView *)textView{
    
}
- (void)textEditClick:(CustomTextView *)textView{
    
}
-(void)addFinishBlock:(ImageBlock)block{
    _block = block;
}
- (UIImage *)composeImage{
    CGImageRef imgRef = self.imageView.image.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //    UIGraphicsBeginImageContextWithOptions(self.imageView.image.size, NO, 0);
    //
    //    [self.imageView.image drawInRect:CGRectMake(0, 0, w, h)];
    //    CGFloat scaleW = self.imageView.image.size.width/self.imageRect.size.width;
    //    CGFloat scaleH = self.imageView.image.size.height/self.imageRect.size.height;
    //
    //    [self.textField drawViewHierarchyInRect:CGRectMake(self.textField.x, self.textField.y, self.textField.width*scaleW, self.textField.height*scaleH) afterScreenUpdates:YES];
    
    UIGraphicsBeginImageContextWithOptions(self.imageView.size, NO, 0);
    [self.imageView drawViewHierarchyInRect:CGRectMake(0, 0, self.imageView.size.width, self.imageView.size.height) afterScreenUpdates:YES];
    
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.image.size, self.imageBg.bounds);
}
- (NSMutableArray *)textViewArray{
    if (!_textViewArray) {
        _textViewArray = [NSMutableArray array];
    }
    return _textViewArray;
}
@end
