//
//  NBHttpManager.h
//  YJAutoProject
//
//  Created by 峥刘 on 17/5/23.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^successBlock)(id respObject);
typedef void(^failureBlock)(NSString * error);


@interface NBRequest : NSObject

#pragma mark -------------------------------------------------------- 普通的POST请求(不带图片)
+ (void )Post:(NSString *)sUrl params:(NSDictionary *)paramDic success:(successBlock)success fail:(failureBlock)failure;


#pragma mark -------------------------------------------------------- 普通的GET请求
+ (void)Get:(NSString *)sUrl params:(NSDictionary *)paramDic success:(successBlock)success fail:(failureBlock)failure;




#pragma mark -------------------------------------------------------- 下载任务
+ (void)downLoad:(NSString *)sUrl params:(NSDictionary *)paramDic success:(successBlock)success fail:(failureBlock)failure;


#pragma mark -------------------------------------------------------- 上传任务
+ (void)upLoad:(NSString *)sUrl params:(NSDictionary *)paramDic success:(successBlock)success fail:(failureBlock)failure;

@end

