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
    return @[(id)[[PMColor lightBlueColor] CGColor], (id)[[PMColor darkBlueColor] CGColor]];
}

#pragma mark - Switch

+ (UIColor *)switchTintColor
{
    return [UIColor colorWithRed:0.29f green:0.4f blue:0.56f alpha:1.0f];
}

+ (UIColor *)switchThumbColor
{
    return [self whiteColor];
}

#pragma mark -

+ (UIColor *)lightBlueColor
{
    return [UIColor colorWithRed:0.07 green:0.07 blue:0.08 alpha:1];
}

+ (UIColor *)darkBlueColor
{
    return [UIColor colorWithRed:0.13 green:0.14 blue:0.15 alpha:1];
}

+ (UIColor *)lightGrayColor
{
    return [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1];
}

+ (UIColor *)whiteColor
{
    return [UIColor colorWithRed:0.95f green:0.95f blue:1.0f alpha:1];
}

+ (UIColor *)blackColor
{
    return [UIColor colorWithWhite:0.2f alpha:1.0f];
}

@end
