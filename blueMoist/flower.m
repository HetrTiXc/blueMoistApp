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
        self.moistureLevel = 0.5;
        self.batteryLevel = 0.5;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_thumbImage forKey:@"thumbImage"];
    [aCoder encodeObject:_fullImage forKey:@"fullImage"];
    [aCoder encodeObject:_userDescription forKey:@"userDescription"];
    [aCoder encodeObject:_appDescription forKey:@"appDescription"];
    [aCoder encodeObject:_flowerService forKey:@"flowerService"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.thumbImage = [aDecoder decodeObjectForKey:@"thumbImage"];
        self.fullImage = [aDecoder decodeObjectForKey:@"fullIamge"];
        self.userDescription = [aDecoder decodeObjectForKey:@"userDescription"];
        self.appDescription = [aDecoder decodeObjectForKey:@"appDescription"];
        self.flowerService = [aDecoder decodeObjectForKey:@"flowerService"];
    }
    return self;
}

@end
