//
//  PhotoView.h
//  Image
//
//  Created by pigbear on 17/1/25.
//  Copyright © 2017年 pigbeartech.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewImageView.h"

@interface PhotoView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,strong)UIScrollView * BackView;
@property(nonatomic,strong)UIView * uiView;
@property(nonatomic,strong)PreviewImageView * imageView;
@end
