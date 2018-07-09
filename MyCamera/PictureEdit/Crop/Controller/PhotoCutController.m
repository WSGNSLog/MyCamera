
//
//  PhotoCutController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoCutController.h"
#import "PhotoEditView.h"
#import "PhotoCutView.h"
#import "FingerDrawLine.h"

@interface PhotoCutController ()<PhotoEditViewDelegate>
{
    FingerDrawLine *drawBoard;
    PhotoEditView *photoEditView;
    UIImage *testImage;
    PhotoCutView *cutView;
}

@end

@implementation PhotoCutController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setModalPresentationCapturesStatusBarAppearance:YES];
    testImage = [UIImage imageNamed:@"2222.jpg"];
    photoEditView = [[PhotoEditView alloc]initWithFrame:self.view.bounds image:testImage];
    
    photoEditView.delegate = self;
    
    [self.view addSubview:photoEditView];
    
    [self createDrawView];
}
-(void)createDrawView{
    drawBoard = [[FingerDrawLine alloc]initWithFrame:CGRectMake(0, 0, photoEditView.imageView.frame.size.width, photoEditView.imageView.frame.size.height)];

    drawBoard.currentPaintBrushColor = [UIColor redColor];

    drawBoard.currentPaintBrushWidth = 2;

    [photoEditView.imageView addSubview:drawBoard];
}
-(void)PhotoEditView:(UIView *)view changeCategory:(Category_View)categoryView{
    
    UIImage *image = [self createNewPhoto];
    photoEditView.imageView.image = image;
    if(categoryView == Category_View_Draw){
        [cutView removeFromSuperview];
        [self createDrawView];
    }else if (categoryView == Category_View_Text){

    }else if (categoryView == Category_View_Cut){
        [drawBoard removeFromSuperview];
        [self createCutView];
    }
}
-(void)createCutView{
    
    CGPoint center = photoEditView.imageView.center;
    float width = photoEditView.imageView.frame.size.width;
    float height = photoEditView.imageView.frame.size.height;

    photoEditView.imageView.frame = CGRectMake(0, 0, width-20, height-20);

    photoEditView.imageView.center = center;

    cutView = [[PhotoCutView alloc]initWithFrame:photoEditView.topView.frame cutArea:photoEditView.imageView.frame];

    [photoEditView.topView addSubview:cutView];
}
-(void)PhotoEditView:(UIScrollView *)categoryView color:(UIColor *)color{
    drawBoard.currentPaintBrushColor = color;
}


-(UIImage*)createNewPhoto{

    CGRect frame = photoEditView.imageView.frame;

    photoEditView.imageView.frame = CGRectMake(0, 0,testImage.size.width,testImage.size.height);

    drawBoard.frame = CGRectMake(0, 0,testImage.size.width,testImage.size.height);

    UIGraphicsBeginImageContext(photoEditView.imageView.frame.size);

    [photoEditView.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    photoEditView.imageView.frame = frame;

    return image;

}

-(void)revokeDraw{
    if((drawBoard.allMyDrawPaletteLineInfos.count)){

        [drawBoard cleanFinallyDraw];
    }

}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
