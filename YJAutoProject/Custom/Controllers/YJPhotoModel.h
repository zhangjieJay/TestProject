//
//  YJPhotoModel.h
//  YJAutoProject
//
//  Created by 张杰 on 2017/1/13.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "BaseModel.h"
#import <Photos/Photos.h>

@interface YJPhotoModel : BaseModel
@property(nonatomic,assign)BOOL isSelected;//是否被选中
@property(nonatomic,strong)PHAsset * asset;


@end
