//
//  MemberShipTabBarController.m
//  Montage
//
//  Created by MacBookPro4 on 7/12/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MemberShipTabBarController.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"

@interface MemberShipTabBarController ()<UITabBarControllerDelegate>
{
    UINavigationController *viewController;
    
    int index;
}

@end

@implementation MemberShipTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    NSString *planType = [[NSUserDefaults standardUserDefaults]valueForKey:@"Plan"];
    if([planType isEqualToString:@"Free"]){
        self.tabBarController.selectedIndex = 0;
    }else if([planType isEqualToString:@"Standard"]){
        self.tabBarController.selectedIndex = 1;
    }else{
        self.tabBarController.selectedIndex = 2;
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
        
    }
    
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y = self.view.frame.origin.y+65;
    self.tabBar.frame = tabFrame;
}

- (void)viewDidAppear:(BOOL)animated{
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // NSLog(@"TabBar:%@", tabBarController);
    // NSLog(@"viewController:%@", viewController);
    NSLog(@"tab selected index %lu",(unsigned long)tabBarController.selectedIndex);
    
    index = (int)tabBarController.selectedIndex;
    
//    if(index==0)
//        self.navigationItem.title=@"Choose a plan";
//    else if(index==1)
//        self.navigationItem.title=@"Standard";
//    else
//        self.navigationItem.title=@"Premium";
    
   
}

- (IBAction)sideMenu:(id)sender
{     [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:@"SelectedIndex"];

    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    //
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
