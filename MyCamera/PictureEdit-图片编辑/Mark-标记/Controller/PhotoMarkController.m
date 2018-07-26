
//
//  PhotoMarkController.m
//  MyCamera
//
//  Created by shiguang on 2018/7/26.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoMarkController.h"
#import "MarkDrawView.h"

@interface PhotoMarkController ()
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIView *imgBgView;

@end

@implementation PhotoMarkController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WEAKSELF
    MarkDrawView *drawView = [[MarkDrawView alloc]init];
    [self.imgBgView addSubview:drawView];
    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(weakSelf.imgBgView);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)closeClick:(id)sender {
    
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

@end
