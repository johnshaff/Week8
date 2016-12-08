//
//  DetailViewController.m
//  location-reminds
//
//  Created by John Shaff on 12/6/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminder.h"
#import "LocationController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Annotation [With Title:%@ - Lat:%3f, Long:%3f", self.annotationTitle, self.coordinate.latitude, self.coordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)saveReminderPressed:(UIButton *)sender {
    
    NSString *reminderTitle = @"New Reminder";
    NSNumber *radius = [NSNumber numberWithFloat:100.0];
    
    Reminder *newReminder = [Reminder object];
    newReminder.title = reminderTitle;
    newReminder.radius = radius;
    
    PFGeoPoint *reminderPoint = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    newReminder.location = reminderPoint;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReminderCreated" object:nil];
    
    if(self.completion) {
        MKCircle *newCircle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius.floatValue];
        self.completion(newCircle);
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}



@end
