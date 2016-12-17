//
//  LoginViewController.m
//  location-reminds
//
//  Created by John Shaff on 12/7/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *newLogo = [[UIImageView alloc]initWithFrame:self.logInView.logo.frame];
    newLogo.image = [UIImage imageNamed:@"vectoriousDYT03.jpg"];

    self.logInView.logo = nil;
    self.logInView.backgroundColor = [UIColor redColor];
    

}



@end
