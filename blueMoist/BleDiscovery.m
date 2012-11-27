//
//  BleDiscovery.m
//  BlueFlower
//
//  Created by student on 11/3/12.
//  Copyright (c) 2012 student. All rights reserved.
//

#import "BleDiscovery.h"

@interface BleDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager    *centralManager;
}
@end

@implementation BleDiscovery


@synthesize connectedServices;
@synthesize freePeripheralName;
@synthesize BleDelegate;

+ (id) sharedInstance
{
	static BleDiscovery	*this	= nil;
    
	if (!this)
		this = [[BleDiscovery alloc] init];
    
	return this;
}

//#####################################################################################################

- (id) init
{
    self = [super init];
    if (self) {
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        connectedServices = [[NSMutableArray alloc] init];
        freePeripheralName = [[NSMutableArray alloc] init];
	}
    return self;
}

//#####################################################################################################

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrieveConnectedPeripherals");
    
	CBPeripheral	*peripheral;
	for (peripheral in peripherals) {
		[central connectPeripheral:peripheral options:nil];
	}
	
}

//#####################################################################################################

- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didRetrievePeripheral");
    
	[central connectPeripheral:peripheral options:nil];

}

//#####################################################################################################

- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
    NSLog(@"didFailToRetrievePeripheralForUUID");

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
    
	if (![peripheral isConnected]) {
		[centralManager connectPeripheral:peripheral options:nil];
	}
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    NSLog(@"disconnectPeripheral");
    
	[centralManager cancelPeripheralConnection:peripheral];
}


//Callback for: scanForPeripheralsWithServices
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral");
   
    //The stopScan is done for the CSR dongle to work, may not be needed for iphone
    if(![peripheral isConnected])
    {
        [centralManager stopScan];
        [BleDelegate foundPeripheral:peripheral];
    }
}

//Callback for: connectPeripheral

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didConnectPeripheral");
    
    [BleDelegate startBleFlowerService];
    [BleDelegate changeConnectButton];
}

//callback for: connectPeripheral 

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral");
    
}


//State of the CBCentralManager --> the BLE controller
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state]) {
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
