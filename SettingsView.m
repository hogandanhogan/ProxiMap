//
//  SettingsView.m
//  ProxiMap
//
//  Created by Dan Hogan on 9/23/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "SettingsView.h"
#import "PMRadialGradientLayer.h"
#import "PMColor.h"

@interface SettingsView ()

@property (nonatomic) PMRadialGradientLayer *gradientLayer;

@end

@implementation SettingsView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.picImageView.image = [UIImage imageNamed:@"male28.png"];
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.layer.cornerRadius = self.picImageView.frame.size.width/2;
    self.picImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.picImageView.layer.borderWidth = 1.0;
    self.picImageView.clipsToBounds = YES;

    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    self.hidden = YES;
    self.backgroundColor = [UIColor colorWithRed:0.44 green:0.75 blue:0.75 alpha:1];
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
