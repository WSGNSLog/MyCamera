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

#define OptionViewMargin 90

@interface DrawBordController ()

@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) DrawView *drawView;
@property (retain,nonatomic) UIImageView *imageView;
@property (nonatomic, readonly) CGRect imageRect;
@property (nonatomic,assign) LineShape lineShape;
//@property (nonatomic,strong) UIButton *selectedBtn;
@end

@implementation DrawBordController

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    WEAKSELF
    self.bottomView.frame = CGRectMake(0, LL_ScreenHeight-150, LL_ScreenWidth, 150);
    self.barView.frame = CGRectMake(0, self.bottomView.height-50, LL_ScreenWidth, 50);
    self.optionView.frame = CGRectMake(0, 0, LL_ScreenWidth, self.bottomView.height-self.barView.height);
    self.imgBgView.frame = CGRectMake(0, 0, LL_ScreenWidth, LL_ScreenHeight-self.bottomView.height);
    self.imageView =  [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.originImg;
    self.imageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];;
    [self.imgBgView addSubview:self.imageView];
    self.imageView.frame = self.imgBgView.bounds;
    
    self.drawView.frame = CGRectMake(weakSelf.imageRect.origin.x, weakSelf.imageRect.origin.y, weakSelf.imageRect.size.width, weakSelf.imageRect.size.height);
    
    [self createBottomBarView];
    [self createLineShapeView];
}

#pragma mark -控制面板
- (void)createLineShapeView{
    WEAKSELF
    
    DrawShapeView *shapeView = [[DrawShapeView alloc]initWithFrame:CGRectMake(25, (self.optionView.height-40)/2, LL_ScreenWidth-25-OptionViewMargin, 40) DefaultShape:self.lineShape];
    shapeView.ShapeChangeBlock = ^(LineShape shape) {
        weakSelf.lineShape = shape;
        switch (shape) {
            case LineShapeCircle:
                weakSelf.drawView.drawMode = DrawModeCircle;
                break;
            case LineShapeSquare:
                weakSelf.drawView.drawMode = DrawModeSquare;
                break;
            case LineShapeTriangle:
                weakSelf.drawView.drawMode = DrawModeTriangle;
                break;
            case LineShapeFree:
                weakSelf.drawView.drawMode = DrawModeFree;
                break;
            default:weakSelf.drawView.drawMode = DrawModeFree;;
                break;
        }
    };
    [self.optionView addSubview:shapeView];
    
}
- (void)createDashedView{
    WEAKSELF
    DrawDashedView *dashedView = [[DrawDashedView alloc]initWithFrame:CGRectMake(25, (self.optionView.height-40)/2, LL_ScreenWidth-25-OptionViewMargin, 40) DefaultType:LineTypeDefault];
    dashedView.LineTypeChangeBlock = ^(LineType lineType) {
        weakSelf.drawView.drawLineType = (int)lineType;
    };
    [self.optionView addSubview:dashedView];
}
//创建笔触粗细选择器
-(void)createStrokeWidthSlider{
    WEAKSELF
    DrawThicknessView *thicknessView = [[DrawThicknessView alloc]initWithFrame:CGRectMake(10, 35, LL_ScreenWidth-OptionViewMargin-10, 20)];
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
    DrawColorView *colorBoardView = [[DrawColorView alloc]initWithFrame:CGRectMake(10, 35, LL_ScreenWidth-OptionViewMargin-10, 20)];
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
    NSArray *imgArr = @[@"CloseIcon",@"markshapes",@"markLineType",@"markcolor",@"marklineThickness",@"CompleteBtnImg"];
    NSArray *imgHighLightArr = @[@"CloseIcon",@"markshapes_highLight",@"markLineType_highLight",@"markcolor_highLight",@"marklineThickness_highLight",@"CompleteBtnImg"];
    for (int i=0; i<6; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(margin*(i+1)+wh*i, (self.barView.height-wh)/2, wh, wh);
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgHighLightArr[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.barView addSubview:btn];
    }
}
- (void)barBtnClick:(UIButton *)btn{
    if (btn.isSelected) {
        return;
    }
    btn.selected = YES;
    for (UIView *subView in self.optionView.subviews) {
        if (![subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    for (UIView *subView in self.barView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subBtn.tag != btn.tag) {
                subBtn.selected = NO;
            }
        }
    }
    switch (btn.tag) {
        case 0:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 1:
            [self createLineShapeView];
            break;
        case 2:
            [self createDashedView];
            break;
        case 3:
            //创建色板
            [self createColorBord];
            break;
        case 4:
            //创建笔触粗细选择器
            [self createStrokeWidthSlider];
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
        barView.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
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
- (void)undoBtnClick{
    [self.drawView deleteLastDrawing];
}
- (UIView *)optionView{
    if (!_optionView) {
        UIView *optionView = [[UIView alloc]init];
        optionView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.98f alpha:1.00f];
        UIButton *undoBtn = [[UIButton alloc]init];
        undoBtn.frame = CGRectMake(LL_ScreenWidth-55-15, 30, 55, 35);
        undoBtn.layer.cornerRadius = 5;
        undoBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        undoBtn.layer.borderWidth = 1;
        undoBtn.clipsToBounds = YES;
        [undoBtn setImage:[UIImage imageNamed:@"undoIcon"] forState:UIControlStateNormal];
        [undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
        undoBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [undoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [undoBtn addTarget:self action:@selector(undoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [optionView addSubview:undoBtn];
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
        self.drawView.drawMode = DrawModeCircle;
        [self.imgBgView addSubview:drawView];
    }
    return _drawView;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
