//
//  WXTool.h
//  ComeHelpMe
//
//  Created by Vison on 15-2-27.
//  Copyright (c) 2015年 zxkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//  金额计算方式
typedef enum {
    Adding,
    Subtracting,
    Multiplying,
    Dividing,
}calucateWay;

@interface CUTool : NSObject

#pragma mark - 货币计算

/**
 *  计算金钱
 *
 *  @param money 参数
 *
 *  @return 返回值（只舍不入，保留小数点2位有效数字）
 */
+ (NSString *)calculateMoney:(NSString *)money;

/**
 *  货币计算
 *
 *  @param originValue1 参数1
 *  @param originValue2 参数2
 *  @param calucateWay  计算方法（＋ － ＊ ／）
 *
 *  @return 返回值（只舍不入，保留小数点2位有效数字）
 */
#pragma mark - 货币计算（只舍不入，保留小数点2位有效数字)

+ (NSString *)decimalNumberCalucate:(NSString *)originValue1 originValue2:(NSString *)originValue2 calucateWay:(calucateWay)calucateWay;

/**
 *  获取随机整型值
 *
 *  @param minNum 最小限制值
 *  @param maxNum 最大上限值
 *
 *  @return 一个随机整型值
 */
+(NSInteger)randomIntegerWithMinNum:(NSInteger)minNum andMaxNum:(NSInteger)maxNum;

#pragma mark - 字符串
///**
// *  传入一个字符串，返回它的全部大写字符串（如果有中文，将中文变为大写拼音)
// *
// *  @param string 参数
// *
// *  @return 返回值
// */
//+ (NSString *)convertStringToCapical:(NSString *)string;



#pragma mark - 获取对应字体文字的自适应高度

/**
 *  根据内容获取UILabel的高度
 *
 *  @param text  文本
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 返回值
 */
+ (CGFloat)obtainLabelHeightWithString:(NSString *)text
                                  font:(UIFont *)font
                                 width:(CGFloat)width;


/**
 *  根据内容获取NSAttributeString的高度
 *
 *  @param text  参数
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 返回值
 */
+ (CGFloat)obtainLabelHeightWithAttributeString:(NSAttributedString *)text
                                           font:(UIFont *)font
                                          width:(CGFloat)width;

#pragma mark - 获取对应字体文字的size

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
                        font:(UIFont*)font
                       width:(CGFloat)width;

+ (CGSize)autoSizeWithString:(NSString *)text
                        font:(UIFont *)font
                       width:(CGFloat)width
                      height:(CGFloat)height;
#pragma mark - 字符串转化为Json

+ (id)dictionaryWithJsonString:(NSString *)jsonString;

#pragma mark - MD5加密
/**
 *  md5加密
 *
 *  @param input 参数
 *
 *  @return 返回值
 */
+ (NSString *)md5HexDigest:(NSString *)input;


//Jay
+ (NSString *)MD5StringFromString:(NSString *)str;

#pragma mark - 字符串转化为Json
/**
 *   data转换为 Json
 */
+ (id)makeJsonToData:(NSData *)jsonData;


#pragma mark - 验证数字，手机号码，银行卡，身份证，全部汉字

/**
 *  判断是否全为数字
 */
+(BOOL)isNumber:(NSString *)numStr;
/**
 *  判断手机号
 */
+ (BOOL)checkPhoneNumInput:(NSString *)phoneNumString;

/**
 *  验证银行卡号
 */
+ (BOOL)checkCardNo:(NSString *)cardNo;

/**
 *  验证身份证号
 */
+ (BOOL)validateIdentityCard:(NSString *)value;

/**
 *  验证字符串全部为汉字
 */
+ (BOOL)validateChinese:(NSString *)value;

/**
 *  判断字符串是否符合长度
 *
 *  @param string 字符串
 *  @param start  开始长度
 *  @param end    结束长度
 *
 *  @return bool
 */
+ (BOOL)isValidateString:(NSString *)string
                   start:(NSInteger)start
                     end:(NSInteger)end;


/**
 *  对象是否为nil | NULL | @""
 *
 *  @param object 对象
 */
+ (BOOL)isEmpty:(id)object;


/**
 *  判断价格格式是否正确
 *
 *  @param price 价格
 *
 */
+ (BOOL)isPrice:(NSString *)price;



#pragma mark - 时间/距离／年龄计算

/**
 *  现在到之前一个时间点的时间差
 *
 *  @param timeStamp 时间戳
 *
 *  @return 返回值
 */
+ (NSString *)getTimeFormateWithTimeStamp:(NSString *)timeStamp;

/**
 *  未来到现在一个时间点的时间差（如：1分钟后、1小时后、1天后...）
 *
 *  @param timestamp 时间戳
 *
 *  @return 返回值
 */
