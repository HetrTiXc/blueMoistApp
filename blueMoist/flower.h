//
//  flower.h
//  blueMoist
//
//  Created by Dag-Are Trydal on 11/9/12.
//  Copyright (c) 2012 Anders Brekke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface flower : NSObject

@property (strong) NSString *name;
@property (strong) UIImage *thumbImage;
@property (strong) UIImage *fullImage;
@property (strong) NSString *userDescription;
@property (strong) NSString *appDescription;
@property (assign) float moistureLevel;
@property (assign) float batteryLevel;

- (id) initWithName:(NSString *) name thumbImage:(UIImage *) thumbImage fullImage:(UIImage *) fullImage;


@end