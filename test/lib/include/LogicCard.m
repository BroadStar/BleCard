//
//  DualInterface4442.m
//  Fusion
//
//  Created by 苏子瞻 on 16/6/15.
//  Modified by fengmlo on 16/9/29.
//  Copyright © 2016年 suzizhan. All rights reserved.
//
#define MAX_LENGTH 256
#define PROTECTED_BLOCK_LENGTH 32
#define SECURE_BLOCK_LENGTH  4


#import "LogicCard.h"
#import "Exception.h"
#import "hexString+byte.h"

@interface LogicCard ()

@end

@implementation LogicCard

-(instancetype)initWith:(BleReader *)reader
{
    if (self = [super init]) {
        self.reader  = reader;
    }
    return self;
}

-(NSData *)readBlock:(int)address andWith:(int)length
{
    if ((address<0) || (length<1) || (address + length > MAX_LENGTH)) {
        NSLog(@"参数错误");
    }
    Byte apdu[] = {0x00, 0x30, 0x00, 0x00, 0x00};
    apdu[3] = (Byte) address;
    apdu[4] = (Byte) length;
    return [self transmitAndGetFinalResult:[NSData dataWithBytes:apdu length:5]];
}

-(void)writeBlock:(int)address andWith:(int)length andWith:(Byte[])data
{
    if ((address<0) || (length<1) || (address + length > MAX_LENGTH)) {
        NSLog(@"参数错误");
    }
    Byte apdu[length + 5];
    apdu[0] = 0x00;
    apdu[1] = 0x38;
    apdu[2] = 0x00;
    apdu[3] = (Byte) address;
    apdu[4] = (Byte) length;
    for (int i = 0; i < length; ++i) {
        apdu[i + 5] = data[i];
    }
    NSData *apduData = [NSData dataWithBytes:apdu length:length + 5];
    [self transmit:apduData];
}

-(void)checkPW:(NSData *) password
{
    if (password.length != 3) {
        NSLog(@"参数错误");
    }
    Byte *passwordByte = (Byte *)[password bytes];
    Byte apdu[5 + 3];
    apdu[0] = 0x00;
    apdu[1] = 0x33;
    apdu[2] = 0x00;
    apdu[3] = 0x00;
    apdu[4] = 0x03;
    for (int i = 0; i < 3; ++i) {
        apdu[i + 5] = passwordByte[i];
    }
    NSData *apduData = [NSData dataWithBytes:apdu length:5 + 3];
    [self transmit:apduData];
}

-(void)changePW:(NSData *) password
{
    if (password.length != 3)
    {
        NSLog(@"参数错误");
    }
    Byte *passwordByte = (Byte *)[password bytes];
    Byte apdu[5 + 3];
    apdu[0] = 0x00;
    apdu[1] = 0x39;
    apdu[2] = 0x00;
    apdu[3] = 0x01;
    apdu[4] = 0x03;
    for (int i = 0; i < 3; ++i) {
        apdu[i + 5] = passwordByte[i];
    }
    NSData *apduData = [NSData dataWithBytes:apdu length:5 + 3];
    [self transmit:apduData];
}

-(NSData *) transmitAndGetFinalResult:(NSData *) apdu
{
    NSData *tmp = [self transmit:apdu];
    Byte *tmpByte = (Byte *)[tmp bytes];
    int resultLen = (int)tmp.length -2;
    Byte resultByte[resultLen];
    for (int i = 0; i < resultLen; ++i) {
        resultByte[i] = tmpByte[i];
    }
    NSData *result = [NSData dataWithBytes:resultByte length:resultLen];
    return result;
}

-(NSData *)transmit:(NSData *) apdu
{
    NSData *result = [[NSData alloc] init];
    @try {
        result = [self.reader transmit:apdu];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    Byte swByte[2];
    if (result.length == 2) {
        swByte[0] = *((Byte *)[result bytes]);
        swByte[1] = *(((Byte *)[result bytes]) + 1);
    }else
    {
        int offset = (int)result.length - 2;
        Byte *resultByte = (Byte *)[result bytes];
        swByte[0] = *(resultByte + offset);
        swByte[1] = *(resultByte + offset + 1);
        
    }
    NSString * reaseon = [self checkSW:swByte];
    if (reaseon != nil) {
        [Exception raiseExceptionName:kAPDUException reaseon:reaseon userInfo:nil];
    }
    return result;
}

-(NSString *)checkSW:(Byte[]) sw
{
    
   	if (sw[0] == (Byte) 0x90 && sw[1] == (Byte) 0x00) {
        return nil;
    } else if (sw[0] == (Byte) 0x67 && sw[1] == (Byte) 0x00) {
        return @"长度错误";
    } else if (sw[0] == (Byte) 0x6E && sw[1] == (Byte) 0x00) {
        return @"CLA类别不支持";
    } else if (sw[0] == (Byte) 0x6A && sw[1] == (Byte) 0x86) {
        return @"错误的参数P1-P2";
    } else if (sw[0] == (Byte) 0x93 && sw[1] == (Byte) 0x03) {
        return @"卡片已报废";
    } else if (sw[0] == (Byte) 0x62 && sw[1] == (Byte) 0x83) {
        return @"存储的数据受保护";
    } else if (sw[0] == (Byte) 0x69 && sw[1] == (Byte) 0x82) {
       return @"未校验密码";
    } else if (sw[0] == (Byte) 0x65 && sw[1] == (Byte) 0x81) {
       return @"存储区错误";
    } else if (sw[0] == (Byte) 0x69 && sw[1] == (Byte) 0x84) {
        return @"与参考数据不一致";
    } else if (sw[0] == (Byte) 0x63 && (sw[1] & (Byte) 0xF0) == (Byte) 0xC0) {
        return [NSString stringWithFormat:@"剩余校验次数%d", (sw[1] & 0x0F)];
    } else {
        return @"未知错误";
    }
}


@end
