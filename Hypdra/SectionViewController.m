//
//  SectionViewController.m
//  Montage
//
//  Created by MacBookPro on 3/27/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SectionViewController.h"
#import "MyImages.h"
#import "RKSwipeBetweenViewControllers.h"
#import "CJMSimpleScrollingTabBar.h"
#import "UIImage+animatedGIF.h"
#import "WYPopoverController.h"
#import "SettingsViewController.h"
#import "DEMORootViewController.h"
#import "DEMOHomeViewController.h"
#import "AdvancedViewController.h"
#import "MyMusic.h"

@interface SectionViewController ()<WYPopoverControllerDelegate>
{
    WYPopoverController *popoverController;
    RKSwipeBetweenViewControllers *secondChildVC;
    UIPageViewController *pageController;
}

@end

@implementation SectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.titleName.adjustsFontSizeToFitWidth = YES;

    
    [self animateButton];
    
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
     
     secondChildVC = [[RKSwipeBetweenViewControllers alloc]initWithRootViewController:pageController];
     
     //%%% DEMO CONTROLLERS
     
     UIViewController *demo = [[UIViewController alloc]init];
     UIViewController *demo2 = [[UIViewController alloc]init];
     UIViewController *demo3 = [[UIViewController alloc]init];
     UIViewController *demo4 = [[UIViewController alloc]init];
     

    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AdvancedViewController *vc2 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ADView"];

    MyImages *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MyImg"];
    
    MyMusic *vc3 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MyMusicPage"];
     
    CJMSimpleScrollingTabBar *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CJM"];
     
    demo.view.backgroundColor = [UIColor whiteColor];
    demo2.view.backgroundColor = [UIColor whiteColor];
    demo3.view.backgroundColor = [UIColor grayColor];
    demo4.view.backgroundColor = [UIColor orangeColor];
     
    [secondChildVC.viewControllerArray addObjectsFromArray:@[vc,vc3,vc1,vc2]];
     
    [secondChildVC.view setBackgroundColor:[UIColor whiteColor]];
    [self addChildViewController:secondChildVC];
     
    [secondChildVC didMoveToParentViewController:self];
     
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        secondChildVC.view.frame = CGRectMake(self.view.frame.origin.x, self.topView.frame.origin.y + self.topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.topView.frame.size.height + self.topView.frame.origin.y));

    }
    else
    {
        secondChildVC.view.frame = CGRectMake(self.view.frame.origin.x, self.topView.frame.origin.y + self.topView.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height - (self.topView.frame.size.height + self.topView.frame.origin.y) - 20);

    }
    
    [self.view addSubview:secondChildVC.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LogoutScreen:)
                                                 name:@"LogOut"
                                               object:nil];
}

-(void)animateButton
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"titleImage" withExtension:@"gif"];
    
    self.titleImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
    [self.titleImage setContentMode:UIViewContentModeScaleAspectFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)settings:(id)sender
{
    
//    [pageController setViewControllers:@[[secondChildVC.viewControllerArray objectAtIndex:1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//    


    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
    
    
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:vc];
    
    
    popoverController.delegate = self;
    popoverController.popoverContentSize = CGSizeMake(150, 80);
    
    [popoverController presentPopoverFromRect:self.settingBtn.frame
                                       inView:self.settingBtn.superview
                     permittedArrowDirections:1
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
    
    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//    
//    //    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    
//    [self presentViewController:vc animated:YES completion:NULL];

}

- (void) LogoutScreen:(NSNotification *) notification
{
    
    
    [popoverController dismissPopoverAnimated:YES];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSError *error = nil;
    
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error])
    {
        [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
    }

    NSLog(@"Logout");
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}


@end
