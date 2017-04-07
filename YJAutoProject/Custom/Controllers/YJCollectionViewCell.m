//
//  YJCollectionViewCell.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/1/9.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "YJCollectionViewCell.h"

@interface YJCollectionViewCell()
@property(nonatomic,strong)UIImageView * imageView;//照片视图
@property(nonatomic,strong)UIButton * selectedBtn;//选项按钮
@property(nonatomic,strong)PHImageRequestOptions *option;
@end



@implementation YJCollectionViewCell



-(void)setModel:(YJPhotoModel *)model{

    _model = model;
    
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.frame= self.contentView.bounds;
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    if (!_option) {
        _option = [[PHImageRequestOptions alloc] init];
        _option.resizeMode = PHImageRequestOptionsResizeModeNone;//控制照片尺寸
        
    }

    [[PHImageManager defaultManager] requestImageForAsset:_model.asset targetSize:CGSizeZero contentMode:PHImageContentModeAspectFit options:_option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        _imageView.image = result;
    }];
    
    
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn addTarget:self action:@selector(selectedBottonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _selectedBtn.frame = CGRectMake(self.bounds.size.width - 20, 0 , 20, 20);
        [_selectedBtn setImage:[UIImage imageNamed:@"YJ_Failed_Face"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"YJ_Successed_Face"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectedBtn];
    }
    _selectedBtn.selected = _model.isSelected;
    
}


-(void)selectedBottonClicked:(UIButton*)sender{
    sender.selected = !sender.selected;
    _model.isSelected = sender.isSelected;
}
@end
