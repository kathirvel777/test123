//
//  AlbumTabViewController.m
//  Montage
//
//  Created by MacBookPro on 4/28/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "AlbumTabViewController.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"

@interface AlbumTabViewController () <UITabBarControllerDelegate>

@end

@implementation AlbumTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@""];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"NavigationFromWizardToAlbum"]){
        
        self.selectedIndex = 1;
    }
    
    NSLog(@"Height = %f",self.navigationController.navigationBar.frame.size.height);
    
    NSLog(@"Y = %f",self.tabBar.frame.size.height+15);
    
    NSLog(@"Y = %f",statusBarHeight);
    
    NSLog(@"Bar Frame");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y = self.view.frame.origin.y+65;
    self.tabBar.frame = tabFrame;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sideMenu:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"SelectedIndex"];

    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    //Present the view controller
    
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)back:(id)sender
{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc1 animated:YES completion:nil];
    
}

- (IBAction)delete:(id)sender {
    
    if ([_vc isEqualToString:@"Advance"])
    {
        
        NSLog(@"Third");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postAdvanceAlbumDelete" object:nil];
        
    }
    else if ([_vc isEqualToString:@"wizard"])
    {
        
        NSLog(@"Second");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postWizardAlbumDelete" object:nil];
        
        
    }
    
}
@end

