//
//  WizardTabViewController.m
//  Hypdra
//
//  Created by MacBookPro on 7/25/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "WizardTabViewController.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"
@import GoogleMobileAds;


@interface WizardTabViewController ()<UITabBarControllerDelegate>
{
    int index;
    BOOL isFirst;


}
@end

@implementation WizardTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.tabBar.frame=CGRectMake(0, self.tabBar.frame.origin.y+self.tabBar.frame.size.height-20, self.tabBar.frame.size.width,statusBarHeight);
    

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y = self.view.frame.origin.y+65;
    
    self.tabBar.frame = tabFrame;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"tab selected index %lu",(unsigned long)tabBarController.selectedIndex);
    
    index = (int)tabBarController.selectedIndex;
}

-(IBAction)Back:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"wizardGalleryImg"];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    //    CGRect tabFrame = self.tabBar.frame;
//    //    tabFrame.origin.y = self.view.frame.origin.y+65;
//    //    self.tabBar.frame = tabFrame;
//    
//    if(isFirst)
//    {
//        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
//            CGRect tabFrame = self.tabBar.frame;
//            //        //tabFrame.origin.y = self.view.frame.origin.y-44;
//            //        //  self.tabBar.frame = tabFrame;
//            
//            tabFrame.origin.y = tabFrame.origin.y - 48;
//            self.tabBar.frame = tabFrame;
//            isFirst=NO;
//            
//            //  bview=[[UIView alloc]initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y+self.tabBar.frame.size.height, self.tabBar.frame.size.width,44)];
//            //bview.backgroundColor=[UIColor blueColor];
//            
//            self.bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
//            
//            bview=[[UIView alloc]initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y+self.tabBar.frame.size.height, self.tabBar.frame.size.width,50)];
//            
//            self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
//            
//            //@"ca-app-pub-3940256099942544/2934735716";
//            
//            self.bannerView.rootViewController = self;
//            GADRequest *request = [GADRequest request];
//            
//            request.testDevices = @[ kGADSimulatorID , @"a78336ddc8e01915e84e7454e395adf9"];
//            [self.bannerView loadRequest:request];
//            self.bannerView.center=CGPointMake(bview.frame.size.width/2,bview.frame.size.height/2);
//            
//            [bview addSubview:_bannerView];
//            [self.view addSubview:bview];
//            
//        }
//    }
//    
//}
- (IBAction)sideMenu:(id)sender
{
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)done:(id)sender
{
    if(index == 0)
    {
        NSLog(@"First");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wizardImg" object:nil];
        
    }
    
    if(index == 1)
    {
        NSLog(@"Second");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wizardVid" object:nil];
        
    }
}

@end
