//
//  hexString+byte.h
//  des demo
//
//  Created by 苏子瞻 on 16/5/6.
//  Copyright © 2016年 susizhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hexStringTool : NSObject

+(NSString*)stringWithHexBytes2:(NSData *)sender;

//将GB2312编码串转成字符串
+(NSString *)ansiToString:(NSString *)string;
//将十六进制字符串转换成NSData
+(NSData *)convertHexStrToData:(NSString *)str;

//NSData转换成十六进制的字符串
+(NSString *)convertDataToHexStr:(NSData *)data;

/*
 将16进制数据转化成字节数组(NSData)
 */
+(NSData*) hexStringToBytes:(NSString *)string;
/*
 int转成两个长度的16进制字符串
 */
+(NSString*) to2WidthHexstringWithIntData:(int)data;

//int转成4个长度的16进制字符串
+(NSString*) to4WidthHexstringWithIntData:(int)data;
//NSData转成8个长度的16进制字符串
+(NSString*) to8WidthHexstringWithIntData:(int)data;
/**
 将16进制数据转化成字节数组(NSData)
 */
+(NSString *) bytesToHexString:(Byte *) bytes length:(NSUInteger)length;
/**
 16 进制字符串进行异或操作
 */
+(NSString *)hexStringToXor:(NSString *)hexStr1 andWith:(NSString *)hexStr2;
/**
 拼接字符粗并转大写
 */
+(NSString *) toStringWithChar:(char *)c andWithLength:(int) length;
@end
