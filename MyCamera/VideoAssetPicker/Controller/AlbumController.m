//
//  AlbumController.m
//  CustomCamera
//
//  Created by shiguang on 2018/3/9.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "AlbumController.h"
#import <Photos/Photos.h>
#import "AlbumCell.h"
#import "VideoAssetPickerController.h"


static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@interface AlbumController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *fetchResults;
@property (nonatomic, copy) NSArray *assetCollections;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *assetCollectionSubtypes;

@end

@implementation AlbumController

static NSString *const AlbumCellID = @"AlbumCellID";
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
    
    self.assetCollectionSubtypes = [NSArray arrayWithObjects:@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                                            @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                                            @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                                            @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                    @(PHAssetCollectionSubtypeSmartAlbumBursts), nil];
    
    self.mediaType = ImagePickerMediaTypeVideo;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    self.fetchResults = @[smartAlbums, userAlbums];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AlbumCell class]) bundle:nil] forCellReuseIdentifier:AlbumCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self updateAssetCollections];
}

- (void)cancelClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doneClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetCollections.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
    
    PHAssetCollection *assetCollection = self.assetCollections[indexPath.row];
    
    PHFetchOptions *options = [PHFetchOptions new];
    
    switch (self.mediaType) {
        case ImagePickerMediaTypeImage:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            break;
            
        case ImagePickerMediaTypeVideo:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            break;
            
        default:
            break;
    }
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    if (fetchResult.count >= 3) {
        cell.imageView3.hidden = NO;
        
        [imageManager requestImageForAsset:fetchResult[fetchResult.count - 3]
                                targetSize:CGSizeScale(cell.imageView3.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView3.image = result;
                                 }
                             }];
    } else {
        cell.imageView3.hidden = YES;
    }
    
    if (fetchResult.count >= 2) {
        cell.imageView2.hidden = NO;
        
        [imageManager requestImageForAsset:fetchResult[fetchResult.count - 2]
                                targetSize:CGSizeScale(cell.imageView2.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView2.image = result;
                                 }
                             }];
    } else {
        cell.imageView2.hidden = YES;
    }
    
    if (fetchResult.count >= 1) {
        [imageManager requestImageForAsset:fetchResult[fetchResult.count - 1]
                                targetSize:CGSizeScale(cell.imageView1.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView1.image = result;
                                 }
                             }];
    }
    
    if (fetchResult.count == 0) {
        cell.imageView3.hidden = NO;
        cell.imageView2.hidden = NO;
        
        
        UIImage *placeholderImage = [self placeholderImageWithSize:cell.imageView1.frame.size];
        cell.imageView1.image = placeholderImage;
        cell.imageView2.image = placeholderImage;
        cell.imageView3.image = placeholderImage;
    }
    
    
    cell.titleLabel.text = assetCollection.localizedTitle;
    
    
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (long)fetchResult.count];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoAssetPickerController *assetVC = [[VideoAssetPickerController alloc]init];
    assetVC.mediaType = PickerMediaTypeVideo;
    assetVC.assetCollection = self.assetCollections[self.tableView.indexPathForSelectedRow.row];
    [self.navigationController pushViewController:assetVC animated:YES];
}
- (void)updateAssetCollections
{
    // Filter albums
    NSArray *assetCollectionSubtypes = self.assetCollectionSubtypes;
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            
            if (subtype == PHAssetCollectionSubtypeAlbumRegular) {
                [userAlbums addObject:assetCollection];
            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    }
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];
    
    self.assetCollections = assetCollections;
}

- (UIImage *)placeholderImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *backgroundColor = [UIColor colorWithRed:(239.0 / 255.0) green:(239.0 / 255.0) blue:(244.0 / 255.0) alpha:1.0];
    UIColor *iconColor = [UIColor colorWithRed:(179.0 / 255.0) green:(179.0 / 255.0) blue:(182.0 / 255.0) alpha:1.0];
    
    // Background
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // Icon (back)
    CGRect backIconRect = CGRectMake(size.width * (16.0 / 68.0),
                                     size.height * (20.0 / 68.0),
                                     size.width * (32.0 / 68.0),
                                     size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, backIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(backIconRect, 1.0, 1.0));
    
    // Icon (front)
    CGRect frontIconRect = CGRectMake(size.width * (20.0 / 68.0),
                                      size.height * (24.0 / 68.0),
                                      size.width * (32.0 / 68.0),
                                      size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, -1.0, -1.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, frontIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, 1.0, 1.0));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
