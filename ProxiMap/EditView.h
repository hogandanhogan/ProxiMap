//
//  EditView.h
//  ProxiMap
//
//  Created by Patrick Hogan on 8/31/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditView : UIView

-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view;
-(void)scrollElement:(UIView *)view toPoint:(float)y;

@end
