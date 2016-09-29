//
//  CardOperation.h
//  Fusion
//
//  Created by 苏子瞻 on 16/6/15.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleReader.h"
#import "UserBean.h"

@interface CardOperation : NSObject
@property (nonatomic, strong) BleReader *reader;

+(int)identifyCard:(BleReader *)reader;

-(UserBean *)getUserBean;
-(BOOL)charge:(int)money;
@end
