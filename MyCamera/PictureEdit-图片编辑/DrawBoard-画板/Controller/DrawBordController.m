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
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *barView;
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
    self.bottomView.frame = CGRectMake(0, LL_ScreenHeight-150, LL_ScreenWidth, 150);
    self.barView.frame = CGRectMake(0, self.bottomView.height-50, LL_ScreenWidth, 50);
    self.optionView.frame = CGRectMake(0, 0, LL_ScreenWidth, self.bottomView.height-self.barView.height);
    self.imgBgView.frame = CGRectMake(0, 0, LL_ScreenWidth, LL_ScreenHeight-self.bottomView.height);
    self.imageView =  [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.originImg;
    self.imageView.backgroundColor = self.imgBgView.backgroundColor;
    [self.imgBgView addSubview:self.imageView];
    self.imageView.frame = self.imgBgView.bounds;
    
    self.drawView.frame = CGRectMake(weakSelf.imageRect.origin.x, weakSelf.imageRect.origin.y, weakSelf.imageRect.size.width, weakSelf.imageRect.size.height);
     
    NSLog(@"===%@",NSStringFromCGRect(self.imageRect));
    //创建色板
    [self createColorBord];
    //创建笔触粗细选择器
    [self createStrokeWidthSlider];
    [self createBottomBarView];
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
- (void)createBottomBarView{
    CGFloat wh = 30;
    CGFloat margin = (LL_ScreenWidth-wh*6)/7;
    NSArray *imgArr = @[@"CloseIcon", @"CompleteBtnImg",@"markcolor",@"markline",@"markLineType",@"markshapes"];
    for (int i=0; i<6; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(margin*(i+1)+wh*i, (self.barView.height-wh)/2, wh, wh);
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.barView addSubview:btn];
    }
}
- (void)barBtnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 1:
        
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            break;
        case 5:
            self.drawView.image = self.originImg;
            if (self.imageBlock) {
                self.imageBlock([self.drawView getImage]);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}
- (UIView *)barView{
    if (!_barView) {
        UIView *barView = [[UIView alloc]init];
        [self.bottomView addSubview:barView];
        _barView = barView;
    }
    return _barView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc]init];
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}
- (UIView *)optionView{
    if (!_optionView) {
        UIView *optionView = [[UIView alloc]init];
        [self.bottomView addSubview:optionView];
        _optionView = optionView;
    }
    return _optionView;
}
- (UIView *)imgBgView{
    if (!_imgBgView) {
        UIView *imgBgView = [[UIView alloc]init];
        [self.view addSubview:imgBgView];
        _imgBgView = imgBgView;
    }
    return _imgBgView;
}
- (DrawView *)drawView{
    if (!_drawView) {
        DrawView *drawView = [[DrawView alloc]init];
        self.drawView = drawView;
        self.drawView.image = self.originImg;
        self.drawView.drawViewMode = DrawViewModeBezier;
        [self.imgBgView addSubview:drawView];
    }
    return _drawView;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
