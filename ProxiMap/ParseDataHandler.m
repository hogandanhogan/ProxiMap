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
        self.posts = [NSArray new];
        self.images = [NSArray new];
    }
    
    return self;
}

- (void)saveToParse
{
    self.mapViewController.post = [PFObject objectWithClassName:@"Post"];
    self.mapViewController.post[@"title"] = self.mapViewController.cUPoint.title;
    self.mapViewController.post[@"subtitle"] = self.mapViewController.cUPoint.subtitle;
    self.mapViewController.post[@"location"] = self.mapViewController.currentUserLocation;
    [self.mapViewController.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Connection error, try again"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}

- (void)queryPosts
{
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:self.mapViewController.currentUserLocation];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"location" nearGeoPoint:point];

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            self.posts = posts;

        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}

- (void)queryImages
{
    PFQuery *query = [PFQuery queryWithClassName:@"Image"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *images, NSError *error) {
        if (!error) {
            self.images = images;
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];

}

@end
