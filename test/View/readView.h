//
//  readView.h
//  Fusion
//
//  Created by 苏子瞻 on 16/6/6.
//  Copyright © 2016年 suzizhan. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^ChargeMoneyBlock)(NSString *money);

@protocol ChargeButtonClickDelegate <NSObject>

-(void)ChargeButtonClick;

@end

@interface readView : UIView
+(instancetype)loadView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dirviceHeight;

@property (nonatomic, weak) id<ChargeButtonClickDelegate> chargeButtonClickDelegate;

@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;


-(void)getChargeMoney:(NSString *)money;

@end
