//
//  AMRadialGradientLayer.h
//  AlarMock
//
//  Created by Patrick Hogan on 9/1/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PMRadialGradientLayer : CAGradientLayer

@property (nonatomic, assign) CGPoint gradientOrigin;
@property (nonatomic, assign) CGFloat gradientRadius;

@end
