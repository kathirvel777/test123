//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOHomeViewController.h"
#import "RKSwipeBetweenViewControllers.h"
#import "MyImages.h"
#import "CJMSimpleScrollingTabBar.h"
#import "ViewController.h"
#import "UIImage+animatedGIF.h"
#import "SectionViewController.h"
#import "DEMORootViewController.h"
#import "ViewController.h"
#import "PageSelectionViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterKit/TwitterKit.h>
#import "AppDelegate.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ForgotPasswordController.h"
#import "RegisterOTPViewController.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASS @"[A-Za-z0-9]{3,20}"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

static NSString * const kClientId = @"843659127107-tianp29e0poa0lsnuad1ug7fcbpoe3rq.apps.googleusercontent.com";

@interface DEMOHomeViewController () <KIImagePagerDelegate, KIImagePagerDataSource,UITextFieldDelegate,UITextFieldDelegate,FBSDKLoginButtonDelegate,GPPSignInDelegate,ClickDelegates>
{
    NSArray *images;
    NSArray *gifImages;
    NSString *user_id,*tuser_id,*storeEmail;
    NSMutableArray *finalArray,*musicArray;
    dispatch_group_t group;
    
    UIActivityIndicatorView *spinner;
    MBProgressHUD *hud;
    AppDelegate *appDelegate;
    
    NSString *Pass,*eMail,*social_email,*firstName,*lastName,*pfl_pic_url;
    
    GPPSignIn *signIn;
    GIDSignIn *signIn1;
    NSData *pfl_img;
    
    id resValue;
    NSMutableURLRequest *request;
    
#define URL @"https://hypdra.com/api/api.php?rquest=register"
    
}

@end

@implementation DEMOHomeViewController

@synthesize GoogleSign_In;

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    [self animateButton:@"titleImage"];
    
    NSLog(@"width = %f",self.imagePager.frame.size.width);
    
    NSLog(@"width = %f",self.imagePager.frame.size.width);
    
    gifImages = @[@"Gif1",@"Gif2",@"Gif3",@"Gif4"];
    
    images = @[@"banner1.png", @"banner2.png",@"banner3.png",@"banner4.png"];
    
    NSLog(@"Login");
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];//UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    //    NSLog(@"Login");
    //    [[FBSession alloc] initWithPermissions:@[@"basic_info", @"email"]];
    //    [FBSession setActiveSession:session];
    //
    //    [session openWithBehavior:FBSessionLoginBehaviorForcingWebView
    //            completionHandler:^(FBSession *session,
    //                                FBSessionState status,
    //                                NSError *error) {
    //                if (FBSession.activeSession.isOpen) {
    //                    [[FBRequest requestForMe] startWithCompletionHandler:
    //                     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
    //                         if (!error) {
    //                             NSLog(@"accesstoken %@",[NSString stringWithFormat:@"%@",session.accessTokenData]);
    //                             NSLog(@"user id %@",user.id);
    //                             NSLog(@"Email %@",[user objectForKey:@"email"]);
    //                             NSLog(@"User Name %@",user.username);
    //                         }
    //                     }];
    
    //     FBSession* session = [[session alloc] initWithPermissions:@[@"publish_actions"]];
    //    if (FBSession.activeSession.isOpen) {
    //
    //        [[FBRequest requestForMe] startWithCompletionHandler:
    //         ^(FBRequestConnection *connection,
    //           NSDictionary<FBGraphUser> *user,
    //           NSError *error) {
    //             if (!error) {
    //                 NSString *firstName = user.first_name;
    //                 NSString *lastName = user.last_name;
    //                 NSString *facebookId = user.id;
    //                 NSString *email = [user objectForKey:@"email"];
    //                 NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
    //             }
    //         }];
    //    }
    
    self.scrollView.bounces = false;
    self.email.delegate = self;
    self.password.delegate = self;
    
    _loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    _loginButton.frame = CGRectMake(100, 150, 100, 40);
    [self.socialLoginView addSubview:_loginButton];
    
    self.scrollView.bounces = false;
    
    self.email.delegate = self;
    self.password.delegate = self;
    
    self.email.tintColor = [UIColor whiteColor];
    self.password.tintColor = [UIColor whiteColor];
    //    [self configTwitter];
    
    // [self Google];
    
    
    signIn1 = [GIDSignIn sharedInstance];
    signIn1.delegate = self;
    signIn1.uiDelegate = self;
    signIn1.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];//UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.7;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, self.email.frame.size.height - borderWidth, 0, self.email.frame.size.height);
    [self.email.layer addSublayer:border];
    self.email.layer.masksToBounds = YES;
    
    UIColor *color = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    NSString *placeholderText = self.email.placeholder;
    self.email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
    
    
    CALayer *PwdBorder  =  [CALayer layer];
    CGFloat PassBorderWidth = 0.2;
    PwdBorder.borderColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4].CGColor;
    border.frame = CGRectMake(0, self.password.frame.size.height - borderWidth, 0, self.password.frame.size.height);
    PwdBorder.borderWidth = PassBorderWidth;
    [self.password.layer addSublayer:PwdBorder];
    self.password.layer.masksToBounds = YES;
    
    UIColor *Pwdcolor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    NSString *PwdplaceholderText = self.password.placeholder;
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:PwdplaceholderText attributes:@{NSForegroundColorAttributeName: Pwdcolor}];
    [self setupAlerts];
}

/*
 -(void)Google
 {
 appDelegate = (AppDelegate *)
 [[UIApplication sharedApplication] delegate];
 signIn = [GPPSignIn sharedInstance];
 signIn.shouldFetchGooglePlusUser = YES;
 //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
 
 // You previously set kClientId in the "Initialize the Google+ client" step
 signIn.clientID = kClientId;
 
 // Uncomment one of these two statements for the scope you chose in the previous step
 signIn.scopes = @[ kGTLAuthScopePlusLogin ,kGTLAuthScopePlusMe];  // "https://www.googleapis.com/auth/plus.login" scope
 
 
 //    signIn.scopes:@[@"https://www.googleapis.com/auth/plus.login", @"https://www.googleapis.com/auth/plus.me"]];
 
 //signIn.scopes = @[ @"profile" ];            // "profile" scope
 signIn.shouldFetchGoogleUserEmail = YES;
 // Optional: declare signIn.actions, see "app activities"
 signIn.delegate = self;
 GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
 plusService.retryEnabled = YES;
 
 //    self.GoogleSign_In.currentBackgroundImage = [UIImage imageNamed:@"32-g+.png"];
 
 //[self.GoogleSign_In setImage:[UIImage imageNamed:@"32-g+.png"] forState:UIControlStateNormal]; //  custom image
 
 }
 */
/*
 - (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
 error: (NSError *) error
 {
 if(!error)
 {
 // Get the email address.
 NSLog(@"G+ Email :- %@", signIn.authentication.userEmail);
 }}
 */





- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    NSLog(@"UserProfile:%@",user.profile);
    // Perform any operations on signed in user here.
    
    GIDGoogleUser *currentUser = [GIDSignIn sharedInstance].currentUser;
    NSLog(@"user = %@", currentUser);
    
    if(currentUser)
    {
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
        {
            // NSUInteger dimension = round(thumbSize.width * [[UIScreen mainScreen] scale]);
            NSURL *imageURL = [user.profile imageURLWithDimension:100];
            pfl_pic_url=[NSString stringWithFormat:@"%@",imageURL];
            NSLog(@"imageURL:%@",imageURL);
        }
        eMail=email;
        // ,pfl_pic_url,pfl_img,firstName
        firstName=fullName;
        NSLog(@"Email:%@",user.profile.email);
        [self SocialRegister];
    }
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    //[myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
//- (void)signIn:(GIDSignIn *)signIn
//presentViewController:(UIViewController *)viewController
//{
//    [self presentViewController:viewController animated:YES completion:nil];
//
//    //[[GIDSignIn sharedInstance] signIn];
//
//}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 - (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
 error: (NSError *) error
 {
 NSLog(@"GTMOAuth2Authentication");
 
 //    [self doAnAuthenticatedAPIFetch:auth];
 
 if(!error)
 {
 // Get the email address.
 NSLog(@"G+ Email :- %@", signIn.authentication.userEmail);
 eMail = signIn.authentication.userEmail;
 if (auth.userEmail)
 {
 [[[GPPSignIn sharedInstance] plusService] executeQuery:[GTLQueryPlus queryForPeopleGetWithUserId:@"me"] completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error)
 {
 pfl_pic_url = person.image.url;
 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",person.image.url]];
 
 
 NSLog(@"The image is %@",person.image);
 pfl_img = [NSData dataWithContentsOfURL:url];
 
 NSLog(@"%@",url);
 firstName = person.displayName;
 //[[NSUserDefaults standardUserDefaults]setValue:pfl_pic_url forKey:@"ProfilePic"];
 [self SocialRegister];
 
 }];
 
 }
 }
 }*/

/*
 - (void)doAnAuthenticatedAPIFetch : (GTMOAuth2Authentication *)auth
 {
 NSString *urlStr = @"https://www.google.com/m8/feeds/contacts/default/full";//@"https://www.google.com/m8/feeds/contacts/default/full";
 
 
 //    https://www.google.com/m8/feeds/contacts/{userEmail}/full
 
 
 NSURL *url = [NSURL URLWithString:urlStr];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 [signIn.authentication authorizeRequest:request
 completionHandler:^(NSError *error)
 {
 NSString *output = nil;
 
 if (error)
 {
 output = [error description];
 }
 else
 {
 NSURLResponse *response = nil;
 NSData *data = [NSURLConnection sendSynchronousRequest:request
 returningResponse:&response
 error:&error];
 if (data)
 {
 // API fetch succeeded :Here I am getti
 output = [[NSString alloc] initWithData:data
 encoding:NSUTF8StringEncoding];
 
 NSLog(@"Contacts = %@",output);
 
 }
 else
 {
 // fetch failed
 output = [error description];
 
 NSLog(@"Error Contacts = %@",output);
 
 }
 }
 }];
 
 }
 */


/*
 - (void)doAnAuthenticatedAPIFetch : (GTMOAuth2Authentication *)auth
 {
 
 NSLog(@"doAnAuthenticatedAPIFetch");
 
 NSString *urlStr = @"https://www.google.com/m8/feeds/contacts/default/full";
 NSURL *url = [NSURL URLWithString:urlStr];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 
 [auth authorizeRequest:request
 completionHandler:^(NSError *error)
 {
 NSString *output = nil;
 if (error)
 {
 output = [error description];
 }
 else
 {
 NSURLResponse *response = nil;
 NSData *data = [NSURLConnection sendSynchronousRequest:request
 returningResponse:&response
 error:&error];
 if (data)
 {
 // API fetch succeeded :Here I am getti
 output = [[NSString alloc] initWithData:data
 encoding:NSUTF8StringEncoding];
 
 
 NSLog(@"Google Contacts = %@",output);
 
 }
 else
 {
 // fetch failed
 output = [error description];
 
 NSLog(@"Google Contacts Error = %@",output);
 
 }
 }
 }];
 }*/

/*
 -(void)configTwitter
 {
 
 
 TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error)
 {
 if (session)
 {
 user_id = [session userID];
 TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:[session userID]];
 [client loadUserWithID:user_id completion:^(TWTRUser *user, NSError *error)
 {
 NSLog(@"USER IMAGE %@",user.profileURL);
 }];
 NSString *message = [NSString stringWithFormat:@"@%@ logged in! (%@)",
 [session userName], [session userID]];
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged in!"
 message:message
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 [alert show];
 
 }
 else
 {
 NSLog(@"Login error: %@", [error localizedDescription]);
 }
 }];
 
 logInButton.loginMethods = TWTRLoginMethodWebBased;
 
 logInButton.center = self.view.center;
 
 [self.view addSubview:logInButton];
 
 [logInButton setImage:[UIImage imageNamed:@"twitter-icon.png"] forState:UIControlStateNormal];
 
 logInButton.imageView.image = [UIImage imageNamed:@"twitter-icon.png"];
 
 }*/

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    /*    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
     NSString *userID = store.session.userID;
     
     NSLog(@"Twitter UserId = %@",userID);
     
     [store logOutUserID:userID];
     
     
     NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"];
     NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
     for (NSHTTPCookie *cookie in cookies)
     {
     [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
     }*/
    
    //    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    [self deregisterFromKeyboardNotifications];
    
    self.imagePager.slideshowShouldCallScrollToDelegate = NO;
    
    [super viewWillDisappear:animated];
}


-(void)animateButton:(NSString*)image
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:image withExtension:@"gif"];
    
    self.imageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    


_imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.slideshowTimeInterval = 3.0f;
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    [UIView transitionWithView:self.email
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        NSArray *layerAry = self.email.layer.sublayers;
                        CALayer *border  = layerAry[0];
                        CGFloat borderWidth = 0.7;
                        border.borderColor = [UIColor whiteColor].CGColor;
                        [border setFrame:CGRectMake(0, (self.email.frame.size.height -borderWidth), self.email.frame.size.width, borderWidth)];
                        border.borderWidth = borderWidth;
                        self.email.layer.masksToBounds = YES;
                        
                        NSArray *PasslayerAry = self.password.layer.sublayers;
                        CALayer *PwdBorder  = PasslayerAry[0];
                        CGFloat PassBorderWidth = 0.7;
                        PwdBorder.borderColor = [UIColor whiteColor].CGColor;
                        [PwdBorder setFrame:CGRectMake(0, self.password.frame.size.height - borderWidth, self.password.frame.size.width, self.password.frame.size.height)];
                        PwdBorder.borderWidth = PassBorderWidth;
                        self.password.layer.masksToBounds = YES;
                        
                    }
                    completion:NULL];
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    
    //    NSLog(@"arrayWithImages");
    
    return images;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

