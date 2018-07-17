//
//  PhotoLocationController.m
//  MyCamera
//
//  Created by shiguang on 2018/5/23.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "PhotoLocationController.h"

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "UndisplayLocCell.h"
#import "NearbyLocCell.h"
#import "OriginLocCell.h"
#import "SearchedLocCell.h"
#import "SearrchLocResultCell.h"

@interface PhotoLocationController ()<BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource> {
    BMKPoiSearch* _searcher;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    CLLocation *_userLocation;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) BOOL isNearbyLocation;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,assign) BOOL isSearching;

@end
static NSString *const UndisplayCellID = @"UndisplayCell";
static NSString *const NearbyCellID = @"NearbyCell";
static NSString *const OriginCellID = @"OriginCell";
static NSString *const SearchedCellID = @"SearchedCell";
static NSString *const SearchResultCellID = @"SearrchResultCell";

@implementation PhotoLocationController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    _locService.delegate = self;
    _searcher.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    _locService.delegate = nil;
    _searcher.delegate = nil; // 不用时，置nil
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cancelBtnWidthConstraint.constant = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
    
    WEAKSELF
    self.isNearbyLocation = YES;
    
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchBar.mas_bottom);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"UndisplayLocCell" bundle:nil] forCellReuseIdentifier:UndisplayCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"NearbyLocCell" bundle:nil] forCellReuseIdentifier:NearbyCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"OriginLocCell" bundle:nil] forCellReuseIdentifier:OriginCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchedLocCell" bundle:nil] forCellReuseIdentifier:SearchedCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearrchLocResultCell" bundle:nil] forCellReuseIdentifier:SearchResultCellID];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
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
    if (searchBar.text.length >0) {
        self.isNearbyLocation = NO;
        //初始化检索对象
        _searcher =[[BMKPoiSearch alloc]init];
        _searcher.delegate = self;
        //发起检索
        BMKPOICitySearchOption *option = [[BMKPOICitySearchOption alloc]init];
        option.pageIndex = 0;
        option.pageSize = 10;
        option.city= @"天津";
        option.keyword = searchBar.text;
        BOOL flag = [_searcher poiSearchInCity:option];
        
        if(flag)
        {
            NSLog(@"周边检索发送成功");
        }
        else
        {
            NSLog(@"周边检索发送失败");
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    
    [searchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    self.cancelBtnWidthConstraint.constant = 0;
    if (searchBar.text.length >0) {
        self.isNearbyLocation = NO;
        //初始化检索对象
        _searcher =[[BMKPoiSearch alloc]init];
        _searcher.delegate = self;
        //发起检索
        BMKPOICitySearchOption *option = [[BMKPOICitySearchOption alloc]init];
        option.pageIndex = 0;
        option.pageSize = 10;
        option.city= @"天津";
        option.keyword = searchBar.text;
        BOOL flag = [_searcher poiSearchInCity:option];
        
        if(flag)
        {
            NSLog(@"周边检索发送成功");
        }
        else
        {
            NSLog(@"周边检索发送失败");
        }
    }
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"=======");
    return YES;
}

#pragma mark - BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult*)result errorCode:(BMKSearchErrorCode)error
{
    _searcher.delegate = nil;
    _searcher = nil;
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.dataSource.count>0) {
            [self.dataSource removeAllObjects];
        }
        
        [self.dataSource addObjectsFromArray:result.poiInfoList];
        [self.tableView reloadData];
        
        
    }else {
        [MBProgressHUD showError:@"未找到地理位置信息"];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation.location;
    
    //初始化检索对象
    _geocodesearch =[[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
#pragma mark - 反向地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    _searcher.delegate = nil;
    _searcher = nil;
    
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.dataSource.count>0) {
            [self.dataSource removeAllObjects];
        }
        
        [self.dataSource addObjectsFromArray:result.poiList];
        [self.tableView reloadData];
        
        
    }else {
        [MBProgressHUD showError:@"未找到地理位置信息"];
    }
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isNearbyLocation && self.locationStr) {
        return self.dataSource.count +2;
    }else{
        return self.dataSource.count +1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isNearbyLocation) {
        if (self.locationStr) {
            if(indexPath.row == 2){
                return 80;
            }else{
                return 50;
            }
        }else{
            if(indexPath.row == 1){
                return 80;
            }else{
                return 50;
            }
        }
    }else{
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BMKPoiInfo *poi;
    if (!self.isNearbyLocation) {
        
        if (indexPath.row == 0) {
            SearchedLocCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchedCellID];
            cell.nameLabel.text = self.searchBar.text;
            return cell;
        }else{
            poi = self.dataSource[indexPath.row-1];
            SearrchLocResultCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchResultCellID];
            cell.nameLabel.text = poi.name;
            cell.addressLabel.text = poi.address;
            return cell;
        }
    }else{
        
        if (self.locationStr) {
            if (indexPath.row == 0) {
                UndisplayLocCell *cell = [tableView dequeueReusableCellWithIdentifier:UndisplayCellID];
                return cell;
            }else if(indexPath.row == 1){
                OriginLocCell *cell = [tableView dequeueReusableCellWithIdentifier:OriginCellID];
                cell.nameLabel.text = self.locationStr;
                return cell;
            }else if(indexPath.row == 2){
                poi = self.dataSource[indexPath.row-2];
                NearbyLocCell *cell = [tableView
                                       dequeueReusableCellWithIdentifier:NearbyCellID];
                cell.nameLabel.text = poi.name;
                cell.addressLabel.text = poi.address;
                return cell;
            }else{
                poi = self.dataSource[indexPath.row-2];
                SearrchLocResultCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchResultCellID];
                cell.nameLabel.text = poi.name;
                cell.addressLabel.text = poi.address;
                return cell;
            }
        }else{
            if (indexPath.row == 0) {
                UndisplayLocCell *cell = [tableView dequeueReusableCellWithIdentifier:UndisplayCellID];
                return cell;
            }else if(indexPath.row == 1){
                poi = self.dataSource[indexPath.row-1];
                NearbyLocCell *cell = [tableView
                                       dequeueReusableCellWithIdentifier:NearbyCellID];
                cell.nameLabel.text = poi.name;
                cell.addressLabel.text = poi.address;
                return cell;
            }else{
                poi = self.dataSource[indexPath.row-1];
                SearrchLocResultCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchResultCellID];
                cell.nameLabel.text = poi.name;
                cell.addressLabel.text = poi.address;
                return cell;
            }
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isNearbyLocation) {
        if (indexPath.row == 0) {
            self.locationBlock(nil, nil);
        }else if (indexPath.row == 1 && self.locationStr){
            
            self.locationBlock(nil, self.locationStr);
            
        }else{
            NearbyLocCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            self.locationBlock(cell.nameLabel.text, cell.addressLabel.text);
        }
    }else{
        if (indexPath.row == 0) {
            SearchedLocCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            self.locationBlock(nil, cell.nameLabel.text);
        }else{
            SearrchLocResultCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            self.locationBlock(cell.nameLabel.text, cell.addressLabel.text);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    NSLog(@"%s",__func__);
}

@end
