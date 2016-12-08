//
//  LocationController.h
//  location-reminds
//
//  Created by John Shaff on 12/6/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

//DOESN'T NEED TO BE IN ANOTHER FILE
@protocol LocationControllerDelegate <NSObject>

@required

-(void)locationControllerUpdatedLocation:(CLLocation *)location;

@optional

@end



@interface LocationController : NSObject

//WHEN WE CREATE A PROPERTY IN THE HEADER IT AUTOMATICALLY CREATES (1) AN UNDERLYING INSTANCE VARIABLE (2) SETMANAGER (3) GETMANAGER
@property(strong, nonatomic) CLLocationManager *manager;
@property(strong, nonatomic) CLLocation *location;

//BY DECLARING A DELEGATE PROPERTY WE KNOW WHERE GOING USE THIS CLASS AS THE DELEGATE, WHICH IS ESSENTIALLY AN IMPLIMENTED VERSION OF THE PROTOCAL, WHICH WE THEN ALLOW ALL ID'S TO USE, AS LONG AS THEY CONFORM TO THE SAME PROTOCAL

@property(weak, nonatomic) id<LocationControllerDelegate> delegate;

+(instancetype)sharedController;


@end
