//
//  MasterViewController.m
//  blueMoist
//
//  Created by Dag-Are Trydal on 11/9/12.
//  Copyright (c) 2012 Anders Brekke. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "flower.h"
#import "BleDiscovery.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize flowerList = _flowerList;



- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    NSString *applicationDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [applicationDocumentsPath stringByAppendingPathComponent:@"test.plist"];
    
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!array) {
        // if it couldn't be loaded from disk create a new one
        [_flowerList addObjectsFromArray:array];
    }
    
        
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = @"Flowers";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _flowerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFlowerCell" forIndexPath:indexPath];

    flower *oneFlowerInTheList = [self.flowerList objectAtIndex:indexPath.row];
    cell.textLabel.text = oneFlowerInTheList.name;
    cell.imageView.image = oneFlowerInTheList.thumbImage;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_flowerList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
        _detailController = segue.destinationViewController;
        flower *oneFlowerToShow = [self.flowerList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        _detailController.detailFlower = oneFlowerToShow;
    }
}

- (void) addTapped:(id)sender {
    flower *newFlower = [[flower alloc] initWithName:@"New Plant" thumbImage:[UIImage imageNamed:@"dummyFlowerThumb"] fullImage:[UIImage imageNamed:@"dummyFlower"]];
    [_flowerList addObject:newFlower];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_flowerList.count-1 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:YES];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (NSString *) saveFilePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[path objectAtIndex:0] stringByAppendingPathComponent:@"/saveFile.plist"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"appDidEnterBackground");
    // save the file
    NSString *applicationDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [applicationDocumentsPath stringByAppendingPathComponent:@"test.plist"];
    
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];    
    BOOL result = [NSKeyedArchiver archiveRootObject:array toFile:path];
    

}

@end
