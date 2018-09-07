
//
//  PhotoTextController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoTextController.h"
#import "TextFontCell.h"
#import "CustomTextView.h"
#import "TextInputController.h"
#import "MyTextView.h"

#define CellWidth 60
#define CellHeight 75
#define CellMargin 8

@interface PhotoTextController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    ImageBlock _block;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *fontArr;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, weak) CustomTextView *textView;
@property (nonatomic, readonly) CGRect imageRect;
@property (weak, nonatomic) IBOutlet UIView *imageBg;
@property (nonatomic,strong) NSMutableArray *textViewArray;
@end

@implementation PhotoTextController

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
    
    self.fontArr = [NSArray arrayWithObjects:@"Wawati SC",@"Hannotate SC",@"Kaiti SC",@"Xingkai SC",@"HanziPen SC",@"LingWai SC", nil];
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
    for (CustomTextView *textV in self.textViewArray) {
        [textV setEditLayerAndButtonHidden:YES];
    }
    if (_block) {
        _block([self composeImage]);
    }
    
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
    cell.textLabel.font = [UIFont fontWithName:self.fontArr[indexPath.row] size:17];
    cell.fontNameLabel.text = self.fontArr[indexPath.row];
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
    
//    CustomTextView *textField = [[CustomTextView alloc] initWithFrame:CGRectMake((self.imageView.width - 170) / 2, (self.imageView.height - 50) / 2, 170, 50)];
//    textField.delegate = self;
//    [self.imageView addSubview:textField];
//    self.textField = textField;
    TextInputController * vc = [[TextInputController alloc]init];
    WEAKSELF
    [vc setCompleteInputBlock:^(NSString *text, UIColor *textColor) {
        if (text == nil || [text isEqualToString:@""]) {
            return ;
        }
        [weakSelf setTextViewWithText:text color:textColor];
    }];
    [vc setCancleEditBlock:^{
//        weakSelf.topBar.hidden = NO;
    }];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc animated:NO completion:nil];
    
    
    
    
}
- (void)setTextViewWithText:(NSString *)text color:(UIColor *)color{
    
    CGSize sizeToFit = [text boundingRectWithSize:CGSizeMake(LL_ScreenWidth - 48, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:20]}
                                          context:nil].size;
    CGRect bgRect = CGRectMake((LL_ScreenWidth - sizeToFit.width - 48)/2.0, (self.imageBg.frame.size.height - sizeToFit.height - 48)/2 ,sizeToFit.width + 48, sizeToFit.height + 48);
    CGRect imageRect =  [self.imageView convertRect:bgRect fromView:self.imageBg];
    
    MyTextView * textView = [[MyTextView alloc]initWithFrame:imageRect];
    
    textView.canEdit = YES;
    textView.canDelete = YES;
    textView.isPreview = YES;
    [self.imageView addSubview:textView];
    textView.text = text;
    textView.textColor = color;
//    self.topBar.hidden = NO;
    WEAKSELF
    
    [textView setEditTextBlock:^(MyTextView *textView) {
//        weakSelf.topBar.hidden = YES;
        TextInputController * vc = [[TextInputController alloc]init];
        vc.textView = textView;
        [vc setCancleEditBlock:^{
//            weakSelf.topBar.hidden = NO;
        }];
        [vc setCompleteEditBlock:^(MyTextView *textView, NSString *text, UIColor *textColor) {
            if (text == nil || [text isEqualToString:@""]) {
                [textView removeFromSuperview];
                return ;
            }
            textView.textColor = textColor;
            textView.text = text;
            
            CGPoint center = textView.center;
            CGAffineTransform transform = textView.transform;
            CGSize sizeToFit = [text boundingRectWithSize:CGSizeMake(LL_ScreenWidth - 48, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:20]}
                                                  context:nil].size;
            CGRect bgRect = CGRectMake((LL_ScreenWidth - sizeToFit.width - 48)/2.0, (weakSelf.imageBg.frame.size.height - sizeToFit.height - 48)/2 ,sizeToFit.width + 48, sizeToFit.height + 48);
            CGRect imageRect = [weakSelf.imageView convertRect:bgRect fromView:weakSelf.imageBg];
            NSLog(@"==:%@",NSStringFromCGRect(imageRect));
            MyTextView * newTextView = [[MyTextView alloc]initWithFrame:imageRect];
            newTextView.canEdit = YES;
            newTextView.canDelete = YES;
            newTextView.isPreview = YES;
            newTextView.center = center;
            newTextView.transform =transform;
            newTextView.text = text;
            newTextView.textColor = textColor;
            newTextView.editTextBlock = textView.editTextBlock;
            [textView.superview addSubview:newTextView];
            [textView removeFromSuperview];
//            weakSelf.topBar.hidden = NO;
            
        }];
        
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [weakSelf presentViewController:vc animated:NO completion:nil];
    }];
}
//文字输入完成
- (void)onTextInputDone:(NSString *)text textField:(CustomTextView *)textField
{
//    CGRect rect = [text boundingRectWithSize:CGSizeMake((self.imageView.width - 170) / 2, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:@18.0} context:nil];
//    textField.frame = rect;
    
// //   [self.textView layoutSubviews];
}

//删除在文字操作view
- (void)onRemoveTextField:(CustomTextView *)textField
{
    
}
- (void)onBubbleTap
{
    
}
-(void)addFinishBlock:(ImageBlock)block
{
    _block = block;
}
- (UIImage *)composeImage{
    CGFloat w = self.image.size.width;
    CGFloat h = self.image.size.height;
    CGFloat scale_x = w/self.imageRect.size.width;
    CGFloat scale_y = h/self.imageRect.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [self.image drawInRect:CGRectMake(0, 0, w, h)];
    
    CGRect rect = [self textViewRect:self.textView];
    CGFloat newW = rect.size.width*scale_x;
    CGFloat newH = rect.size.height*scale_y;
    [self.textView.textImage drawInRect:CGRectMake(rect.origin.x*scale_x,rect.origin.y*scale_y , newW, newH)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)composeImage2{
    CGImageRef imgRef = self.imageView.image.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //    UIGraphicsBeginImageContextWithOptions(self.imageView.image.size, NO, 0);
    //    [self.imageView.image drawInRect:CGRectMake(0, 0, w, h)];
    //    CGFloat scaleW = self.imageView.image.size.width/self.imageRect.size.width;
    //    CGFloat scaleH = self.imageView.image.size.height/self.imageRect.size.height;
    //
    //    [self.textView drawViewHierarchyInRect:CGRectMake(self.textView.x, self.textView.y, self.textView.width*scaleW, self.textView.height*scaleH) afterScreenUpdates:YES];
    
    UIGraphicsBeginImageContextWithOptions(self.imageView.size, NO, 0);
    [self.imageView drawViewHierarchyInRect:CGRectMake(0, 0, self.imageView.size.width, self.imageView.size.height) afterScreenUpdates:YES];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (void)textEditClick:(CustomTextView*)textView{
    
}
- (void)textViewRemovedClick:(CustomTextView *)textView{
    
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
- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.image.size, self.imageBg.bounds);
}
- (CGRect)textViewRect:(CustomTextView *)textView{
    return [textView convertRect:textView.bounds toView:self.imageView];
}
- (NSMutableArray *)textViewArray{
    if (!_textViewArray) {
        _textViewArray = [NSMutableArray array];
    }
    return _textViewArray;
}
@end
