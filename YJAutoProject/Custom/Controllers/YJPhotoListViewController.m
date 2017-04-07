//
//  YJPhotoListViewController.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/1/13.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "YJPhotoListViewController.h"
#import "YJAlbumPickerViewController.h"
#import "YJPHListCell.h"

@interface YJPhotoListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * photoListArray;
@property(nonatomic,strong)BaseTableView * tableView;

@end

@implementation YJPhotoListViewController{
    
    NSString * listCellID ;
}

-(NSArray *)photoListArray{
    if (!_photoListArray) {
        _photoListArray = [NSArray array];
    }
    return _photoListArray;
}


-(BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[YJPHListCell class] forCellReuseIdentifier:listCellID];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    listCellID = [NSString stringWithFormat:@"PhotoListCellIdentifier"];
    self.photoListArray = [NSArray arrayWithArray:[self getPhotoAblumList]];
    [self.tableView reloadData];
}

#pragma mark - 获取所有相册列表
- (NSArray<YJPhotoListModel *> *)getPhotoAblumList
{
    NSMutableArray<YJPhotoListModel *> *photoAblumList = [NSMutableArray array];
    
    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        //过滤掉视频和最近删除
        if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] ||
              [collection.localizedTitle isEqualToString:@"Videos"] ||[collection.localizedTitle isEqualToString:@"Bursts"] )) {
            NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:NO];
            if (assets.count > 0) {
                YJPhotoListModel *listModel = [[YJPhotoListModel alloc] init];
                listModel.title = [self transformAblumTitle:collection.localizedTitle];
                listModel.count = assets.count;
                listModel.headImageAsset = assets.firstObject;
                listModel.assetCollection = collection;
                [photoAblumList addObject:listModel];
            }
        }
    }];
    
    //获取用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:NO];
        if (assets.count > 0) {
            YJPhotoListModel *listModel = [[YJPhotoListModel alloc] init];
            listModel.title = collection.localizedTitle;
            listModel.count = assets.count;
            listModel.headImageAsset = assets.firstObject;
            
            listModel.assetCollection = collection;
            [photoAblumList addObject:listModel];
        }
    }];
    
    return photoAblumList;
}

#pragma mark - 获取指定相册内的所有图片
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
    }];
    return arr;
}



- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}


- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    } else if ([title isEqualToString:@"Panoramas"]) {
        return @"全景照片";
    }
    return nil;
}

//#pragma mark - 获取相册内所有照片资源
//- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
//{
//    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
//    
//    PHFetchOptions *option = [[PHFetchOptions alloc] init];
//    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
//    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
//    
//    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
//    
//    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        PHAsset *asset = (PHAsset *)obj;
//        [assets addObject:asset];
//    }];
//    
//    return assets;
//}




#pragma mark - tableview delegate & datasource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.photoListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJPHListCell * cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    YJPhotoListModel * model = [self.photoListArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YJAlbumPickerViewController * picVC = [YJAlbumPickerViewController new];
    YJPhotoListModel * model = [self.photoListArray objectAtIndex:indexPath.row];
    picVC.assetCollection = model.assetCollection;
    [self.navigationController pushViewController:picVC animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
