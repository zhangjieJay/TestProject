//
//  YJAlbumPickerViewController.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/1/9.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "YJAlbumPickerViewController.h"
#import "YJCollectionViewCell.h"

#import <Photos/Photos.h>


@interface YJAlbumPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView * albumCollectionView;//相册的集合视图
@property(nonatomic,strong)NSMutableArray * dataArray;//照片数组
@property(nonatomic,strong)NSArray * assetsArray;//存放asset方便获取高清图
@property(nonatomic,strong)YJNormalView * viewBottom;//
@property(nonatomic,strong)YJBaseButton * btnPreview;
@property(nonatomic,strong)YJBaseButton * btnFinish;

@end


@implementation YJAlbumPickerViewController

-(UICollectionView *)albumCollectionView{
    
    if (!_albumCollectionView) {
        
        CGFloat gap = 5.f;
        CGFloat itemsWidth = (YJ_SCREEN_WIDTH - 3 * gap)/4.0;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemsWidth, itemsWidth);
        layout.minimumLineSpacing = gap;
        layout.minimumInteritemSpacing = gap;
        _albumCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, YJ_SCREEN_WIDTH, YJ_SCREEN_HEIGHT) collectionViewLayout:layout];
        _albumCollectionView.backgroundColor = [UIColor greenColor];
        [_albumCollectionView registerClass:[YJCollectionViewCell class] forCellWithReuseIdentifier:@"CELLID"];
        _albumCollectionView.delegate = self;
        _albumCollectionView.dataSource = self;
        
    }
    return _albumCollectionView;
    
}

-(YJNormalView *)viewBottom{
    if (!_viewBottom) {
        _viewBottom = [[YJNormalView alloc]initWithFrame:CGRectMake(0, YJ_SCREEN_HEIGHT - 50, YJ_SCREEN_WIDTH, 50)];
        _viewBottom.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        
        self.btnPreview = [YJBaseButton buttonWithType:UIButtonTypeCustom];
        [self.btnPreview setTitle:@"预览" forState:UIControlStateNormal];
        [self.btnPreview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnPreview.frame = CGRectMake(0, 10, 60, 30);
        [_viewBottom addSubview:self.btnPreview];
        
        self.btnFinish = [YJBaseButton buttonWithType:UIButtonTypeCustom];
        [self.btnFinish addTarget:self action:@selector(finishChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnFinish setTitle:@"完成" forState:UIControlStateNormal];
        [self.btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnFinish.frame = CGRectMake(YJ_SCREEN_WIDTH - 60, 10, 60, 30);
        [_viewBottom addSubview:self.btnFinish];

        
    }
    return _viewBottom;
}



-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(PHAssetCollection *)assetCollection{

    if (!_assetCollection) {
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"]){
                _assetCollection = collection;
                *stop = YES;
            }
        }];
    }

    return _assetCollection;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.albumCollectionView];
    [self.view addSubview:self.viewBottom];
    [self getAssetsInAssetCollection:self.assetCollection ascending:NO];
    [self.albumCollectionView reloadData];
  
    
}

#pragma mark - 获取指定相册内的所有图片
- (void)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
            YJPhotoModel * model =[YJPhotoModel new];
            model.asset = obj;
            [self.dataArray addObject:model];
        }
    }];
}

//-(void)getImageWithAssets:(NSArray <PHAsset *>*)array{
//    
//    
//    [array enumerateObjectsUsingBlock:^(PHAsset *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
//        /**
//         resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
//         deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
//         这个属性只有在 synchronous 为 true 时有效。
//         */
//        option.resizeMode = PHImageRequestOptionsResizeModeFast;//控制照片尺寸
//        //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
//        //option.synchronous = YES;
//        option.networkAccessAllowed = YES;
//        //        option.synchronous = YES;
//        //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
//        [[PHImageManager defaultManager] requestImageForAsset:obj targetSize:[self getSizeWithAsset:obj] contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            [self.dataArray addObject:result];
//            
//        }];
//    }];
//    
//}


- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"一共获取到%ld张照片",self.dataArray.count);
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YJCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[YJCollectionViewCell alloc]init];
    }
    
    YJPhotoModel * model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    NSLog(@"给第%ld个cell赋值",indexPath.row);
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self.albumCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 获取图片及图片尺寸的相关方法
- (CGSize)getSizeWithAsset:(PHAsset *)asset
{
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = width/height;
    
    return CGSizeMake(self.albumCollectionView.frame.size.height*scale, self.albumCollectionView.frame.size.height);
}

-(void)finishChoose:(UIButton *)sender{

 
  NSArray * array =  [self getSelectedAssets];
    

    

   NSArray * imges =  [self getImagesArray:array];
    
    for (UIImage * image in imges) {
        
        NSData * data = UIImagePNGRepresentation(image);
        if (!data) {
            data = UIImageJPEGRepresentation(image, 1.f);
        }
        if (!data) {
            
            
        }

    }
    
    

}

-(NSArray *)getImagesArray:(NSArray *)arAssets{

    
    PHImageRequestOptions * option = [[PHImageRequestOptions alloc]init];
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    NSMutableArray * arImages = [NSMutableArray array];
    __block BOOL isFinish = NO;
    CGSize size;
    
    for (PHAsset * asset in arAssets) {
        size = [self getSizeWithAsset:asset];
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            BOOL isPreview = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (!isPreview) {
                [arImages addObject:result];
            }
            if (arAssets.count == arImages.count) {
                isFinish = YES;
            }
        }];
    }
    
    while (!isFinish) {
        
        [[NSRunLoop currentRunLoop] acceptInputForMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

    }
    
    
    
    return arImages;

}

-(NSArray <PHAsset *> *)getSelectedAssets{

    NSMutableArray * muAssets = [NSMutableArray array];
    for (YJPhotoModel * model in self.dataArray) {
        if (model.isSelected) {
            [muAssets addObject:model.asset];
        }
    }
    return muAssets;
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
