//
//  AdvanceTabViewController.m
//  Montage
//
//  Created by MacBookPro4 on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AdvanceTabViewController.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"

@interface AdvanceTabViewController ()<UITabBarControllerDelegate>
{
    UINavigationController *viewController;
    
    int index;
}

@end

@implementation AdvanceTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Advance Tab Loaded");
    
    self.delegate = self;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.tabBar.frame=CGRectMake(0, self.tabBar.frame.origin.y+self.tabBar.frame.size.height-20, self.tabBar.frame.size.width,statusBarHeight);
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"FuturaT-Book" size:16.0]} forState:UIControlStateNormal];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y = self.view.frame.origin.y+65;
    self.tabBar.frame = tabFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"tab selected index %lu",(unsigned long)tabBarController.selectedIndex);
    
    index = (int)tabBarController.selectedIndex;
}


- (IBAction)sideMenu:(id)sender
{
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(IBAction)Back:(id)sender
{
    NSString *option=[[NSUserDefaults standardUserDefaults]objectForKey:@"isWizardOrAdvance"];
    NSLog(@"Wizard Option:%@",option);
    
    if([option isEqualToString:@"Wizard"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
        [vc awakeFromNib:@"contentController_6" arg:@"menuController"];
    
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CreateNewFinalDic"];
    }
}


- (IBAction)done:(id)sender
{
    NSLog(@"tab selected index %d",index);
    if(index == 0)
    {
        NSLog(@"First");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"galleryImage" object:nil];
        
    }
    if (index == 1)
    {
        NSLog(@"Second");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"galleryVideo" object:nil];
        
    }

}
@end
