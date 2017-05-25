//
//  WXTool.m
//  ComeHelpMe
//
//  Created by Vison on 15-2-27.
//  Copyright (c) 2015年 zxkj. All rights reserved.
//

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#import "CUTool.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <net/if.h>
#import "sys/utsname.h"
#import <Photos/Photos.h>
#import "Reachability.h"

@interface CUTool()<UIAlertViewDelegate>

@end;

@implementation CUTool
//
//#pragma mark -
//////传入一个字符串，返回它的全部大写字符串（如果有中文，将中文变为大写拼音）
////+ (NSString *)convertStringToCapical:(NSString *)string{
////    NSMutableString *capitalString = [NSMutableString string];
////    for (int i = 0; i < string.length; i ++) {
////        unichar character = [string characterAtIndex:i];
////        if (character >= 0x4E00 && character <= 0x9FFF) {
////            NSString *str = [POAPinyin Convert:[NSString stringWithCharacters:&character length:1]];
////            [capitalString appendString:str];
////        }
////        else{
////            [capitalString appendString:[[NSString stringWithFormat:@"%c",character] uppercaseString]];
////        }
////    }
////    return capitalString;
////}
//
#pragma mark - 货币计算
/**
 *  货币转换
 *
 *  @param money 参数
 *
 *  @return 返回值（只舍不入，保留小数点2位有效数字）
 */
+ (NSString *)calculateMoney:(NSString *)money {
    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", [CUTool isEmpty:money] ? @"0.00" : money]];
    NSDecimalNumber *product = [number decimalNumberByRoundingAccordingToBehavior:handler];
    
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@", product];
    NSRange pointRange = [result rangeOfString:@"."];//小数点位置
    
    //不存在小数，添加两个零
    if (pointRange.location == NSNotFound) {
        [result appendString:@".00"];
    }
    
    //存在小数
    else {
        NSString *pointString = [result substringFromIndex:pointRange.location + 1];//小数点后面数字字符串
        if (pointString.length == 1) {
            //只有一位小数，添加一个零
            [result appendString:@"0"];
        }
    }
    return result;
}


/**
 *  货币计算
 *
 *  @param originValue1 参数1
 *  @param originValue2 参数2
 *  @param calucateWay  计算方法（＋ － ＊ ／）
 *
 *  @return 返回值（只舍不入，保留小数点2位有效数字）
 */
+ (NSString *)decimalNumberCalucate:(NSString *)originValue1 originValue2:(NSString *)originValue2 calucateWay:(calucateWay)calucateWay {
    
    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSString *number1 = [NSString stringWithFormat:@"%@", [CUTool isEmpty:originValue1] ? @"0.00" : originValue1];
    NSString *number2 = [NSString stringWithFormat:@"%@", [CUTool isEmpty:originValue2] ? @"0.00" : originValue2];
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:number2];
    NSDecimalNumber *product;
    switch (calucateWay) {
        case Adding:
            NSLog(@"+++++++++");
            product = [decimalNumber1 decimalNumberByAdding:decimalNumber2 withBehavior:handler];
            break;
            
        case Subtracting:
            NSLog(@"---------");
            product = [decimalNumber1 decimalNumberBySubtracting:decimalNumber2 withBehavior:handler];
            break;
            
        case Multiplying:
            NSLog(@"*********");
            product = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2 withBehavior:handler];
            break;
            
        case Dividing:
            NSLog(@"/////////");
            product = [decimalNumber1 decimalNumberByDividingBy:decimalNumber2 withBehavior:handler];
            break;
            
        default:
            break;
    }
    return [self calculateMoney:[product stringValue]];
}


+(NSInteger)randomIntegerWithMinNum:(NSInteger)minNum andMaxNum:(NSInteger)maxNum{
    
    NSInteger randomNum = arc4random() % (maxNum - minNum + 1) + minNum;
    
    return randomNum;
    
}

