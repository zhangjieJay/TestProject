//
//  YJProgressView.m
//  YJAutoProject
//
//  Created by 张杰 on 2016/12/14.
//  Copyright © 2016年 JayZhang. All rights reserved.
//

#import "YJProgressView.h"

@interface YJProgressView()

@property(nonatomic,strong)YJNormalView * viewMask;//遮罩视图
@property(nonatomic,strong)YJNormalView * viewStatus;//黑色底视图
@property(nonatomic,strong)YJNormalImageView * imageView;//成功或者失败的图片
@property(nonatomic,strong)YJNormalIndicatorView * viewIndicator;//苹果自带经典菊花
@property(nonatomic,strong)YJNormalLabel * lbText;//状态标签


@end

@implementation YJProgressView{
    
    CGFloat width_StatusView;
    CGFloat height_StatusView;
    UIFont * textFont;//文字的字体
    
    
}

//单例方法
+(instancetype)defaultView{
    static YJProgressView * viewProgress = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (viewProgress == nil) {
            viewProgress = [[YJProgressView alloc] initSelfObject];
        }
    });
    return viewProgress;
}


//自定义初始化方法
- (instancetype)initSelfObject
{
    self = [super init];
    if (self) {
        width_StatusView = 120.f * YJ_SCALE;
        height_StatusView = 120.f * YJ_SCALE;
        textFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.f];
  
    }
    return self;
}

//禁止使用
- (instancetype)init
{
    @throw @"请使用+defaultView方法进行初始化";
}

-(YJNormalView *)viewMask{
    
    if (!_viewMask) {
        _viewMask = [[YJNormalView alloc]initWithFrame:CGRectMake(0, 0, YJ_SCREEN_WIDTH, YJ_SCREEN_HEIGHT)];
        _viewMask.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.6];
    }
    return _viewMask;
}

-(YJNormalView *)viewStatus{
    if (!_viewStatus) {
        _viewStatus = [[YJNormalView alloc]initWithFrame:CGRectMake(0, 0, width_StatusView, height_StatusView)];
        _viewStatus.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _viewStatus;
}

-(YJNormalImageView *)imageView{
    
    if (!_imageView) {
        _imageView = [[YJNormalImageView alloc]initWithFrame:CGRectMake(0, 15.f, width_StatusView * 0.4, height_StatusView* 0.4)];
    }
    return _imageView;
}

-(YJNormalIndicatorView *)viewIndicator{
    if (!_viewIndicator) {
        _viewIndicator = [[YJNormalIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _viewIndicator.frame = CGRectMake(0, 15.f, 20, 20);
        [_viewIndicator startAnimating];
        
    }
    return _viewIndicator;
}

-(YJNormalLabel *)lbText{
    if (!_lbText) {
        _lbText = [[YJNormalLabel alloc]init];
        _lbText.font = textFont;
        _lbText.textColor = [CUTool getColorWithRed:240 greenColor:240 blueColor:240];
    }
    return _lbText;
}

+(void)showStatusWithText:(NSString *)statusText{
    [YJProgressView showStatusWithText:statusText inParentView:YJ_KEYWINDOW];
}

+ (void)showStatusWithText:(NSString *)statusText inParentView:(UIView *)parentView{
    
    [[YJProgressView defaultView] showStatusText:statusText parentView:parentView];
    
}


-(void)showStatusText:(NSString *)text parentView:(UIView *)parentView{
    
    CGSize size = [CUTool autoSizeWithString:text font:textFont width:100.f * YJ_SCALE  height:40.f];
    [[YJProgressView defaultView].viewMask addSubview:[YJProgressView defaultView].viewStatus];
    [CUTool alignVerticalSonView:[YJProgressView defaultView].viewStatus toParentView:[YJProgressView defaultView].viewMask alignHorizontal:YES];
    [[YJProgressView defaultView].viewStatus addSubview:[YJProgressView defaultView].viewIndicator];
    [CUTool alignHorizontalSonView:[YJProgressView defaultView].viewIndicator toParentView:[YJProgressView defaultView].viewStatus];
    CGFloat y = CGRectGetMaxY([YJProgressView defaultView].viewIndicator.frame)+ 20.f;
    [YJProgressView defaultView].lbText.frame = CGRectMake(0, y, size.width, size.height);
    [YJProgressView defaultView].lbText.text = text;
    [[YJProgressView defaultView].viewStatus addSubview:[YJProgressView defaultView].lbText];
    [CUTool alignHorizontalSonView:[YJProgressView defaultView].lbText toParentView:[YJProgressView defaultView].viewStatus];
    [parentView addSubview:[YJProgressView defaultView].viewMask];
    
}

+(void)disMiss{

    [[YJProgressView defaultView] removeFromSuperView];

}

-(void)removeFromSuperView{

    if (_viewMask) {
        [_viewMask removeFromSuperview];
        _viewMask = nil;
    }else if(_viewStatus){
        [_viewStatus removeFromSuperview];
        _viewStatus = nil;
    }
    [_viewIndicator removeFromSuperview];
    _viewIndicator = nil;
    [_lbText removeFromSuperview];
    _lbText  = nil;

}


@end
