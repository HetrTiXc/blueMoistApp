//
//  BleDiscovery.h
//  BlueFlower
//
//  Created by Tobias on 11/3/12.
//  Copyright (c) 2012 Tobias. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleFlowerService.h"

@protocol BleDelegate <NSObject>
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

@property (nonatomic, retain) id <BleDelegate>  BleDelegate;

@end
