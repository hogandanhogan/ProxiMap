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
#import "SettingsView.h"
#import "ParseDataHandler.h"
#import "ListViewController.h"
#import "PMColor.h"

@interface MapViewController () <CLLocationManagerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet EditView *editView;
@property (weak, nonatomic) IBOutlet SettingsView *settingsView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (nonatomic) ParseDataHandler *parseDataHandler;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchFieldContainer;
@property (nonatomic) CLLocationManager *locationManager;
@property UIImagePickerController *imagePicker;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imagePicker = [UIImagePickerController new];
    self.imagePicker.delegate = self;
    self.imagePicker.navigationController.delegate = self;

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

    UIButton *rightButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"menu51.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onRightBarButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setFrame:CGRectMake(-2, 2, 22, 18)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    UIButton *leftButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onLeftBarButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setFrame:CGRectMake(0, 0, 18, 18)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
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

#pragma mark - Image Picker Controller Delegate

+(BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)
UIImagePickerControllerSourceTypePhotoLibrary
{
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.settingsView.picImageView.image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
    }];
}

- (void) navigationController: (UINavigationController *) navigationController  willShowViewController: (UIViewController *) viewController animated: (BOOL) animated
{
    self.imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showCamera:)];
        button.tintColor = [PMColor whiteColor];
        viewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:button];
    } else {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Library" style:UIBarButtonItemStylePlain target:self action:@selector(showLibrary:)];
  UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reverseCamera:)];
        button.tintColor = [PMColor whiteColor];
        rightButton.tintColor = [PMColor whiteColor];
        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:button];
        viewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:rightButton];
        viewController.navigationItem.title = @"Take Photo";
        viewController.navigationController.navigationBarHidden = NO;
    }
}

- (void)reverseCamera: (id) sender
{
    [UIView transitionWithView:self.imagePicker.view
                      duration:1.0
                       options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        if ( self.imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear )
                            self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                        else
                            self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                    } completion:NULL];
}

- (void) showCamera: (id) sender
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
}

- (void) showLibrary: (id) sender
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

#pragma mark - Action Handlers

- (IBAction)onAddPic:(id)sender
{

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)onSaveSettingsView:(id)sender
{
    NSData *fileData = UIImagePNGRepresentation(self.settingsView.picImageView.image);
    NSString *fileName = @"image.png";
    NSString *fileType = @"image";

    PFFile *file = [PFFile fileWithName:fileName data:fileData];

    if (!self.post) {
        self.post = [PFObject objectWithClassName:@"Post"];
    }

    self.post[@"file"] = file;
    self.post[@"fileType"] = fileType;

    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"An error occurred"
                                        message:@"Please try again"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
        }
    }];
    
    self.settingsView.hidden = YES;
}

- (IBAction)onCancelSettingsView:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.settingsView.alpha = 1.0;
        self.settingsView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.settingsView.hidden = YES;
    }];
}

- (IBAction)onCancelEditView:(id)sender
{
    [self.titleField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
    [self.editView scrollToY:-149.0f];
}
- (IBAction)onLeftBarButtonSelected:(id)sender
{
    [UIView animateWithDuration:0.15 animations:^(void) {
        self.settingsView.hidden = NO;
        self.settingsView.alpha = 0.0;
        self.settingsView.alpha = 1.0;
    } completion:nil];
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

    if (!self.post) {
        self.post = [PFObject objectWithClassName:@"Post"];
    }
    self.post[@"title"] = self.cUPoint.title;
    self.post[@"subtitle"] = self.cUPoint.subtitle;
    self.post[@"location"] = self.point;

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
