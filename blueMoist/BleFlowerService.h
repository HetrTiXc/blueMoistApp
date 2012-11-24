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
- (void) setBleFlowerServiceCharacteristicValue:(float)value;
@end


extern NSString *humidityUUID;
extern NSString *batteryUUID;

@interface BleFlowerService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral;
- (void) start;
- (void) updateValue;

@property (readonly) CBPeripheral *peripheral;
@property (nonatomic, assign) id <BleServiceDelegate> BleServiceDelegate;

@end
