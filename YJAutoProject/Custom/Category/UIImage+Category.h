//
//  UIImage+Category.h
//  ComeHelpMe
//
//  Created by Vison on 15-2-5.
//  Copyright (c) 2015年 zxkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
/*颜色转image*/
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  修正图片方向为正常
 */
+ (UIImage *)fixOrientationWithTargeeImage:(UIImage *)tarImage;


/**
 *  UIImage 转NSData
 */
- (NSData *)imageData;

/**
 *  按照原图的比例缩放图片（不会失真）
 *
 *  @param scale 0.1 ～ 1.0
 *
 *  @return 缩放后的图片
 */
- (UIImage *)scaleImage:(float)scale;



/**
 *  按照一定尺寸缩放和裁剪图片
 *
 *  @param targetSize 目标尺寸
 *
 *  @return 处理后后的图片
 */
- (UIImage *)scaleAndcropImageWithSize:(CGSize)targetSize;


/**
 *  压缩图片到一定的大小（不会变化图片的尺寸，可能会失真）
 *
 *  @param memory 目标大小，单位KB
 *
 */

- (void)compressImageWithMemory:(NSInteger)memory
                       complete:(void(^)(UIImage *image, NSData *data))complete;




@end