- (NSString *) captionForImageAtIndex:(NSUInteger)index inPager:(KIImagePager *)pager
{
    return nil;
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
    
    //    [self animateButton:gifImages[index]];
    
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)login:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");
        
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
        //                                                                      message:@"Internet connection is down"
        //                                                               preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
        //                                                            style:UIAlertActionStyleDefault
        //                                                          handler:^(UIAlertAction * action)
        //                                    {
        //                                        NSLog(@"you pressed Yes, please button");
        //
        //                                    }];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    else
    {
        storeEmail=self.email.text;
        
        if(([self.email validate] && [self.password validate]))
        {
            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            hud.label.text = NSLocalizedString(@"Loading", @"HUD loading title");
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            manager.securityPolicy.allowInvalidCertificates = YES;
            manager.securityPolicy.validatesDomainName = NO;
            
            [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            
            [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            manager.securityPolicy.allowInvalidCertificates = YES;
            
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
            
            if (deviceToken == NULL)
            {
                deviceToken = @" ";
            }
            
            NSLog(@"Login Device Token = %@",deviceToken);
            
            NSDictionary *params = @{@"Email_ID":self.email.text , @"Password":self.password.text,@"lang":@"iOS",@"device_token":deviceToken,@"mobile_id":@"",@"wifi_ip_address":@""};
            
            NSString *url = @"https://hypdra.com/api/api.php?rquest=login";
            
            [manager POST:url parameters:params success:^(NSURLSessionTask *operation, id responseObject)
             {
                 
                 NSLog(@"Enter Login Response = %@",responseObject);
                 resValue = responseObject;
                 NSString *res=[responseObject objectForKey:@"msg"];
                 
                 tuser_id = [responseObject objectForKey:@"user_id"];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"User_name"] forKey:@"UserName"];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"referral_code"] forKey:@"ReferralCode"];
                 
                 NSString *Status=[responseObject valueForKey:@"status"];
                 
                 user_id = [resValue objectForKey:@"user_id"];
                 
                 if ([res isEqualToString:@"Success"] && [Status isEqualToString:@"1"])
                 {
                     [self LoadAllData];
                 }
                 else if([res isEqualToString:@"Account Confirmation Pending"] || [Status isEqualToString:@"2"]  || [Status isEqualToString:@"3"])
                 {
                     [hud hideAnimated:YES];
                     
                     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     
                     RegisterOTPViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OTPScreen"];
                     
                     vc.email=storeEmail;
                     vc.user_ID=tuser_id;
                     if([Status isEqualToString:@"3"])
                         vc.Type = @"TwoWay";
                     else
                         vc.Type = @"FirstTime";
                     
                     [self.navigationController pushViewController:vc animated:YES];
                 }
                 else
                 {
                     
                     [hud hideAnimated:YES];
                     
                     CustomPopUp *popUp = [CustomPopUp new];
                     [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your login credentials are invalid.\nPlease correct and try again" withTitle:@"Oops!" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                     popUp.okay.backgroundColor = [UIColor navyBlue];
                     popUp.agreeBtn.hidden = YES;
                     popUp.cancelBtn.hidden = YES;
                     popUp.inputTextField.hidden = YES;
                     [popUp show];
                 }
                 
             }
                  failure:^(NSURLSessionTask *operation, NSError *error)
             {
                 NSLog(@"Error: %@", error);
                 [hud hideAnimated:YES];
                 
                 CustomPopUp *popUp = [CustomPopUp new];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                 popUp.okay.backgroundColor = [UIColor navyBlue];
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
             }];
        }
        else
        {
            [hud hideAnimated:YES];
            
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter your details" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor lightGreen];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
            
        }
    }
}

- (IBAction)register:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
        //                                                                      message:@"Internet connection is down"
        //                                                               preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
        //                                                            style:UIAlertActionStyleDefault
        //                                                          handler:^(UIAlertAction * action)
        //                                    {
        //                                        NSLog(@"you pressed Yes, please button");
        //
        //                                    }];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Ckeck Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
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

- (IBAction)back:(id)sender
{
    
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"signOut"];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FirstView"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)profile:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type =  kCATransitionMoveIn;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController pushViewController:vc animated:NO];
    
    //   [self.navigationController pushViewController:vc animated:YES];// presentViewController:vc animated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSLog(@"textFieldShouldReturn");
    
    if (textField == self.email)
    {
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
        
    }
    else if (textField == self.password)
    {
        [textField resignFirstResponder];
        [self homePage];
    }
    return YES;
}

-(void)homePage
{
    storeEmail=self.email.text;
    
    if(([self.email validate] && [self.password validate]))
    {
        
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.label.text = NSLocalizedString(@"Loading", @"HUD loading title");
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
        
        if (deviceToken == NULL)
        {
            deviceToken = @" ";
        }
        
        NSLog(@"Login Device Token = %@",deviceToken);
        
        NSDictionary *params = @{@"Email_ID":self.email.text , @"Password":self.password.text,@"lang":@"iOS",@"device_token":deviceToken,@"mobile_id":@"",@"wifi_ip_address":@""};
        
        NSString *url = @"https://hypdra.com/api/api.php?rquest=login";
        
        [manager POST:url parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             
             NSLog(@"Enter Login Response = %@",responseObject);
             resValue = responseObject;
             NSString *res=[responseObject objectForKey:@"msg"];
             
             tuser_id = [responseObject objectForKey:@"user_id"];
             
             NSString *Status=[responseObject valueForKey:@"status"];
             
             user_id = [resValue objectForKey:@"user_id"];
             
             if ([res isEqualToString:@"Success"])
             {
                 [self LoadAllData];
             }
             else if([res isEqualToString:@"Account Confirmation Pending"] || [Status isEqualToString:@"2"] || [Status isEqualToString:@"3"])
             {
                 [hud hideAnimated:YES];
                 
                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 
                 RegisterOTPViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OTPScreen"];
                 
                 vc.email=storeEmail;
                 vc.user_ID=tuser_id;
                 if([Status isEqualToString:@"3"])
                     vc.Type = @"TwoWay";
                 else
                     vc.Type = @"FirstTime";
                 
                 [self.navigationController pushViewController:vc animated:YES];
             }
             else
             {
                 
                 [hud hideAnimated:YES];
                 
                 CustomPopUp *popUp = [CustomPopUp new];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your login credentials are invalid.\nPlease correct and try again" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                 popUp.okay.backgroundColor = [UIColor navyBlue];
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
             }
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             
             [hud hideAnimated:YES];
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
         }];
    }
    else
    {
        [hud hideAnimated:YES];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter your details" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView transitionWithView:self.email
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        NSArray *layerAry = textField.layer.sublayers;
                        CALayer *border  = layerAry[0];
                        CGFloat borderWidth = 2.0;
                        border.borderColor = [UIColor whiteColor].CGColor;
                        [border setFrame:CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height)];
                        border.borderWidth = borderWidth;
                        
                        textField.layer.masksToBounds = YES;
                        
                        
                        
                        UIColor *color = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.0];
                        NSString *placeholderText = textField.placeholder;
                        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
                    }
                    completion:NULL];
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView transitionWithView:textField
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        NSArray *layerAry = textField.layer.sublayers;
                        CALayer *border  = layerAry[0];
                        CGFloat borderWidth = 0.7;
                        border.borderColor = [UIColor whiteColor].CGColor;
                        [border setFrame:CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height)];
                        border.borderWidth = borderWidth;
                        
                        textField.layer.masksToBounds = YES;
                        
                        UIColor *color = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
                        NSString *placeholderText = textField.placeholder;
                        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
                    }
                    completion:NULL];
    [self animateTextField:textField up:NO];
}

-(void)setupAlerts{
    
    _email.isMandatory = YES;
    _password.isMandatory = YES;
    [_email updateLengthValidationMsg:@"enter valid email"];
    [_password updateLengthValidationMsg:@"Password charaters limit should be come between 4-20"];
    [_email addRegx:REGEX_EMAIL withMsg:@"enter valid email"];
    [_password addRegx:REGEX_PASS withMsg:@"Password must contain min 3 and max 20 characters"];
    
}
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    //    const int movementDistance = -130; // tweak as needed
    //    const float movementDuration = 0.3f; // tweak as needed
    //
    //    int movement = (up ? movementDistance : -movementDistance);
    //
    //    [UIView beginAnimations: @"animateTextField" context: nil];
    //    [UIView setAnimationBeginsFromCurrentState: YES];
    //    [UIView setAnimationDuration: movementDuration];
    //    self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
    //    [UIView commitAnimations];
}

