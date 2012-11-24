//
//  BleDiscovery.h
//  BlueFlower
//
//  Created by student on 11/3/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleFlowerService.h"

@protocol BleDelegate <NSObject>
- (void) BleDiscoveryDidRefresh;
- (void) foundPeripheral:(CBPeripheral *)peripheral;
- (void) startBleFlowerService;
- (void) changeConnectButton;
@end

@interface BleDiscovery : NSObject

+ (id) sharedInstance;
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;
- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;


@property (retain, nonatomic) NSMutableArray	*connectedServices;
@property (retain, nonatomic) NSMutableArray    *freePeripheralName;

@property (nonatomic, assign) id <BleDelegate> BleDelegate;

@end
