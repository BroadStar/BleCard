//
//  NotiLable.h
//  Fusion
//
//  Created by 苏子瞻 on 16/6/21.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizedPaddingLabel.h"
IB_DESIGNABLE
@interface NotiLable : CustomizedPaddingLabel
@property (nonatomic, assign) IBInspectable CGFloat radius;
@property (nonatomic, assign) IBInspectable CGRect  rect;

@end