//
//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//}
//
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
//
////    [self.view endEditing:YES];
//}
//
//
//- (void)keyboardDidShow:(NSNotification *)notification
//{
//    // Assign new frame to your view
//
//        [UIView beginAnimations: @"animateTextField" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: 0.2f];
//
//        [self.view setFrame:CGRectMake(0,-110,320,460)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
//
//        [UIView commitAnimations];
//
//
//}
//
//-(void)keyboardDidHide:(NSNotification *)notification
//{
//    [UIView beginAnimations: @"animateTextField" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: 0.2f];
//
//    [self.view setFrame:CGRectMake(0,0,320,460)];
//
//    [UIView commitAnimations];
//
//}

/*
 - (void)registerForKeyboardNotifications {
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(keyboardWasShown:)
 name:UIKeyboardDidShowNotification
 object:nil];
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(keyboardWillBeHidden:)
 name:UIKeyboardWillHideNotification
 object:nil];
 
 }
 
 - (void)deregisterFromKeyboardNotifications {
 
 [[NSNotificationCenter defaultCenter] removeObserver:self
 name:UIKeyboardDidHideNotification
 object:nil];
 
 [[NSNotificationCenter defaultCenter] removeObserver:self
 name:UIKeyboardWillHideNotification
 object:nil];
 
 }
 
 
 - (void)keyboardWasShown:(NSNotification *)notification
 {
 
 NSLog(@"Enable");
 
 NSDictionary* info = [notification userInfo];
 
 CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
 
 CGPoint buttonOrigin = self.signInButton.frame.origin;
 
 CGFloat buttonHeight = self.signInButton.frame.size.height;
 
 CGRect visibleRect = self.view.frame;
 
 visibleRect.size.height -= keyboardSize.height;
 
 NSLog(@"visibleRect Point = %@",NSStringFromCGRect(visibleRect));
 
 NSLog(@"Point = %@",NSStringFromCGPoint(buttonOrigin));
 
 if (!CGRectContainsPoint(visibleRect, buttonOrigin))
 {
 CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
 
 NSLog(@"Scroll Point = %@",NSStringFromCGPoint(scrollPoint));
 
 [self.scrollView setContentOffset:scrollPoint animated:YES];
 }
 
 }
 
 - (void)keyboardWillBeHidden:(NSNotification *)notification
 {
 [self.scrollView setContentOffset:CGPointZero animated:YES];
 }
 
 */



