//
//  CardController.m
//  Fusion
//
//  Created by 苏子瞻 on 16/6/5.
//  Copyright © 2016年 suzizhan. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "CardController.h"
#import "readView.h"
#import "MJRefresh.h"
#import "UIBarButtonItem+Item.h"
#import "ServiceManager.h"
#import "deviceView.h"


@interface CardController ()<ChargeButtonClickDelegate>
@property (nonatomic, strong) MJRefreshNormalHeader *header;
@property (nonatomic, weak) readView *readview;
@property (nonatomic, copy) NSString *money;
@end


@implementation CardController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qppSelOnePeripheralRsp) name : qppSelOnePeripheralNoti object:nil];
    self.title = @"读卡充值";
    [self setupUI];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI
{
    [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backImage"]]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    self.readview = [readView loadView];
    self.readview.chargeButtonClickDelegate = self;
    self.readview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [scrollView addSubview:self.readview];
 
   self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [[NSNotificationCenter defaultCenter] postNotificationName:blePeriWillDiscovereNoti object:nil userInfo:nil];
    }];
    // Hide the time
    self.header.lastUpdatedTimeLabel.hidden = YES;
    // Hide the status
    self.header.stateLabel.hidden = YES;

    scrollView.mj_header = self.header;
}

-(void)qppSelOnePeripheralRsp
{
    [self.header endRefreshing];
}

-(void)ChargeButtonClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"充值" message:@"输入充值金额" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"100";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    __weak typeof(self) weakself = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *moneyTextField = alertController.textFields.firstObject;
        [weakself.readview getChargeMoney:moneyTextField.text];
        

    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:sureAction];
    [alertController addAction:cancleAction];
 
    [self presentViewController:alertController animated:YES completion:nil];

    
}


@end
