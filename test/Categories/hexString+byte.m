//
//  hexString+byte.m
//  des demo
//
//  Created by 苏子瞻 on 16/5/6.
//  Copyright © 2016年 susizhan. All rights reserved.
//

#import "hexString+byte.h"

@implementation hexStringTool


//NSData转成16进制字符串
+ (NSString*)stringWithHexBytes2:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    free(strbuf);
    return hexBytes;
}

//NSData转成两个长度的16进制字符串
+(NSString*) to2WidthHexstringWithIntData:(int)data
{
    int value = data | 0xF00;
    NSString *str = [[self toHexstringWithIntData:value] substringFromIndex:1];
    return  str;

}
//NSData转成4个长度的16进制字符串
+(NSString*) to4WidthHexstringWithIntData:(int)data
{
    int value = data | 0xF0000;
    NSString *str = [[self toHexstringWithIntData:value] substringFromIndex:1];
    return  str;
}
//NSData转成8个长度的16进制字符串
+(NSString*) to8WidthHexstringWithIntData:(int)data
{
    NSString *str = [self toHexstringWithIntData:data];
    NSMutableString *mutableStr = [NSMutableString stringWithString:str];
    while (mutableStr.length < 8) {
        [mutableStr insertString:@"0" atIndex:0];
    }
    str = mutableStr;
    return  str;
}

+(NSString *)toHexstringWithIntData:(int)value
{
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i < 9; i++) {
        ttmpig = value % 16;
        value = value / 16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%d",ttmpig];
        }
        
        str = [nLetterValue stringByAppendingString:str];
        
        if (value == 0) {
            break;
        }
    }
    return str;
}
//将GB2312编码串转成字符串
+(NSString *)ansiToString:(NSString *)string
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self convertHexStrToData:string];
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    return retStr;
}


//将十六进制字符串转换成NSData
+(NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

//NSData转换成十六进制的字符串
+(NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return [string uppercaseString];
}
/**
 字节数组转化16进制数
 */
+(NSString *) bytesToHexString:(Byte *) bytes length:(NSUInteger)length
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (i < length)
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr uppercaseString];
    
}
/*
 将16进制数据转化成字节数组(NSData)
 */
+(NSData*) hexStringToBytes:(NSString *)string
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [string substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

/**
 16 进制字符串进行异或操作
 */
+(NSString *)hexStringToXor:(NSString *)hexStr1 andWith:(NSString *)hexStr2
{
    NSData *data1 = [hexStringTool hexStringToBytes:hexStr1];
    NSData *data2 = [hexStringTool hexStringToBytes:hexStr2];
    Byte *data1Byte = (Byte *)[data1 bytes];
    Byte *data2Byte = (Byte *)[data2 bytes];
    
    Byte resultByte[data1.length];
    
    int i = 0;
    for (i=0; i < [data1 length]; i++) {
        resultByte[i] = data1Byte[i] ^ data2Byte[i];
    }
    
    NSString *tmpStr = [hexStringTool bytesToHexString:resultByte length:data1.length];
    return tmpStr;
}

/**
 拼接字符粗并转大写
 */
+(NSString *) toStringWithChar:(char *)c andWithLength:(int) length
{
    NSMutableString *Str = [[NSMutableString alloc] init];
    for (int i = 0; i < length; ++i) {
       NSString *tempStr = [NSMutableString stringWithFormat:@"%s",c];
        [Str appendString:tempStr];
    }
    NSString *upperStr = Str;
    [upperStr uppercaseString];
    return  upperStr;
}

@end
