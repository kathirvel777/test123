

//
//  ViewController.m
//  Montage
//
//  Created by MacBookPro on 3/20/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MyImages.h"
#import "RKSwipeBetweenViewControllers.h"
#import "SectionViewController.h"
#import "CJMSimpleScrollingTabBar.h"
#import "DEMORootViewController.h"
#import "DEMONavigationController.h"
#import "RegisterViewController.h"
#import "DGActivityIndicatorView.h"
#import "MBProgressHUD.h"
#import "Reachability.h"


#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface ViewController ()<UITextFieldDelegate,NSURLConnectionDataDelegate>
{
   // HoshiTextField
    UITextField *user,*pass,*firstname,*lastname,*email,*pwd;
    
    CGRect screenRect;
    CGFloat screenWidth,screenHeight;
    
    NSString *user_id;
    
    NSMutableArray *finalArray;
    
    dispatch_group_t group;
    
    UIActivityIndicatorView *spinner;

    NSMutableArray *videoPath;

}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ViewController");

    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    finalArray = [[NSMutableArray alloc]init];

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.color = [UIColor darkGrayColor];
    
    spinner.alpha = 1.0;
    
    spinner.center = self.view.center;
    
//    user.delegate = self;
//    pass.delegate = self;
    
/*    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    RKSwipeBetweenViewControllers *secondChildVC = [[RKSwipeBetweenViewControllers alloc]initWithRootViewController:pageController];
    
    //%%% DEMO CONTROLLERS
    
    UIViewController *demo = [[UIViewController alloc]init];
    UIViewController *demo2 = [[UIViewController alloc]init];
    UIViewController *demo3 = [[UIViewController alloc]init];
    UIViewController *demo4 = [[UIViewController alloc]init];
    
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MyImages *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MyImg"];
    
    demo.view.backgroundColor = [UIColor redColor];
    demo2.view.backgroundColor = [UIColor whiteColor];
    demo3.view.backgroundColor = [UIColor grayColor];
    demo4.view.backgroundColor = [UIColor orangeColor];
    
    [secondChildVC.viewControllerArray addObjectsFromArray:@[vc,demo2,demo3,demo]];
 
    [secondChildVC.view setBackgroundColor:[UIColor redColor]];
    [self addChildViewController:secondChildVC];
    
    [secondChildVC didMoveToParentViewController:self];
    secondChildVC.view.frame = self.view.frame; 
    [self.view addSubview:secondChildVC.view];
*/	
    
    
/*    [self login];
    [self userRegister];

    [self.view addSubview:spinner]; */
    
  //   }
    
    
    [self.loginBtn.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?17:13]];
    [self.signupBtn.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?17:13]];


}


- (IBAction)login:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                      message:@"Internet connection is down"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        NSLog(@"you pressed Yes, please button");
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else
    {
        
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            UIStoryboard *mainStoryBoard= [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DEMORootViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            [vc awakeFromNib:@"contentController" arg:@"menuController"];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:vc animated:YES completion:NULL];
        }
     
        else
        {
            UIStoryboard *mainStoryBoard= [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DEMORootViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            [vc awakeFromNib:@"contentController" arg:@"menuController"];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:vc animated:YES completion:NULL];
        }
        
    }
}

- (IBAction)signup:(id)sender
{
    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    RegisterViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Register"];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
//    
////    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    [self presentViewController:navigationController animated:YES completion:NULL];
   
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                      message:@"Internet connection is down"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
            style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action)
            {
                    NSLog(@"you pressed Yes, please button");
                                        
            }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_1" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    }
}


