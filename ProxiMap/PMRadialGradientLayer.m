//
//  AMRadialGradientLayer.m
//  AlarMock
//
//  Created by Patrick Hogan on 9/1/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "PMRadialGradientLayer.h"

@implementation PMRadialGradientLayer

@dynamic gradientOrigin;
@dynamic gradientRadius;
@dynamic colors;
@dynamic locations;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"gradientOrigin"] ||
        [key isEqualToString:@"gradientRadius"] ||
        [key isEqualToString:@"colors"] ||
        [key isEqualToString:@"location"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (id)actionForKey:(NSString *)key
{
    if ([key isEqualToString:@"gradientOrigin"] ||
        [key isEqualToString:@"gradientRadius"] ||
        [key isEqualToString:@"colors"] ||
        [key isEqualToString:@"location"]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
        animation.fromValue = [self.presentationLayer valueForKey:key];
        return animation;
    } else {
        return [super actionForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)ctx
{
    NSUInteger numberOfLocations = self.locations.count;
    
    if (self.colors.count == 0) {
        return;
    }
    
    CGFloat *gradientLocations = malloc(sizeof(CGFloat) * numberOfLocations);
    
    for (NSUInteger i=0; i < numberOfLocations; i++) {
        NSNumber *loc = self.locations[i];
        gradientLocations[i] = [loc floatValue];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)self.colors, gradientLocations);
    CGContextDrawRadialGradient(ctx,
                                gradient,
                                self.gradientOrigin,
                                0.0f,
                                self.gradientOrigin,
                                self.gradientRadius,
                                kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    free(gradientLocations);
}

@end
