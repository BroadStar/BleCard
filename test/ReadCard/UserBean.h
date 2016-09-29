//
//  UserBean.h
//  des demo
//
//  Created by 苏子瞻 on 16/6/12.
//  Copyright © 2016年 susizhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBean : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) int balance;
@property (nonatomic, assign) int record;
@property (nonatomic, assign, getter=isChargeable) BOOL chargeable;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userBeanWithDict:(NSDictionary *)dict;
@end