/*

-(void)userRegister
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {

    self.FirstText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*25/100, screenHeight*20/100, screenWidth*50/100, 60)];
    
    firstname = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*50/100, 60)];
    firstname.placeholder = @"First Name";
    
    [self.FirstText addSubview:firstname];
        
    self.LastText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*25/100, screenHeight*28/100, screenWidth*50/100, 60)];
        
    lastname = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*50/100, 60)];
    
    lastname.placeholder = @"Last Name";
        
        
    [self.LastText addSubview:lastname];

        
    self.emailText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*25/100, screenHeight*36/100, screenWidth*50/100, 60)];
    
    email = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*50/100, 60)];
    email.placeholder = @"Email";
    

        [self.emailText addSubview:email];

    
    self.pwdText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*25/100, screenHeight*44/100, screenWidth*50/100, 60)];
    
    pwd = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*50/100, 60)];
    pwd.placeholder = @"Password";

    [pwd setSecureTextEntry:YES];
    

        [self.pwdText addSubview:pwd];

        
    
    self.createAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.createAccount addTarget:self
                    action:@selector(createAccount:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self.createAccount setTitle:@"CREATE ACCOUNT" forState:UIControlStateNormal];
        
        
    
    self.createAccount.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    self.createAccount.frame = CGRectMake(screenWidth*25/100, self.pwdText.frame.origin.y + self.pwdText.frame.size.height + 20, screenWidth*50/100, 30);
    
    self.createAccount.backgroundColor = [self colorFromHexString:@"#C3FFF9"];
    

    self.connectText = [[UILabel alloc]init];
    
    self.connectText.text = @"----- OR CONNECT WITH -----";
    
    self.connectText.font = [UIFont systemFontOfSize:12.0];
    
    self.connectText.textColor=[UIColor grayColor];
    
    self.connectText.textAlignment = NSTextAlignmentCenter;
    
    self.connectText.frame =CGRectMake(screenWidth*25/100, self.createAccount.frame.origin.y + self.createAccount.frame.size.height + 20, screenWidth*50/100, 30);

    
    self.AddFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.AddFacebook addTarget:self
                      action:@selector(AddFacebook:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.AddFacebook setTitle:@"FACEBOOK" forState:UIControlStateNormal];
    
    self.AddFacebook.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    self.AddFacebook.frame = CGRectMake(screenWidth*25/100, self.connectText.frame.origin.y + self.connectText.frame.size.height + 20, screenWidth*50/100, 30);
    
    self.AddFacebook.backgroundColor = [self colorFromHexString:@"#0D2A46"];
    
    self.AlreadyAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.AlreadyAccount addTarget:self
                        action:@selector(AlreadyAccount:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.AlreadyAccount setTitle:@"Already have an account? Log in" forState:UIControlStateNormal];
    
    [self.AlreadyAccount.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8.0]];
        
        
        
    self.AlreadyAccount.titleLabel.adjustsFontSizeToFitWidth = YES;

//        myButton.titleLabel.minimumFontSize = 40;

    
    self.AlreadyAccount.frame = CGRectMake(screenWidth*35/100, screenHeight *96/100, screenWidth*30/100, 30);
    
    [self.AlreadyAccount setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    }
    else
    {
        
        self.FirstText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*35/100, screenHeight*30/100, screenWidth*30/100, 60)];
        
        firstname = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*30/100, 60)];
        firstname.placeholder = @"First Name";
        
        
        [self.FirstText addSubview:firstname];

       
        self.LastText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*35/100, screenHeight*35/100, screenWidth*30/100, 60)];
        
        lastname = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*30/100, 60)];
        lastname.placeholder = @"Last Name";
        
        
        [self.LastText addSubview:lastname];
        

        
        self.emailText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*35/100, screenHeight*40/100, screenWidth*30/100, 60)];
        
        email = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*30/100, 60)];
        email.placeholder = @"Email";
        
        [self.emailText addSubview:email];


        
        self.pwdText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*35/100, screenHeight*45/100, screenWidth*30/100, 60)];
        
        pwd = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*30/100, 60)];
        pwd.placeholder = @"Password";
        
        [pwd setSecureTextEntry:YES];
        
        [self.pwdText addSubview:pwd];

        
        self.createAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.createAccount addTarget:self
                               action:@selector(createAccount:)
                     forControlEvents:UIControlEventTouchUpInside];
        
        [self.createAccount setTitle:@"CREATE ACCOUNT" forState:UIControlStateNormal];
        
        self.createAccount.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        self.createAccount.frame = CGRectMake(screenWidth*25/100, self.pwdText.frame.origin.y + self.pwdText.frame.size.height + 20, screenWidth*50/100, 30);
        
        self.createAccount.backgroundColor = [self colorFromHexString:@"#C3FFF9"];
        
        
        self.connectText = [[UILabel alloc]init];
        
        self.connectText.text = @"----- OR CONNECT WITH -----";
        
        self.connectText.font = [UIFont systemFontOfSize:12.0];
        
        self.connectText.textColor=[UIColor grayColor];
        
        self.connectText.textAlignment = NSTextAlignmentCenter;
        
        self.connectText.frame =CGRectMake(screenWidth*25/100, self.createAccount.frame.origin.y + self.createAccount.frame.size.height + 20, screenWidth*50/100, 30);
        
        
        self.AddFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.AddFacebook addTarget:self
                             action:@selector(AddFacebook:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        [self.AddFacebook setTitle:@"FACEBOOK" forState:UIControlStateNormal];
        
        self.AddFacebook.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        self.AddFacebook.frame = CGRectMake(screenWidth*25/100, self.connectText.frame.origin.y + self.connectText.frame.size.height + 20, screenWidth*50/100, 30);
        
        self.AddFacebook.backgroundColor = [self colorFromHexString:@"#0D2A46"];
        
        self.AlreadyAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.AlreadyAccount addTarget:self
                                action:@selector(AlreadyAccount:)
                      forControlEvents:UIControlEventTouchUpInside];
        
        [self.AlreadyAccount setTitle:@"Already have an account? Log in" forState:UIControlStateNormal];
        
        self.AlreadyAccount.titleLabel.adjustsFontSizeToFitWidth = YES;

        
        [self.AlreadyAccount.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        
        self.AlreadyAccount.frame = CGRectMake(screenWidth*35/100, screenHeight *96/100, screenWidth*30/100, 30);
        
        [self.AlreadyAccount setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }
    
    
    [self.view addSubview:self.FirstText];
    [self.view addSubview:self.LastText];
    [self.view addSubview:self.emailText];
    [self.view addSubview:self.pwdText];
    [self.view addSubview:self.createAccount];
    [self.view addSubview:self.connectText];
    [self.view addSubview:self.AddFacebook];
    [self.view addSubview:self.AlreadyAccount];
    
    
    [self.FirstText setAlpha:0.0f];
    
    [self.LastText setAlpha:0.0f];
    
    [self.emailText setAlpha:0.0f];
    
    [self.pwdText setAlpha:0.0f];
    
    [self.createAccount setAlpha:0.0f];
    
    [self.connectText setAlpha:0.0f];
    
    [self.AddFacebook setAlpha:0.0f];
    
    [self.AlreadyAccount setAlpha:0.0f];
    
    
   
    [self.FirstText setHidden:YES];
    
    [self.LastText setHidden:YES];
    
    [self.emailText setHidden:YES];
    
    [self.pwdText setHidden:YES];
    
    [self.createAccount setHidden:YES];
    
    [self.connectText setHidden:YES];
    
    [self.AddFacebook setHidden:YES];
    
    [self.AlreadyAccount setHidden:YES];
    

    
    
    
//    [self.titleView setAlpha:0.0f];
    
    
}



-(void)login
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        NSLog(@"iPhone");
        
        self.userText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*25/100, screenHeight*20/100, screenWidth*50/100, 60)];
        
        user = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*50/100, 60)];
        user.placeholder = @"Email";
        
        [self.userText addSubview:user];
        
        
        self.passText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*25/100, screenHeight*28/100, screenWidth*50/100, 60)];
        
        pass = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*50/100, 60)];
        pass.placeholder = @"Password";
        
        [pass setSecureTextEntry:YES];
        
        [self.passText addSubview:pass];
        
        self.forget = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.forget addTarget:self
                        action:@selector(buttonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self.forget setTitle:@"Forget your password?" forState:UIControlStateNormal];
        
        
        self.forget.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        
        [self.forget setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        
        self.forget.frame = CGRectMake(screenWidth*40/100 - 25, self.passText.frame.origin.y + self.passText.frame.size.height + 20, 130, 30);
        
        self.SignIn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.SignIn addTarget:self
                        action:@selector(login:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self.SignIn setTitle:@"LOG IN" forState:UIControlStateNormal];
        
        self.SignIn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        self.SignIn.frame = CGRectMake(screenWidth*25/100, self.forget.frame.origin.y + self.forget.frame.size.height + 20, screenWidth*50/100, 30);
        
        self.SignIn.backgroundColor = [self colorFromHexString:@"#C3FFF9"];// [UIColor colorWithRed:213/255 green:255/255 blue:252/255 alpha:1.0];
        
        
        self.labelText = [[UILabel alloc]init];
        
        self.labelText.text = @"----- OR LOG IN WITH -----";
        
        self.labelText.font = [UIFont systemFontOfSize:12.0];
        
        self.labelText.textColor=[UIColor grayColor];
        
        self.labelText.textAlignment = NSTextAlignmentCenter;
        
        self.labelText.frame =CGRectMake(screenWidth*25/100, self.SignIn.frame.origin.y + self.SignIn.frame.size.height + 20, screenWidth*50/100, 30);
        
        self.facebook = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.facebook addTarget:self
                          action:@selector(buttonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self.facebook setTitle:@"FACEBOOK" forState:UIControlStateNormal];
        
        self.facebook.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        self.facebook.frame = CGRectMake(screenWidth*25/100, self.labelText.frame.origin.y + self.labelText.frame.size.height + 20, screenWidth*50/100, 30);
        
        self.facebook.backgroundColor = [self colorFromHexString:@"#0D2A46"];// [UIColor colorWithRed:213/255 green:255/255 blue:252/255 alpha:1.0];
        
        self.NewAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.NewAccount addTarget:self
                            action:@selector(NewAccount:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self.NewAccount setTitle:@"New to Montage?Create an account" forState:UIControlStateNormal];
        
        self.NewAccount.titleLabel.adjustsFontSizeToFitWidth = YES;

        
        [self.NewAccount.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8.0]];
        
        self.NewAccount.frame = CGRectMake(screenWidth*25/100, screenHeight *95/100, screenWidth*50/100, 30);
        
        [self.NewAccount setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"Ipad");
        
        self.userText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*35/100, screenHeight*30/100, screenWidth*30/100, 60)];
        
        user = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*30/100, 60)];
        user.placeholder = @"Email";
        
        [self.userText addSubview:user];
        
        self.passText = [[UIView alloc]initWithFrame:CGRectMake(screenWidth*35/100, screenHeight*35/100, screenWidth*30/100, 60)];
        
        pass = [[HoshiTextField alloc] initWithFrame:CGRectMake(0, 0, screenWidth*30/100, 60)];
        pass.placeholder = @"Password";
        
        [pass setSecureTextEntry:YES];
        
        [self.passText addSubview:pass];
        
        self.forget = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.forget addTarget:self
                        action:@selector(buttonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self.forget setTitle:@"Forget your password?" forState:UIControlStateNormal];
        
        [self.forget.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        
        [self.forget setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.forget.frame = CGRectMake(screenWidth*35/100, self.passText.frame.origin.y + self.passText.frame.size.height + 20, screenWidth*30/100, 30);
        
        self.SignIn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.SignIn addTarget:self
                        action:@selector(login:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self.SignIn setTitle:@"LOG IN" forState:UIControlStateNormal];
        
        [self.SignIn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        
        self.SignIn.frame = CGRectMake(screenWidth*35/100, self.forget.frame.origin.y + self.forget.frame.size.height + 20, screenWidth*30/100, 30);
        
        self.SignIn.backgroundColor = [self colorFromHexString:@"#C3FFF9"];// [UIColor colorWithRed:213/255 green:255/255 blue:252/255 alpha:1.0];
        
        self.labelText = [[UILabel alloc]init];
        
        self.labelText.text = @"----- OR LOG IN WITH -----";
        
        [self.labelText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        
        self.labelText.textColor=[UIColor grayColor];
        
        self.labelText.textAlignment = NSTextAlignmentCenter;
        
        
        self.labelText.frame =CGRectMake(screenWidth*35/100, self.SignIn.frame.origin.y + self.SignIn.frame.size.height + 20, screenWidth*30/100, 30);
        
        self.facebook = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.facebook addTarget:self
                          action:@selector(buttonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self.facebook setTitle:@"FACEBOOK" forState:UIControlStateNormal];
        
        [self.facebook.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        
        self.facebook.frame = CGRectMake(screenWidth*35/100, self.labelText.frame.origin.y + self.labelText.frame.size.height + 20, screenWidth*30/100, 30);
        
        self.facebook.backgroundColor = [self colorFromHexString:@"#0D2A46"];// [UIColor colorWithRed:213/255 green:255/255 blue:252/255 alpha:1.0];
        
        self.NewAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.NewAccount addTarget:self
                            action:@selector(NewAccount:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self.NewAccount setTitle:@"New to Montage?Create an account" forState:UIControlStateNormal];
        
        self.NewAccount.titleLabel.adjustsFontSizeToFitWidth = YES;

        [self.NewAccount.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
        
        self.NewAccount.frame = CGRectMake(screenWidth*35/100, screenHeight *96/100, screenWidth*30/100, 30);
        
        [self.NewAccount setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        //self.NewAccount.backgroundColor = [self colorFromHexString:@"#0D2A46"];// [UIColor colorWithRed:213/255 green:255/255 blue:252/255 alpha:1.0];
        
    }
    
    [self.view addSubview:self.NewAccount];
    
    [self.view addSubview:self.facebook];
    
    [self.view addSubview:self.labelText];
    
    [self.view addSubview:self.SignIn];
    
    [self.view addSubview:self.forget];
    
    [self.view addSubview:self.passText];
    
    [self.view addSubview:self.userText];
    
    [self.userText setAlpha:0.0f];
    
    [self.passText setAlpha:0.0f];
    
    [self.forget setAlpha:0.0f];
    
    [self.SignIn setAlpha:0.0f];
    
    [self.labelText setAlpha:0.0f];
    
    [self.facebook setAlpha:0.0f];
    
    [self.NewAccount setAlpha:0.0f];
    
    [self.titleView setAlpha:0.0f];


}


-(IBAction)AlreadyAccount:(id)sender
{
    [self.FirstText setHidden:YES];

    [self.LastText setHidden:YES];

    [self.emailText setHidden:YES];
    
    [self.pwdText setHidden:YES];
    
    [self.createAccount setHidden:YES];
    
    [self.connectText setHidden:YES];
    
    [self.AddFacebook setHidden:YES];
    
    [self.AlreadyAccount setHidden:YES];
    
    [self.FirstText setAlpha:0.0f];

    [self.LastText setAlpha:0.0f];

    [self.emailText setAlpha:0.0f];
    
    [self.pwdText setAlpha:0.0f];
    
    [self.createAccount setAlpha:0.0f];
    
    [self.connectText setAlpha:0.0f];
    
    [self.AddFacebook setAlpha:0.0f];
    
    [self.AlreadyAccount setAlpha:0.0f];
    
    
    [self.NewAccount setHidden:NO];
    
    [self.facebook setHidden:NO];
    
    [self.labelText setHidden:NO];
    
    [self.SignIn setHidden:NO];
    
    [self.forget setHidden:NO];
    
    [self.passText setHidden:NO];
    
    [self.userText setHidden:NO];
    
    [UIView animateWithDuration:1.0f animations:^{
        
        [self.userText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:2.0f animations:^{
        
        [self.passText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:3.0f animations:^{
        
        [self.forget setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:4.0f animations:^{
        
        [self.SignIn setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:5.0f animations:^{
        
        [self.labelText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:6.0f animations:^{
        
        [self.facebook setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:7.0f animations:^{
        
        [self.NewAccount setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:10.0f animations:^{
        
        [self.titleView setAlpha:1.0f];
        
    } completion:nil];
    
} */


