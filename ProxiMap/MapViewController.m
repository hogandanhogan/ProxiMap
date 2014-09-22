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

    self.parseDataHandler = [[ParseDataHandler alloc] init];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboardonTapOutside:)];
    [self.view addGestureRecognizer:tap];

    self.titleField.delegate = self;
    self.descriptionField.delegate = self;

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

    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(onLeftBarButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(0, 0, 18, 18)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.parseDataHandler queryPosts];
    for (PFObject *post in self.parseDataHandler.posts) {
        PFGeoPoint *point = [post objectForKey:@"location"];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = point.latitude;
        coordinate.longitude = point.longitude;
        MKPointAnnotation *postPoint = [MKPointAnnotation new];
        postPoint.coordinate = coordinate;
        postPoint.title = [post objectForKey:@"title"];
        postPoint.subtitle = [post objectForKey:@"subtitle"];
        [self.mapView addAnnotation:postPoint];
    }
    
    [self.mapView reloadInputViews];

    [self.navigationController.navigationBar setHidden:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinLabel = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pinLabel.canShowCallout = YES;
    pinLabel.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    if([annotation isKindOfClass:[CurrentUserAnnotation class]]) {
        pinLabel.pinColor = MKPinAnnotationColorGreen;
    }
    return pinLabel;

}

#pragma mark CLLocation Mangager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.currentUserLocation = [locations lastObject];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentUserLocation.coordinate, 250, 250);
    [_mapView setRegion:region];
    
    self.cUPoint = [[CurrentUserAnnotation alloc] init];
    self.cUPoint.coordinate = self.currentUserLocation.coordinate;
    self.cUPoint.title = @"Create a post";
    self.cUPoint.subtitle = @"Add a description";

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
    float y = self.view.frame.origin.y + 213.0f;
    [self.editView scrollToY:y];
    [self.titleField becomeFirstResponder];
}

- (IBAction)onCancelEditView:(id)sender
{
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    [self.editView scrollToY:-149.0f];
}
- (IBAction)onLeftBarButtonSelected:(id)sender
{

}
- (IBAction)onRightBarButtonSelected:(id)sender
{
    ListViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"listVC"];
    self.currentUserLocation = lvc.currentUserLocation;
    lvc.parseDataHandler = self.parseDataHandler;
    [self.navigationController pushViewController:lvc animated:YES];
}

- (IBAction)onSaveEditView:(id)sender
{
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    self.cUPoint.title = self.titleField.text;
    self.cUPoint.subtitle = self.descriptionField.text;

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

    [self.editView scrollToY:-149.0f];

}

- (IBAction)titleField:(id)sender{}
- (IBAction)descriptionField:(id)sender{}
- (IBAction)searchField:(id)sender {}

-(IBAction)dismissKeyboardonTapOutside:(id)sender
{
    [self.searchField resignFirstResponder];
}

@end
