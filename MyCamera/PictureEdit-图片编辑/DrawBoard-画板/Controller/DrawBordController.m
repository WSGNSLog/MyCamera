//
//  DrawBordController.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "DrawBordController.h"
#import "DrawView.h"
#import "DrawColorView.h"
#import "DrawDashedView.h"
#import "DrawShapeView.h"
#import "DrawThicknessView.h"


@interface DrawBordController ()

@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) DrawView *drawView;
@property (retain,nonatomic) UIImageView *imageView;
@property (nonatomic, readonly) CGRect imageRect;

//@property (nonatomic,strong) UIButton *selectedBtn;
@end

@implementation DrawBordController
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAKSELF
    self.imageView =  [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.originImg;
    self.imageView.backgroundColor = self.imgBgView.backgroundColor;
    [self.imgBgView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.imgBgView);
    }];
    DrawView *drawView = [[DrawView alloc]init];
    drawView.image = self.originImg;
    self.drawView = drawView;
    self.drawView.drawViewMode = DrawViewModeBezier;
    [self.imgBgView addSubview:drawView];
    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.equalTo(weakSelf.imgBgView);
        make.top.equalTo(@(weakSelf.imageRect.origin.y));
        make.left.equalTo(@(weakSelf.imageRect.origin.x));
        make.bottom.equalTo(@(weakSelf.imageRect.size.height));
        make.right.equalTo(@(weakSelf.imageRect.origin.x+weakSelf.imageRect.size.width));
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
    if(self.drawView.drawViewMode == DrawViewModeStroke){
        self.drawView.drawViewMode = DrawViewModeBezier;
        [btn setBackgroundImage:[UIImage imageNamed:@"bezierBoard_l"] forState:UIControlStateNormal];
    }else{
        self.drawView.drawViewMode = DrawViewModeStroke;
        [btn setBackgroundImage:[UIImage imageNamed:@"bezierBoard"] forState:UIControlStateNormal];
    }
    
}
//创建笔触粗细选择器
-(void)createStrokeWidthSlider{
    WEAKSELF
    DrawThicknessView *thicknessView = [[DrawThicknessView alloc]initWithFrame:CGRectMake(0, 50, LL_ScreenWidth, 20)];
    [self.optionView addSubview:thicknessView];
    thicknessView.SliderChangeBlock = ^(CGFloat sliderValue) {
        weakSelf.drawView.sliderValue = sliderValue;
    };
}
//创建色板
-(void)createColorBord{
    //默认当前笔触颜色是黑色
    WEAKSELF
    self.drawView.paintColor = [UIColor blackColor];
    //色板的view
    DrawColorView *colorBoardView = [[DrawColorView alloc]initWithFrame:CGRectMake(10, 20, LL_ScreenWidth-20, 20)];
    [self.optionView addSubview:colorBoardView];
    colorBoardView.DrawColorBlock = ^(UIColor *color) {
        weakSelf.drawView.paintColor = color;
    };
}
- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.originImg.size, self.imgBgView.bounds);
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
