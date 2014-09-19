//
//  ViewController.m
//  ProxiMap
//
//  Created by Patrick Hogan on 8/21/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "LoginViewController.h"
#import "EditView.h"
#import "ParseDataHandler.h"
#import "ListViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet EditView *editView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (nonatomic) ParseDataHandler *parseDataHandler;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchFieldContainer;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleField.delegate = self;
    self.descriptionField.delegate = self;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboardonTapOutside:)];
    [self.view addGestureRecognizer:tap];

    self.editView.hidden = YES;
    self.editView.layer.cornerRadius = 10;
    self.editView.layer.masksToBounds = YES;
    
    self.currentUser = [PFUser currentUser];
    if (!self.currentUser) {
        LoginViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"showLogin"];
        [self.navigationController pushViewController:lvc animated:YES];
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"menu51.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onRightBarButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 18, 18)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[CurrentUserAnn class]]) {
        CurrentUserAnn *cUPoint = (CurrentUserAnn *)annotation;
        MKPinAnnotationView *pinLabel = [[MKPinAnnotationView alloc] initWithAnnotation:cUPoint reuseIdentifier:nil];
        pinLabel.canShowCallout = YES;
        pinLabel.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return pinLabel;
    }
    else {
        return nil;
    }
}

#pragma mark CLLocation Mangager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.currentUserLocation = [locations lastObject];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentUserLocation.coordinate, 250, 250);
    [_mapView setRegion:region];
    
    self.cUPoint = [[CurrentUserAnn alloc] init];
    self.cUPoint.coordinate = self.currentUserLocation.coordinate;
    self.cUPoint.title = @"Update your title";
    self.cUPoint.subtitle = @"Update your description";

    [self.mapView addAnnotation:self.cUPoint];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to Get Your Location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [UIView animateWithDuration:0.15 animations:^(void) {
        self.editView.hidden = NO;
        self.editView.alpha = 0;
        self.editView.alpha = 1.0;
    } completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.editView.frame, point)) {
        return;
    } else {
        [UIView animateWithDuration:0.3 animations:^(void) {
            self.editView.alpha = 1.0;
            self.editView.alpha = 0;
        } completion:^(BOOL finished) {
            self.editView.hidden = YES;
        }];
    }

}

- (IBAction)onCancelEditView:(id)sender
{
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.editView.alpha = 1.0;
        self.editView.alpha = 0;
    } completion:^(BOOL finished) {
        self.editView.hidden = YES;
    }];
}

- (IBAction)onRightBarButtonSelected:(id)sender
{
    ListViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"listVC"];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (IBAction)onSaveEditView:(id)sender
{
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    self.cUPoint.title = self.titleField.text;
    self.cUPoint.subtitle = self.descriptionField.text;
    self.parseDataHandler = [ParseDataHandler new];

    self.point = [PFGeoPoint geoPointWithLocation:self.currentUserLocation];

    self.post = [PFObject objectWithClassName:@"Post"];
    self.post[@"title"] = self.cUPoint.title;
    self.post[@"subtitle"] = self.cUPoint.subtitle;
    self.post[@"location"] = self.point;


    [self.currentUser setObject:self.cUPoint.title forKey:@"title"];
    [self.currentUser setObject:self.cUPoint.subtitle forKey:@"subtitle"];

    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error, try again"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] show];
        }

    }];

    [UIView animateWithDuration: 0.3 animations:^(void) {
        self.editView.alpha = 1.0;
        self.editView.alpha = 0;
    } completion:^(BOOL finished) {
        self.editView.hidden = YES;
    }];
}

- (IBAction)titleField:(id)sender{}
- (IBAction)descriptionField:(id)sender{}
- (IBAction)searchField:(id)sender {}

- (IBAction)dismissKeyboardonTapOutside:(id)sender
{
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    [self.searchField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
        [self.editView scrollToView:self.view];

        float y = self.searchFieldContainer.frame.origin.y - 120;
        [self scrollToY:y];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.view isFirstResponder]) {
        return;
    } else {
        [self.editView scrollToY:0];
        [textField resignFirstResponder];
        [self scrollToY:0];
    }
}

- (void)scrollToY:(float)y
{
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.searchFieldContainer.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ListViewController class]]) {
        self.currentUserLocation = ((ListViewController *)[segue destinationViewController]).currentUserLocation;
    }
}



@end
