//
//  UIImage+Category.m
//  ComeHelpMe
//
//  Created by Vison on 15-2-5.
//  Copyright (c) 2015年 zxkj. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (WXChangeColorToImage)
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)fixOrientationWithTargeeImage:(UIImage *)tarImage{
    [self createImageWithColor:nil];
    // No-op if the orientation is already correct
    if (tarImage.imageOrientation == UIImageOrientationUp)
        return tarImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (tarImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, tarImage.size.width, tarImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, tarImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, tarImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (tarImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, tarImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, tarImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, tarImage.size.width, tarImage.size.height,
                                             CGImageGetBitsPerComponent(tarImage.CGImage), 0,
                                             CGImageGetColorSpace(tarImage.CGImage),
                                             CGImageGetBitmapInfo(tarImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (tarImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,tarImage.size.height,tarImage.size.width), tarImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,tarImage.size.width,tarImage.size.height), tarImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (NSData *)imageData {
    return UIImageJPEGRepresentation(self, 1.0);
}

- (UIImage *)scaleImage:(float)scale {
    float targetScale = scale;
    if (targetScale <= 0.1) {
        targetScale = 0.1;
    }
    if (targetScale >= 1.0) {
        targetScale = 1.0;
    }
    CGSize originalSize = self.size;
    CGSize targetSize = CGSizeMake(originalSize.width * targetScale, originalSize.height * targetScale);
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return targetImage;
}

- (UIImage *)scaleAndcropImageWithSize:(CGSize)targetSize {
    float wRatio = targetSize.width / self.size.width * 1.0;
    float hRatio = targetSize.height / self.size.height * 1.0;
    float originalRito = MAX(wRatio, hRatio) > 1.0 ? 1.0 : MAX(wRatio, hRatio);
    CGSize originalScaleSize = CGSizeMake(self.size.width * originalRito, self.size.height * originalRito);
    float x = originalScaleSize.width / 2 * 1.0 - targetSize.width / 2 * 1.0;
    float y = originalScaleSize.height / 2 * 1.0 - targetSize.height / 2 * 1.0;
    
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:CGRectMake(- x, - y, originalScaleSize.width, originalScaleSize.height)];
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return targetImage;
}

- (void)compressImageWithMemory:(NSInteger)memory
                       complete:(void(^)(UIImage *image, NSData *data))complete;{
    float minCompressRatio = 0.1;
    __block float compressRatio = 0.9;
    NSInteger bytes = memory * 1024;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData *imageData = UIImageJPEGRepresentation(self, compressRatio);
        
        while (compressRatio > minCompressRatio && imageData.length > bytes) {
            compressRatio -= 0.1;
            imageData = UIImageJPEGRepresentation(self, compressRatio);
        }
        
        UIImage *newImage = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           complete(newImage, imageData);
            
        });
    });
    
}
@end












