//
//  PhotoEditView.h
//  MyCamera
//
//  Created by shiguang on 2018/5/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, Category_View) {
    Category_View_Draw = 0,
    Category_View_Text,
    Category_View_Cut,
};

@protocol PhotoEditViewDelegate <NSObject>

-(void)PhotoEditView:(UIScrollView *)categoryView color:(UIColor *)color;

-(void)revokeDraw;

-(void)PhotoEditView:(UIView *)view changeCategory:(Category_View)categoryView;

@end
@interface PhotoEditView : UIView
@property(nonatomic,strong)UIView *topView;//上半部view

@property(nonatomic,strong)UIImageView *imageView;//图片显示区域

@property(nonatomic,strong)UIImage *image;//图片

@property(nonatomic,strong)UIView *bottomView;//下半部view

@property(nonatomic,strong)UIView *toolView;//工具栏

@property(nonatomic,strong)UIScrollView *categoryView;//分类view

@property(nonatomic,strong)UIView *categoryView1;

@property(nonatomic,strong)UIScrollView *colorCategory;

@property(nonatomic,strong)UIView *cutCategory;

@property(nonatomic,strong)UIButton *leftRotateBtn;

@property(nonatomic,strong)UIButton *rightRotateBtn;

@property(nonatomic,strong)UIScrollView *fontCategory;

@property(nonatomic,strong)UIButton *revokeBtn;

@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)UIButton *drawLineBtn;

@property(nonatomic,strong)UIButton *textBtn;

@property(nonatomic,strong)UIButton *cutBtn;

@property(nonatomic,strong)UIButton *okBtn;

@property(nonatomic,assign)id<PhotoEditViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
@end
