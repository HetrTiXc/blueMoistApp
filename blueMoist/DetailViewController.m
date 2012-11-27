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

//@synthesize _flowerNameTextBox = flowerNameTextBox;
@synthesize options = _options;
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
        //self.detailedDescriptionLabel.text = @"This plant grow everywhere where the sun shines at least 10 hours a day. No water is needed because it just suck out what it needs from the air. Very poisonoius and may kill you upon touch";
        //self.detail.text = self.detailFlower.name;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BleDiscovery sharedInstance] setBleDelegate:self];
	// Do any additional setup after loading the view, typically from a nib.
    //NSString *teststreng = [[NSString alloc] initWithFormat:@"TESTSTRENG FTW"];
    //self.labelNumUno.text = teststreng;
    
    if ([self.detailFlower.flowerService.peripheral isConnected]) {
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateBleFlowerServiceCharacteristicValues)];
        self.navigationItem.rightBarButtonItem = refreshButton;
        
        
    } else {
        UIBarButtonItem *connectButton = [[UIBarButtonItem alloc] initWithTitle:@"Connect" style:UIBarButtonItemStylePlain target:self action:@selector(infoTapped:)];
        self.navigationItem.rightBarButtonItem = connectButton;
    }
    NSLog(@"%f", self.waterLevelProgress.progress);
    //self.waterLevelProgress.progress = 0.0;
    self.waterLevelLabel.text = [NSString stringWithFormat:@"Humidity"];//@"%d%%", (int) (self.waterLevelProgress.progress*100)];
    self.batteryLevelProgress.progress = 0.0;
    self.batteryLevelLabel.text = [NSString stringWithFormat:@"Battery"];//@"%d%%", (int) (self.batteryLevelProgress.progress*100)];
    //self.navigationItem.rightBarButtonItem = refreshButton;
   // _options = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"dummy",@"text", nil],nil];
    
    
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

- (IBAction)dummyButtonFunc:(id)sender {
    self.waterLevelProgress.progress = 0.7;
}

- (IBAction)nameOfFlowerChanged:(id)sender {
    self.detailFlower.name = self.flowerNameTextBox.text;
}
- (void) infoTapped:(id) sender{
    NSLog(@"Connect Button pushed");
    [[BleDiscovery sharedInstance] startScanningForUUIDString:humidityUUID];
    
}

//BleDelegate functions, called from BleDiscovery class
- (void) BleDiscoveryDidRefresh
{
    NSLog(@"BleDiscoveryDidRefresh");
}

//Made this function so we can choose to initiate the connection with a button, if we want...? if not, all can be done in the BleDiscovery
- (void) foundPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"foundPeripheral");
    //[self showListView];
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

//Requests update for characteristic values from the peripheral connected to the flower, called after the connection is set up, on each load of detailedView, and from "update" button
- (void) updateBleFlowerServiceCharacteristicValues
{
    NSLog(@"updateBleFlowerServiceCharacteristicValues");
    if([self.detailFlower.flowerService.peripheral isConnected])
    {
        [self.detailFlower.flowerService updateValue:self.detailFlower.flowerService.batteryCharacteristic];
        [self.detailFlower.flowerService updateValue:self.detailFlower.flowerService.humidityCharacteristic];
    }
}

- (void) setWaterLevel:(float)value
{
    
    NSLog(@"setWaterLevel");
    self.detailFlower.moistureLevel = value;
    self.waterLevelProgress.progress = value;
    NSLog(@"Progress: %f",self.waterLevelProgress.progress);
    self.waterLevelLabel.text = [NSString stringWithFormat:@"Møkkabar"];
    self.flowerNameTextBox.text = [NSString stringWithFormat:@"Ny tittel"];

}

- (void) setBatteryLevel:(float)value
{
    NSLog(@"setBatteryLevel");
    self.detailFlower.batteryLevel = value;
    self.batteryLevelProgress.progress = value;
    NSLog(@"Progress: %f",self.batteryLevelProgress.progress);
    self.batteryLevelLabel.text = [NSString stringWithFormat:@"Drittbar"];
}

-(void) changeConnectButton
{
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateBleFlowerServiceCharacteristicValues)];
    [self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
}

-(void) updateProgressBars
{
    [self.waterLevelProgress setProgress:self.detailFlower.moistureLevel ];
    [self.batteryLevelProgress setProgress:self.detailFlower.batteryLevel ];
}


@end
