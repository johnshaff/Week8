//
//  DetailViewControllerTests.m
//  location-reminds
//
//  Created by John Shaff on 12/8/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DetailViewController.h"

@import CoreLocation;

@interface DetailViewControllerTests : XCTestCase


@property(strong, nonatomic) DetailViewController *viewController;

@end

@implementation DetailViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [[DetailViewController alloc]init];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.viewController.coordinate = coordinate;
}

- (void)tearDown {
    self.viewController = nil;
    

    //STAYS AT BOTTOM
    [super tearDown];
}

-(void)testCreateNewReminderWithName{
    NSString *testReminderName =@"Test Reminder Name";
    NSNumber *testRadius = [NSNumber numberWithFloat:111.11];
    
    Reminder *testReminder = [self.viewController createNewReminderWithName:testReminderName andRadius:testRadius];
    
    XCTAssertNotNil(testReminder, @"testReminder is nil");
}

@end
