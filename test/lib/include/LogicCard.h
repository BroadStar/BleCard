//
//  原DualInterface4442.h
//  Fusion
//
//  Created by 苏子瞻 on 16/6/15.
//  Modified by fengmlo on 16/9/29.
//  Copyright © 2016年 suzizhan. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "BleReader.h"
@interface LogicCard : NSObject
@property (nonatomic, strong) BleReader *reader;

-(instancetype)initWith:(BleReader *)reader;

-(NSData *)readBlock:(int)address andWith:(int)length;
-(void)writeBlock:(int)address andWith:(int)length andWith:(Byte[])data;
-(void)checkPW:(NSData *) password;
-(void)changePW:(NSData *) password;

@end
