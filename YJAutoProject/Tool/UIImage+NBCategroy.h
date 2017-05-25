//
//  UIImage+NBCategroy.h
//  wenzhong
//
//  Created by 峥刘 on 17/5/9.
//  Copyright © 2017年 刘峥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIImageRoundedCornerTopLeft = 1,
    UIImageRoundedCornerTopRight = 1 << 1,
    UIImageRoundedCornerBottomRight = 1 << 2,
    UIImageRoundedCornerBottomLeft = 1 << 3
} UIImageRoundedCorner;

@interface UIImage (NBCategroy)


/**根据颜色创建图片**/
+ (UIImage *)imageWithColor:(UIColor *)color;


/**图片上面绘制文字**/
- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;//在当前图片上绘制文字


- (UIImage *)drawContext:(NSString *)text;
- ( UIImage *)createShareImage:( NSString *)str;

/**图片上面绘制文字**/
- (UIImage *)roundedRectWith:(CGFloat)radius cornerMask:(UIImageRoundedCorner)cornerMask;

@end
