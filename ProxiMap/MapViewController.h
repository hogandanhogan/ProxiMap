//
//  ViewController.h
//  ProxiMap
//
//  Created by Patrick Hogan on 8/21/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentUserAnn.h"

@interface MapViewController : UIViewController

@property PFUser *currentUser;
@property PFObject *userLocation;
@property PFGeoPoint *point;
@property PFObject *post;
@property CurrentUserAnn *cUPoint;
@property CLLocation *currentUserlocation;

@end
