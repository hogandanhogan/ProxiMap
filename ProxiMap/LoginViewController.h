//
//  LoginViewController.h
//  Ribbit
//
//  Created by Dan Hogan on 7/11/14.
//  Copyright (c) 2014 Wayne Gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)login:(id)sender;

@end
