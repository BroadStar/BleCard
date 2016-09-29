//
//  NotiLable.m
//  Fusion
//
//  Created by 苏子瞻 on 16/6/21.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#import "NotiLable.h"

@implementation NotiLable

-(void)setRadius:(CGFloat)radius
{
    [self.layer setCornerRadius:radius];
    self.layer.masksToBounds = YES;
}

-(void)setRect:(CGRect)rect
{
    
    self.edgeInsets = UIEdgeInsetsMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}


@end
