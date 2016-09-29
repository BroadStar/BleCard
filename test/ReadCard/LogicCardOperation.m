//
//  原LogicCard.m
//  Fusion
//
//  Created by 苏子瞻 on 16/6/15.
//  Modified by fengmlo on 16/9/29.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#import "LogicCardOperation.h"
#import "UserBean.h"
#import "hexString+byte.h"
#import "LogicCard.h"

@interface LogicCardOperation ()
{
    Byte cardData[32];
}

@property (nonatomic, strong) UserBean *userBean;
@property (nonatomic, strong) LogicCard *logicCard;
@end

@implementation LogicCardOperation

-(instancetype)initWith:(BleReader *)reader
{
    if (self = [super init]) {
        self.reader = reader;
        self.logicCard = [[LogicCard alloc] initWith:reader];
    }
    return self;
}


-(UserBean *)getUserBean
{
    @try {
        NSData *data = [self.logicCard readBlock:32 andWith:32];
        NSData *falg = [self .logicCard readBlock:64 andWith:1];
        
        Byte *dataByte = (Byte *)[data bytes];
        Byte *flagbyte = (Byte *)[falg bytes];
        if (dataByte[0] != (Byte) 0x68 && dataByte[1] != (Byte) 0x50) {
            NSLog(@"getUserBean,Card not support");
            return nil;
        }
        for (int i = 0; i < 32; ++i) {
            cardData[i] = dataByte[i];
        }
        NSString *strData = [hexStringTool bytesToHexString:dataByte length:32];
        self.userBean = [[UserBean alloc] init];
        _userBean.ID = [strData substringWithRange:NSMakeRange(6, 10)];
        NSString *recStr = [strData substringWithRange:NSMakeRange(16, 4)];
        long int rec = strtoul([recStr UTF8String], nil, 16);
        _userBean.record = (int)rec;
        NSString *aStr = [strData substringWithRange:NSMakeRange(20, 4)];
        long int a = strtoul([aStr UTF8String], nil, 16);
        _userBean.balance = (int)a;
        if (flagbyte[0] == (Byte) 0x68) {
            _userBean.chargeable = true;
            _userBean.balance = 0;
        }
        return _userBean;
    } @catch (NSException *exception) {
        NSLog(@"NSException ====== %@%@",exception.name,exception.reason);
        return nil;
    } @finally {
        
    }

}

-(BOOL)charge:(int)money
{
    int times = self.userBean.record;
    times++;
    NSString *oriData = [hexStringTool bytesToHexString:cardData length:32];
    NSString *writeData = [NSString stringWithFormat:@"%@%@%@%@",[oriData substringWithRange:NSMakeRange(0, 16)],[hexStringTool to4WidthHexstringWithIntData:times],[hexStringTool to4WidthHexstringWithIntData:money],[oriData substringWithRange:NSMakeRange(24, 24)]];
    short s = ([self getSum:[hexStringTool hexStringToBytes:writeData] andWith:1 andWith:23] & 0xff);
    
    NSString *sumStr = [hexStringTool to2WidthHexstringWithIntData:s];
    writeData = [writeData stringByAppendingFormat:@"%@%@",sumStr,[oriData substringFromIndex:50]];
    @try {
        [self.logicCard checkPW:[hexStringTool hexStringToBytes:@"69328E"]];
        [self.logicCard writeBlock:32 andWith:32 andWith:(Byte *)[[hexStringTool hexStringToBytes:writeData] bytes]];
        Byte byte[64];
        [self.logicCard writeBlock:64 andWith:64 andWith:byte];
    } @catch (NSException *exception) {
        return  NO;
    } @finally {
        
    }
    return true;
}

-(short)getSum:(NSData *)data andWith:(int)offset andWith:(int)length
{
    short sum = 0;
    Byte *dataByte = (Byte *)[data bytes];
    for (int i = 0; i < length; ++i) {
        sum += dataByte[offset + i];
    }
    return sum;
}
@end