-(IBAction)NewAccount:(id)sender
{
    [self.NewAccount setHidden:YES];
    
    [self.facebook setHidden:YES];
    
    [self.labelText setHidden:YES];
    
    [self.SignIn setHidden:YES];
    
    [self.forget setHidden:YES];
    
    [self.passText setHidden:YES];
    
    [self.userText setHidden:YES];
    
    [self.userText setAlpha:0.0f];
    
    [self.passText setAlpha:0.0f];
    
    [self.forget setAlpha:0.0f];
    
    [self.SignIn setAlpha:0.0f];
    
    [self.labelText setAlpha:0.0f];
    
    [self.facebook setAlpha:0.0f];
    
    [self.NewAccount setAlpha:0.0f];
    
    
    [self.FirstText setHidden:NO];

    [self.LastText setHidden:NO];

    [self.emailText setHidden:NO];
    
    [self.pwdText setHidden:NO];
    
    [self.createAccount setHidden:NO];
    
    [self.connectText setHidden:NO];
    
    [self.AddFacebook setHidden:NO];
    
    [self.AlreadyAccount setHidden:NO];

    
    [UIView animateWithDuration:1.0f animations:^{
        
        [self.FirstText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:1.5f animations:^{
        
        [self.LastText setAlpha:1.0f];
        
    } completion:nil];
    
    
    [UIView animateWithDuration:2.0f animations:^{
        
        [self.emailText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:3.0f animations:^{
        
        [self.pwdText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:4.0f animations:^{
        
        [self.createAccount setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:5.0f animations:^{
        
        [self.connectText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:6.0f animations:^{
        
        [self.AddFacebook setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:7.0f animations:^{
        
        [self.AlreadyAccount setAlpha:1.0f];
        
    } completion:nil];
    
}

- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    //    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    //    [keyboardToolbar sizeToFit];
    //    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
    //                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
    //                                      target:nil action:nil];
    //    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
    //                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
    //                                      target:self.view action:@selector(endEditing:)];
    //    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    //    pass.inputAccessoryView = keyboardToolbar;
    
    
//    self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:85/255.0f blue:101/255.0f alpha:1.0f];
//    
//    NSArray *activityTypes = @[@(DGActivityIndicatorAnimationTypeBallScaleRipple)];
//    
//    //    for (int i = 0; i < activityTypes.count; i++)
//    //    {
//    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[activityTypes[0] integerValue] tintColor:[UIColor whiteColor]];
//    CGFloat width = self.view.bounds.size.width / 3.0f;
//    CGFloat height = self.view.bounds.size.height / 5.0f;
//    
//    activityIndicatorView.frame = CGRectMake(30,30, width, height);
//    
//    activityIndicatorView.center = self.centerView.center;
//    
//    [self.view addSubview:activityIndicatorView];
//    [activityIndicatorView startAnimating];

    
    
    NSLog(@"Condition = %d",[[NSUserDefaults standardUserDefaults]boolForKey:@"signOut"]);
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"signOut"])
    {
        
        NSLog(@"True");
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"signOut"];
    }
    else
    {
        
        NSLog(@"False");
        
    
    [self.view setUserInteractionEnabled:NO];

        
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.centerView animated:YES];
    
    // Set the label text.
        
    hud.label.text = NSLocalizedString(@"Loading", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        [self doSomeWork];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            [self.view setUserInteractionEnabled:YES];

            [self moveView];
        });
    });
    }
}

- (void)doSomeWork
{
    sleep(3.);
}

-(void)moveView
{
    NSString *str =  [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_ID"];
    
    NSLog(@"Main User ID = %@",str);
    
    if(str == nil)
    {
        
    }
    else
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc1 animated:YES completion:nil];
    }
}


/*{
    user.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    user.autocorrectionType = UITextAutocorrectionTypeNo;

    
    firstname.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    firstname.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    lastname.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    lastname.autocorrectionType = UITextAutocorrectionTypeNo;


    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    email.autocorrectionType = UITextAutocorrectionTypeNo;

    
/*    [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.userText setAlpha:1.0f];
    } completion:nil];
    
    [UIView animateWithDuration:2.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.passText setAlpha:1.0f];
    } completion:nil];
    
    [UIView animateWithDuration:3.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.forget setAlpha:1.0f];
    } completion:nil];
    
    [UIView animateWithDuration:4.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.SignIn setAlpha:1.0f];
    } completion:nil];
    
    [UIView animateWithDuration:5.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.labelText setAlpha:1.0f];
    } completion:nil];
    
    [UIView animateWithDuration:6.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.facebook setAlpha:1.0f];
    } completion:nil];
    
    [UIView animateWithDuration:7.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.NewAccount setAlpha:1.0f];
    } completion:nil]; //
    
    
    [UIView animateWithDuration:1.0f animations:^{
        
        [self.userText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:2.0f animations:^{
        
        [self.passText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:3.0f animations:^{
        
        [self.forget setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:4.0f animations:^{
        
        [self.SignIn setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:5.0f animations:^{
        
        [self.labelText setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:6.0f animations:^{
        
        [self.facebook setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:7.0f animations:^{
        
        [self.NewAccount setAlpha:1.0f];
        
    } completion:nil];
    
    [UIView animateWithDuration:10.0f animations:^{
        
        [self.titleView setAlpha:1.0f];
        
    } completion:nil];

}
*/

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


-(void)createAccount:(UIButton*)sender
{
    if(!([firstname.text isEqualToString:@""] && [lastname.text isEqualToString:@""] && [email.text isEqualToString:@""]&& [pwd.text isEqualToString:@""]))
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        //            NSDictionary *params = @{@"User_Name":@"Ragu",@"Email_ID": self.email.text,@"Password":self.password.text,};
        
        NSDictionary *params = @{@"First_Name":firstname.text ,@"Last_Name": lastname.text,@"Email_ID":email.text,@"Password":pwd.text,@"lang":@"ios"};
        
        
        
        [manager POST:@"http://108.175.2.116/montage/api/api.php?rquest=register" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSLog(@"Login Json Response:%@",responseObject);
             

             NSString *res = [responseObject objectForKey:@"status"];
             
             
             if([res isEqualToString:@"Success"])
             {
                 firstname.text = @"";
                 lastname.text = @"";
                 email.text = @"";
                 pwd.text = @"";
             }
             else
             {
                 
             }
//
//                 [spinner stopAnimating];
//                 
//                 user_id=[responseObject objectForKey:@"User_ID"];
//                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                 MainViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"main"];
//                 
//                 [self.navigationController pushViewController:vc animated:YES];
//                 
//                 NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//                 [defaults setValue:user_id forKey:@"USER_ID"];
//                 [defaults synchronize];
//             }
//             else
//             {
//                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Email Id Already Exists" message:@"Please Login"delegate:self cancelButtonTitle:0 otherButtonTitles:@"OK", nil];
//                 [av show];
//             }
         }
         failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             //responseBlock(nil, FALSE, error);
         }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Enter your details" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/*

-(void) login:(UIButton*)sender
{
    
    if(!([user.text isEqualToString:@""] && [pass.text isEqualToString:@""]))
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSDictionary *params = @{@"Email_ID":user.text , @"Password":pass.text,@"lang":@"ios"};
                
        
        [manager POST:@"http://108.175.2.116/montage/api/api.php?rquest=login" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             
             NSLog(@"Response = %@",responseObject);
             
             NSString *res=[responseObject objectForKey:@"msg"];

             user_id = [responseObject objectForKey:@"user_id"];
             
             if ([res isEqualToString:@"Success"])
             {
                 [self LoadAllData];
             }
             else
             {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid Credentials" preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                 {
                     user.text = @"";
                     pass.text = @"";
                     
                     [user becomeFirstResponder];
                     
                 }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
             }
             NSLog(@"Response  = %@",responseObject);
         }
         failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
        }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Enter your details" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

*/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self deleteMusic];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)LoadAllData
{
    @try
    {
        NSLog(@"Load All Function");
        
        group=dispatch_group_create();
        
        [spinner startAnimating];
        
        [self loadEffectsData];
        [self loadImageData];
        //    //    [self deleteImageLocally:@"7"];
        [self loadTransitionData];
        [self loadTextData];
        //    [self loadMusic];
        
        dispatch_group_notify(group, dispatch_get_main_queue(),
                              ^{
                                  NSLog(@"All Done");
                                  
                                  [spinner stopAnimating];
                                  
                                  NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                  [defaults setValue:user_id forKey:@"USER_ID"];
                                  [defaults synchronize];
                                  
                                  UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  
                                  SectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CSection"];
                                  
                                  vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                  
                                  [self presentViewController:vc animated:YES completion:NULL];
                                  
                              });
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           
                       });
        NSLog(@"Thread here");

    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Receiving");
}


