//
//  YJAlbumPickerViewController.h
//  YJAutoProject
//
//  Created by 张杰 on 2017/1/9.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "BaseViewController.h"

@class PHAssetCollection;

@interface YJAlbumPickerViewController : BaseViewController
@property(nonatomic,strong)PHAssetCollection * assetCollection;
@end
