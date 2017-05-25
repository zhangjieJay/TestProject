//
//  UIImage+NBCategroy.m
//  wenzhong
//
//  Created by 峥刘 on 17/5/9.
//  Copyright © 2017年 刘峥. All rights reserved.
//

#import "UIImage+NBCategroy.h"

@implementation UIImage (NBCategroy)


//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 100, 100);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}


- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize
{
    
    //画布大小
    CGSize size = CGSizeMake(self.size.width,self.size.height);
    
    
    //创建一个基于位图的上下文
    //    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    UIGraphicsBeginImageContext(size);
    
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText = [CUTool autoSizeWithString:title font:[CUTool getFont:fontSize] width:size.width];
    
    
    CGFloat width = self.size.width;
    
    CGFloat height = self.size.height;
    
    
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    
    //绘制文字
    
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[ UIColor redColor],NSParagraphStyleAttributeName:paragraphStyle}];
    
    
    
    //返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}



- (UIImage *)drawContext:(NSString *)text{
    
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [self drawAtPoint : CGPointMake(0,0)];
    
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextDrawPath (context, kCGPathStroke);
    
    // 画
    [text drawAtPoint:CGPointMake(30,self.size.height * 0.65) withAttributes : @{ NSFontAttributeName :[ UIFont systemFontOfSize:30], NSForegroundColorAttributeName :[UIColor redColor]}];
    
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
    
    
}


- ( UIImage *)createShareImage:( NSString *)str
{
    
    UIImage *image = [ UIImage imageNamed : @"timg.jpeg" ];
    
    CGSize size= CGSizeMake (image. size . width , image. size . height ); // 画布大小
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    
    // 获得一个位图图形上下文
    
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    CGContextDrawPath (context, kCGPathStroke );
    
    // 画 打败了多少用户
    
    [str drawAtPoint : CGPointMake ( 30 , image. size . height * 0.65 ) withAttributes : @{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : 30 ], NSForegroundColorAttributeName :[ UIColor whiteColor ] } ];
    
    //画自己想画的内容。。。。。
    
    // 返回绘制的新图形
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}








static void addRoundedRectToPath(CGContextRef context, CGRect rect, float radius, UIImageRoundedCorner cornerMask)
{
    //原点在左下方，y方向向上。移动到线条2的起点。
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    
    //画出线条2, 目前画线的起始点已经移动到线条2的结束地方了。
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    
    //如果左上角需要画圆角，画出一个弧线出来。
    if (cornerMask & UIImageRoundedCornerTopLeft) {
        
        //已左上的正方形的右下脚为圆心，半径为radius， 180度到90度画一个弧线，
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
                        radius, M_PI, M_PI / 2, 1);
    }
    
    else {
        //如果不需要画左上角的弧度。从线2终点，画到线3的终点，
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        
        //线3终点，画到线4的起点
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
    }
    
    //画线4的起始，到线4的终点
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    
    //画右上角
    if (cornerMask & UIImageRoundedCornerTopRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
                        rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    }
    else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    
    //画右下角弧线
    if (cornerMask & UIImageRoundedCornerBottomRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
                        radius, 0.0f, -M_PI / 2, 1);
    }
    else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    
    //画左下角弧线
    if (cornerMask & UIImageRoundedCornerBottomLeft) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
                        -M_PI / 2, M_PI, 1);
    }
    else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }
    
    CGContextClosePath(context);
}





- (UIImage *)roundedRectWith:(CGFloat)radius cornerMask:(UIImageRoundedCorner)cornerMask
{
    UIImageView *bkImageViewTmp = [[UIImageView alloc] initWithImage:self];
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//获取色彩空间
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    //data                    指向要渲染的绘制内存的地址。这个内存块的大小至少是（bytesPerRow*height）个字节
    //width                   bitmap的宽度,单位为像素
    //height                  bitmap的高度,单位为像素
    //bitsPerComponent        内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
    //bytesPerRow             bitmap的每一行在内存所占的比特数
    //colorspace              bitmap上下文使用的颜色空间。
    //bitmapInfo              指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
    
    
    
    
    CGContextBeginPath(context);//开始绘制路径
    addRoundedRectToPath(context,bkImageViewTmp.frame, radius, cornerMask);//处理路径,出否倒角
    CGContextClosePath(context);//结束绘制路径
    CGContextClip(context);//裁剪
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);//绘制裁剪后的图片
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage * newImage = [UIImage imageWithCGImage:imageMasked];//获取图片
    
    CGImageRelease(imageMasked);
    
    return newImage;
}



@end
