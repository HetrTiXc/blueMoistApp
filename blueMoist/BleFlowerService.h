//
//  BleFlowerService.h
//  BlueFlower
//
//  Created by student on 11/16/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BleServiceDelegate <NSObject>
- (void) setWaterLevel:(float)value;
- (void) setBatteryLevel:(float)value;
@end


extern NSString *humidityUUID;
extern NSString *batteryUUID;

@interface BleFlowerService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral;
- (void) start;
- (void) updateValue:(CBCharacteristic *) characteristic;

@property (readonly) CBPeripheral *peripheral;
@property (nonatomic, retain) id <BleServiceDelegate> BleServiceDelegate;
@property (readonly)  CBCharacteristic    *humidityCharacteristic;
@property (readonly)  CBCharacteristic    *batteryCharacteristic;

@end
