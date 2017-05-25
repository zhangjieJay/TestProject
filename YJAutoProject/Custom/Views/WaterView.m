//
//  WaterView.m
//  YJAutoProject
//
//  Created by 峥刘 on 17/5/11.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "WaterView.h"

@implementation WaterView


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
*/
 - (void)drawRect:(CGRect)rect {
 // Drawing code
     
//     NSString * sText = @"WZ";
//     
//     [sText drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.f],NSForegroundColorAttributeName:[UIColor blueColor]}];
//     
//     
//     
//     UIBezierPath * pate = [UIBezierPath bei]
//     
//     UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, rect.size.height)];
//     label.text = @"WZ";
//     label.textColor = [UIColor redColor];
//     label.font = [UIFont boldSystemFontOfSize:20.f];
//     
//     [UIView animateWithDuration:3 animations:^{
//         label.frame = CGRectMake(0, 0, 100, 100);
//     }];
//     
//     self.layer.mask = label.layer;
     
     
     


     
}

- (void)startAnimation{

    CGFloat KShapelayerLineWidth = 5.f;
    CGFloat KShapeLayerRadius = self.frame.size.height/2.f;
    /// 橘黄色的layer
    CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
    ovalShapeLayer.strokeColor = [UIColor colorWithRed:0.984 green:0.153 blue:0.039 alpha:1.000].CGColor;
    ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ovalShapeLayer.lineWidth = KShapelayerLineWidth;
    ovalShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:KShapeLayerRadius].CGPath;
    
    
    /// 起点动画
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1.0);
    
    /// 终点动画
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);
    
    /// 组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    animationGroup.duration = 1.f;
    animationGroup.repeatCount = CGFLOAT_MAX;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [ovalShapeLayer addAnimation:animationGroup forKey:nil];

}



@end
