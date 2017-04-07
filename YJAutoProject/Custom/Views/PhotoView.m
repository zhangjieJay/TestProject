//
//  PhotoView.m
//  Image
//
//  Created by pigbear on 17/1/25.
//  Copyright © 2017年 pigbeartech.Ltd. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView()<UIScrollViewDelegate>


@end

@implementation PhotoView{
    
    CGRect maxFrame;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        maxFrame = frame;
        self.backgroundColor = [UIColor blackColor];
        _BackView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _BackView.showsHorizontalScrollIndicator = NO;
        _BackView.showsVerticalScrollIndicator = NO;
        _BackView.minimumZoomScale = 1.f;
        _BackView.maximumZoomScale = 3.f;
        _BackView.delegate =self;
        _BackView.backgroundColor = [UIColor blackColor];
        [self addSubview:_BackView];
        
        _imageView = [[PreviewImageView alloc]initWithFrame:_BackView.bounds];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.userInteractionEnabled = YES;
        _imageView.multipleTouchEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_BackView addSubview:_imageView];
        
        
    }
    return self;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    [self changeFramse:scrollView];
}


-(void)resetFrames:(UIImageView *)imageView{
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;//屏幕宽高比
    
    CGFloat width = imageView.image.size.width;//图片宽度
    CGFloat height = imageView.image.size.height;//图片高度
    
    CGFloat imageScale = width/height;//图片宽高比
    
    CGRect frame = imageView.frame;
    CGRect superFrame = imageView.superview.frame;
    
    if (scale<=imageScale) {
        height = superFrame.size.height;
        frame.size.height = frame.size.width/imageScale;
        superFrame.size.height = frame.size.height;
        superFrame.origin.y = (height-frame.size.height)/2.f;
        imageView.frame = frame;
    }else{
        
        width = superFrame.size.width;
        frame.size.width = frame.size.height*imageScale;
        superFrame.size.width = frame.size.width;
        imageView.frame = frame;
        
    }
    self.BackView.frame = superFrame;
}

-(void)changeFramse:(UIScrollView *)scrollview{
    CGRect imageFrame = self.imageView.frame;
    if (imageFrame.size.width>maxFrame.size.width) {
        imageFrame.origin.x = 0;
        imageFrame.size.width = maxFrame.size.width;
    }else{
        imageFrame.origin.x = (maxFrame.size.width - imageFrame.size.width)/2.f;
    }
    
    if (imageFrame.size.height>maxFrame.size.height) {
        imageFrame.size.height = maxFrame.size.height;
        imageFrame.origin.y = 0;
    }else{
        
        imageFrame.origin.y = (maxFrame.size.height - imageFrame.size.height)/2.f;
        
    }
    scrollview.frame = imageFrame;
}
@end
