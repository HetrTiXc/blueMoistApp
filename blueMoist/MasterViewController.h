//
//  MasterViewController.h
//  blueMoist
//
//  Created by Dag-Are Trydal on 11/9/12.
//  Copyright (c) 2012 Anders Brekke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController

@property (strong) NSMutableArray *flowerList;

- (NSString *) saveFilePath;
- (void)applicationDidEnterBackground:(UIApplication *)application;

@end