-(void)loadTextData
{
    @try {
        dispatch_group_enter(group);
        dispatch_group_t sub_group=dispatch_group_create();
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        // NSString *URLString = @"http://108.175.2.116/montage/api/api.php?rquest=delete_my_image";
        NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=view_text";
        
        //  NSString *URLString = [NSString stringWithFormat:@"%@view_coach.php", BasePath];
        NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
        
        dispatch_group_enter(sub_group);
        
        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             NSArray *imageArray = [response objectForKey:@"view_text_image"];
             NSLog(@"Text Response %@",response);
             for(NSDictionary *imageDic in imageArray)
             {
                 NSString *imageUrl = [imageDic objectForKey:@"resize_mov_or_gif_path"];
                 
                 NSString *image_id = [imageDic objectForKey:@"id"];
                 NSLog(@"Text Retrive Response:%@",imageUrl);
                 
                 NSURL *url = [NSURL URLWithString:imageUrl];
                 
                 NSData *imageData = [NSData dataWithContentsOfURL:url];
                 
                 [finalArray addObject:image_id];
                 
                 [self fileName:image_id fileData:imageData folderName:@"Text"];
             }
             dispatch_group_leave(sub_group);
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             dispatch_group_leave(sub_group);
             
             //responseBlock(nil, FALSE, error);
         }];
        dispatch_group_notify(sub_group, dispatch_get_main_queue(), ^{
            NSLog(@"Load Text Data Done");
            dispatch_group_leave(group);
        });
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}

