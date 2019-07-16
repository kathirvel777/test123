//
//  CallToActionTabViewController.m
//  Montage
//
//  Created by MacBookPro on 6/28/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "CallToActionTabViewController.h"
#import "REFrostedViewController.h"
#import "MyPlayerViewController.h"
#import "CallToActionPlayerController.h"
#import "CallToActionCollectionViewController.h"
#import "CallToActionCollectionViewController.h"


@interface CallToActionTabViewController ()
{
    
}

@end

@implementation CallToActionTabViewController

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainMenu:)
                                                 name:@"callToAction" object:nil];
    
    [super viewDidLoad];
    
    self.delegate = self;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //  self.tabBar.frame=CGRectMake(0, self.tabBar.frame.size.height+15, self.tabBar.frame.size.width,statusBarHeight);
    
    NSLog(@"Height = %f",self.navigationController.navigationBar.frame.size.height);
    
    NSLog(@"Y = %f",self.tabBar.frame.size.height+15);
    
    NSLog(@"Y = %f",statusBarHeight);
    [[UITabBarItem appearance]setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"FuturaT-Book" size:16.0]} forState:UIControlStateNormal];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"popToMyPlayer"] isEqualToString:@"popToMyPlayer"])
    {
        self.selectedIndex=2;
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y = self.view.frame.origin.y+65;
    self.tabBar.frame = tabFrame;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"popToMyPlayer"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMainMenu:(NSNotification *)note
{
    [self.doneOutlet setTintColor:[UIColor whiteColor]];
    [self.doneOutlet setEnabled:YES];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"tab selected index %lu",(unsigned long)tabBarController.selectedIndex);
    
    _index = (int)tabBarController.selectedIndex;
    
    if (_index == 0)
    {
        [self.doneOutlet setTintColor:[UIColor clearColor]];
        [self.doneOutlet setEnabled:NO];
        
    }
    else if (_index == 1)
    {
        [self.doneOutlet setTintColor:[UIColor clearColor]];
        [self.doneOutlet setEnabled:NO];
        
    }
    else if (_index == 2)
    {
        [self.doneOutlet setTintColor:[UIColor clearColor]];
        [self.doneOutlet setEnabled:NO];
    }
}

- (IBAction)Back:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyPlayerViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MyPlayer"];
    NSString *rID = [[NSUserDefaults standardUserDefaults] valueForKey:@"randomID"];
    NSString *pID = [[NSUserDefaults standardUserDefaults]valueForKey:@"playerID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    vc.playerURL = rID;
    vc.paymentResult = pID;
    
    //[self.navigationController pushViewController:vc animated:YES];
    
        [self.navigationController popToViewController:vc animated:YES];

    NSLog(@"Play Video = %@",rID);
    
}

- (IBAction)sideMenu:(id)sender
{
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)Done:(id)sender
{
    _index = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"SelectedIndex"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SaveToCollection" object:nil];
    
    /* UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
     //CallToActionCollectionViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"Call to action"];
     
     CallToActionTabViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"Call to action"];
     
     vc.selectedIndex=2;
     
     [self.navigationController pushViewController:vc animated:YES];
     */
    
    // }
}
@end