-(void)get
{
    @try
    
    {
        dispatch_group_enter(group);
        dispatch_group_t sub_group=dispatch_group_create();
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=view_my_image";
        NSDictionary *parameters = @{@"User_ID":tuser_id,@"lang":@"iOS"};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8",@"application/json", nil];
        manager.responseSerializer = responseSerializer;
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        dispatch_group_enter(sub_group);
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSLog(@"ImageViewResponse == %@",responseObject);
                  
                  NSMutableDictionary *response=responseObject;
                  
                  NSArray *imageArray = [response objectForKey:@"view_my_image"];
                  
                  NSLog(@"Image Response %@",response);
                  
                  finalArray = [[NSMutableArray alloc]init];
                  
                  NSArray *statusArray = [response objectForKey:@"Response_array"];
                  
                  NSDictionary *stsDict = [statusArray objectAtIndex:0];
                  
                  NSString *status = [stsDict objectForKey:@"msg"];
                  
                  if ([status isEqualToString:@"Found"])
                  {
                      for(NSDictionary *imageDic in imageArray)
                      {
                          NSString *thumbnailPath;
                          
                          NSString *type = [imageDic objectForKey:@"type"];
                          
                          if([type isEqualToString:@"Video"])
                          {
                              thumbnailPath = [imageDic objectForKey:@"thumb_img"];
                          }
                          else
                          {
                              thumbnailPath = [imageDic objectForKey:@"thumb_img"];
                          }
                          
                          NSString *id = [imageDic objectForKey:@"image_id"];
                          
                          NSString *videoPath;
                          
                          NSLog(@"Image Retrive Response:%@",videoPath);
                          
                          NSURL *thumbnailUrl = [NSURL URLWithString:thumbnailPath];
                          
                          NSData *thumbnailData = [NSData dataWithContentsOfURL:thumbnailUrl];
                          
                          NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                          
                          [dic setValue:type forKey:@"DataType"];
                          
                          [dic setValue:id forKey:@"Id"];
                          
                          if(![type isEqualToString:@"Image"])
                          {
                              videoPath = [imageDic objectForKey:@"VideoPath"];
                              
                              [dic setValue:videoPath forKey:@"videoPath"];
                          }
                          
                          [finalArray addObject:dic];
                          
                          [self fileName:id fileData:thumbnailData folderName:@"MyImagesAndVideos"];
                          
                      }
                  }
                  else
                  {
                      NSLog(@"No Image Found");
                  }
                  dispatch_group_leave(sub_group);
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  dispatch_group_leave(sub_group);
              }
              
          }]resume];
        
        dispatch_group_notify(sub_group, dispatch_get_main_queue(),
                              ^{
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

-(void)LoadAllData
{
    @try
    {
        NSLog(@"Load All Function");
        
        group=dispatch_group_create();
       
        
        dispatch_group_notify(group, dispatch_get_main_queue(),
                              ^{
                                  NSLog(@"All Done");
                                  //                                  [spinner stopAnimating];
                                  [hud hideAnimated:YES];
                                  
                                  NSLog(@"Final Response Before = %@",resValue);
                                  
                                  NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                  
                                  NSString *minAvil=[resValue objectForKey:@"Duration Status"];
                                  
                                  NSString *spcAvil = [resValue objectForKey:@"Space Status"];
                                  
                                  [defaults setValue:minAvil forKey:@"minAvil"];
                                  
                                  [defaults setValue:spcAvil forKey:@"spcAvil"];
                                  
                                  NSString *MemberShipType = [resValue objectForKey:@"Plan"];
                                  
                                  [defaults setValue:MemberShipType forKey:@"MemberShipType"];
                                  
                                  user_id = [resValue objectForKey:@"user_id"];
                                  
                                  NSString *albumCount = [resValue objectForKey:@"advance_album_count"];
                                  
                                  NSString *albumCount1 = [resValue objectForKey:@"wizard_album_count"];
                                  
                                  int numValue = [albumCount intValue];
                                  
                                  int numValue1 = [albumCount1 intValue];
                                  
                                  NSLog(@"Login Album Count = %d",numValue);
                                  
                                  NSLog(@"Login Wizard Count = %d",numValue1);
                                  
                                  [defaults setInteger:numValue forKey:@"AlbumCount"];
                                  
                                  [defaults setInteger:numValue1 forKey:@"AlbumCount1"];
                                  
                                  [defaults setValue:user_id forKey:@"USER_ID"];
                                  
                                  NSString *profilePic = [resValue objectForKey:@"User_Profile_Pic"];
             
                                  NSString *profileName = [resValue objectForKey:@"User_name"];
                                  
                                  [defaults setValue:profilePic forKey:@"ProfilePic"];
                                  
                                  [defaults setValue:profileName forKey:@"Profilename"];
                                  
                                  [defaults setValue:[resValue objectForKey:@"Email_ID"] forKey:@"Email_ID"];
                                  
                                  [defaults setValue:user_id forKey:@"USER_ID"];
                                  [defaults setValue:[resValue objectForKey:@"referral_code"] forKey:@"referral_code"];
                                  [defaults synchronize];
                                  
                                  [CrashlyticsKit setUserIdentifier:user_id];
                                  [CrashlyticsKit setUserEmail:[resValue objectForKey:@"Email_ID"]];
                                  [CrashlyticsKit setUserName:profileName];
                                  
                                  NSLog(@"Final Before Login");
                                  
                                  //                                   NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                  //                                   [defaults setValue:user_id forKey:@"USER_ID"];
                                  //                                   [defaults synchronize];
                                  
                                  UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  
                                  DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                                  
                                  [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
                                  
                                  vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                  [self presentViewController:vc animated:YES completion:nil];
                                  
                                  
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

-(void)loadMusic
{
    
    //    @try
    //    {
    //        dispatch_group_enter(group);
    //        dispatch_group_t sub_group=dispatch_group_create();
    //
    //        NSURL *URL = [NSURL URLWithString:@"https://www.hypdra.com/api/api.php?rquest=view_particular_user_audio_dtls"];
    //
    //        NSDictionary *params = @{@"user_id":tuser_id,@"lang":@"iOS"};
    //        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    //        dispatch_group_enter(sub_group);
    //
    //        [manager POST:URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
    //         {
    //             NSMutableDictionary *response=responseObject;
    //
    //             NSLog(@"Music Response = %@",response);
    //
    //             NSArray *MusicArray = [response objectForKey:@"view_particular_user_audio_dtls"];
    //
    //             musicArray = [[NSMutableArray alloc]init];
    //
    //             NSArray *statusArray = [response objectForKey:@"Response_array"];
    //
    //             NSDictionary *stsDict = [statusArray objectAtIndex:0];
    //
    //             NSString *status = [stsDict objectForKey:@"msg"];
    //
    //             if ([status isEqualToString:@"Found"])
    //             {
    //                 for(NSDictionary *imageDic in MusicArray)
    //                 {
    //                     NSString *name = [imageDic objectForKey:@"Audio_name"];
    //                     NSString *audid = [imageDic objectForKey:@"aud_id"];
    //
    //                     NSDictionary *sampleDic = @{@"MusicTitle":name,@"MusicId":audid};
    //
    //                     [musicArray addObject:sampleDic];
    //                 }
    //                 [self saveMusic];
    //             }
    //             else
    //             {
    //                 NSLog(@"Music Not Found..");
    //             }
    //             dispatch_group_leave(sub_group);
    //         }
    //              failure:^(NSURLSessionTask *operation, NSError *error)
    //         {
    //             NSLog(@"Error: %@", error);
    //             dispatch_group_leave(sub_group);
    //         }];
    //        dispatch_group_notify(sub_group, dispatch_get_main_queue(),
    //                              ^{
    //                                  NSLog(@"Load Music Data Done");
    //                                  dispatch_group_leave(group);
    //                              });
    //    }
    //    @catch (NSException *exception)
    //    {
    //
    //    }
    //    @finally
    //    {
    //
    //    }
    //
    //
    
    
    
    /*
     
     @try
     {
     
     NSLog(@"Enter Music Group");
     
     dispatch_group_enter(group);
     dispatch_group_t sub_group=dispatch_group_create();
     
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     
     manager.securityPolicy.allowInvalidCertificates = YES;
     manager.securityPolicy.validatesDomainName = NO;
     
     manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
     
     [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
     [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
     
     manager.securityPolicy.allowInvalidCertificates = YES;
     
     // NSString *URLString = @"http://108.175.2.116/montage/api/api.php?rquest=delete_my_image";
     
     
     NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_particular_user_audio_dtls";
     
     //  NSString *URLString = [NSString stringWithFormat:@"%@view_coach.php", BasePath];
     
     NSDictionary *params = @{@"user_id":tuser_id,@"lang":@"iOS"};
     
     dispatch_group_enter(sub_group);
     
     [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
     NSMutableDictionary *response=responseObject;
     
     NSLog(@"Music Response = %@",response);
     
     NSArray *MusicArray = [response objectForKey:@"view_particular_user_audio_dtls"];
     
     musicArray = [[NSMutableArray alloc]init];
     
     NSArray *statusArray = [response objectForKey:@"Response_array"];
     
     NSDictionary *stsDict = [statusArray objectAtIndex:0];
     
     NSString *status = [stsDict objectForKey:@"msg"];
     
     if ([status isEqualToString:@"Found"])
     {
     for(NSDictionary *imageDic in MusicArray)
     {
     
     NSString *name = [imageDic objectForKey:@"Audio_name"];
     NSString *audid = [imageDic objectForKey:@"aud_id"];
     
     NSDictionary *sampleDic = @{@"MusicTitle":name,@"MusicId":audid};
     
     [musicArray addObject:sampleDic];
     
     }
     
     [self saveMusic];
     
     }
     else
     {
     NSLog(@"Music Not Found..");
     }
     
     
     dispatch_group_leave(sub_group);
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
     NSLog(@"Error for Music : %@", error);
     dispatch_group_leave(sub_group);
     }];
     dispatch_group_notify(sub_group, dispatch_get_main_queue(),
     ^{
     NSLog(@"Load Music Data Done");
     dispatch_group_leave(group);
     });
     }
     @catch (NSException *exception)
     {
     
     }
     @finally
     {
     
     }*/
    
    @try
    {
        
        NSLog(@"Enter Music Group");
        
        dispatch_group_enter(group);
        dispatch_group_t sub_group=dispatch_group_create();
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_particular_user_audio_dtls";
        
        NSDictionary *parameters = @{@"user_id":tuser_id,@"lang":@"iOS"};
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8",@"application/json", nil];
        manager.responseSerializer = responseSerializer;
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        dispatch_group_enter(sub_group);
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSMutableDictionary *response=responseObject;
                  
                  NSLog(@"Music Response = %@",response);
                  
                  NSArray *MusicArray = [response objectForKey:@"view_particular_user_audio_dtls"];
                  
                  musicArray = [[NSMutableArray alloc]init];
                  
                  NSArray *statusArray = [response objectForKey:@"Response_array"];
                  
                  NSDictionary *stsDict = [statusArray objectAtIndex:0];
                  
                  NSString *status = [stsDict objectForKey:@"msg"];
                  
                  if ([status isEqualToString:@"Found"])
                  {
                      for(NSDictionary *imageDic in MusicArray)
                      {
                          
                          NSString *name = [imageDic objectForKey:@"Audio_name"];
                          NSString *audid = [imageDic objectForKey:@"aud_id"];
                          
                          NSDictionary *sampleDic = @{@"MusicTitle":name,@"MusicId":audid};
                          
                          [musicArray addObject:sampleDic];
                          
                      }
                      
                      [self saveMusic];
                      
                  }
                  else
                  {
                      NSLog(@"Music Not Found..");
                  }
                  
                  dispatch_group_leave(sub_group);
              }
              else
              {
                  NSLog(@"Error for Music :");
                  dispatch_group_leave(sub_group);
              };
              dispatch_group_notify(sub_group, dispatch_get_main_queue(),
                                    ^{
                                        NSLog(@"Load Music Data Done");
                                        dispatch_group_leave(group);
                                    });
          }]resume];
    }
    @catch(NSException *exc)
    {
        
    }
}


-(void)saveMusic
{
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Music"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *SharedFinalplistPath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyMusic.plist"]];
    
    //    MusicName = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    //
    //    if (MusicName == nil)
    //    {
    //        MusicName = [[NSMutableArray alloc]init];
    //    }
    
    //    NSLog(@"MusicPlistPath:%@",SharedFinalplistPath);
    
    /*    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
     
     [dic setValue:songTitle forKey:@"MusicTitle"];
     
     [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"MusicId"];
     
     [MusicName addObject:dic];*/
    
    NSLog(@"MusicArray = %@",musicArray);
    
    [musicArray writeToFile:SharedFinalplistPath atomically:YES];
    
    /*    NSLog(@"NSData = %@",globalDataPath);
     
     NSData *data = [NSData dataWithContentsOfFile:globalDataPath];
     
     NSLog(@"All Data's = %d",data.length);*/
    
    NSLog(@"Music Data's done");
}


//-(void)loadEffectsData
//{
//    @try
//    {
//        dispatch_group_enter(group);
//        dispatch_group_t sub_group=dispatch_group_create();
//
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//
//        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
//        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
//        manager.securityPolicy.allowInvalidCertificates = YES;
//        // NSString *URLString = @"http://108.175.2.116/montage/api/api.php?rquest=delete_my_image";
//
//        NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=view_effects";
//
//        //  NSString *URLString = [NSString stringWithFormat:@"%@view_coach.php", BasePath];
//
//        NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
//
//
//        dispatch_group_enter(sub_group);
//
//
//        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
//         {
//             NSMutableDictionary *response=responseObject;
//             NSArray *imageArray = [response objectForKey:@"view_effect_image"];
//             NSLog(@"Effects Response %@",response);
//             for(NSDictionary *imageDic in imageArray)
//             {
//                 NSString *imageUrl = [imageDic objectForKey:@"thumb_img_path"];
//
//
//                 if (!(imageUrl == nil || imageUrl == (id)[NSNull null]))
//                 {
//                     NSString *image_id = [imageDic objectForKey:@"id"];
//                     NSLog(@"Effect Retrive Response:%@",imageUrl);
//                     NSURL *url = [NSURL URLWithString:imageUrl];
//                     NSData *imageData = [NSData dataWithContentsOfURL:url];
//                     //[finalArray addObject:image_id];
//                     [self fileName:image_id fileData:imageData folderName:@"Effects"];
//                 }
//             }
//             dispatch_group_leave(sub_group);
//         }
//              failure:^(NSURLSessionTask *operation, NSError *error)
//         {
//             NSLog(@"Error9: %@", error);
//             dispatch_group_leave(sub_group);
//         }];
//
//        dispatch_group_notify(sub_group, dispatch_get_main_queue(), ^{
//            NSLog(@"Load Effects Done");
//            dispatch_group_leave(group);
//        });
//
//    }
//    @catch (NSException *exception)
//    {
//
//    }
//    @finally
//    {
//
//    }
//}

-(void)loadTransitionData
{
    @try
    {
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
                 
                 //[finalArray addObject:image_id];
                 [self fileName:image_id fileData:imageData folderName:@"Transitions"];
                 
             }
             dispatch_group_leave(sub_group);
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             dispatch_group_leave(sub_group);
             
         }];
        
        dispatch_group_notify(sub_group, dispatch_get_main_queue(),
                              ^{
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
    
    //    NSString *dataPath = [documentsPathlist stringByAppendingFormat:@"/%@",FileName];
    //
    //    NSLog(@"FilePath:%@",dataPath);
    //
    //    [data writeToFile:dataPath atomically:YES];
    
    NSString *SharedFinalplistPath = [documentsPathlist stringByAppendingPathComponent:@"DataList.plist"];
    
    //    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    
    //    if (finalArray == nil)
    //    {
    //        finalArray = [NSMutableArray array];
    //    }
    
    NSLog(@"LoginPlistPath:%@",SharedFinalplistPath);
    
    NSLog(@"Final Array = %@",finalArray);
    
    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    
}

-(void)loadImageData
{
    @try
    {
        dispatch_group_enter(group);
        dispatch_group_t sub_group=dispatch_group_create();
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        // NSString *URLString = @"http://108.175.2.116/montage/api/api.php?rquest=delete_my_image";
        
        // NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=view_my_image";
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_my_image";
        
        //  NSString *URLString = [NSString stringWithFormat:@"%@view_coach.php", BasePath];
        
        NSDictionary *params = @{@"User_ID":tuser_id,@"lang":@"iOS"};
        
        dispatch_group_enter(sub_group);
        
        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             NSArray *imageArray = [response objectForKey:@"view_my_image"];
             
             NSLog(@"Image Response %@",response);
             
             finalArray = [[NSMutableArray alloc]init];
             
             NSArray *statusArray = [response objectForKey:@"Response_array"];
             
             NSDictionary *stsDict = [statusArray objectAtIndex:0];
             
             NSString *status = [stsDict objectForKey:@"msg"];
             
             if ([status isEqualToString:@"Found"])
             {
                 for(NSDictionary *imageDic in imageArray)
                 {
                     //27APR STARTS
                     NSString *thumbnailPath;
                     NSString *type = [imageDic objectForKey:@"type"];
                     if([type isEqualToString:@"Video"])
                     {
                         thumbnailPath = [imageDic objectForKey:@"thumb_img"];
                     }
                     else
                     {
                         thumbnailPath = [imageDic objectForKey:@"thumb_img"];
                     }
                     
                     NSString *id = [imageDic objectForKey:@"image_id"];
                     NSString *videoPath;
                     NSLog(@"Image Retrive Response:%@",videoPath);
                     
                     NSURL *thumbnailUrl = [NSURL URLWithString:thumbnailPath];
                     NSData *thumbnailData = [NSData dataWithContentsOfURL:thumbnailUrl];
                     NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                     [dic setValue:type forKey:@"DataType"];
                     [dic setValue:id forKey:@"Id"];
                     
                     if(![type isEqualToString:@"Image"])
                     {
                         videoPath = [imageDic objectForKey:@"VideoPath"];
                         [dic setValue:videoPath forKey:@"videoPath"];
                     }
                     
                     [finalArray addObject:dic];
                     
                     [self fileName:id fileData:thumbnailData folderName:@"MyImagesAndVideos"];
                 }
                 
             }
             else
             {
                 NSLog(@"No Image Found");
             }
             
             /*             for(NSDictionary *imageDic in imageArray)
              {
              //27APR STARTS
              NSString *thumbnailPath;
              NSString *type = [imageDic objectForKey:@"type"];
              if([type isEqualToString:@"Video"])
              {
              thumbnailPath = [imageDic objectForKey:@"Video_Path"];
              }
              else
              {
              thumbnailPath = [imageDic objectForKey:@"Image_Path"];
              }
              
              NSString *id = [imageDic objectForKey:@"image_id"];
              NSString *videoPath;
              NSLog(@"Image Retrive Response:%@",videoPath);
              
              NSURL *thumbnailUrl = [NSURL URLWithString:thumbnailPath];
              NSData *thumbnailData = [NSData dataWithContentsOfURL:thumbnailUrl];
              NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
              [dic setValue:type forKey:@"DataType"];
              [dic setValue:id forKey:@"Id"];
              
              if(![type isEqualToString:@"Image"])
              {
              videoPath = [imageDic objectForKey:@"VideoPath"];
              [dic setValue:videoPath forKey:@"videoPath"];
              }
              
              [finalArray addObject:dic];
              
              [self fileName:id fileData:thumbnailData folderName:@"MyImagesAndVideos"];
              //27APR ENDS
              }*/
             /*             for(NSDictionary *imageDic in imageArray)
              {
              
              
              NSString *thumbnailPath = [imageDic objectForKey:@"Image_Path"];
              NSString *id = [imageDic objectForKey:@"image_id"];
              NSString *type = [imageDic objectForKey:@"type"];
              NSString *videoPath;
              NSLog(@"Image Retrive Response:%@",videoPath);
              
              NSURL *thumbnailUrl = [NSURL URLWithString:thumbnailPath];
              NSData *thumbnailData = [NSData dataWithContentsOfURL:thumbnailUrl];
              
              NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
              [dic setValue:type forKey:@"DataType"];
              [dic setValue:id forKey:@"Id"];
              
              if(![type isEqualToString:@"Image"])
              {
              videoPath = [imageDic objectForKey:@"VideoPath"];
              [dic setValue:videoPath forKey:@"videoPath"];
              
              }
              
              [finalArray addObject:dic];
              
              [self fileName:id fileData:thumbnailData folderName:@"MyImagesAndVideos"];
              
              }*/
             dispatch_group_leave(sub_group);
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error : %@", error);
             dispatch_group_leave(sub_group);
         }];
        dispatch_group_notify(sub_group, dispatch_get_main_queue(),
                              ^{
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

- (IBAction)forgotPassword:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
        //                                                                      message:@"Internet connection is down"
        //                                                               preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
        //                                                            style:UIAlertActionStyleDefault
        //                                                          handler:^(UIAlertAction * action)
        //                                    {
        //                                        NSLog(@"you pressed Yes, please button");
        //
        //                                    }];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Ckeck Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    
    else
    {
        // if (IS_PAD)
        //        {
        //            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainiPad" bundle:nil];
        //
        //            ForgotPasswordController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ForgotPassword"];
        //
        //            [self.navigationController pushViewController:vc animated:YES];
        //        }
        //        else
        //        {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ForgotPasswordController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ForgotPassword"];
        
        [self.navigationController pushViewController:vc animated:YES];
        // }
    }
}


- (IBAction)FB_btn:(id)sender
{
    
    //    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //
    //    NSArray *allCookies = [cookies cookies];
    //
    //    for(NSHTTPCookie *cookie in allCookies) {
    //        if([[cookie domain] rangeOfString:@"facebook.com"].location != NSNotFound) {
    //            [cookies deleteCookie:cookie];
    //        }
    //    }
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
        //                                                                      message:@"Internet connection is down"
        //                                                               preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
        //                                                            style:UIAlertActionStyleDefault
        //                                                          handler:^(UIAlertAction * action)
        //                                    {
        //                                        NSLog(@"you pressed Yes, please button");
        //
        //                                    }];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Ckeck Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        login.loginBehavior = FBSDKLoginBehaviorNative;
        
        [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 // Process error
                 NSLog(@"error %@",error);
             }
             else if (result.isCancelled)
             {
                 // Handle cancellations
                 NSLog(@"Cancelled");
             }
             else
             {
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     // Do work
                     [self fetchUserInfo];
                 }
             }
         }];
    }
}


