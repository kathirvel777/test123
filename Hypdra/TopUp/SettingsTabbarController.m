//
//  SettingsTabbarController.m
//  Montage
//
//  Created by MacBookPro on 7/27/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SettingsTabbarController.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"

@interface SettingsTabbarController ()<UITabBarControllerDelegate>

@end

@implementation SettingsTabbarController

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    self.delegate = self;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.tabBar.frame=CGRectMake(0, self.tabBar.frame.size.height+15, self.tabBar.frame.size.width,statusBarHeight);
    
    self.settingTabbar.barTintColor = [self colorFromHexString:@"#409FE9"];
    
    //    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    //    [[UITabBar appearance] setBarTintColor:[self colorFromHexString:@"#409FE9"]];
    
    self.settingTabbar.tintColor = [UIColor whiteColor];


}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (IBAction)menu:(id)sender
{
    [self.view endEditing:YES];
        
    [self.frostedViewController.view endEditing:YES];
        
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    [self.frostedViewController presentMenuViewController];
        
}
    
- (IBAction)back:(id)sender
{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
        
}

@end
