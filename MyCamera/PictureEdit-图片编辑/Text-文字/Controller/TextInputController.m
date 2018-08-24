//
//  TextInputController.m
//  MyCamera
//
//  Created by shiguang on 2018/8/22.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "TextInputController.h"

@interface TextInputController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,retain)UITextView *inputTextView;
@property(nonatomic,retain)NSArray * colorArray;
@property(nonatomic,retain)UIView * currentColorView;
@property(nonatomic,retain)UIButton * okBtn;

@end

@implementation TextInputController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.colorArray = @[@"ffffff",@"7d7d7d",@"000000",@"810000",@"cc0000",@"ff0000",@"ff7200",@"ffbf00",@"6cbf00",@"80d4ff",@"0080ff",@"75008c",@"ff338f"];
    
    self.inputTextView = [[UITextView alloc]init];
    self.inputTextView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.inputTextView];
    self.inputTextView.backgroundColor = [UIColor clearColor];
    
    WEAKSELF
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(LL_StatusBarAndNavigationBarHeight-20));
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(@(LL_ScreenWidth - 48));
        make.height.equalTo(@(LL_ScreenHeight * 0.3 - LL_StatusBarAndNavigationBarHeight + 20));
    }];
    self.inputTextView.font = [UIFont systemFontOfSize:20];
    [self setupInputAccessoryView];
    
    
    if (self.textView) {
        self.inputTextView.textColor = self.textView.textColor;
        self.inputTextView.text = self.textView.text;
        self.currentColorView.backgroundColor =  self.textView.textColor;
        self.okBtn.enabled = YES;
    }else{
        self.inputTextView.textColor = [UIColor whiteColor];
        self.currentColorView.backgroundColor = [UIColor whiteColor];
        self.okBtn.enabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange) name:UITextViewTextDidChangeNotification object:nil];
    self.inputTextView.layoutManager.allowsNonContiguousLayout = NO;
    
}

-(void)textViewChange{
    [self.inputTextView scrollRangeToVisible:NSMakeRange(self.inputTextView.text.length, 1)];
    if (self.inputTextView.text.length > 0) {
        self.okBtn.enabled = YES;
    }else{
        self.okBtn.enabled = NO;
    }
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    NSLog(@"height = %zd",height);
    
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(LL_ScreenHeight - height - LL_StatusBarAndNavigationBarHeight + 20));
    }];
}


- (void )setupInputAccessoryView{
    UIView * accessoryView = [[UIView alloc]init];
    
    UILabel * tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"当前颜色:";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:16];
    [accessoryView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@25);
        make.top.equalTo(@0);
        make.height.equalTo(@20);
    }];
    
    UIView * currentColorView = [[UIView alloc]init];
    [accessoryView addSubview:currentColorView];
    currentColorView.layer.cornerRadius = 3;
    currentColorView.clipsToBounds = YES;
    [currentColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(tipLabel);
        make.left.equalTo(tipLabel.mas_right).offset(5);
    }];
    self.currentColorView = currentColorView;
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView * bottomButtons = [[UICollectionView alloc]initWithFrame:CGRectMake(25, 65, (LL_ScreenWidth - 50)/13.0 * 13, 15) collectionViewLayout:flowLayout];
    bottomButtons.backgroundColor = [UIColor clearColor];
    [bottomButtons registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    bottomButtons.delegate = self;
    bottomButtons.dataSource = self;
    [accessoryView addSubview:bottomButtons];
    bottomButtons.layer.cornerRadius = 3;
    bottomButtons.clipsToBounds = YES;
    
    
    UIView * buttonBg = [[UIView alloc]init];
    buttonBg.backgroundColor = [UIColor colorWithHexString:BGGRAYCOLOR];
    [accessoryView addSubview:buttonBg];
    [buttonBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(accessoryView);
        make.height.equalTo(@44);
    }];
    UIButton * ok  = [[UIButton alloc]init];
    [ok addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [ok setTitle:@"确定" forState:UIControlStateNormal];
    [ok setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [ok setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    ok.titleLabel.font = [UIFont systemFontOfSize:16];
    [accessoryView addSubview:ok];
    [ok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(accessoryView);
        make.height.equalTo(@44);
        make.width.equalTo(@60);
    }];
    self.okBtn = ok;
    
    UIButton * cancel  = [[UIButton alloc]init];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:16];
    [accessoryView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(accessoryView);
        make.height.equalTo(@44);
        make.width.equalTo(@60);
    }];
    
    accessoryView.frame = CGRectMake(0, 0, LL_ScreenWidth, 44+ 120);
    self.inputTextView.inputAccessoryView = accessoryView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputTextView becomeFirstResponder];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.inputTextView resignFirstResponder];
}

#pragma mark - 按钮方法
-(void)okBtnClick{
    if (self.textView == nil) {
        if (self.completeInputBlock) {
            self.completeInputBlock(self.inputTextView.text,self.currentColorView.backgroundColor);
        }
    }else{
        if (self.completeEditBlock) {
            self.completeEditBlock(self.textView, self.inputTextView.text,self.currentColorView.backgroundColor);
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)cancelBtnClick{
    if (self.cancleEditBlock) {
        self.cancleEditBlock();
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - uicollection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 13;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((LL_ScreenWidth - 50.0)/13.0, 15);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:self.colorArray[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentColorView.backgroundColor = [UIColor colorWithHexString:self.colorArray[indexPath.item]];
    self.inputTextView.textColor = [UIColor colorWithHexString:self.colorArray[indexPath.item]];
}


@end