#pragma mark - 获取自适应的高度
//根据内容获取NSString UILabel的高度
+ (CGFloat)obtainLabelHeightWithString:(NSString *)text
                                  font:(UIFont *)font
                                 width:(CGFloat)width{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return rect.size.height;
}

//根据内容获取NSAttributeString的高度
+ (CGFloat)obtainLabelHeightWithAttributeString:(NSAttributedString *)text
                                           font:(UIFont *)font
                                          width:(CGFloat)width{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    if (font) {
        [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    }
    
    //为空
    if (str.length == 0) {
        return 0;
    }
    //返回高度
    else {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return rect.size.height;
    }
    
}

/**
 *  根据文本内容获取自适应是文本尺寸
 *
 *  @param text  需要自适应的文字
 *  @param font  自提的大小
 *  @param width 自适应最大宽度
 *
 *  @return 自适应的尺寸
 */
+ (CGSize)autoSizeWithString:(NSString *)text
                        font:(UIFont *)font
                       width:(CGFloat)width{
    
    return [CUTool autoSizeWithString:text font:font width:width height:MAXFLOAT];
}

+ (CGSize)autoSizeWithString:(NSString *)text font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height{
    
    CGSize autoSize = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return autoSize;
}



#pragma mark - 将传入的字符串转化为Jason

+ (id)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    if (![NSJSONSerialization isValidJSONObject:jsonString]) {
        return jsonString;
    }
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    return result;
}

//md5转码
+ (NSString *)md5HexDigest:(NSString *)input {
    
    const char *cStr = [input ? input : @"" UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)(strlen(cStr)), digest );
    NSMutableString *str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [str appendFormat:@"%02x", digest[i]];
    }
    NSString *result = [str uppercaseString];
    return result;
}


//md5转码
+ (NSString *)MD5StringFromString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}


+ (id)makeJsonToData:(NSData *)jsonData {
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}



+(BOOL)isNumber:(NSString *)numStr{
    
    NSString * numPre = @"^[0-9]*$";
    
    NSPredicate *regextestNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numPre];
    
    BOOL isNum = [regextestNum evaluateWithObject:numStr];
    
    return isNum;
    
}


#pragma mark -
+ (BOOL)checkPhoneNumInput:(NSString *)phoneNumString{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09]|7[07])\\d|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumString];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNumString];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNumString];
    BOOL res4 = [regextestct evaluateWithObject:phoneNumString];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

/**
 *  检测银行卡号是否符合（luhn算法）
 *
 *  @param cardNo 卡号
 *
 *  @return 返回是否是正确的卡号
 */
+ (BOOL)checkCardNo:(NSString *)cardNo {
    if ([cardNo isEqualToString:@""]) {
        return NO;
    }
    
    int oddsum = 0;
    int evensum = 0;
    int allsum = 0;
    
    for (int i = 0; i< [cardNo length];i++) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i, 1)];
        int tmpVal = [tmpString intValue];
        if((i % 2) == 0){
            tmpVal *= 2;
            if(tmpVal>=10)
                tmpVal -= 9;
            evensum += tmpVal;
        } else {
            oddsum += tmpVal;
            
        }
    }
    
    allsum = oddsum + evensum;
    
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

//验证身份证
+ (BOOL)validateIdentityCard:(NSString *)value {
    if (value.length == 15) {
        NSString *pattern = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        return [predicate evaluateWithObject:value];
    }
    else if (value.length == 18) {
        NSString *pattern = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        return [predicate evaluateWithObject:value];
    }
    else {
        return NO;
    }
}

/**
 *  验证字符串是否全部为汉字
 *
 *  @param value 字符串
 *
 *  @return 返回值
 */
+ (BOOL)validateChinese:(NSString *)value {
    NSString *number = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:value];
}



+ (BOOL)isValidateString:(NSString *)string
                   start:(NSInteger)start
                     end:(NSInteger)end {
    NSUInteger character = 0;
    for (int i = 0; i < string.length; i ++) {
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a <0x9fff) {//是否为中文
            character += 2;
        } else {
            character += 1;
        }
    }
    if (character >= start && character <= end) {
        return YES;
    } else {
        return NO;
    }
}