-(void)loadImageData
{
    @try {
        
        dispatch_group_enter(group);
        dispatch_group_t sub_group=dispatch_group_create();;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        // NSString *URLString = @"http://108.175.2.116/montage/api/api.php?rquest=delete_my_image";
        NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=view_my_image";
        
        //  NSString *URLString = [NSString stringWithFormat:@"%@view_coach.php", BasePath];
        NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
        
        dispatch_group_enter(sub_group);
        
        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             NSArray *imageArray = [response objectForKey:@"view_my_image"];
             NSLog(@"Image Response %@",response);
             for(NSDictionary *imageDic in imageArray)
             {
                 NSString *imageUrl = [imageDic objectForKey:@"Image_Path"];
                 NSString *image_id = [imageDic objectForKey:@"image_id"];
                 NSLog(@"Image Retrive Response:%@",imageUrl);
                 NSURL *url = [NSURL URLWithString:imageUrl];
                 NSData *imageData = [NSData dataWithContentsOfURL:url];
                 [finalArray addObject:image_id];
                 [self fileName:image_id fileData:imageData folderName:@"MyImages"];
             }
             dispatch_group_leave(sub_group);
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             dispatch_group_leave(sub_group);
             
             //responseBlock(nil, FALSE, error);
         }];
        dispatch_group_notify(sub_group, dispatch_get_main_queue(), ^{
            NSLog(@"Load Image Data Done");
            dispatch_group_leave(group);
        });
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}


