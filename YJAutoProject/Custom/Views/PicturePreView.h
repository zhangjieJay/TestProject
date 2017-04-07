//
//  PicturePreView.h
//  YJAutoProject
//
//  Created by 张杰 on 2017/2/16.
//  Copyright © 2017年 JayZhang. All rights reserved.
//
typedef enum : NSUInteger {
    ImageSourceTypeImageName       = 0,
    ImageSourceTypeImageUrl        = 1,
    ImageSourceTypeImagePHAsset    = 2
} ImageSourceType;


#import "YJBaseView.h"


@interface PicturePreView : YJBaseView
-(void)funSetDataArray:(NSArray*)arData sourceType:(ImageSourceType)sourceType;
@end