/**
 *  判断是否为空
 */
+ (BOOL)isEmpty:(id)object {
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (object == nil) {
        return YES;
    }
    if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        if ([object floatValue] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}

/**
 *  判断价格格式是否正确
 *
 *  @param price 价格
 *
 */
+ (BOOL)isPrice:(NSString *)price {
    NSString *priceValidateStr = @"^(0|[1-9][0-9]{0,9})(\\.[0-9]{1,2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", priceValidateStr];
    return [predicate evaluateWithObject:price];
}


#pragma mark -
+ (NSString *)getTimeFormateWithTimeStamp:(NSString *)timeStamp{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTimeStamp = [date timeIntervalSince1970] * 1000;
    long time = currentTimeStamp - [timeStamp doubleValue];
    
    long days = time / (1000 * 60 * 60 * 24);
    int hours = time % (1000 * 60 * 60 * 24) / (1000 * 60 * 60) ;
    int mins = time % (1000 * 60 * 60 * 24) % (1000 * 60 * 60) / (1000 * 60);
    
    NSString *subTime;
    if (days > 0) {
        subTime = [NSString stringWithFormat:@"%ld天前",days];
    }
    else if (days <= 0 && hours > 0){
        subTime = [NSString stringWithFormat:@"%d小时前",hours];
    }
    else if (days <= 0 && hours <= 0 && mins > 0){
        subTime = [NSString stringWithFormat:@"%d分钟前",mins];
    }
    else{
        subTime = @"1分钟前";
    }
    
    return subTime;
}



+ (NSString *)getTimeFromFutureToNowWithTimestamp:(NSString *)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTimeStamp = [date timeIntervalSince1970] * 1000;
    int time = [timestamp doubleValue] - currentTimeStamp;
    
    int days = time / (1000 * 60 * 60 * 24);
    int hours = time % (1000 * 60 * 60 * 24) / (1000 * 60 * 60) ;
    int mins = time % (1000 * 60 * 60 * 24) % (1000 * 60 * 60) / (1000 * 60);
    
    NSString *subTime;
    if (days > 0) {
        subTime = [NSString stringWithFormat:@"%d天后", days];
    }
    else if (days <= 0 && hours > 0){
        subTime = [NSString stringWithFormat:@"%d小时后", hours];
    }
    else if (days <= 0 && hours <= 0 && mins > 0){
        subTime = [NSString stringWithFormat:@"%d分钟后", mins];
    }
    else{
        subTime = @"已经";
    }
    
    return subTime;
}


#pragma mark -
+ (NSString *)getStandardDateWithTimeStamp:(NSString *)timeStamp
                                 formatter:(NSString *)formatter{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    NSString *standardDate = [format stringFromDate:date];
    return standardDate;
}

#pragma mark -
+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *tomorrow, *yesterday, *afterTomorrow;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    afterTomorrow = [today dateByAddingTimeInterval:secondsPerDay * 2];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString * afterTomorrowString = [[afterTomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]) {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString]) {
        return @"昨天";
    } else if ([dateString isEqualToString:tomorrowString]) {
        return @"明天";
    } else if ([dateString isEqualToString:afterTomorrowString]){
        return @"后天";
    } else {
        return dateString;
    }
}


+ (int)calcuteAgeWithBirthday:(NSString *)birthday {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //当为设置过生日时出现错误年龄的显示:jay
    if ([birthday isKindOfClass:[NSNull class]]) {
        
        NSDate * dateNow = [NSDate date];
        
        NSString * dateNowStr = [formatter stringFromDate:dateNow];
        
        birthday = dateNowStr;
        
    }
    
    
    NSDate *date = [formatter dateFromString:birthday];
    
    CGFloat bornTimeStamp = [date timeIntervalSince1970];
    CGFloat nowTimeStamp = [[NSDate date] timeIntervalSince1970];
    CGFloat subTimeStamp = nowTimeStamp - bornTimeStamp;
    int years = subTimeStamp / 3600 / 24 / 365;
    return years;
}




