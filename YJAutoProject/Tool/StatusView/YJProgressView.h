//
//  YJProgressView.h
//  YJAutoProject
//
//  Created by 张杰 on 2016/12/14.
//  Copyright © 2016年 JayZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJProgressView : NSObject


+(void)showStatusWithText:(NSString *)statusText;

+ (void)showStatusWithText:(NSString *)statusText inParentView:(UIView *)parentView;





@end