-(void)loadEffectsData
{
    @try {
        dispatch_group_enter(group);
        dispatch_group_t sub_group=dispatch_group_create();
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        // NSString *URLString = @"http://108.175.2.116/montage/api/api.php?rquest=delete_my_image";
        
        NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=view_effects";
        
        //  NSString *URLString = [NSString stringWithFormat:@"%@view_coach.php", BasePath];
        
        NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
        
        
        dispatch_group_enter(sub_group);
        
        
        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             NSArray *imageArray = [response objectForKey:@"view_effect_image"];
             NSLog(@"Effects Response %@",response);
             for(NSDictionary *imageDic in imageArray)
             {
                 NSString *imageUrl = [imageDic objectForKey:@"thumb_img_path"];
                 
                 if (!(imageUrl == nil || imageUrl == (id)[NSNull null]))
                 {
                 NSString *image_id = [imageDic objectForKey:@"id"];
                 NSLog(@"Effect Retrive Response:%@",imageUrl);
                 NSURL *url = [NSURL URLWithString:imageUrl];
                 NSData *imageData = [NSData dataWithContentsOfURL:url];
                 [finalArray addObject:image_id];
                 [self fileName:image_id fileData:imageData folderName:@"Effects"];
                 }
             }
             dispatch_group_leave(sub_group);
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             dispatch_group_leave(sub_group);
             
         }];
        dispatch_group_notify(sub_group, dispatch_get_main_queue(), ^{
            NSLog(@"Load Effects Done");
            dispatch_group_leave(group);
        });
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}

