//
//  TabBarViewController.m
//  Montage
//
//  Created by MacBookPro4 on 4/22/17.
//  Copyright © 2017 sssn. All rights reserved.


#import "TabBarViewController.h"
#import "REFrostedViewController.h"
#import "DEMORootViewController.h"
@import GoogleMobileAds;

@interface TabBarViewController ()<UITabBarControllerDelegate,GADBannerViewDelegate>
{
    UINavigationController *viewController;
    int index;
    BOOL isFirst;
    UIView *bview;
}

@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation TabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirst=YES;

    self.delegate = self;
    [self.navigationController.navigationBar setShadowImage:[UIImage alloc]]
    ;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    

    NSLog(@"Height = %f",self.navigationController.navigationBar.frame.size.height);
    NSLog(@"Y = %f",self.tabBar.frame.size.height+15);
    
    NSLog(@"Y = %f",statusBarHeight);
    NSLog(@"Bar Frame");
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"FuturaT-Book" size:16.0]} forState:UIControlStateNormal];
    
    NSString *videoIndex = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"videoIndex"];
    
    if([videoIndex isEqualToString:@"videoPage"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"videoIndex"];
        self.selectedIndex=1;
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    CGRect tabFrame = self.tabBar.frame;
//    tabFrame.origin.y = self.view.frame.origin.y+65;
//    self.tabBar.frame = tabFrame;
    
    if(isFirst)
    {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        CGRect tabFrame = self.tabBar.frame;
//        //tabFrame.origin.y = self.view.frame.origin.y-44;
//        //  self.tabBar.frame = tabFrame;

        tabFrame.origin.y = tabFrame.origin.y - 48;
        self.tabBar.frame = tabFrame;
        isFirst=NO;

//  bview=[[UIView alloc]initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y+self.tabBar.frame.size.height, self.tabBar.frame.size.width,44)];
//bview.backgroundColor=[UIColor blueColor];
    
    self.bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    
    bview=[[UIView alloc]initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y+self.tabBar.frame.size.height, self.tabBar.frame.size.width,50)];
    
            self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
           // self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
            self.bannerView.rootViewController = self;
            GADRequest *request = [GADRequest request];
            //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
            request.testDevices = nil;

    [self.bannerView loadRequest:request];
    self.bannerView.center=CGPointMake(bview.frame.size.width/2,bview.frame.size.height/2);
    
    [bview addSubview:_bannerView];
    [self.view addSubview:bview];

        }
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
       // self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
        request.testDevices = nil;

    [self.bannerView loadRequest:request];
    [bview addSubview:_bannerView];
    [self.view addSubview:bview];
    }
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    //    [self addBannerViewToView:self.bannerView];
    //
    //    adView.alpha = 0;
    //    [UIView animateWithDuration:1.0 animations:^{
    //        adView.alpha = 1;
    //    }];
}

/// Tells the delegate an ad request failed.

- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {

    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"videoIndex"];
}
/*
- (IBAction)tappedRightButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
    
    CATransition *anim= [CATransition animation];
    [anim setType:kCATransitionPush];
    [anim setSubtype:kCATransitionFromRight];
    [anim setDuration:1];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                             kCAMediaTimingFunctionEaseIn]];
    
    [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
    
}

- (IBAction)tappedLeftButton:(id)sender
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex - 1];
    
    CATransition *anim= [CATransition animation];
    [anim setType:kCATransitionPush];
    [anim setSubtype:kCATransitionFromRight];
    [anim setDuration:1];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                             kCAMediaTimingFunctionEaseIn]];
    
    [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // NSLog(@"TabBar:%@", tabBarController);
    // NSLog(@"viewController:%@", viewController);
    NSLog(@"tab selected index %lu",(unsigned long)tabBarController.selectedIndex);
    
    index = (int)tabBarController.selectedIndex;


//    if(tabBarController.selectedIndex==0)
//    {
//        
//    }
//    else if (tabBarController.selectedIndex==1)
//    {
//        
//    }

}

- (IBAction)sideMenu:(id)sender
{
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

- (IBAction)AddAssets:(id)sender
{
    if (index == 0)
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"DeleteMode"]){
            
            NSLog(@"Third");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postDelete" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postImage" object:nil];
        }
     }
    
    else if (index == 1)
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"DeleteMode"]){
        NSLog(@"Second");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postVideoDelete" object:nil];
        }else{
            NSLog(@"First");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postVideo" object:nil];
        }
    }
    else if (index == 2)
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"DeleteMode"]){
            
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postMusic" object:nil];
        }
    }
}

@end
