//
//  ListViewController.h
//  ProxiMap
//
//  Created by Dan Hogan on 9/16/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseDataHandler.h"

@interface ListViewController : UIViewController

@property (nonatomic) CLLocation *currentUserLocation;
@property (nonatomic) ParseDataHandler *parseDataHandler;
@property (nonatomic) NSArray *posts;
@property (nonatomic) NSArray *images;
@property (nonatomic) NSDictionary *imageDictionary;

@end
