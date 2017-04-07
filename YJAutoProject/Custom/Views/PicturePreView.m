//
//  PicturePreView.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/2/16.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "PicturePreView.h"
#import "PhotoView.h"
#import <objc/runtime.h>


@interface PicturePreView()<UIScrollViewDelegate>

@property(nonatomic,strong)BaseScrollView * BaseScrollView;
@property(nonatomic,strong)NSArray * dataArray;


@end

@implementation PicturePreView{

    NSInteger nCurrentPage;

    CGFloat pageWidth;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pageWidth = frame.size.width;
        [self initBaseControls];
    }
    return self;
}

-(BaseScrollView *)BackScrollView
{
    if (!_BaseScrollView) {
        _BaseScrollView = [[BaseScrollView alloc]initWithFrame:self.bounds];
        _BaseScrollView.pagingEnabled = YES;
        _BaseScrollView.delegate = self;
        _BaseScrollView.showsHorizontalScrollIndicator = NO;
        _BaseScrollView.showsVerticalScrollIndicator = NO;
        _BaseScrollView.backgroundColor = [UIColor blackColor];
    }
    return _BaseScrollView;
}




#pragma mark--初始化控件
-(void)initBaseControls{
    
    [self addSubview:self.BackScrollView];
}


-(void)funSetDataArray:(NSArray*)arData sourceType:(ImageSourceType)sourceType{


    self.dataArray = arData.mutableCopy;//赋值


    switch (sourceType) {
        case ImageSourceTypeImageName:
            [self funInputImagesWithNames];
            break;
        case ImageSourceTypeImageUrl:
            [self funInputImagesWithUrls];
            break;
        case ImageSourceTypeImagePHAsset:
            [self funInputImagesWithPHAssets];
            break;
            
        default:
            break;
    }
}


-(void)funInputImagesWithNames{

    [self funAddViewsWithNames];


}
-(void)funInputImagesWithUrls{
    
    
    
    
}
-(void)funInputImagesWithPHAssets{
    
    
    
    
}


-(void)funAddViewsWithNames{

    NSInteger nCount = self.dataArray.count;
    CGRect tempRect = self.bounds;
    CGFloat perWidth = tempRect.size.width;
    self.BaseScrollView.contentSize = CGSizeMake(perWidth * nCount, tempRect.size.height);
    for (NSInteger i = 0; i < nCount; i++) {
        tempRect.origin.x = i * perWidth;
        PhotoView * PhotoViewPhotoView = [[PhotoView alloc]initWithFrame:tempRect];
        [self.BaseScrollView addSubview:PhotoViewPhotoView];
        [PhotoViewPhotoView.imageView setImage:[UIImage imageNamed:[self.dataArray objectAtIndex:i]]];//设置图片
    }

}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//
//    CGFloat offset_x = scrollView.contentOffset.x;
//    
//    NSInteger page = (pageWidth/2.f + offset_x)/pageWidth;
////    
////    if (nCurrentPage != page) {
////        [self funScaleToMinScale];
////    }
//    nCurrentPage = page;
//
//
//}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    
    if (decelerate) {
        CGFloat offset_x = scrollView.contentOffset.x;
        NSInteger page = (pageWidth/2.f + offset_x)/pageWidth;
        if (nCurrentPage != page) {
            [self funScaleToMinScale];
        }
        nCurrentPage = page;
    }
    
    
  



}


-(void)funScaleToMinScale{

    for (UIView * view in self.BaseScrollView.subviews) {

        if ([view isKindOfClass:[PhotoView class]]) {
            PhotoView * singleView = (PhotoView *)view;
            [singleView.BackView setZoomScale:1.f animated:NO];
        }
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
