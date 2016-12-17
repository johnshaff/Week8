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

@import UserNotifications;
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
    
    
    Reminder *reminder = [self createNewReminderWithName:reminderTitle andRadius:radius];
    

    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReminderCreated" object:nil];
    
    if(self.completion) {
        MKCircle *newCircle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius.floatValue];
        self.completion(newCircle);
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    __weak typeof(self) bruceBanner = self;
    
    [reminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        __strong typeof(bruceBanner) hulk = bruceBanner;
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            
        } else {
            NSLog(@"Save Reminder to Parse Success: %i", succeeded);
            
            if (hulk.completion) {
                
                if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:hulk.coordinate radius:radius.floatValue identifier:reminderTitle];
                    
                    [[LocationController sharedController].manager startMonitoringForRegion:region];
                    
                    [hulk createNotificationForRegion:region withName:reminderTitle];
                }
                
                MKCircle *newCircle = [MKCircle circleWithCenterCoordinate:hulk.coordinate radius:radius.floatValue];
                hulk.completion(newCircle);
                
                [hulk.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }];
    
}

-(Reminder *)createNewReminderWithName:(NSString *)name andRadius:(NSNumber *)radius{
    
    Reminder *newReminder = [Reminder object];
    newReminder.title = name;
    newReminder.radius = radius;
    PFGeoPoint *reminderPoint = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];

    newReminder.location = reminderPoint;

    return newReminder;
}

-(void)createNotificationForRegion:(CLRegion *)region withName:(NSString *)reminderName {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"Location Reminder";
    content.body = reminderName;
    content.sound = [UNNotificationSound defaultSound];
    
    //All kinds of triggers: region, calendar, timer, server push... we're using region
//    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:7.0 repeats:YES];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:reminderName content:content trigger:trigger];
    
    //This is getting a reference to the shared center which is the singleton where the notifications a stored
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    //This adds our request to the singleton which is the noticication center
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error Adding Notification with Error: %@", error.localizedDescription);
        }
    }];
}





@end
