//
//  CardController.h
//  Fusion
//
//  Created by 苏子瞻 on 16/6/5.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChargeMoneyBlock)(NSString *money);

@interface CardController : UIViewController

@property (nonatomic, copy)  ChargeMoneyBlock chargeMoneyBlock;

-(void)setBlock:(ChargeMoneyBlock)chargeMoneyBlock;
@end
