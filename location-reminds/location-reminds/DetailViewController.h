//
//  DetailViewController.h
//  location-reminds
//
//  Created by John Shaff on 12/6/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

#import <Parse/Parse.h>
@import MapKit;

typedef void(^DetailViewControllerCompletion)(MKCircle *circle);

@interface DetailViewController : UIViewController

@property(strong, nonatomic) NSString *annotationTitle;
@property(nonatomic) CLLocationCoordinate2D coordinate;

@property(copy, nonatomic) DetailViewControllerCompletion completion;


-(Reminder *)createNewReminderWithName:(NSString *)name andRadius:(NSNumber *)radius;


@end
