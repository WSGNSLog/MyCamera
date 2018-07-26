//
//  DrawBordController.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "DrawBordController.h"
#import "DrawView.h"
@interface DrawBordController ()
{
    UIButton *selectedBtn;
    //当前笔触粗细选择器
    UISlider *slider;
}
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) DrawView *drawView;
@property (retain,nonatomic) UIImageView *imageView;


//@property (nonatomic,strong) UIButton *selectedBtn;
@end

@implementation DrawBordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAKSELF
    self.imageView =  [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.originImg;
    [self.imgBgView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.imgBgView);
    }];
    DrawView *drawView = [[DrawView alloc]init];
    self.drawView = drawView;
    self.drawView.paintViewMode = PaintViewModeStroke;
    [self.imgBgView addSubview:drawView];
    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(weakSelf.imgBgView);
    }];
    
    //创建色板
    [self createColorBord];
    //创建笔触粗细选择器
    [self createStrokeWidthSlider];
}

- (IBAction)closeClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)markLineShapeClick:(id)sender {
    
}
- (IBAction)markLineTypeClick:(id)sender {
    
}
- (IBAction)markLineColotClick:(id)sender {
    
}
- (IBAction)markLineClick:(id)sender {
    
}
- (IBAction)saveClick:(id)sender {
    
}
#pragma mark -控制面板按钮点击
//贝塞尔按钮的点击事件
-(IBAction)berzierBtnClick:(id)sender{
    UIButton *btn = sender;
    if(self.drawView.paintViewMode == PaintViewModeStroke){
        self.drawView.paintViewMode = PaintViewModeBezier;
        [btn setBackgroundImage:[UIImage imageNamed:@"bezierBoard_l"] forState:UIControlStateNormal];
    }else{
        self.drawView.paintViewMode = PaintViewModeStroke;
        [btn setBackgroundImage:[UIImage imageNamed:@"bezierBoard"] forState:UIControlStateNormal];
    }
    
}
//创建笔触粗细选择器
-(void)createStrokeWidthSlider{
    slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 50, LL_ScreenWidth, 20)];
    [slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    slider.maximumValue = 20;
    slider.minimumValue = 1;
    self.drawView.sliderValue = slider.value;
    [self.optionView addSubview:slider];
}
- (void)sliderValueChange{
    self.drawView.sliderValue = slider.value;
}
//创建色板
-(void)createColorBord{
    //默认当前笔触颜色是黑色
    self.drawView.paintColor = [UIColor blackColor];
    //色板的view
    UIView *colorBoardView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, LL_ScreenWidth-20, 20)];
    [self.optionView addSubview:colorBoardView];
    //色板样式
    colorBoardView.layer.borderWidth = 1;
    colorBoardView.layer.borderColor = [UIColor blackColor].CGColor;
    
    //创建每个色块
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor blackColor],[UIColor redColor],[UIColor blueColor],
                       [UIColor greenColor],[UIColor yellowColor],[UIColor brownColor],
                       [UIColor orangeColor],[UIColor whiteColor],[UIColor orangeColor],
                       [UIColor purpleColor],[UIColor cyanColor],[UIColor lightGrayColor], nil];
    for (int i =0; i<colors.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(((LL_ScreenWidth-20)/colors.count)*i, 0, (LL_ScreenWidth-20)/colors.count, 20)];
        [colorBoardView addSubview:btn];
        [btn setBackgroundColor:colors[i]];
        [btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            selectedBtn = [[UIButton alloc]init];
            selectedBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
            selectedBtn.layer.cornerRadius = 5;
            selectedBtn.layer.borderColor = [UIColor colorWithRed:0.36f green:0.72f blue:0.76f alpha:1.0f].CGColor;
            selectedBtn.layer.borderWidth = 1.5;
            [colorBoardView addSubview:selectedBtn];
            [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(btn).offset = 5;
                make.top.left.equalTo(btn).offset = -3;
            }];
        }
    }
    [colorBoardView bringSubviewToFront:selectedBtn];
}
//切换颜色
-(void)changeColor:(id)target{
    UIButton *btn = (UIButton *)target;
    self.drawView.paintColor = [btn backgroundColor];
    [selectedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(btn).offset = 5;
        make.top.left.equalTo(btn).offset = -3;
    }];
    
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
