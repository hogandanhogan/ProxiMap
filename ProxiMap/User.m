//
//  User.m
//  ProxiMap
//
//  Created by Dan Hogan on 9/26/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic post;
@dynamic point;


+ (void)load {
    [self registerSubclass];

}

- (NSUInteger)hash
{
    return self.objectId.intValue;
}

- (BOOL)isEqual:(User *)user
{
    return [self.objectId isEqualToString:user.objectId];
}

@end
