//
//  DetailViewController.m
//  blueMoist
//
//  Created by Dag-Are Trydal on 11/9/12.
//  Copyright (c) 2012 Anders Brekke. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"


@interface DetailViewController () <BleDelegate, BleServiceDelegate>
- (void)configureView;
@end

@implementation DetailViewController

@synthesize waterLevelProgress = _waterLevelProgress;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        //self.detail.text = [self.detailItem description];
    }
    if(self.detailFlower){
        self.flowerNameTextBox.text = self.detailFlower.name;
        self.imageOfFlowerDetailView.image = self.detailFlower.fullImage;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BleDiscovery sharedInstance] setBleDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (![self.detailFlower.flowerService.peripheral isConnected]) {
        UIBarButtonItem *connectButton = [[UIBarButtonItem alloc] initWithTitle:@"Connect" style:UIBarButtonItemStylePlain target:self action:@selector(infoTapped:)];
        self.navigationItem.rightBarButtonItem = connectButton;
    }
    
    self.waterLevelLabel.text = [NSString stringWithFormat:@"Humidity"];
    self.batteryLevelLabel.text = [NSString stringWithFormat:@"Battery"];

    //Start timer which will request the connected peripheral for characteristic updates
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(updateBleFlowerServiceCharacteristicValues)
                                   userInfo:nil
                                    repeats:YES];
    
    [self updateBleFlowerServiceCharacteristicValues];
    [self updateProgressBars];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *) inputTextBox {
    if(inputTextBox == self.flowerNameTextBox) {
        [inputTextBox resignFirstResponder];
    }
    return YES;
}

- (IBAction)nameOfFlowerChanged:(id)sender {
    self.detailFlower.name = self.flowerNameTextBox.text;
}
- (void) infoTapped:(id) sender{
    NSLog(@"Connect Button pushed");
    [[BleDiscovery sharedInstance] startScanningForUUIDString:humidityUUID];
}


//Creates a flower service with the found peripheral and connect to it
- (void) foundPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"foundPeripheral");
    BleFlowerService *service	= nil;
    service = [[BleFlowerService alloc] initWithPeripheral:peripheral];
    self.detailFlower.flowerService = service;
    [self.detailFlower.flowerService setBleServiceDelegate:self];    
    [[BleDiscovery sharedInstance] connectPeripheral:self.detailFlower.flowerService.peripheral];
    
}


- (void) startBleFlowerService
{
    NSLog(@"createBleFlowerService");
    
    //Start the service
	[self.detailFlower.flowerService start];

}

//Requests updates for characteristic values
- (void) updateBleFlowerServiceCharacteristicValues
{
    NSLog(@"updateBleFlowerServiceCharacteristicValues");
    if([self.detailFlower.flowerService.peripheral isConnected])
    {
        if(self.detailFlower.flowerService.batteryCharacteristic){
        [self.detailFlower.flowerService updateValue:self.detailFlower.flowerService.batteryCharacteristic];
        }
        if(self.detailFlower.flowerService.batteryCharacteristic){
        [self.detailFlower.flowerService updateValue:self.detailFlower.flowerService.humidityCharacteristic];
        }
    [self updateProgressBars];
    }
}

- (void) setWaterLevel:(float)value
{    
    NSLog(@"setWaterLevel");
    self.detailFlower.moistureLevel = value;
}

- (void) setBatteryLevel:(float)value
{
    NSLog(@"setBatteryLevel");
    self.detailFlower.batteryLevel = value;  
}

-(void) changeConnectButton
{
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

-(void) updateProgressBars
{
    NSLog(@"updateProgressBars");
    [self.waterLevelProgress setProgress:self.detailFlower.moistureLevel ];
    [self.batteryLevelProgress setProgress:self.detailFlower.batteryLevel ];
}


@end