#pragma mark -
+ (NSString *)getDistanceWithMeters:(NSString *)meters{
    float kilometers = [meters floatValue] / 1000;
    int meter = [meters intValue] % 1000;
    if (kilometers >= 1) {
        
        return [NSString stringWithFormat:@"%.2f公里",kilometers];
    }
    else{
        return [NSString stringWithFormat:@"%d米",meter];
    }
}

+ (NSString *)calcuteDecimalNumberCountWithDoubleValue:(double)value
                                          decimalCount:(int)count {
    if (count != 0) {
        NSString *string = [NSString stringWithFormat:@"%@%@f",@"%",[NSString stringWithFormat:@".%d", count]];
        NSString *result = [NSString stringWithFormat:string, value];
        return result;
    }
    return [NSString stringWithFormat:@"%.15f", value];
}

//获取手机物理ip
+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self deviceIPAdress];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSString *)createUUID {
    CFUUIDRef  uuidObj = CFUUIDCreate(nil);
    NSString  *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

+ (UIViewController *)getViewControllerWithView:(UIView *)view {
    if(view==nil) return nil;
    while (1) {
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)view.nextResponder;
            break;
        }
        if(view==nil) return nil;
        view = view.superview;
    }
}


#pragma mark -- private Method
+ (NSDictionary *)deviceIPAdress{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


+ (NSString *)machine {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}




//获取当前视图控制器
+(UIViewController *)getCurrentViewController{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // modal展现方式的底层视图不同
    // 取到第一层时，取到的是UITransitionView，通过这个view拿不到控制器
    UIView *firstView = [keyWindow.subviews firstObject];
    UIView *secondView = [firstView.subviews firstObject];
    
    UIViewController *vc = [CUTool getViewControllerWithView:secondView];
    
    //    UIViewController *vc = secondView.parentController;
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
    return nil;
    
}


/**
 *  在竖直方向上使子视图对齐父视图的竖向中心
 *
 *  @param sonView    子视图
 *  @param parentView 父视图
 *  @param isAlign    在水平方向上是否也需要对齐父视图的水平中心点
 */
+(void)alignVerticalSonView:(UIView*)sonView toParentView:(UIView *)parentView alignHorizontal:(BOOL)isAlign{
    
    CGPoint tempCentre = sonView.center;
    
    tempCentre.y = CGPointMake(parentView.frame.size.width/2.0, parentView.frame.size.height/2.0).y;
    
    if (isAlign) {
        
        tempCentre.x = CGPointMake(parentView.frame.size.width/2.0, parentView.frame.size.height/2.0).x;;
        
    }
    sonView.center = tempCentre;
    
}
/**
 *  竖直方向上对齐两个视图
 *
 *  @param baseView   对其的基准视图
 *  @param targetView 需要对其的视图
 */
+(void)alignVerticalToBaseView:(UIView*)baseView targetView:(UIView *)targetView{
    CGPoint tempCentre = targetView.center;
    tempCentre.y = baseView.center.y;
    targetView.center = tempCentre;
}

/**
 *  水平方向上对齐两个视图
 *
 *  @param baseView   对其的基准视图
 *  @param targetView 需要对其的视图
 */
+(void)alignHorizontalToBaseView:(UIView*)baseView targetView:(UIView *)targetView{
    CGPoint tempCentre = targetView.center;
    tempCentre.x = baseView.center.x;
    targetView.center = tempCentre;
}

/**
 *  在竖直方向上使子视图对齐父视图的水平中心
 *
 *  @param sonView    子视图
 *  @param parentView 父视图
 */
+(void)alignHorizontalSonView:(UIView*)sonView toParentView:(UIView *)parentView{
    
    CGFloat offsetx = parentView.frame.size.width - sonView.frame.size.width;
    
    CGRect frame = sonView.frame;
    
    frame.origin.x = offsetx/2.0;
    
    sonView.frame = frame;
    
}


/**
 *  根据时间戳返回天数小时及分钟数
 *
 *  @param time 时间
 *
 *  @return 返回已经拼接好的字符串
 */
+(NSMutableAttributedString *)timeStringWithSeconds:(long long)time {
    NSInteger day = time / 60 / 60 / 24;
    long hour = time / 60 / 60 % 24;
    long minute = time / 60 % 60;
    long second = time % 60;
    NSMutableAttributedString *dayString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", day]];
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld", hour]];
    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld", minute]];
    NSMutableAttributedString *secondString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld", second]];
    [dayString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, dayString.length)];
    [hourString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, hourString.length)];
    [minuteString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, minuteString.length)];
    [secondString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, secondString.length)];
    
    NSMutableAttributedString *describtion = [[NSMutableAttributedString alloc] initWithString:@""];
    
    [describtion appendAttributedString:dayString];
    [describtion appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" 天: "]];
    
    [describtion appendAttributedString:hourString];
    [describtion appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@":"]];
    
    [describtion appendAttributedString:minuteString];
    [describtion appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@":"]];
    
    [describtion appendAttributedString:secondString];
    
    return describtion;
}



