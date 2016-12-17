//
//  LocationController.m
//  location-reminds
//
//  Created by John Shaff on 12/6/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import "LocationController.h"

@import NotificationCenter;

@interface LocationController () <CLLocationManagerDelegate>

@end


@implementation LocationController


+(instancetype)sharedController{
    
    static LocationController *sharedController;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[LocationController alloc]init];
    });
    
    return sharedController;
}



-(instancetype)init{
    self = [super init];
    
    if (self) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 100;
        
        [_manager requestAlwaysAuthorization];
        
    }
    
    return self;
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self setLocation:locations.lastObject];
    [self.delegate locationControllerUpdatedLocation:locations.lastObject];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Started Monitoring Region for : %@", region);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"USER DID ENTER REGION!! NO BUG!! %@", region);
}


//ERROR HANDLING

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Error");
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error");
    
}

-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    NSLog(@"Error");

}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
}

@end
