//
//  SettingsView.h
//  ProxiMap
//
//  Created by Dan Hogan on 9/23/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsView : UIView

- (void)scrollToY:(float)y;
- (void)scrollToView:(UIView *)view;
- (void)scrollElement:(UIView *)view toPoint:(float)y;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end
