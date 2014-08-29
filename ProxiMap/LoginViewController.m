//
//  LoginViewController.m
//  Ribbit
//
//  Created by Dan Hogan on 7/11/14.
//  Copyright (c) 2014 Wayne Gomez. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)login:(id)sender {

    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] ==0 || [password length] == 0)
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username, password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

        [alertview show];
    }
    else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
}
@end
