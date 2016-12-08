//
//  ViewController.m
//  location-reminds
//
//  Created by John Shaff on 12/5/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
@import ParseUI;

#import "DetailViewController.h"
#import "LocationController.h"
#import "Reminder.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"

@import MapKit;

@interface ViewController () <MKMapViewDelegate, LocationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(strong, nonatomic) CLLocationManager *locationManager;

//@property(strong, nonatomic) UIColor *pinTintColor;

@property(strong, nonatomic) UIColor *randomColor;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    Reminder *testReminder = [Reminder object];
    testReminder.title = @"New Reminder! So Exciting!";
    [testReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        
        if (succeeded) {
            NSLog(@"Check your dashboard, cuz we just saved a reminder");
        }
        
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"%@", objects);
            }];
        }
    }];
    
    [self requestPermissions];
    [self.mapView setShowsUserLocation:YES];
    
    //SETTING THIS VIEW CONTROLLER AS AS THE DELEGATE TO THE MAPVIEW
    self.mapView.delegate = self;
    
    //SETTING THIS VIEW CONTROLLER AS THE DELEGATE TO THE LOCATION CONTROLLER
    LocationController.sharedController.delegate.self;
    
    [self gimmeDaPointsBro];
    
    [self login];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[[LocationController sharedController] manager] startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderCreatedNotificationFired) name:@"ReminderCreated" object:nil];
    
}

//NOTIFICATION SELECTOR
-(void)reminderCreatedNotificationFired{
    NSLog(@"Reminder was Created! Log fired from %@", self);
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReminderCreated" object:nil];
}


-(void)requestPermissions{
    [self setLocationManager:[[CLLocationManager alloc]init]];
    
    //this was stored in our infoplist
    [self.locationManager requestWhenInUseAuthorization];
}



//- (IBAction)setLocationPressed:(id)sender {
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566, -122.351096);
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
//    
//    [self.mapView setRegion:region animated:YES];
//}



-(void)gimmeDaPointsBro{
    
    CLLocationCoordinate2D olympia = CLLocationCoordinate2DMake(47.085787, -122.742298);
    MKPointAnnotation *olympiaMapPoint = [[MKPointAnnotation alloc]init];
    olympiaMapPoint.coordinate = olympia;
    olympiaMapPoint.title = @"My Olympia House";
//    [self randomAssColors];
    [self.mapView addAnnotation:olympiaMapPoint];


    CLLocationCoordinate2D seattle = CLLocationCoordinate2DMake(47.619927, -122.358452);
    MKPointAnnotation *seattleMapPoint = [[MKPointAnnotation alloc]init];
    seattleMapPoint.coordinate = seattle;
    olympiaMapPoint.title = @"My Seattle Apartment";
//    [self randomAssColors];
    [self.mapView addAnnotation:seattleMapPoint];

    CLLocationCoordinate2D losAngeles = CLLocationCoordinate2DMake(34.145215, -118.613893);
    MKPointAnnotation *losAngelesMapPoint = [[MKPointAnnotation alloc]init];
    losAngelesMapPoint.coordinate = losAngeles;
    olympiaMapPoint.title = @"My Los Angeles House";
//    [self randomAssColors];
    [self.mapView addAnnotation:losAngelesMapPoint];

}



-(void)randomAssColors{
    
    uint32_t randomNumber1 = arc4random_uniform(255);
    uint32_t randomNumber2 = arc4random_uniform(255);
    uint32_t randomNumber3 = arc4random_uniform(255);
    
    NSNumber *random1 = [NSNumber numberWithInt:randomNumber1];
    NSNumber *random2 = [NSNumber numberWithInt:randomNumber2];
    NSNumber *random3 = [NSNumber numberWithInt:randomNumber3];
    
    float red = random1.floatValue / 255;
    float green = random2.floatValue / 255;
    float blue = random3.floatValue / 255;
    
    self.randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}



- (IBAction)mapLongPressed:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newMapPoint = [[MKPointAnnotation alloc]init];
        newMapPoint.title = @"New Location!";
        newMapPoint.coordinate = touchMapCoordinate;

        [self.mapView addAnnotation:newMapPoint];
    }
}

//MARK: locationControllerDelegate

-(void)locationControllerUpdatedLocation:(CLLocation *)location{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
    
    [self.mapView setRegion:region];
    
}

//MARK: MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    
    
    //This will assign it either way whether its been created in memory or not.
    
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    UIButton *rightCalloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    annotationView.rightCalloutAccessoryView = rightCalloutButton;
    [self randomAssColors];
    annotationView.pinTintColor = self.randomColor;
    // in this method I will call the function that gives me a random color for a the pin tint color
    
    
    return annotationView;
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //the view is the litte i on the callout box
    [self performSegueWithIdentifier:@"DetailViewController" sender:view];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        if ([sender isKindOfClass:[MKPinAnnotationView class]]) {
            
            // The star on the inside of the parenthesis is casting sender as that type
            MKPinAnnotationView *annotationView = (MKPinAnnotationView *) sender;
            
            DetailViewController *detailViewController = segue.destinationViewController;
            
            detailViewController.annotationTitle = annotationView.annotation.title;
            detailViewController.coordinate = annotationView.annotation.coordinate;
            
            __weak typeof(self) bruceBanner = self;
            
            detailViewController.completion = ^(MKCircle *circle) {
                
                __strong typeof(bruceBanner) hulk = bruceBanner;
                [hulk.mapView removeAnnotation:annotationView.annotation];
                [hulk.mapView addOverlay:circle];
                
            };
        }
    }
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    renderer.fillColor = [UIColor blueColor];
    renderer.strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.25];
//    renderer.alpha = 0.5;
    return renderer;
}



//MARK: PARSE UI

-(void)login{
    if (![PFUser currentUser]) {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        loginViewController.delegate = self;
        loginViewController.signUpController.delegate = self;
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else {
        [self setupAdditionalUI];
    }
}

-(void)setupAdditionalUI{
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutPressed)];
    
    self.navigationItem.leftBarButtonItem = signOutButton;
}

-(void)signOutPressed{
    [PFUser logOut];
    [self login];
}


//MARK: Parse Delegate Methods

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self setupAdditionalUI];

}




@end
