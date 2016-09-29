//
//  CardOperation.m
//  Fusion
//
//  Created by 苏子瞻 on 16/6/15.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#import "CardOperation.h"
#import "Cons.h"
#import "hexString+byte.h"

@implementation CardOperation

- (instancetype)init
{
    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector() name:kTransmitFail object:nil];
    }
    return self;
}

+ (int)identifyCard:(BleReader *)reader
{
    [reader reset];
    
    NSData *data = [reader transmit:[hexStringTool hexStringToBytes:@"0031000004"]];
    
    Byte *byte = (Byte *)[data bytes];
    if (byte[0] == 7) {
        return LOGIC_CARD;
    }
    
    return CPU_CARD;
}


@end
