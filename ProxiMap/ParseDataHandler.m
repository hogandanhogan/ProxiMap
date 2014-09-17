//
//  ParseObject.m
//  ProxiMap
//
//  Created by Patrick Hogan on 8/31/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "ParseDataHandler.h"

@implementation ParseDataHandler

- (id)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (void)saveToParse
{
    //possible TODO: not sure if I need to retain the currentUser title and subtitle
    [self.mapViewController.currentUser setObject:self.mapViewController.cUPoint.title forKey:@"title"];
    [self.mapViewController.currentUser setObject:self.mapViewController.cUPoint.subtitle forKey:@"subtitle"];
    self.mapViewController.userLocation = [PFObject objectWithClassName:@"UserLocation"];
    self.mapViewController.point = [PFGeoPoint geoPointWithLocation:self.mapViewController.currentUserlocation];
    self.mapViewController.userLocation[@"location"] = self.mapViewController.point;
    
    self.mapViewController.post = [PFObject objectWithClassName:@"Post"];
    self.mapViewController.post[@"title"] = self.mapViewController.cUPoint.title;
    self.mapViewController.post[@"subtitle"] = self.mapViewController.cUPoint.subtitle;
    [self.mapViewController.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Connection error, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }];
}

@end
