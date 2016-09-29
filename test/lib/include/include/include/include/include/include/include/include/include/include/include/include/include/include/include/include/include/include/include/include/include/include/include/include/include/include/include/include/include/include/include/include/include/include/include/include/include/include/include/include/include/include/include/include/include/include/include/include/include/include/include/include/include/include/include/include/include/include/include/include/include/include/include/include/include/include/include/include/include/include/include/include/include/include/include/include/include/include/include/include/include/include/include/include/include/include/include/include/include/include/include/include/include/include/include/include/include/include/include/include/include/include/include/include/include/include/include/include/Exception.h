//
//  Exception.h
//  Fusion
//
//  Created by 苏子瞻 on 16/6/18.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kReaderException @"kReaderException"
#define kAPDUException @"kAPDUException"

@interface Exception : NSException

+ (void)raiseExceptionName:(NSString *)name reaseon:(NSString *)reason userInfo:(NSDictionary *)userInfo;

@end