/**
 *  判断是否需要更新当前app
 *
 *  @param appVersion      目前安装的app版本号
 *  @param appStoreVersion app store 最新的版本
 *
 *  @return 是否需要去更新
 */
+(BOOL)needUpdateAppLocationVersion:(NSString *)appVersion appStoreVersion:(NSString *)appStoreVersion{
    
    BOOL needUpdate = NO;
    NSString * comStr = @".";
    
    NSArray * preArr = [appVersion componentsSeparatedByString:comStr];
    
    NSArray * appArr = [appStoreVersion componentsSeparatedByString:comStr];
    
    if (preArr.count!=appArr.count && preArr.count != 3) {
        needUpdate = NO;
    }
    else{
        
        NSInteger localVersion = [preArr[0] integerValue] * 100 + [preArr[1] integerValue]* 10 + [preArr[2] integerValue];
        
        NSInteger appstVersion = [appArr[0] integerValue] * 100 + [appArr[1] integerValue]* 10 + [appArr[2] integerValue];
        //本机版本为最新版本,不需要更新
        if (localVersion >= appstVersion) {
            needUpdate = NO;
        }
        //本机版本不是最新版本,需要更新
        else{
            
            needUpdate = YES;
        }
    }
    return needUpdate;
}




+(long long)getTimeTampWithString:(NSString *)timeTampString{
    
    if(![@"0" isEqualToString:timeTampString])
    {
        timeTampString=timeTampString;
    }
    if (!timeTampString) {
        return 0;
    }
    else{
        long long timeTamp = 0;
        //现在时间到1970的时间差
        NSTimeInterval nowTamp = [[NSDate date] timeIntervalSince1970];
        //目标时间到1970的时间差
        NSTimeInterval targetTamp = [timeTampString doubleValue]/1000.0;
        //剩余的时间
        timeTamp = targetTamp - nowTamp;
        
        return timeTamp;
    }
}

+(UIColor *)getColorWithRed:(CGFloat)redValue greenColor:(CGFloat)greenValue blueColor:(CGFloat)blueValue{
    return [CUTool getColorWithRed:redValue greenColor:greenValue blueColor:blueValue alpha:1.f];
}

#pragma mark -获取当前的最前端的window
+(UIColor *)getColorWithRed:(CGFloat)redValue greenColor:(CGFloat)greenValue blueColor:(CGFloat)blueValue alpha:(CGFloat)alp{
    CGFloat R = redValue/255.0;
    CGFloat G = greenValue/255.0;
    CGFloat B = blueValue/255.0;
    UIColor * color = [UIColor colorWithDisplayP3Red:R green:G blue:B alpha:alp];
    return color;
}

