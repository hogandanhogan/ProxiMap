//
//  EditView.m
//  ProxiMap
//
//  Created by Patrick Hogan on 8/31/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "EditView.h"
#import "PMRadialGradientLayer.h"
#import "PMColor.h"

@interface EditView ()

@property (nonatomic) PMRadialGradientLayer *gradientLayer;

@end

@implementation EditView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.gradientLayer = ({
        PMRadialGradientLayer *gradientLayer = [PMRadialGradientLayer layer];

        gradientLayer.colors = [PMColor backgroundGradientColors];

        gradientLayer.locations = @[@0.0f, @1.0f];

        [gradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
        [gradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];

        gradientLayer;
    });
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.gradientLayer.frame = (CGRect) { CGPointZero, self.frame.size };
    self.gradientLayer.gradientOrigin = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    self.gradientLayer.gradientRadius = CGRectGetMaxY(self.frame) * 0.9f;
}

//TODO:class the scrolling logic
- (void)scrollToY:(float)y
{
    
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
    
}

- (void)scrollToView:(EditView *)view
{
    CGRect editViewFrame = view.frame;
    float y = editViewFrame.origin.y - 80;

    [self scrollToY:y];
}


- (void)scrollElement:(UIView *)view toPoint:(float)y
{
    CGRect theFrame = view.frame;
    float orig_y = theFrame.origin.y;
    float diff = y - orig_y;
    if (diff < 0) {
        [self scrollToY:diff];
    }
    else {
        [self scrollToY:0];
    }

}

@end
