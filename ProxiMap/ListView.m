//
//  TableView.m
//  
//
//  Created by Dan Hogan on 9/16/14.
//
//

#import "ListView.h"
#import "PMRadialGradientLayer.h"
#import "PMColor.h"

@interface ListView ()

@property (nonatomic) PMRadialGradientLayer *gradientLayer;

@end


@implementation ListView

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


@end
