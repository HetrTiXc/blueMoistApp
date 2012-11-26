//
//  flower.m
//  blueMoist
//
//  Created by Dag-Are Trydal on 11/9/12.
//  Copyright (c) 2012 Anders Brekke. All rights reserved.
//

#import "flower.h"

@implementation flower

//Git test kommentar

@synthesize name = _name;
@synthesize thumbImage = _thumbImage;
@synthesize userDescription = _userDescription;

- (id) initWithName:(NSString *) name thumbImage:(UIImage *) thumbImage fullImage:(UIImage *) fullImage {
    if(self = [super init]) {
        self.name = name;
        self.thumbImage = thumbImage;
        self.fullImage = fullImage;

    }
    return self;
}

@end