-(void)loadTransitionData
{
    @try {
        
        dispatch_group_enter(group);
        dispatch_group_t sub_group=dispatch_group_create();
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        // NSString *URLString = @"http://108.175.2.116/montage/api/api.php?rquest=delete_my_image";
        NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=view_advance_transition";
        
        //  NSString *URLString = [NSString stringWithFormat:@"%@view_coach.php", BasePath];
        NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
        
        dispatch_group_enter(sub_group);
        
        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             NSArray *imageArray = [response objectForKey:@"view_transition_image"];
             NSLog(@"Transition Response %@",response);
             for(NSDictionary *imageDic in imageArray)
             {
                 NSString *imageUrl = [imageDic objectForKey:@"resize_mask_image"];
                 NSString *image_id = [imageDic objectForKey:@"id"];
                 NSLog(@"Transition Retrive Response:%@",imageUrl);
                 NSURL *url = [NSURL URLWithString:imageUrl];
                 NSData *imageData = [NSData dataWithContentsOfURL:url];
                 
                 [finalArray addObject:image_id];
                 [self fileName:image_id fileData:imageData folderName:@"Transitions"];
             }
             dispatch_group_leave(sub_group);
         }
         
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             dispatch_group_leave(sub_group);
             
         }];
        
        dispatch_group_notify(sub_group, dispatch_get_main_queue(), ^{
            NSLog(@"Load Transitions done");
            dispatch_group_leave(group);
        });
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}


