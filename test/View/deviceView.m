//
//  deviceBackView.m
//  Fusion
//
//  Created by 苏子瞻 on 16/6/8.
//  Copyright © 2016年 suzizhan. All rights reserved.
//


#import "ServiceManager.h"
#import "deviceView.h"

@interface deviceView ()<UITableViewDataSource,UITableViewDelegate,ReloadDeviceListDelegate>
@property (nonatomic, weak) ServiceManager *serviceManager;
@end

@implementation deviceView

-(void)setRadius:(CGFloat)radius
{
    [self.layer setCornerRadius:radius];
}


-(void)awakeFromNib
{
    self.serviceManager = [ServiceManager sharedInstance];
    self.serviceManager.ReloadDeviceListDelegate = self;
    self.delegate = self;
    self.dataSource = self;
}
-(instancetype)init
{
    if (self == nil) {
        self = [super init];
    }
    self.delegate = self;
    self.dataSource = self;
    return self;
}

#pragma UITableViewDataSource 


/**
 *****************************************************************
 * @brief       device number in the table view.
 *
 * @param[in]  sender   : current sender id.
 *
 * @return :   NSInteger : number of rows in the table
 *****************************************************************
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //    NSLog(@"%s ", __func__);
    
    return self.serviceManager.deviceArray.count;

//    return 1;
}

/**
 *****************************************************************
 * @brief
 * // Row display. Implementers should *always* try to reuse cells by setting each cell's
 *    reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
 * // Cell gets various attributes set automatically based on table (separators) and data
 *    source (accessory views, editing controls)
 *
 * @param[in]  indexPath   : index of the row.
 *
 * @return :   returns nil if cell is not visible or index path is out of range
 *****************************************************************
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.serviceManager.deviceArray== nil)
    {
        NSLog(@"cell:nil \n");
        return cell;
    }
    
    NSArray *peripherals = self.serviceManager.deviceArray;
    
    
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    cell.textLabel.text = [peripheral name];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

/**
 *****************************************************************
 * @brief      // Called after the user changes the selection.
 *
 * @return :   none
 *****************************************************************
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *peripherals = self.serviceManager.deviceArray;
    
    // protect code
    uint8_t perIndex = indexPath.row;
    
    if (perIndex > [peripherals count]){
        perIndex = [peripherals count];
    };
    
    // CBPeripheral *peripheral
    CBPeripheral *selectedPeri = [peripherals objectAtIndex:perIndex /*indexPath.row*/];
    
//    NSDictionary *dictPeri = [NSDictionary dictionaryWithObject : selectedPeri forKey:keyQppSelectPeri];
    [[NSNotificationCenter defaultCenter] postNotificationName: qppSelOnePeripheralNoti object:nil];

//        NSLog(@"selectedPeri======%ld",(long)selectedPeri.state);
    [self.serviceManager qppSelOnePeripheralRsp:selectedPeri];
//    if (selectedPeri.state == 0) {
//        [dev pubConnectPeripheral : selectedPeri];
//    }
//    [dev pubConnectPeripheral : selectedPeri];
    

}

- (void)endRefresh
{
    
}

-(void) updatePeriInTableView:(UIRefreshControl *)refreshControl
{
    
    [refreshControl beginRefreshing];
    
    [self reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
    //[self performSelector:@selector(endRefresh:) withObject:refreshControl afterDelay:1.0f];
}

-(void)reloadDeviceList
{
    [self reloadData];
}


@end
