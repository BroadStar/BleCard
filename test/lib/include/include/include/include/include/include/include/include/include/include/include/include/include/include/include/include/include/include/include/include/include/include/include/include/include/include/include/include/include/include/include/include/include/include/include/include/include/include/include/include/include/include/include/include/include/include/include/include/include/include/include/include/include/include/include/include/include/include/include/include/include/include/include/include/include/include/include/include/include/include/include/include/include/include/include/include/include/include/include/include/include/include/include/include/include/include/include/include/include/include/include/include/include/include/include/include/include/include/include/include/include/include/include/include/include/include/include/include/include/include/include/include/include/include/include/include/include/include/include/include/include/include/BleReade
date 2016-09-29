//
//  BleReader.h
//  des demo
//
//  Created by 苏子瞻 on 16/5/18.
//  Copyright © 2016年 susizhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataWriteDeldgate <NSObject>

-(void)dataWrite:(NSData *)data;

@end

@interface BleReader : NSObject

extern const int CARD_TYPE_4442;
extern const int CARD_TYPE_CPU;
@property (nonatomic, assign) long mTimeOut;
@property (nonatomic, assign) int cardType;
@property (nonatomic, weak) id<DataWriteDeldgate> writeDelegate;

//-(void)BleReader:(QppService *)qppService;

-(void)reset;

-(NSData *)transmit:(NSData *)data;
-(void)onCharacteristicWrite;
-(void)onCharacteristicNotified:(NSData *)data;
+(BleReader *)sharedInstance;


@end