+ (NSString *)getTimeFromFutureToNowWithTimestamp:(NSString *)timestamp;


/**
 *  时间戳转换为标准时间
 *
 *  @param timeStamp 时间戳
 *  @param formatter 格式(如：yyyy-MM-dd HH:mm:ss)
 *
 *  @return 返回值
 */
+ (NSString *)getStandardDateWithTimeStamp:(NSString *)timeStamp
                                 formatter:(NSString *)formatter;


/**
 *  判读时间是今天，昨天还是明天
 *
 *  @param date 日期
 *
 *  @return 返回值
 */
+ (NSString *)compareDate:(NSDate *)date;

/**
 *  根据生日计算年龄
 *
 *  @param birthday 生日(格式：yyyy-MM-dd)
 *
 *  @return 返回值
 */
+ (int)calcuteAgeWithBirthday:(NSString *)birthday;


/**
 *  距离转换
 *
 *  @param meters 距离（单位：米）
 *
 *  @return 返回值
 */
+ (NSString *)getDistanceWithMeters:(NSString *)meters;

/**
 *  保留小数点
 *
 *  @param value double小数
 *  @param count 小数位，默认为15
 *
 *  @return 字符串
 */
+ (NSString *)calcuteDecimalNumberCountWithDoubleValue:(double)value
                                          decimalCount:(int)count;


#pragma mark - 获取本机信息，物理IP地址/UUID/设备型号
/**
 *  获取本机ip地址
 *
 *  @return 返回值
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

/**
 *  获取uuid
 */
+ (NSString *)createUUID;

/**
 *  机型
 */
+ (NSString *)machine;


#pragma mark - 获取视图控制器
/**
 *  获取一个view所在的控制器
 *
 *  @param view 当前视图
 *
 *  @return 返回值
 */
+ (UIViewController *)getViewControllerWithView:(UIView *)view;



/**
 *  获取当前窗口显示的视图控制器
 *
 *  @return 当前视图控制器
 */
+(UIViewController *)getCurrentViewController;

#pragma mark - 布局对其两个视图的水平或者竖向
/**
 *  子视图中心竖向对其父视图
 *
 *  @param sonView    子视图
 *  @param parentView 父视图
 *  @param isAlign    是否需要中心水平对齐
 */
+(void)alignVerticalSonView:(UIView*)sonView toParentView:(UIView *)parentView alignHorizontal:(BOOL)isAlign;

/**
 *  竖直方向上对齐两个视图
 *
 *  @param baseView   对其的基准视图
 *  @param targetView 需要对其的视图
 */
+(void)alignVerticalToBaseView:(UIView*)baseView targetView:(UIView *)targetView;

/**
 *  水平方向上对齐两个视图
 *
 *  @param baseView   对其的基准视图
 *  @param targetView 需要对其的视图
 */
+(void)alignHorizontalToBaseView:(UIView*)baseView targetView:(UIView *)targetView;


/**
 *  水平方向上将子视图对其父视图,竖向方向坐标不变
 *
 *  @param sonView   需要改变的子视图
 *  @param parentView 需要对齐的父视图
 */
+(void)alignHorizontalSonView:(UIView*)sonView toParentView:(UIView *)parentView;




/**
 *  根据时间戳返回天数小时及分钟数
 *
 *  @param time 时间
 *
 *  @return 返回已经拼接好的字符串
 */
+(NSMutableAttributedString *)timeStringWithSeconds:(long long)time;


/**
 *  判断是否需要更新当前app
 *
 *  @param appVersion      目前安装的app版本号
 *  @param appStoreVersion app store 最新的版本
 *
 *  @return 是否需要去更新
 */
#pragma mark - app 是否需要更新

+(BOOL)needUpdateAppLocationVersion:(NSString *)appVersion appStoreVersion:(NSString *)appStoreVersion;

#pragma mark - 传入时间和当前时间的时间差
/**
 *  根据传入的时间返回改时间和目前时间的时间差
 *
 *  @param timeTampString 目标时间
 *
 *  @return 目标时间和现在时间的时间差
 */
+(long long)getTimeTampWithString:(NSString *)timeTampString;



+(UIColor *)getColorWithRed:(CGFloat)redValue greenColor:(CGFloat)greenValue blueColor:(CGFloat)blueValue;

+(UIColor *)getColorWithRed:(CGFloat)redValue greenColor:(CGFloat)greenValue blueColor:(CGFloat)blueValue alpha:(CGFloat)alp;

#pragma mark -获取当前的最前端的window
+(UIWindow *)getCurrentWindow;


+(BOOL)canEnterLibrary;//是否能够进入相册;

//网络连接是否可用
+(BOOL)CanConnectTheInterNet;




@end
