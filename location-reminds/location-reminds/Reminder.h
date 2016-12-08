//
//  Reminder.h
//  location-reminds
//
//  Created by John Shaff on 12/7/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import <Parse/Parse.h>


@interface Reminder : PFObject <PFSubclassing>

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSNumber *radius;
@property(strong, nonatomic) PFGeoPoint *location;

@end
