//
//  ListTableViewCell.m
//  ProxiMap
//
//  Created by Dan Hogan on 9/18/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "ListTableViewCell.h"
#import "PMColor.h"

@implementation ListTableViewCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:24.0];
    self.textLabel.textColor = [UIColor whiteColor];
    //self.textLabel.frame.size.width = 320 - 64.0f;
    self.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next" size:16.0];
    self.detailTextLabel.textColor = [UIColor whiteColor];

    UIImageView *rightIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"male28.png"]];
    rightIV.frame = CGRectMake(self.frame.size.width, self.frame.origin.y + 3, 58, 58);
    rightIV.contentMode = UIViewContentModeScaleAspectFill;
    rightIV.layer.cornerRadius = rightIV.frame.size.width/2;
    rightIV.layer.borderColor = [UIColor whiteColor].CGColor;
    rightIV.layer.borderWidth = 1.0;
    rightIV.clipsToBounds = YES;
    self.accessoryView = rightIV;
}

@end
