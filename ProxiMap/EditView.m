//
//  EditView.m
//  ProxiMap
//
//  Created by Patrick Hogan on 8/31/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "EditView.h"

@implementation EditView

-(void)scrollToY:(float)y
{
    
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
    
}

-(void)scrollToView:(EditView *)view
{
    CGRect theFrame = view.frame;
    float y = theFrame.origin.y - 15;
    y -= (y/1.7);
    [self scrollToY:-y];
}


-(void)scrollElement:(UIView *)view toPoint:(float)y
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
