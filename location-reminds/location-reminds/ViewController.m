//
//  ViewController.m
//  location-reminds
//
//  Created by John Shaff on 12/5/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@import MapKit;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(strong, nonatomic) CLLocationManager *locationManager;



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

- (IBAction)showLA:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(34.145215, -118.613893);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
    
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)showSeattle:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.619927, -122.358452);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
    
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)showOlympia:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.085787, -122.742298);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
    
    [self.mapView setRegion:region animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
