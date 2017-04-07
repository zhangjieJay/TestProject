//
//  ImageScrollVIew.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/1/11.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "ImageScrollVIew.h"

@implementation ImageScrollVIew{

    BaseScrollView * scrollView;//


}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self funInitControls];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)funInitControls{
    scrollView = [[BaseScrollView alloc]initWithFrame:self.bounds];
    [self addSubview:scrollView];
    
}

-(void)funPutImagesWithImageArray:(NSArray *)arImages{






}

@end
