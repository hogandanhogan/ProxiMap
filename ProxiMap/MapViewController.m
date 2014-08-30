//
//  ViewController.m
//  ProxiMap
//
//  Created by Patrick Hogan on 8/21/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "MapViewController.h"
#import "CurrentUserAnn.h"
#import <MapKit/MapKit.h>
#import "LoginViewController.h"

@interface MapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property CLLocation *currentUserlocation;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property CurrentUserAnn *cUPoint;


@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];

    _editView.hidden = YES;
    _editView.layer.cornerRadius = 10;
    _editView.layer.masksToBounds = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        LoginViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"showLogin"];
        [self.navigationController pushViewController:lvc animated:YES];
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    [_locationManager startUpdatingLocation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView
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
    [_locationManager stopUpdatingLocation];
    _currentUserlocation = [locations lastObject];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_currentUserlocation.coordinate, 250, 250);
    [_mapView setRegion:region];
    
    _cUPoint = [[CurrentUserAnn alloc] init];
    _cUPoint.coordinate = self.currentUserlocation.coordinate;
    _cUPoint.title = @"Create a title";
    _cUPoint.subtitle = @"Add a description";

    [_mapView addAnnotation:_cUPoint];
    

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)mapView:(MKMapView *)mapView
annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    [UIView animateWithDuration:0.15 animations:^(void) {
        _editView.hidden = NO;
        _editView.alpha = 0;
        _editView.alpha = 0.90;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)onCancelEditView:(id)sender
{
    [_titleField resignFirstResponder];
    [_descriptionField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^(void) {
        _editView.alpha = 0.9;
        _editView.alpha = 0;
    } completion:^(BOOL finished) {
        _editView.hidden = YES;
    }];
}

- (IBAction)onSaveEditView:(id)sender
{
    [_titleField resignFirstResponder];
    [_descriptionField resignFirstResponder];
    _cUPoint.title = _titleField.text;
    _cUPoint.subtitle = _descriptionField.text;
    [UIView animateWithDuration: 1.0 animations:^(void) {
        _editView.alpha = 0.9;
        _editView.alpha = 0;
    } completion:^(BOOL finished) {
        _editView.hidden = YES;
    }];
}

- (IBAction)titleField:(id)sender
{

}

- (IBAction)descriptionField:(id)sender
{

}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
}

@end
