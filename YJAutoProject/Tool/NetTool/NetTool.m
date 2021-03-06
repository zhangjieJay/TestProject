//
//  NetTool.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/3/15.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import "NetTool.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>


@implementation NetTool

+(NSString *)getNetStatus{
    
    NSString * strNetworkType = @"";
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags){
        return strNetworkType;
    }
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0){
        // if target host is reachable and no connection is required
        // then we'll assume (for now) that your on Wi-Fi
        strNetworkType = @"";
    }
    
    if (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0 ){
        // ... and the connection is on-demand (or on-traffic) if the
        // calling application is using the CFSocketStream or higher APIs
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0){
            // ... and no [user] intervention is needed
            strNetworkType = @"WIFI";
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            
            if (currentRadioAccessTechnology){
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]){
                    strNetworkType =  @"4G";
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]){
                    strNetworkType =  @"2G";
                }
                else{
                    strNetworkType =  @"3G";
                }
            }
        }
        else{
            if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable){
                if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection){
                    if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired){
                        strNetworkType = @"2G";
                    }
                    else{
                        strNetworkType = @"3G";
                    }
                }
            }
        }
    }
    
    
    //    if ([strNetworkType isEqualToString:@""]) {
    //        strNetworkType = @"WWAN";
    //    }
    
    return strNetworkType;
    
    
}
@end
