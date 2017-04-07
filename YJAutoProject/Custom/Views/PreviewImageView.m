//
//  PreviewImageView.m
//  Image
//
//  Created by pigbear on 17/2/16.
//  Copyright © 2017年 pigbeartech.Ltd. All rights reserved.
//

#import "PreviewImageView.h"

@implementation PreviewImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setImage:(UIImage *)image{

    [super setImage:image];
    [self resetImageViewFrame:self];
}



-(void)resetImageViewFrame:(UIImageView *)imageView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = screenWidth/screenHeight;//屏幕宽高比


    CGFloat width = imageView.image.size.width;//图片宽度
    CGFloat height = imageView.image.size.height;//图片高度
    
    CGFloat imageScale = width/height;//图片宽高比
    
    CGRect frame = imageView.frame;
    CGRect superFrame = imageView.superview.frame;
    frame.origin.x = 0.f;
    frame.origin.y = 0.f;

    if (scale<=imageScale) {
        frame.size.width = screenWidth;
        frame.size.height = frame.size.width/imageScale;
        superFrame.size.height = frame.size.height;
        superFrame.origin.y = (screenHeight-frame.size.height)/2.f;
        imageView.frame = frame;
    }else{
        frame.size.width = screenHeight;
        frame.size.width = frame.size.height*imageScale;
        superFrame.size.width = frame.size.width;
        superFrame.origin.x = (screenWidth-frame.size.width)/2.f;
        imageView.frame = frame;
    }
    
    imageView.superview.frame = superFrame;

}

@end
