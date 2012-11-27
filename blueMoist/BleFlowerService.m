//
//  BleFlowerService.m
//  BlueFlower
//
//  Created by student on 11/16/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import "BleFlowerService.h"
#import "BleDiscovery.h"

//Service UUIDs
NSString *humidityUUID = @"2012";
NSString *batteryUUID = @"180f";


@interface BleFlowerService() <CBPeripheralDelegate> {
@private
    CBPeripheral		*servicePeripheral;
    CBService			*humidityService;
    CBService			*batteryService;
    CBCharacteristic    *humidityCharacteristic;
    CBCharacteristic    *batteryCharacteristic;
    
}
@end


@implementation BleFlowerService

@synthesize humidityCharacteristic = humidityCharacteristic;
@synthesize batteryCharacteristic = batteryCharacteristic;
@synthesize peripheral = servicePeripheral;
@synthesize BleServiceDelegate;

//Initializes the BleFlowerService

- (id) initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        
        servicePeripheral = peripheral;
        [servicePeripheral setDelegate:self];
		      
	}
    return self;
}


//Starts the BleFlowerService

- (void) start
{
	CBUUID	*humidityServiceUUID	= [CBUUID UUIDWithString:humidityUUID];
    CBUUID  *batteryServiceUUID    = [CBUUID UUIDWithString:batteryUUID];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:humidityServiceUUID,batteryServiceUUID, nil];
    NSLog(@"-->start");
    [servicePeripheral discoverServices:serviceArray];
}

//Callback for: discoverServices

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSLog(@"didDiscoverServices");
    NSArray		*services	= nil;
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
		return ;
	}
    
	services = [peripheral services];
	if (!services || ![services count]) {
		return ;
	}
    
	humidityService = nil;
    
	for (CBService *service in services) {
        NSLog(@"%@", service.UUID);
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:humidityUUID]]) {
			humidityService = service;
			//break;
		}
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:batteryUUID]]) {
			batteryService = service;
			//break;
		}
	}
    
	if (humidityService) {
		[peripheral discoverCharacteristics:nil forService:humidityService];
	}
    if (batteryService) {
		[peripheral discoverCharacteristics:nil forService:batteryService];
	}
}

//Callback for: discoverCharacteristics

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
	NSLog(@"didDiscoverCharacteristicsForService");
    NSArray		*characteristics	= [service characteristics];
	CBCharacteristic *characteristic;
    if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
	
	if (service == humidityService) {
		for (characteristic in characteristics) {
             NSLog(@"service: %@", [service UUID]);
            NSLog(@"characteristic: %@", [characteristic UUID]);
            humidityCharacteristic = characteristic;
        }
        [self updateValue:humidityCharacteristic];
	}
    
    if (service == batteryService) {
		for (characteristic in characteristics) {
            NSLog(@"service: %@", [service UUID]);
            NSLog(@"characteristic: %@", [characteristic UUID]);
            batteryCharacteristic = characteristic;
        }
        [self updateValue:batteryCharacteristic];
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}

    
    
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateValueForCharacteristic");
    
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong peripheral\n");
		return ;
	}
    
    if ([error code] != 0) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
    if ([[characteristic service] isEqual:humidityService]) {
        NSLog(@"humidity");
        NSLog(@"value: %@",characteristic.value);
        [self convertValueFromHexToFloat:characteristic];
        return;
    }
    
    if ([[characteristic service] isEqual:batteryService]) {
        NSLog(@"battery");
        NSLog(@"value: %@",characteristic.value);
        [self convertValueFromHexToFloat:characteristic];
        return;
    }

    
    

}

- (void) updateValue:(CBCharacteristic *)characteristic
{
    NSLog(@"-->updateValue");
    [servicePeripheral readValueForCharacteristic:characteristic];
}

- (void) convertValueFromHexToFloat:(CBCharacteristic *) characteristic
{
    NSData *hexValue = characteristic.value;
    NSLog(@"convertValueFromHexToFloat");
    NSString *hexValueStr = hexValue.description;
    hexValueStr = [hexValueStr substringFromIndex:1];
    hexValueStr = [hexValueStr substringToIndex:[hexValueStr length] - 1];
    unsigned int value;
    NSScanner *scanner = [NSScanner scannerWithString:hexValueStr];
    [scanner scanHexInt:&value];
    float flValue = (float) value;
    NSLog(@"Float value: %f",flValue);
    
    if ([[characteristic service] isEqual:humidityService]) {
        flValue = flValue/120;
        [BleServiceDelegate setWaterLevel:flValue];
        return;
    }
    
    if ([[characteristic service] isEqual:batteryService]) {
        flValue = flValue/100;
        [BleServiceDelegate setBatteryLevel:flValue];
    }
    
    
}

@end
