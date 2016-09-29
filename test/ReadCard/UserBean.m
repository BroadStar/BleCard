//
//  UserBean.m
//  des demo
//
//  Created by 苏子瞻 on 16/6/12.
//  Copyright © 2016年 susizhan. All rights reserved.
//

#import "UserBean.h"

@implementation UserBean
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)uesrBeanWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
