//
//  AMColor.m
//  AlarMock
//
//  Created by Patrick Hogan on 9/8/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "PMColor.h"

@implementation PMColor

#pragma mark - Background

+ (NSArray *)backgroundGradientColors
{
    return @[(id)[[PMColor lightBlackColor] CGColor], (id)[[PMColor darkBlackColor] CGColor]];
}

#pragma mark -

+ (UIColor *)lightBlackColor
{
    return [UIColor colorWithRed:0.07 green:0.07 blue:0.08 alpha:1];
}

+ (UIColor *)darkBlackColor
{
    return [UIColor colorWithRed:0.13 green:0.14 blue:0.15 alpha:1];
}


+ (UIColor *)whiteColor
{
    return [UIColor colorWithRed:0.95f green:0.95f blue:1.0f alpha:1];
}

@end
