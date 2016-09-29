//
//  serviceManager.h
//  des demo
//
//  Created by 苏子瞻 on 16/5/28.
//  Copyright © 2016年 susizhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define blePeriWillDiscovereNoti      @"ble-PeriWillDiscovereNoti"
/// QPP Peripheral UUID
#define UUID_USER0_PERIPHERAL         @"UUID_QPP_PERIPHERAL"

/// QPP Service's UUID
#define UUID_USER0_SERVICE            @"0000FF92-0000-1000-8000-00805F9B34FB"

/// QPP a Peripheral's Characteristic with CBCharacteristicPropertyRead
#define UUID_USER0_READ               @"CE01"

/// QPP a Peripheral's Characteristic with CBCharacteristicPropertyWrite
#define UUID_USER0_WRITE              @"00009600-0000-1000-8000-00805F9B34FB"

/// QPP a Peripheral's Characteristic with CBCharacteristicPropertyNotify
#define UUID_USER0_NOTI               @"00009601-0000-1000-8000-00805F9B34FB"

/// for user1
#define UUID_USER1_PERIPHERAL         @"UUID_USER1_PERIPHERAL"

/// read
#define UUID_USER1_SVC_FOR_READ       @"FFE5"    /// svc for write
#define UUID_USER1_CHAR_FOR_READ      @"FFE5"    /// for write

/// write
#define UUID_USER1_SVC_FOR_WRITE      @"FFE5"    /// svc for write
#define UUID_USER1_CHAR_FOR_WRITE     @"FFE9"    /// for write

/// notify
#define UUID_USER1_SVC_FOR_NOTIFY     @"FFE0"    /// svc for notify
#define UUID_USER1_CHAR_FOR_NOTIFY    @"FFE4"    /// for notify
/// indicate
#define UUID_USER1_SVC_FOR_INDICATE   @"FFE5"    /// svc for notify
#define UUID_USER1_CHAR_FOR_INDICATE  @"FFE5"    /// for notify


#define UUID_PT_PERIPHERAL            @"UUID_PT_PERIPHERAL"
#define UUID_PT_SVC_FOR_NT            UUID_QPP_SERVICE
#define UUID_PT_CHAR_FOR_NT           UUID_QPP_SC_NOTI      // for noti
#define UUID_PT_CHAR_FOR_WR           UUID_QPP_WRITE        // for write

#define _ENABLE_QPP_TEST 0

#if _ENABLE_QPP_TEST
#define UUID_QPP_PERIPHERAL        UUID_USER1_PERIPHERAL

#define UUID_QPP_SVC_FOR_READ      UUID_USER1_SVC_FOR_READ
#define UUID_QPP_CHAR_FOR_READ     UUID_USER1_CHAR_FOR_READ

#define UUID_QPP_SVC_FOR_WRITE     UUID_USER1_SVC_FOR_WRITE
#define UUID_QPP_CHAR_FOR_WRITE    UUID_USER1_CHAR_FOR_WRITE

#define UUID_QPP_SVC_FOR_NOTIFY    UUID_USER1_SVC_FOR_NOTIFY
#define UUID_QPP_CHAR_FOR_NOTIFY   UUID_USER1_CHAR_FOR_NOTIFY

#define UUID_QPP_SVC_FOR_INDICATE  UUID_USER1_SVC_FOR_INDICATE
#define UUID_QPP_CHAR_FOR_INDICATE UUID_USER1_CHAR_FOR_INDICATE

#else

//#define UUID_QPP_PERIPHERAL        UUID_USER0_PERIPHERAL
#define UUID_QPP_SVC               UUID_USER0_SERVICE

//#define UUID_QPP_SVC_FOR_READ      UUID_USER0_SERVICE      /// service for read.
//#define UUID_QPP_CHAR_FOR_READ     UUID_USER0_READ     /// char for read.

