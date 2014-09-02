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

@interface MapViewController () <CLLocationManagerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet EditView *editView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (nonatomic) ParseDataHandler *parseDataHandler;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchFieldContainer;


@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleField.delegate = self;
    self.descriptionField.delegate = self;
    
    self.parseDataHandler = [ParseDataHandler new];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboardonTapOutside:)];
    [self.view addGestureRecognizer:tap];

    _editView.hidden = YES;
    _editView.layer.cornerRadius = 10;
    _editView.layer.masksToBounds = YES;
    
    self.currentUser = [PFUser currentUser];
    if (!self.currentUser) {
        LoginViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"showLogin"];
        [self.navigationController pushViewController:lvc animated:YES];
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    [_locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
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
    _cUPoint.title = @"Update your title";
    _cUPoint.subtitle = @"Update your description";

    [_mapView addAnnotation:_cUPoint];
    

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [UIView animateWithDuration:0.15 animations:^(void) {
        _editView.hidden = NO;
        _editView.alpha = 0;
        _editView.alpha = 0.90;
    } completion:^(BOOL finished) {
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.editView.frame, point)) {
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^(void) {
            _editView.alpha = 0.9;
            _editView.alpha = 0;
        } completion:^(BOOL finished) {
            _editView.hidden = YES;
        }];
    }

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
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    self.cUPoint.title = self.titleField.text;
    self.cUPoint.subtitle = self.descriptionField.text;
    
    [self.parseDataHandler saveToParse];
    
    [UIView animateWithDuration: 1.0 animations:^(void) {
        _editView.alpha = 0.9;
        _editView.alpha = 0;
    } completion:^(BOOL finished) {
        _editView.hidden = YES;
    }];
}

- (IBAction)titleField:(id)sender{}
- (IBAction)descriptionField:(id)sender{}
- (IBAction)searchField:(id)sender {
}

- (IBAction)dismissKeyboardonTapOutside:(id)sender
{
    [_titleField resignFirstResponder];
    [_descriptionField resignFirstResponder];
    [_searchField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.editView scrollToView:self.view];
    
    float y = self.searchFieldContainer.frame.origin.y - 120;
    [self scrollToY:y];
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.editView scrollToY:0];
    [textField resignFirstResponder];
    [self scrollToY:0];
}

-(void)scrollToY:(float)y
{
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.searchFieldContainer.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
}



@end
