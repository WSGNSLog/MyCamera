//
//  PhotoLocationController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/23.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoLocationController.h"

@interface PhotoLocationController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation PhotoLocationController
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
    
    self.cancelBtnWidthConstraint.constant = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
    
    
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    
}
- (void)tapGesture{
    [self.searchBar resignFirstResponder];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.cancelBtnWidthConstraint.constant = 60;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    
}

@end