#pragma mark -获取当前的最前端的window
+(UIWindow *)getCurrentWindow{
    UIWindow * window;
    for(UIWindow * tempWindow in [UIApplication sharedApplication].windows){
        if([tempWindow isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]){
            window = tempWindow;
        }else{
            window = tempWindow;
        }
    }
    return window;
}


+(BOOL)canEnterLibrary{
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    
    BOOL canAccess = NO;
    
    switch (author) {
        case PHAuthorizationStatusNotDetermined:
            break;
        case PHAuthorizationStatusRestricted:
            break;
        case PHAuthorizationStatusDenied:
            canAccess = NO;
            break;
        case PHAuthorizationStatusAuthorized:
            canAccess = YES;
            break;
        default:
            break;
    }
    return canAccess;
}

+(BOOL)CanConnectTheInterNet{
    
    Reachability * reachablity = [Reachability reachabilityForInternetConnection];
    BOOL isReach = NO;
    if (reachablity) {
        switch ([reachablity currentReachabilityStatus]) {
            case NotReachable:
                isReach = NO;
                break;
            case ReachableViaWiFi:
            case ReachableViaWWAN:
                isReach = YES;
                break;
            default:
                break;
        }
    }
    
    return isReach;
}


+ (UIColor *)getColorWithColorType:(NSInteger)colorType{

    return [CUTool getColorWithColorType:colorType alph:1];

}


+ (UIColor *)getColorWithColorType:(NSInteger)colorType alph:(CGFloat)alp{
    
    CGFloat red;
    CGFloat gre;
    CGFloat blu;
    
    switch (colorType) {
            
        case 410://项目主调色
            red = 243.f;
            gre = 100.f;
            blu = 44.f;
            break;
        case 411://项目主调色
            red = 230.f;
            gre = 120.f;
            blu = 44.f;
            break;
        case 412://项目主调色
            red = 243.f;
            gre = 140.f;
            blu = 44.f;
            break;
        case 413://项目主调色
            red = 243.f;
            gre = 160.f;
            blu = 44.f;
            break;
        case 414://项目主调色
            red = 243.f;
            gre = 180.f;
            blu = 44.f;
            break;
        case 415://项目主调色
            red = 243.f;
            gre = 200.f;
            blu = 44.f;
            break;
        case 416://项目主调色
            red = 243.f;
            gre = 220.f;
            blu = 44.f;
            break;
        case 417://项目主调色
            red = 243.f;
            gre = 240.f;
            blu = 44.f;
            break;
            
        default:
            red = 255.f;
            gre = 255.f;
            blu = 255.f;
            break;
    }
    
    return [UIColor colorWithRed:red/255.f green:gre/255.f blue:blu/255.f alpha:alp];
    
}

+(UIFont *)getFont:(CGFloat)font{
    return [CUTool getFont:font isBold:NO];
}

+(UIFont *)getFont:(CGFloat)font isBold:(BOOL)isBold{
    
    UIFont * fontNormal = [UIFont systemFontOfSize:font];
    if (isBold) {
        fontNormal = [UIFont boldSystemFontOfSize:font];
        
    }else{
        fontNormal = [UIFont systemFontOfSize:font];
        
    }
    return fontNormal;
}


+ (UIImage *)addText:(NSString *)text toImage:(UIImage *)image font:(UIFont *)font color:(UIColor *)color
{

    CGSize imageSize = image.size;
    UIGraphicsBeginImageContextWithOptions (imageSize, NO , 0.0 );
    [image drawAtPoint : CGPointMake(0,0)];
    
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextDrawPath (context, kCGPathStroke);
    
    CGSize size = [CUTool autoSizeWithString:text font:font width:imageSize.width height:imageSize.height];
    CGRect rect = CGRectMake((imageSize.width - size.width)/2.f, (imageSize.height - size.height)/2.f, size.width, size.height);
    
    //画文字
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName :color}];
    
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
    




}


@end





