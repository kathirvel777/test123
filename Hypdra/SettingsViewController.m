//
//  SettingsViewController.m
//  Montage
//
//  Created by MacBookPro on 3/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SettingsViewController.h"
#import "DEMORootViewController.h"
#import "DEMOHomeViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)logout:(id)sender
{
    
    NSLog(@"Before Logout");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogOut" object:self];
}

@end
