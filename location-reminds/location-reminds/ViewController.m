//
//  ViewController.m
//  location-reminds
//
//  Created by John Shaff on 12/5/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "DetailViewController.h"
#import "LocationController.h"

@import MapKit;

@interface ViewController () <MKMapViewDelegate, LocationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(strong, nonatomic) CLLocationManager *locationManager;

@property(strong, nonatomic) UIColor *pinTintColor;

@property(strong, nonatomic) UIColor *randomColor;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    
//    testObject[@"foo"] = @"bar";
//    
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%", error.localizedDescription);
//            return;
//        }
//        
//        if (succeeded) {
//            NSLog(@"Successfully saved testObject");
//        }
//    }];
    
    
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

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[[LocationController sharedController] manager] startUpdatingLocation];
    
}

-(void)requestPermissions{
    [self setLocationManager:[[CLLocationManager alloc]init]];
    
    //this was stored in our infoplist
    [self.locationManager requestWhenInUseAuthorization];
}



- (IBAction)setLocationPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.6566, -122.351096);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    
    [self.mapView setRegion:region animated:YES];
}


//- (IBAction)showLA:(id)sender {
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(34.145215, -118.613893);
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
//    
//    [self.mapView setRegion:region animated:YES];
//    
//}
//
//- (IBAction)showSeattle:(id)sender {
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.619927, -122.358452);
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
//    
//    [self.mapView setRegion:region animated:YES];
//    
//}
//
//- (IBAction)showOlympia:(id)sender {
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.085787, -122.742298);
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
//    
//    [self.mapView setRegion:region animated:YES];
//    
//}



-(void)gimmeDaPointsBro{
    CLLocationCoordinate2D olympia = CLLocationCoordinate2DMake(47.085787, -122.742298);
    MKPointAnnotation *olympiaMapPoint = [[MKPointAnnotation alloc]init];
    olympiaMapPoint.coordinate = olympia;
    olympiaMapPoint.title = @"My Olympia House";
    [self randomAssColors];
    [self.mapView addAnnotation:olympiaMapPoint];


    CLLocationCoordinate2D seattle = CLLocationCoordinate2DMake(47.619927, -122.358452);
    MKPointAnnotation *seattleMapPoint = [[MKPointAnnotation alloc]init];
    seattleMapPoint.coordinate = seattle;
    olympiaMapPoint.title = @"My Seattle Apartment";
    [self randomAssColors];
    [self.mapView addAnnotation:seattleMapPoint];

    CLLocationCoordinate2D losAngeles = CLLocationCoordinate2DMake(34.145215, -118.613893);
    MKPointAnnotation *losAngelesMapPoint = [[MKPointAnnotation alloc]init];
    losAngelesMapPoint.coordinate = losAngeles;
    olympiaMapPoint.title = @"My Los Angeles House";
    [self randomAssColors];
    [self.mapView addAnnotation:losAngelesMapPoint];

    
    
}

-(void)randomAssColors{
    
    uint32_t randomNumber1 = arc4random_uniform(255);
    uint32_t randomNumber2 = arc4random_uniform(255);
    uint32_t randomNumber3 = arc4random_uniform(255);

    
    
    float red = randomNumber1 / 255;
    float green = randomNumber2 / 255;
    float blue = randomNumber3 / 255;
    
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
    annotationView.pinTintColor = _randomColor;
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
        }
    }
}

@end
