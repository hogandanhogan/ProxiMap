//
//  ViewController.h
//  ProxiMap
//
//  Created by Patrick Hogan on 8/21/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentUserAnnotation.h"

@interface MapViewController : UIViewController

@property (nonatomic) PFUser *currentUser;
@property (nonatomic) PFGeoPoint *point;
@property (nonatomic) PFObject *post;
@property (nonatomic) CurrentUserAnnotation *cUPoint;
@property (nonatomic) CLLocation *currentUserLocation;

@end