/*
 -(void)fetchUserInfo {
 
 if ([FBSDKAccessToken currentAccessToken]) {
 
 NSLog(@"Token is available");
 
 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name"}]
 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
 if (!error) {
 NSLog(@"fetched user:%@", result);
 NSString *facebookID = result[@"id"];
 
 NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
 NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
 UIImage *fbImage = [UIImage imageWithData:imageData];
 NSLog(@"PictureURL%@",pictureURL);
 
 }
 }];    } else {
 
 NSLog(@"User is not Logged in");
 }
 }*/


-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        
        NSLog(@"Token is available");
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 NSString *facebookID = result[@"id"];
                 
                 firstName = result[@"name"];
                 result[@"first_name"];
                 NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                 pfl_pic_url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
                 pfl_img = [NSData dataWithContentsOfURL:pictureURL];
                 //pfl_img = [UIImage imageWithData:imageData];
                 
                 // [[NSUserDefaults standardUserDefaults]setValue:pfl_pic_url forKey:@"ProfilePic"];
                 //                 [[NSUserDefaults standardUserDefaults]synchronize];
                 NSLog(@"PictureURL%@",pictureURL);
                 eMail = result[@"email"];
                 [self SocialRegister];
             }
         }];
    }
    else
    {
        NSLog(@"User is not Logged in");
    }
}


