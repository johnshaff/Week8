//
//  LocationController.m
//  location-reminds
//
//  Created by John Shaff on 12/6/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import "LocationController.h"

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


@end
