//
//  DetailViewController.h
//  blueMoist
//
//  Created by Dag-Are Trydal on 11/9/12.
//  Copyright (c) 2012 Anders Brekke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flower.h"
#import "BleDiscovery.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleFlowerService.h"


@interface DetailViewController : UIViewController <UITextFieldDelegate, BleDelegate, BleServiceDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) flower *detailFlower;

@property (retain, nonatomic) IBOutlet UIImageView *imageOfFlowerDetailView;
@property (retain, nonatomic) IBOutlet UILabel *detailedDescriptionLabel;
@property ( nonatomic) IBOutlet UITextField *flowerNameTextBox;
@property ( nonatomic) IBOutlet UIProgressView *waterLevelProgress;
@property ( nonatomic) IBOutlet UIProgressView *batteryLevelProgress;
@property ( nonatomic) IBOutlet UILabel *waterLevelLabel;
@property (nonatomic) IBOutlet UILabel *batteryLevelLabel;


- (IBAction)nameOfFlowerChanged:(id)sender;

@end
