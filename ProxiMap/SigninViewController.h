//
//  SigninViewController.h
//  Ribbit
//
//  Created by Dan Hogan on 7/11/14.
//  Copyright (c) 2014 Wayne Gomez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)signup:(id)sender;
- (IBAction)Dismiss:(id)sender;

@end
