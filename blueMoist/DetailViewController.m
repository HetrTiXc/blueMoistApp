//
//  DetailViewController.m
//  blueMoist
//
//  Created by Dag-Are Trydal on 11/9/12.
//  Copyright (c) 2012 Anders Brekke. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

//@synthesize _flowerNameTextBox = flowerNameTextBox;
@synthesize options = _options;

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
	// Do any additional setup after loading the view, typically from a nib.
    //NSString *teststreng = [[NSString alloc] initWithFormat:@"TESTSTRENG FTW"];
    //self.labelNumUno.text = teststreng;
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(infoTapped:)];
    self.navigationItem.rightBarButtonItem = infoButton;
    self.waterLevelProgress.progress = 0.23;
    self.waterLevelLabel.text = [NSString stringWithFormat:@"%d%%", (int) (self.waterLevelProgress.progress*100)];
    self.batteryLevelProgress.progress = 0.88;
    self.batteryLevelLabel.text = [NSString stringWithFormat:@"%d%%", (int) (self.batteryLevelProgress.progress*100)];
    
    _options = [NSArray arrayWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:@"Facebook",@"text", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"Twitter",@"text", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"Tumblr",@"text", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"Google+",@"text", nil],
                 nil];
    
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
    [self showListView];
}
- (void)showListView
{
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"Select BLE device to connect" options:_options];
    lplv.delegate = self;
    [lplv showInView:self.view animated:YES];
}
#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    //Bind the flower to the selected BLE sensor
}

- (void)leveyPopListViewDidCancel
{
    //_infoLabel.text = @"You have cancelled";
}
@end
