//
//  Reminder.m
//  location-reminds
//
//  Created by John Shaff on 12/7/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

@dynamic title;
@dynamic radius;
@dynamic location;


//THIS WILL BE THE CLASS NAME IN PARSE
+(NSString *)parseClassName {
    return @"Reminder";
}

+(void)load{
    [self registerSubclass];
}



@end
