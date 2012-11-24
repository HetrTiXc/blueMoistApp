//
//  DetailViewController.h
//  blueMoist
//
//  Created by Dag-Are Trydal on 11/9/12.
//  Copyright (c) 2012 Anders Brekke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flower.h"
#import "LeveyPopListView.h"
#import "BleDiscovery.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleFlowerService.h"


@interface DetailViewController : UIViewController <UITextFieldDelegate, LeveyPopListViewDelegate, BleDelegate, BleServiceDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) flower *detailFlower;

@property (weak, nonatomic) IBOutlet UIImageView *imageOfFlowerDetailView;
@property (weak, nonatomic) IBOutlet UILabel *detailedDescriptionLabel;

@property (weak, nonatomic) IBOutlet UITextField *flowerNameTextBox;
@property (weak, nonatomic) IBOutlet UIProgressView *waterLevelProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *batteryLevelProgress;
@property (weak, nonatomic) IBOutlet UILabel *waterLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLevelLabel;

@property (strong, nonatomic) NSArray *options;

- (IBAction)nameOfFlowerChanged:(id)sender;

@end
