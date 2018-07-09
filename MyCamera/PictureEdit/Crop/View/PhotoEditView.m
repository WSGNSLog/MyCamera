//
//  PhotoEditView.m
//  MyCamera
//
//  Created by shiguang on 2018/5/17.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoEditView.h"
#import "UIButton+category.h"
#import "UIImageView+size.h"

@interface PhotoEditView()
{
    NSArray *arr;
}
@end
@implementation PhotoEditView

-(UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,LL_ScreenWidth, LL_ScreenHeight-125)];
        _topView.backgroundColor = [UIColor blackColor];
        
        [_topView addSubview:self.imageView];
    }
    return _topView;
}
-(UIImageView *)imageView{
    if(!_imageView){
        
        _imageView = [UIImageView image:self.image];
        
        _imageView.center = self.topView.center;
        
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

-(UIView *)bottomView{
    if(!_bottomView){
        
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,LL_ScreenHeight-125,LL_ScreenWidth,125)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView addSubview:self.colorCategory];
        [_bottomView addSubview:self.toolView];
    }
    
    return _bottomView;
}
-(UIScrollView *)colorCategory{
    if (!_colorCategory) {
        _colorCategory = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LL_ScreenWidth, 70)];
        _colorCategory.showsVerticalScrollIndicator = YES;
        _colorCategory.scrollEnabled = YES;
        _colorCategory.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
        _colorCategory.contentSize = CGSizeMake(400, 70);
        [_colorCategory addSubview:self.revokeBtn];
        for (int i =0; i<arr.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake((i+1)*50, 15, 40, 40);
            
            button.backgroundColor = arr[i];
            
            button.tag = i;
            
            [button addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            if(i==0){
                button.layer.borderWidth = 1;
            }
            
            [_colorCategory addSubview:button];
            
        }
        
    }
    return _colorCategory;
}
-(UIScrollView *)fontCategory{
    if(!_fontCategory){
        _fontCategory = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LL_ScreenWidth, 70)];
        
        _fontCategory.showsVerticalScrollIndicator = YES;
        
        _fontCategory.scrollEnabled = YES;
        
        
        _fontCategory.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
        
        _fontCategory.contentSize = CGSizeMake(510, 70);
        
        for (int i =0; i<arr.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(20+i*70, 15, 40, 40);
            
            button.backgroundColor = arr[i];
            
            button.tag = i;
            
            [button addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            if(i==0){
                button.layer.borderWidth = 1;
            }
            
            [_fontCategory addSubview:button];
            
        }
    }
    return _fontCategory;
}

-(UIView *)cutCategory{
    if(!_cutCategory){
        
        _cutCategory = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LL_ScreenWidth, 70)];
        
        _cutCategory.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
        [_cutCategory addSubview:self.rightRotateBtn];
        [_cutCategory addSubview:self.leftRotateBtn];
        
    }
    return _cutCategory;
}

-(UIButton *)leftRotateBtn{
    
    if(!_leftRotateBtn){
        
        _leftRotateBtn = [UIButton initWithFrame:CGRectMake(LL_ScreenWidth/2-60, 15, 40, 40) normalImage:[UIImage imageNamed:@"left"] selectedImage:nil];
        
        [_leftRotateBtn addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
        
        _leftRotateBtn.tag = 11111;
    }
    return _leftRotateBtn;
}

-(UIButton *)rightRotateBtn{
    if(!_rightRotateBtn){
        
        _rightRotateBtn = [UIButton initWithFrame:CGRectMake(LL_ScreenWidth/2+40, 15, 40, 40) normalImage:[UIImage imageNamed:@"right"] selectedImage:nil];
        
        [_rightRotateBtn addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightRotateBtn.tag = 22222;
    }
    return _rightRotateBtn;
}

-(UIButton *)revokeBtn{
    
    if(!_revokeBtn){
        
        _revokeBtn = [UIButton initWithFrame:CGRectMake(0, 15, 40, 40) normalImage:[UIImage imageNamed:@"revoke"] selectedImage:[UIImage imageNamed:@"revoke"]];
        _revokeBtn.tag = 1000;
        
        [_revokeBtn addTarget:self action:@selector(revoke) forControlEvents:UIControlEventTouchUpInside];
    }
    return _revokeBtn;
}

-(UIView *)toolView{
    if(!_toolView){
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, LL_ScreenWidth, 55)];
        _toolView.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1];
        [_toolView addSubview:self.cancelBtn];
        [_toolView addSubview:self.drawLineBtn];
        [_toolView addSubview:self.textBtn];
        [_toolView addSubview:self.cutBtn];
        [_toolView addSubview:self.okBtn];
    }
    return _toolView;
}
-(UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _cancelBtn.frame = CGRectMake(0, 10, 80, 40);
        
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        [_cancelBtn setTitleColor:[UIColor colorWithRed:18/255.0 green:143/255.0 blue:245/255.0 alpha:1] forState:UIControlStateNormal];
        
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _cancelBtn;
}
-(UIButton *)drawLineBtn{
    if(!_drawLineBtn){
        
        _drawLineBtn = [UIButton initWithFrame:CGRectMake((self.textBtn.frame.origin.x-90)/2+65, 15, 30, 30) normalImage:[UIImage imageNamed:@"colorsSelect"] selectedImage:[UIImage imageNamed:@"colorsSelected"]];
        [_drawLineBtn addTarget:self action:@selector(drawLine:) forControlEvents:UIControlEventTouchUpInside];
        _drawLineBtn.selected = YES;
    }
    return _drawLineBtn;
}

