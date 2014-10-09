//
//  ParseObject.h
//  ProxiMap
//
//  Created by Patrick Hogan on 8/31/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"

@interface ParseDataHandler : NSObject

- (void)saveToParse;
- (void)queryPosts;
- (void)queryImages;
- (id)init;

@property (nonatomic) MapViewController *mapViewController;
@property NSArray *posts;
@property NSArray *images;

@end
