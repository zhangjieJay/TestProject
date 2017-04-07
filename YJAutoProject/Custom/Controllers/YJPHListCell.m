//
//  YJPHListCell.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/1/13.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "YJPHListCell.h"

@implementation YJPHListCell{
    UIImageView * igvPage;
    UILabel * lbTitle;
    UILabel * lbCount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setModel:(YJPhotoListModel *)model{

    _model = model;
    
    CGRect rect = CGRectMake(0, 0, 60, 60);
    
    if (!igvPage) {
        igvPage = [[UIImageView alloc]initWithFrame:rect];
        igvPage.contentMode  = UIViewContentModeScaleAspectFill;
        igvPage.clipsToBounds = YES;
        [self.contentView addSubview:igvPage];
    }
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = PHImageRequestOptionsResizeModeNone;//控制照片尺寸
    //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    //option.synchronous = YES;
//    option.networkAccessAllowed = YES;
    //        option.synchronous = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHImageManager defaultManager] requestImageForAsset:_model.headImageAsset targetSize:CGSizeZero contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        igvPage.image = result;
    }];
    
    
    if (!lbTitle) {
        
        lbTitle = [[UILabel alloc]init];
        lbTitle.textColor = [UIColor blackColor];
        lbTitle.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:lbTitle];
    }
    CGFloat maxWidth = 100;
    CGSize size = [CUTool autoSizeWithString:_model.title font:[UIFont systemFontOfSize:15.f] width:maxWidth height:20.f];
    lbTitle.frame = CGRectMake(CGRectGetMaxX(igvPage.frame)+5.f, 20, size.width, 20);
    lbTitle.text = _model.title;
    
    if (!lbCount) {
        
        lbCount = [[UILabel alloc]init];
        lbCount.textColor = [UIColor grayColor];
        lbCount.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:lbCount];
    }
    maxWidth = 100;
    NSString * text = [NSString stringWithFormat:@"(%ld)",_model.count];
    size = [CUTool autoSizeWithString:text font:[UIFont systemFontOfSize:15.f] width:maxWidth height:20.f];
    lbCount.frame = CGRectMake(CGRectGetMaxX(lbTitle.frame)+5.f, 20.f, size.width, 20);
    lbCount.text = text;

}

@end
