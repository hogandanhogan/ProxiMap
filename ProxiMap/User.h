//
//  User.h
//  ProxiMap
//
//  Created by Dan Hogan on 9/26/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser

@property (nonatomic) PFGeoPoint *point;
@property (nonatomic) PFObject *post;

@end
