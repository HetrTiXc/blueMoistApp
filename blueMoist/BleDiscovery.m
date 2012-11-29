//
//  BleDiscovery.m
//  BlueFlower
//
//  Created by Tobias on 11/3/12.
//  Copyright (c) 2012 Tobias. All rights reserved.
//

#import "BleDiscovery.h"

@interface BleDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager    *centralManager;
}
@end

@implementation BleDiscovery

@synthesize BleDelegate;

+ (id) sharedInstance
{
	static BleDiscovery	*this	= nil;
    
	if (!this)
		this = [[BleDiscovery alloc] init];
    
	return this;
}


- (id) init
{
    self = [super init];
    if (self)
    {
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
	}
    return self;
}


- (void) startScanningForUUIDString:(NSString *)uuidString
{
    NSLog(@"startScanningForUUIDString");    
	NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}


- (void) stopScanning
{
    NSLog(@"stopScanning");    
	[centralManager stopScan];
}


- (void) connectPeripheral:(CBPeripheral*)peripheral
{
    NSLog(@"connectPeripheral");    
	if (![peripheral isConnected])
    {
		[centralManager connectPeripheral:peripheral options:nil];
	}
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    NSLog(@"disconnectPeripheral");    
	[centralManager cancelPeripheralConnection:peripheral];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral");
    if(![peripheral isConnected])
    {
        [centralManager stopScan];//The stopScan is done for the CSR dongle to work with iPhone simulator, may not be needed for real iPhone
        [BleDelegate foundPeripheral:peripheral];
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didConnectPeripheral");
    [BleDelegate startBleFlowerService];
    [BleDelegate changeConnectButton];
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral");
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state])
    {
		case CBCentralManagerStatePoweredOff:
		{            
            NSLog(@"StatePoweredOff");
			break;
		}
            
        case CBCentralManagerStateUnsupported:
		{
            NSLog(@"StateUnsupported");
			break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
            NSLog(@"StateUnauthorized");
			break;
		}
            
		case CBCentralManagerStateUnknown:
		{
            NSLog(@"StateUnknown");            
			break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
            NSLog(@"StatePoweredOn");
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
            NSLog(@"StateResettin");
			break;
		}
	}
    
    previousState = [centralManager state];
}


@end
