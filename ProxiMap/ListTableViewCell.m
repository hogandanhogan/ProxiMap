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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:24.0];
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next" size:16.0];
    self.detailTextLabel.textColor = [UIColor whiteColor];

    self.rightIV = [UIImageView new];
    self.rightIV.frame = CGRectMake(self.frame.size.width, self.frame.origin.y + 3, 58, 58);
    self.rightIV.contentMode = UIViewContentModeScaleAspectFill;
    self.rightIV.layer.cornerRadius = self.rightIV.frame.size.width/2;
    self.rightIV.layer.borderColor = [PMColor whiteColor].CGColor;
    self.rightIV.layer.borderWidth = 1.0;
    self.rightIV.clipsToBounds = YES;
    self.accessoryView = self.rightIV;
}

@end