-(UIButton *)textBtn{
    if(!_textBtn){
        
        _textBtn = [UIButton initWithFrame:CGRectMake((LL_ScreenWidth)/2-15, 15, 30, 30) normalImage:[UIImage imageNamed:@"fontSelect"] selectedImage:[UIImage imageNamed:@"fontSelected"]];
        [_textBtn addTarget:self action:@selector(text:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textBtn;
}

-(UIButton *)cutBtn{
    if(!_cutBtn){
        
        _cutBtn = [UIButton initWithFrame:CGRectMake(LL_ScreenWidth/2+(self.textBtn.frame.origin.x-80)/2+15, 15, 30, 30) normalImage:[UIImage imageNamed:@"cutSelect"] selectedImage:[UIImage imageNamed:@"cutSelected"]];
        [_cutBtn addTarget:self action:@selector(cut:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cutBtn;
}

-(UIButton *)okBtn{
    if(!_okBtn){
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _okBtn.frame = CGRectMake(LL_ScreenWidth-80, 10, 80, 40);
        
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [_okBtn setTitleColor:[UIColor colorWithRed:18/255.0 green:143/255.0 blue:245/255.0 alpha:1] forState:UIControlStateNormal];
        
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _okBtn;
}

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    
    if(self = [super initWithFrame:frame]){
        arr = @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor brownColor]];
        self.image = image;
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
    }
    return self;
}
#pragma mark 私有方法

-(void)changeColor:(UIButton *)sender{
    
    for (UIButton *button in self.colorCategory.subviews) {
        
        if(button.tag == sender.tag){
            button.layer.borderWidth = 1;
        }else{
            button.layer.borderWidth = 0;
        }
    }
    [self.delegate PhotoEditView:self.colorCategory color:arr[sender.tag]];
}
-(void)revoke{
    [self.delegate revokeDraw];
}
-(void)drawLine:(UIButton *)sender{
    
    if(!sender.selected){
        sender.selected = YES;
        self.textBtn.selected = NO;
        self.cutBtn.selected = NO;
        [self.bottomView addSubview:self.colorCategory];
        [self.cutCategory removeFromSuperview];
        [self.fontCategory removeFromSuperview];
        [self.delegate PhotoEditView:self.topView changeCategory:Category_View_Draw];
    }
}
-(void)text:(UIButton *)sender{
    if(!sender.selected){
        sender.selected = YES;
        self.drawLineBtn.selected = NO;
        self.cutBtn.selected = NO;
        [self.bottomView addSubview:self.fontCategory];
        [self.cutCategory removeFromSuperview];
        [self.colorCategory removeFromSuperview];
        [self.delegate PhotoEditView:self.topView changeCategory:Category_View_Text];
    }
}
-(void)cut:(UIButton *)sender{
    if(!sender.selected){
        sender.selected = YES;
        self.textBtn.selected = NO;
        self.drawLineBtn.selected = NO;
        [self.bottomView addSubview:self.cutCategory];
        [self.fontCategory removeFromSuperview];
        [self.colorCategory removeFromSuperview];
        [self.delegate PhotoEditView:self.topView changeCategory:Category_View_Cut];
    }
}
-(void)rotate:(UIButton *)btn{
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform;
    if(btn.tag == 11111){
        
        newTransform = CGAffineTransformRotate(currentTransform,-90*M_PI/180);
    }else{
        newTransform = CGAffineTransformRotate(currentTransform,90*M_PI/180);
    }
    [self.imageView setTransform:newTransform];
    
}









@end
