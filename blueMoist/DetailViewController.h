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

@property (retain, nonatomic) IBOutlet UITextField *flowerNameTextBox;
@property (retain, nonatomic) IBOutlet UIProgressView *waterLevelProgress;
@property (retain, nonatomic) IBOutlet UIProgressView *batteryLevelProgress;
@property (retain, nonatomic) IBOutlet UILabel *waterLevelLabel;
@property (retain, nonatomic) IBOutlet UILabel *batteryLevelLabel;

@property (strong, nonatomic) NSArray *options;

- (IBAction)nameOfFlowerChanged:(id)sender;

@end
