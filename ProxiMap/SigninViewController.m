//
//  SigninViewController.m
//  Ribbit
//
//  Created by Dan Hogan on 7/11/14.
//  Copyright (c) 2014 Wayne Gomez. All rights reserved.
//

#import "SigninViewController.h"
#import <Parse/Parse.h>

@interface SigninViewController ()

@end

@implementation SigninViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
}

- (IBAction)signup:(id)sender {

    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] ==0 || [password length] == 0 || [email length] == 0)
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username, password, and email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

        [alertview show];
    }

    else
    {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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

- (IBAction)Dismiss:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
}

@end