- (IBAction)twitterButton:(id)sender
{
    /*    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased completion:^(TWTRSession *session, NSError *error)
     {
     NSLog(@"session%@",session);
     user_id = [session userID];
     NSLog(@"session %@",user_id);
     
     user_id = [session userID];
     TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:[session userID]];
     [client loadUserWithID:user_id completion:^(TWTRUser *user, NSError *error)
     {
     NSLog(@"USER IMAGE %@",user.profileURL);
     }];
     
     
     }];*/
    
    
    //    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    //    NSString *userID = store.session.userID;
    //
    //    [store logOutUserID:userID];
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
        //                                                                      message:@"Internet connection is down"
        //                                                               preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
        //                                                            style:UIAlertActionStyleDefault
        //                                                          handler:^(UIAlertAction * action)
        //                                    {
        //                                        NSLog(@"you pressed Yes, please button");
        //
        //                                    }];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Ckeck Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    else
    {
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error)
         {
             if (session)
             {
                 NSLog(@"signed in as %@", session.userID);
                 NSLog(@"signed in as %@", session.userName);
                 
                 firstName = session.userName;
                 
                 NSString *userID = session.userID;
                 TWTRAPIClient *client_pfl_pic = [[TWTRAPIClient alloc] initWithUserID:userID];
                 [client_pfl_pic loadUserWithID:userID completion:^(TWTRUser *user, NSError *error) {
                     NSLog(@"Profile image url = %@", user.profileImageLargeURL);
                     pfl_pic_url = user.profileImageLargeURL;
                     TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
                     [client requestEmailForCurrentUser:^(NSString *email, NSError *error)
                      {
                          if (email)
                          {
                              NSLog(@"Email for user %@", email);
                              
                              eMail = email;
                              [self SocialRegister];
                              
                          }
                          else
                          {
                              NSLog(@"error: %@", [error localizedDescription]);
                          }
                          
                      }];
                 }];
             }
             else
             {
                 NSLog(@"error: %@", [error localizedDescription]);
             }
         }];
        
        
        
        //    [[[Twitter sharedInstance] sessionStore] logOutUserID:user_id];
        
        /*    TWTRShareEmailViewController* shareEmailViewController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString* email, NSError* error)
         {
         NSLog(@"Email %@, Error: %@", email, error);
         }]; [self presentViewController:shareEmailViewController animated:YES completion:nil]; } else { // TODO: Handle user not signed in (e.g. attempt to log in or show an alert) }*/
        
        /*    NSHTTPCookie *cookie;
         NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
         for (cookie in [storage cookies])
         {
         NSString* domainName = [cookie domain];
         NSRange domainRange = [domainName rangeOfString:@"Twitter"];
         if(domainRange.length > 0)
         {
         [storage deleteCookie:cookie];
         }
         }
         
         NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"];
         NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
         for (NSHTTPCookie *cookie in cookies)
         {
         [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
         }*/
        //    eMail = @"sundarpay@gmail.com";
    }
}

- (IBAction)GoogleSignIn:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
        //                                                                      message:@"Internet connection is down"
        //                                                               preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
        //                                                            style:UIAlertActionStyleDefault
        //                                                          handler:^(UIAlertAction * action)
        //                                    {
        //                                        NSLog(@"you pressed Yes, please button");
        //
        //                                    }];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Ckeck Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        [[GIDSignIn sharedInstance] signIn];
    }
    
}

