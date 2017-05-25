//
//  NBHttpManager.m
//  YJAutoProject
//
//  Created by 峥刘 on 17/5/23.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "NBRequest.h"
#import "NBParam.h"


@implementation NBRequest

+ (void )Post:(NSString *)sUrl params:(NSDictionary *)paramDic success:(successBlock)success fail:(failureBlock)failure{
    
    NSURL * url = [NSURL URLWithString:sUrl];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;

    // 设置超时时间
    request.timeoutInterval = 10.f;
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // 设置请求模式
    request.HTTPMethod = @"POST";
    
    NSString * sParam = NBQueryStringFromParameters(paramDic);
    
    // 设置请求体
    request.HTTPBody = [sParam dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession * session =   [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        if (error) {
            
            failure(error.localizedDescription);
            
        }else{
            
            NSError * jsError = nil;
            
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsError];
            
            if (jsError) {
                
                failure(jsError.localizedDescription);
                
            }else{
                success(obj);
            }
        }
    }];
    [task resume];
};




+ (void)Get:(NSString *)sUrl params:(NSDictionary *)paramDic success:(successBlock)success fail:(failureBlock)failure
{
    // 处理参数,将参数拼接成user=213&wer=132的格式
    NSString * sParam = NBQueryStringFromParameters(paramDic);
    
    // 创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",sUrl,sParam]];
    
    // 创建一个网络请求
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {

        if (error) {
            failure(error.localizedDescription);
        }else{
            NSError * jsError = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsError];
            
            if (jsError) {
                failure(jsError.localizedDescription);
            }else{
                NSLog(@"从服务器获取到数据");
                success(obj);
            }
        }
    }];
    // 最后一步，执行任务（resume也是继续执行）:
    [task resume];
}

+ (void)downLoad:(NSString *)sUrl params:(NSDictionary *)paramDic success:(successBlock)success fail:(failureBlock)failure{

    //1.NSURLSessionDownloadTask：文件下载任务
    // 1.创建网路路径
    NSURL *url = [NSURL URLWithString:@"http://172.16.2.254/php/phonelogin/image.png"] ;
    // 2.获取会话
    NSURLSession *session = [NSURLSession sharedSession];
    // 3.根据会话，创建任务
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        /*
         a.location是沙盒中tmp文件夹下的一个临时url,文件下载后会存到这个位置,由于tmp中的文件随时可能被删除,所以我们需要自己需要把下载的文件移动到其他地方:pathUrl.
         b.response.suggestedFilename是从相应中取出文件在服务器上存储路径的最后部分，例如根据本路径为，最后部分应该为：“image.png”
         */
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *pathUrl = [NSURL fileURLWithPath:path];
        // 剪切文件
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:pathUrl error:nil];
    }];
    // 4.启动任务
    [task resume];
}
+ (void)upLoad:(NSString *)sUrl params:(NSDictionary *)paramDic success:(successBlock)success fail:(failureBlock)failure{

    
    
    NSString * sParam = NBQueryStringFromParameters(paramDic);
    
    // 创建一个网络路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",sUrl,sParam]];
    
    // 创建一个网络请求
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];

    [session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
    }];

}




#pragma mark -------------------------------------------------------- 将参数进行拼接为字符串(递归方式)

FOUNDATION_EXPORT NSArray * NBQueryStringPairsFromDictionary(NSDictionary *dictionary);
FOUNDATION_EXPORT NSArray * NBQueryStringPairsFromKeyAndValue(NSString *key, id value);


NSString * NBQueryStringFromParameters(NSDictionary *parameters) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (NBParam *pair in NBQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValue]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * NBQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return NBQueryStringPairsFromKeyAndValue(nil, dictionary);
}

#pragma mark -------------------------------------------------------- 将参数进行拼接为字符串(递归方式)

NSArray * NBQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:NBQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:NBQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:NBQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[NBParam alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}


// 设置缓存策略
/*
 // 默认的缓存策略，会在本地缓存
 NSURLRequestUseProtocolCachePolicy = 0,
 
 // 忽略本地缓存数据，永远都是从服务器获取数据，不使用缓存，应用场景：股票，彩票
 NSURLRequestReloadIgnoringLocalCacheData = 1,
 NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData
 
 // 首先使用缓存，如果没有本地缓存，才从原地址下载
 NSURLRequestReturnCacheDataElseLoad = 2,
 
 // 使用本地缓存，从不下载，如果本地没有缓存，则请求失败和 "离线" 数据访问有关，可以和 Reachability 框架结合使用，
 // 如果用户联网，直接使用默认策略。如果没有联网，可以使用返回缓存策略，郑重提示：要把用户拉到网络上来。
 NSURLRequestReturnCacheDataDontLoad = 3,
 
 // 无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载
 NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4,      // Unimplemented
 
 // 如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载
 NSURLRequestReloadRevalidatingCacheData = 5,                // Unimplemented
 
 缓存的数据保存在沙盒路径下 Caches 文件夹中的 SQLite 数据库中。
 */


@end
