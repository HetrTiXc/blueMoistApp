//
//  BleFlowerService.m
//  BlueFlower
//
//  Created by student on 11/16/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import "BleFlowerService.h"
#import "BleDiscovery.h"

NSString *humidityUUID = @"2012";
NSString *humidityCharacteristicUUID = @"2a19";
NSString *batteryUUID = @"180f";

@interface BleFlowerService() <CBPeripheralDelegate> {
@private
    CBPeripheral		*servicePeripheral;
    CBService			*humidityService;
    CBCharacteristic    *humidityCharacteristic;
    
}
@end



@implementation BleFlowerService

@synthesize peripheral = servicePeripheral;
@synthesize BleServiceDelegate;

//#####################################################################################################

- (id) initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        
        servicePeripheral = peripheral;
        [servicePeripheral setDelegate:self];
		      
	}
    return self;
}


//#####################################################################################################

- (void) start
{
	CBUUID	*serviceUUID	= [CBUUID UUIDWithString:humidityUUID];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    NSLog(@"-->start");
    [servicePeripheral discoverServices:serviceArray];
}

//#####################################################################################################

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSLog(@"didDiscoverServices");
    NSArray		*services	= nil;
	NSArray		*uuids	= [NSArray arrayWithObjects:humidityUUID, nil];
    
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
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:humidityUUID]]) {
			humidityService = service;
			break;
		}
	}
    
	if (humidityService) {
		[peripheral discoverCharacteristics:nil forService:humidityService];
	}
}

//#####################################################################################################

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
	NSLog(@"didDiscoverCharacteristicsForService");
    NSArray		*characteristics	= [service characteristics];
	CBCharacteristic *characteristic;
    if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
	
	if (service != humidityService) {
		NSLog(@"Wrong Service.\n");
		return ;
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
	for (characteristic in characteristics) {
        NSLog(@"characteristic: %@", [characteristic UUID]);
        humidityCharacteristic = characteristic;
        
         
    }
    
    [self updateValue];
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateValueForCharacteristic");
    NSLog(@"value: %@",characteristic.value);
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong peripheral\n");
		return ;
	}
    
    if ([error code] != 0) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    
    [self convertValueFromHexToFloat:characteristic.value];
}

- (void) updateValue
{
    NSLog(@"-->updateValue");
    [servicePeripheral readValueForCharacteristic:humidityCharacteristic];
}

- (void) convertValueFromHexToFloat:(NSData*) hexValue
{
    NSLog(@"convertValueFromHexToFloat");
    NSString *hexValueStr = hexValue.description;
    hexValueStr = [hexValueStr substringFromIndex:1];
    hexValueStr = [hexValueStr substringToIndex:[hexValueStr length] - 1];
    NSLog(@"%@",hexValueStr);
    unsigned int value;
    NSScanner *scanner = [NSScanner scannerWithString:hexValueStr];
    [scanner scanHexInt:&value];
    NSLog(@"%u",value);
    float flValue = (float) value;
    
    flValue = flValue/120;
    NSLog(@"%f",flValue);
    [BleServiceDelegate setBleFlowerServiceCharacteristicValue:flValue];
}

@end