- (IBAction)SignUpAcion:(id)sender
{
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_1" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
}
//-(void)SocialRegister
//{
//    if([self setImageParams])
//    {
//        NSOperationQueue *queue = [NSOperationQueue mainQueue];
//
//        [NSURLConnection sendAsynchronousRequest:request
//                                           queue:queue completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
//         {
//
//             NSLog(@"added successfully:%@",data);
//             NSLog(@"URLResponse:%@",urlResponse);
//
//             NSDictionary *responseObject=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//
//             NSLog(@"Social Login Response:%@",responseObject);
//
//         }];
//    }else{
//
//    }
//
////    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
////
////    hud.mode = MBProgressHUDModeAnnularDeterminate;
////    hud.label.text = NSLocalizedString(@"Uploading...", @"HUD loading title");
////    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
////    if (deviceToken == NULL)
////    {
////        deviceToken = @"";
////    }
////    NSLog(@"Socail Login Device Token = %@",deviceToken);
////
////    NSString *URL = @"https://hypdra.com/api/api.php?rquest=register";
////
////NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
////                                 {
////
////                                     [formData appendPartWithFileData:pfl_img name:@"user_profile_pic" fileName:@"uploads.png" mimeType:@"image/jpeg"];
////
////                                     [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"First_Name"];
////
////                                     [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
////
////                                     [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"Last_Name"];
////
////                                     [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"Password"];
////
////                                     [formData appendPartWithFormData:[deviceToken dataUsingEncoding:NSUTF8StringEncoding] name:@"device_token"];
////
////                                     [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"refferal_code"];
////
////                                     [formData appendPartWithFormData:[eMail dataUsingEncoding:NSUTF8StringEncoding] name:@"Email_ID"];
////
////                                     [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:@"social_media_email"];
////                                     [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"mobile_id"];
////                                     [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"wifi_ip_address"];
////
////                                 } error:nil];
////
////
////AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////
////manager.responseSerializer = [AFHTTPResponseSerializer serializer];
////
////
////NSURLSessionUploadTask *uploadTask;
////uploadTask = [manager
////              uploadTaskWithStreamedRequest:requests
////              progress:^(NSProgress * _Nonnull uploadProgress)
////              {
////                  dispatch_async(dispatch_get_main_queue(),
////                                 ^{
////                                     [MBProgressHUD HUDForView:self.navigationController.view].progress = uploadProgress.fractionCompleted;
////
////                                 });
////              }
////              completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
////              {
////                  if (error)
////                  {
////                      NSLog(@"Error For Image: %@", error);
////
////
////                  }
////                  else
////                  {
////                      NSMutableDictionary *response = responseObject;
////                      NSLog(@"Social Login Json Response:%@",response);
////
////                      NSString *res = [response objectForKey:@"status"];
////
////                      resValue = response;
////
////                      tuser_id = [response objectForKey:@"user_id"];
////
////                      if([res isEqualToString:@"Exist"])
////                      {
////
////                          [self LoadAllData];
////
////
////
////                          /*             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
////                           [defaults setValue:user_id forKey:@"USER_ID"];
////
////                           [defaults synchronize];
////
////                           UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////
////                           PageSelectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
////
////                           vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
////
////                           [self presentViewController:vc animated:YES completion:NULL];*/
////                      }
////                      else
////                      {
////                          NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
////
////                          NSString *uID = [response objectForKey:@"user_id"];
////
////                          [defaults setValue:uID forKey:@"USER_ID"];
////
////                          [defaults setValue:@"Duration Available" forKey:@"minAvil"];
////
////                          [defaults setValue:@"Space Available" forKey:@"spcAvil"];
////
////                          [defaults synchronize];
////
////                          [hud hideAnimated:YES];
////
////
////
////
////                          UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
////                                                                                        message:@"Check your email for your new password"
////                                                                                 preferredStyle:UIAlertControllerStyleAlert];
////
////                          UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
////                                                                              style:UIAlertActionStyleDefault
////                                                                            handler:^(UIAlertAction * action)
////                                                      {
////
////                                                          UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////
////                                                          PageSelectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
////
////                                                          vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
////
////                                                          [self presentViewController:vc animated:YES completion:NULL];
////
////                                                      }];
////
////
////                          [alert addAction:yesButton];
////
//// [self presentViewController:alert animated:YES completion:nil];
////
////
////                          }
////                  }
////
////                  }];
////    [uploadTask resume];
//
//}

-(void)SocialRegister
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //            NSDictionary *params = @{@"User_Name":@"Ragu",@"Email_ID": self.email.text,@"Password":self.password.text,};
    
    
    NSLog(@"Email_ID = %@",eMail);
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
    
    if (deviceToken == NULL)
    {
        deviceToken = @" ";
    }
    
    NSLog(@"Socail Login Device Token = %@",deviceToken);
    
    
    NSDictionary *params1 = @{@"First_Name":firstName,@"Last_Name":firstName,@"Password":@"",@"device_token":deviceToken,@"refferal_code":@"",@"Email_ID":eMail,@"lang":@"iOS",@"social_media_email":@"1",@"mobile_id":@"",@"wifi_ip_address":@"",@"user_profile_pic":pfl_pic_url};
    
    NSString *url = @"https://hypdra.com/api/api.php?rquest=register";
    
    [manager POST:url parameters:params1 success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Social Login Json Response:%@",responseObject);
         
         NSString *res = [responseObject objectForKey:@"status"];
         
         resValue = responseObject;
         
         tuser_id = [responseObject objectForKey:@"user_id"];
         
         if([res isEqualToString:@"Exist"])
         {
             
             [self LoadAllData];
             
             
             
             /*             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
              [defaults setValue:user_id forKey:@"USER_ID"];
              
              [defaults synchronize];
              
              UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              
              PageSelectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
              
              vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
              
              [self presentViewController:vc animated:YES completion:NULL];*/
         }
         
         else
         {
             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
             
             NSString *uID = [responseObject objectForKey:@"user_id"];
             
             [defaults setValue:uID forKey:@"USER_ID"];
             
             [defaults setValue:@"Duration Available" forKey:@"minAvil"];
             
             [defaults setValue:@"Space Available" forKey:@"spcAvil"];
             
             [defaults synchronize];
             
             [hud hideAnimated:YES];
             
             //             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
             //                  message:@"Check your email for your new password" preferredStyle:UIAlertControllerStyleAlert];
             //
             //             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
             //                 style:UIAlertActionStyleDefault
             //                 handler:^(UIAlertAction * action)
             //                 {
             //
             //                     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             //
             //                     PageSelectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
             //
             //                     vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
             //
             //                     [self presentViewController:vc animated:YES completion:NULL];
             //
             //                 }];
             //
             //             [alert addAction:yesButton];
             //
             //             [self presentViewController:alert animated:YES completion:nil];
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Ckeck Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.accessibilityHint =@"CheckNewPassword";
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
         }
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         //responseBlock(nil, FALSE, error);
     }];
}

-(BOOL)setImageParams
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
    @try
    {
        if (pfl_img!=nil)
        {
            
            NSLog(@"Enter Image send");
            
            request = [NSMutableURLRequest new];
            request.timeoutInterval = 20.0;
            [request setURL:[NSURL URLWithString:URL]];
            [request setHTTPMethod:@"POST"];
            //[request setCachePolicy:NSURLCacheStorageNotAllowed];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            
            [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_profile_pic\"; filename=\"%@.jpg\"\r\n", @"user_profile_pic"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:pfl_img]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"First_Name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Raju" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Last_Name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"password" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[deviceToken dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"refferal_code\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Email_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[eMail dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"social_media_email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mobile_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"wifi_ip_address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            return TRUE;
        }
        else
        {
            return FALSE;
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Send Image Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Send Image Finally...");
    }
}
-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"CheckNewPassword"]){
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ImageUploadedSuccess"]){
        
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    
}

@end