-(void) fileName:(NSString *)FileName fileData:(NSData *)data folderName:(NSString *)folderName
{
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",folderName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];
    FileName=[FileName stringByAppendingString:@".png"];
    NSString *dataPath = [documentsPathlist stringByAppendingFormat:[NSString stringWithFormat:@"/%@",FileName]];
    
    NSLog(@"FilePath:%@",dataPath);
    // NSData* pictureData = UIImagePNGRepresentation(data);
    
    [data writeToFile:dataPath atomically:YES];
    
    NSString *SharedFinalplistPath = [documentsPathlist stringByAppendingPathComponent:@"DataList.plist"];
    
    if (finalArray == nil)
    {
        finalArray = [NSMutableArray array];
    }
    
    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    
}

/*-(void) fileName:(NSString *)FileName fileData:(NSData *)data folderName:(NSString *)FolderName
{
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",FolderName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];
    
    FileName = [FileName stringByAppendingString:@".png"];
    
    NSString *dataPath = [documentsPathlist stringByAppendingFormat:@"%@",FileName];


 //   dataPath = [documentsPathlist stringByAppendingFormat:[NSString stringWithFormat:@".png"]];
    
    NSLog(@"FilePath:%@",dataPath);
    
    // NSData* pictureData = UIImagePNGRepresentation(data);
    
    [data writeToFile:dataPath atomically:YES];
    
    NSString *SharedFinalplistPath = [documentsPathlist stringByAppendingPathComponent:@"Data.plist"];
    
    if (finalArray == nil)
    {
        finalArray = [NSMutableArray array];
    }
    
    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
}*/



-(void)deleteMusic
{
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocumentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *documentsPathlist = [myDocumentsDirectory stringByAppendingPathComponent:@"/Music"];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPathlist  error:nil];
    
    NSMutableArray *arrMp3Files=[[NSMutableArray alloc]init];
  
    for (NSString *str in filePathsArray)
    {
        NSString *strFileName=[str.lastPathComponent lowercaseString];
      
        if([strFileName.pathExtension isEqualToString:@"m4a"])
        {
            NSLog(@"Music Path = %@",str);
            
            
            NSString *finalPath = [documentsPathlist stringByAppendingFormat:@"/%@",str];
            
            BOOL flag =  [[NSFileManager defaultManager] removeItemAtPath:finalPath error:&error];
            
            NSLog(@"%d",flag);
            
//            [arrMp3Files addObject:str];
        }
        
    }
}



@end