#define UUID_QPP_SVC_FOR_WRITE     UUID_USER0_SERVICE     /// service for write.
#define UUID_QPP_CHAR_FOR_WRITE    UUID_USER0_WRITE    /// char for write.

#define UUID_QPP_SVC_FOR_NOTIFY    UUID_USER0_SERVICE    /// service for notify.
#define UUID_QPP_CHAR_FOR_NOTIFY   UUID_USER0_NOTI   /// char for notify.

//#define UUID_QPP_SVC_FOR_INDICATE  UUID_USER0_SERVICE  /// service for indicate.
//#define UUID_QPP_CHAR_FOR_INDICATE UUID_USER0_NOTI /// char for indicate.
#endif

#define ALERT_DISCONNECT_TITLE              @"Disconnect Warning"
#define ALERT_NODEVICE_TITLE                @"No Device"
#define ALERT_CS_ERROR_TITLE                @"CheckSum Error Warning"
#define ALERT_FAILED_TITLE                  @"Failed Warning"
#define ALERT_RETRIEVE_TITLE                @"Retrieve"
#define ALERT_CONNECT_FAIL_TITLE            @"Connection Warning"
#define ALERT_INPUT_ERROR_TITLE             @"Input Error"

#define strQppScanPeriEndNoti               @"qppScanPeripheralsEndNotification"

#define strQppUpdateDataRateNoti            @"qppUpdateDataRateNotification"

#define strQppDidConnectNoti                @"bleQppDidConnectNoti"
#define strQppDidDisconnectNoti             @"bleQppDidDisconnectNoti"
#define strQppFailToConnectNoti             @"bleQppFailToConnectNoti"
#define strQppRetrievePeripheralsNoti       @"bleQppRetrievePeripheralsNoti"

#define strQppDiscoveredServicesNoti        @"bleQppDiscoveredServicesNoti"

#define strQppUpdateStateForCharNoti        @"bleQppUpdateStateForCharNoti"

#define strQppReceiveDataNoti               @"bleQppUpdateValueForCharNoti"

/// UI noti
#define strQppSendFileEndNoti               @"qppSendFileEndNotification"

#define CharacteristicChangedNoti           @"CharacteristicNotified"

#define keyDataPeiReceived                  @"keyDataPeiReceived"

#define KeyPeiDisConnectedNoti              @"KeyPeiDisConnectedNoti"

typedef enum
{
    QPP_CENT_IDLE = 0, // scan
    QPP_CENT_SCANNING,
    QPP_CENT_SCANNED,
    QPP_CENT_CONNECTING,
    QPP_CENT_CONNECTED,
    QPP_CENT_DISCONNECTING,
    QPP_CENT_DISCONNECTED,
    QPP_CENT_RETRIEVING,
    QPP_CENT_RETRIEVED,
    QPP_CENT_SENDING,        /// sending package
    QPP_CENT_ERROR,
} qppCentralState;



@protocol ServiceManagerDelegate

-(void) onServiceInited:(BOOL)isSuccess;
-(void) onDeviceConnected;
-(void) onDeviceDisconnected;

@end

@protocol ReloadDeviceListDelegate
-(void) reloadDeviceList;
@end

@interface ServiceManager : NSObject {
    qppCentralState qppCentState;
    
}
@property (nonatomic, strong)  CBPeripheral *qppConnectedPeri;
//@property (nonatomic, strong) qBleClient *bleClient;
@property (nonatomic, strong) NSMutableArray *deviceArray;
@property (nonatomic, weak) id<ServiceManagerDelegate> serviceManagerDelegate;
@property (nonatomic, weak) id<ReloadDeviceListDelegate> ReloadDeviceListDelegate;
@property (readonly) qppCentralState qppCentState;


+ (ServiceManager *)sharedInstance;
-(void)writeValue : (NSData *)data;
-(void)peripheralDisconnect;
- (void)qppSelOnePeripheralRsp :(CBPeripheral *)peripheral;


@end
