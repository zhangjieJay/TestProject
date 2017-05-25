//
//  NBParam.h
//  YJAutoProject
//
//  Created by 峥刘 on 17/5/24.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBParam : NSObject

@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (instancetype)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValue;
@end


