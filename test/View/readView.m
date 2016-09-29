//
//  readView.m
//  Fusion
//
//  Created by 苏子瞻 on 16/6/6.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#import "readView.h"
#import "readBackView.h"
#import "ServiceManager.h"
#import "BleReader.h"
#import "CardOperation.h"
#import "LogicCardOperation.h"
#import "UserBean.h"
#import "deviceView.h"
#import "NotiLable.h"
#import "Cons.h"
#import "SVProgressHUD.h"



@interface readView ()<ServiceManagerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devViewHieght;

@property (nonatomic, weak) BleReader *reader;
@property (nonatomic, strong) CardOperation *card;
@property (nonatomic, weak) ServiceManager *serviceManager;
@property (nonatomic, strong) UserBean *userBean;
@property (nonatomic, copy) NSString *chargeMoney;
@property (nonatomic, assign) int delay;


@property (weak, nonatomic) IBOutlet deviceView *deviceView;
@property (weak, nonatomic) IBOutlet readBackView *readView;

@property (weak, nonatomic) IBOutlet NotiLable *notiLable;


@property (weak, nonatomic) IBOutlet UILabel *remaind;

@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end


@implementation readView
+(instancetype)loadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"readView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib
{

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qppSelOnePeripheralRsp) name : qppSelOnePeripheralNoti object:nil];
    self.serviceManager = [ServiceManager sharedInstance];
    self.serviceManager.serviceManagerDelegate = self;
    self.reader = [BleReader sharedInstance];
}


-(void)qppSelOnePeripheralRsp
{
    self.devViewHieght.constant = 60;
    
    self.deviceView.hidden = YES;
    self.notiLable.hidden = NO;
    
    self.notiLable.text = @"正在连接卡片";
   
}



-(void)readData
{
    @try {
        self.reader.cardType = CARD_TYPE_4442;
        int cardType = [CardOperation identifyCard:self.reader];
        if (cardType == LOGIC_CARD) {
            self.card = [[LogicCardOperation alloc] initWith:self.reader];
        }
        self.userBean = [_card getUserBean];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    if (self.userBean == nil) {
        [SVProgressHUD showWithStatus:@"获取信息失败"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }

//    [self.netUtil signIn];
    
}


- (IBAction)Charge:(id)sender {
    
    NSLog(@"remaind ====%@",self.remaind.text);
    
    if ([self.remaind.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先读卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if (![self.remaind.text isEqualToString:@"￥0.00"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请将上次充值如表" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else
    {
        if (self.chargeButtonClickDelegate) {
            
            [self.chargeButtonClickDelegate ChargeButtonClick];
        }

    
    }
    

}

-(void)getChargeMoney:(NSString *)money
{
    NSLog(@"充值金额为%@",money);
    self.chargeMoney = money;
    
    
    
}
-(void)onServiceInited:(BOOL)isSuccess
{
    if (isSuccess) {
        self.notiLable.text = @"卡片已连接";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.notiLable.text = @"正在读卡";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self readData];
            });
            
        });
    }

    
    


}

-(void)onDeviceConnected
{
    
    NSLog(@"onDeviceConnected");
}

-(void)onDeviceDisconnected
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.notiLable.text = @"卡片已断开";
    });
    
}




#pragma mark - NetDelegate


-(void)singInResult:(BOOL)result
{
//    NSLog(@"签到结果为:%id",result);
}

-(void)chargeResult:(BOOL)result
{
//    NSLog(@"充值许可结果为:%id",result);
    
    [SVProgressHUD showWithStatus:@"正在充值"];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        if (result) {
            BOOL chargeResult = [self.card charge:[self.chargeMoney intValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if (chargeResult) {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"充值" message:@"充值成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    
                    [alert show];
                    
                    
                }
            });
        }else
        {
            [SVProgressHUD showWithStatus:@"充值请求失败"];
        }

    });
}

-(void)getUesrBeanFormNet:(UserBean *)userbean
{
    if (self.reader.cardType == CARD_TYPE_4442) {
        self.delay = 5;
    }else
    {
        self.delay = 0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.notiLable.text  = @"读卡成功";
        //    NSString *str = [NSString stringWithFormat:@"%d",self.userBean.balance];
        //    long int a = strtoul([str UTF8String], nil, 16);
        self.remaind.text = [NSString stringWithFormat:@"￥%d.00",self.userBean.balance];
        self.count.text = [NSString stringWithFormat:@"共%d次",self.userBean.record];
        self.number.text = self.userBean.ID;
        self.name.text = self.userBean.name;
        self.address.text = self.userBean.address;
    });
}
-(void)dealloc
{
    [self.serviceManager peripheralDisconnect];
    self.serviceManager.deviceArray = nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertView.hidden = YES;
    
    if ([alertView.title  isEqual: @"充值"]) {
        [SVProgressHUD showWithStatus:@"正在刷新"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
             [self readData];
            
        });
        if (self.reader.cardType == CARD_TYPE_4442) {
            self.delay = 5;
        }else
        {
            self.delay = 3;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }
    
}

@end
