//
//  AppDelegate.m
//  Montage
//
//  Created by MacBookPro on 3/20/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "AppDelegate.h"
#import "DEMORootViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FlickrKit.h"
//#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <GooglePlus/GooglePlus.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "AFNetworking.h"
@import Firebase;
@import GoogleMobileAds;
#import "TestKit.h"
#import "PageSelectionViewController.h"
#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <linkedin-sdk/LISDK.h>
#import <KeyboardManager/IQKeyboardManager.h>
#import <OneDriveSDK/OneDriveSDK.h>
#import <Fabric/Fabric.h>
#import "UIImageView+WebCache.h"
#import <Crashlytics/Crashlytics.h>
#import "UIColor+Utils.h"
//@import BoxContentSDK;

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define INMOBI_ACCOUNT_ID   @"6fda1ebff5c440e1aabc0446a61104f6"


@interface AppDelegate ()<UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate>
{
    NSString *correctTokenId;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];

//    [Fabric with:@[[Twitter class]]];

//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//    
//    [self.window setRootViewController:vc];
    
//    if(SYSTEM_VERSION_EQUALTO(@"10.0"))
//    {
//        UNUserNotificationCenter *notifiCenter = [UNUserNotificationCenter currentNotificationCenter];
//        notifiCenter.delegate = self;
//        [notifiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
//            if( !error )
//            {
//                [[UIApplication sharedApplication] registerForRemoteNotifications];
//            }
//        }];
//    }
    
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    [FIRMessaging messaging].autoInitEnabled = YES;


    [GADMobileAds configureWithApplicationID:@"ca-app-pub-4411584255946382~7096044205"];

    [[Twitter sharedInstance] startWithConsumerKey:@"NTwHECYjJAfqpBLAFgO7Ly5cr" consumerSecret:@"YuDaINL4YJuLCdNpf2q7cmNUWMs2ZXY5AMl6yz7HYTjmWTk1MT"];
    

    
    [GIDSignIn sharedInstance].clientID=@"916257056143-vr3eicm9qap6obi2tnkj7q7a6q40felc.apps.googleusercontent.com";

  
    
    NSString *appKey = @"8jsv9np59zzkzgo";
    NSString *registeredUrlToHandle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0];
    if (!appKey || [registeredUrlToHandle containsString:@"<"])
    {
        NSString *message = @"You need to set `appKey` variable in `AppDelegate.m`, as well as add to `Info.plist`, before you can use DBRoulette.";
        NSLog(@"%@", message);
        NSLog(@"Terminating...");
        exit(1);
    }
    [DBClientsManager setupWithAppKey:appKey];
    NSString *apiKey = @"a78b3470ea0dcf080b990ddba0e65518";//@"A3n7c8EmXnAAAAAAAAAAtCfJCHWScPrB5feeO80ZmVmaPukcQHfwgYPsIDkFjfjW";//@"348ea26ca45d5f9d3da7fff4822a7fd1";
    
    NSString *secret = @"4a8d0edf1774ed19";//@"1xar4l6gpxikfu3"; //@"471cc96b04e60f27";
    
// NSString *apiKey = @"348ea26ca45d5f9d3da7fff4822a7fd1";
// NSString *secret = @"471cc96b04e60f27";

    if (!apiKey)
    {
        NSLog(@"\n----------------------------------\nYou need to enter your own 'apiKey' and 'secret' in FKAppDelegate for the demo to run. \n\nYou can get these from your Flickr account settings.\n----------------------------------\n");
        exit(0);
    }
    
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:apiKey sharedSecret:secret];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    
 //   [BOXContentClient setClientID:@"8gnvzi619z77nok84ktvy20j6nkh5czn" clientSecret:@"5zx8uugL35uVgfO7zdKyPhmzmKfT4wWx"];
    
    [[TestKit sharedKit] startProductRequest];

    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification object:nil queue:[[NSOperationQueue alloc] init]
          usingBlock:^(NSNotification *note)
     {
         NSLog(@"Products available: %@", [[TestKit sharedKit] availableProducts]);
     }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification object:nil queue:[[NSOperationQueue alloc] init] usingBlock:^(NSNotification *note)
     {
         
         NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
         
         NSLog(@"Purchased/Subscribed product Records: %@", [[TestKit sharedKit] valueForKey:@"purchaseRecord"]);
         
//         [self StoreReceiptIntoServer];
         
     }];

    
    NSString *str =  [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_ID"];
    
    NSLog(@"Main User ID = %@",str);
    
    if(str == nil)
    {
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        
        ViewController *viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FirstView"];
        
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
    else
    {
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//        PageSelectionViewController *viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
//
//        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//        self.window.rootViewController = viewController;
//        [self.window makeKeyAndVisible];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
        
    }
    
SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    
        [[UIApplication sharedApplication]
         setMinimumBackgroundFetchInterval:
         UIApplicationBackgroundFetchIntervalMinimum];

[ODClient setMicrosoftAccountAppId:@"2f0c7a21-cd54-4d92-bb4a-5112fc1b7f15" scopes:@[@"onedrive.readwrite"] ];
 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CreateButton"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"NavigationFromWizardToAlbum"];
    [[NSUserDefaults standardUserDefaults]setInteger:-1 forKey:@"SelectedIndex"];
        [Fabric with:@[[Crashlytics class]]];
    [self customappearance];
    //Method declaration
    //For InMobi Ad's
    
    NSMutableDictionary *consentdict=[[NSMutableDictionary alloc]init];
    [consentdict setObject:@"true" forKey:IM_GDPR_CONSENT_AVAILABLE];
    [IMSdk initWithAccountID:INMOBI_ACCOUNT_ID consentDictionary:consentdict];
    [IMSdk setLogLevel:kIMSDKLogLevelDebug];
    return YES;
}

-(void)customappearance
{
    //int imageSize = 20;
    UIImage *myImage = [UIImage imageNamed:@"64-back-arrow"]; //set your backbutton imagename
    UIImage *backButtonImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // now use the new backButtomImage
    [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    
    [[UITextField appearance] setTintColor:[UIColor navyBlue]];

    /*
     UIImage *backbutton=[[UIImage imageNamed:@"icon_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
     
     //resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
     
     [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backbutton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];*/
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // NS_AVAILABLE_IOS(8_0);
{
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
         }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
}

//-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
//{
//    NSLog(@"Notification Error = %@",error);
//}

/*
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    //Do Your Code.................Enjoy!!!!
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
}
*/

/*
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *scheme = [url scheme];
 
 if([@"flickrkitdemo" isEqualToString:scheme])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
    }
    return YES;
}*/

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{

    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    correctTokenId = fcmToken;
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    [[NSUserDefaults standardUserDefaults]setObject:correctTokenId forKey:@"DeviceTokenString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"App delegate registerforremotenotification called");
    NSString *deveiceTokenString=[NSString stringWithFormat:@"%@",deviceToken];

    if (!(deveiceTokenString == nil || deveiceTokenString == (id)[NSNull null]))
    {
        NSLog(@"My token is: %@", deveiceTokenString);
        NSString *TokenId1= [deveiceTokenString stringByReplacingOccurrencesOfString :@"<" withString:@""];
        correctTokenId=[TokenId1 stringByReplacingOccurrencesOfString :@">" withString:@""];
        correctTokenId= [correctTokenId stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"corrected token id:%@",correctTokenId);
    }
    else
    {
        NSLog(@"Else Block");
        correctTokenId=@"NULL";
    }
    
    NSLog(@"length of token id:%lu",(unsigned long)correctTokenId.length);
    NSLog(@"after null token id:%@",correctTokenId);
    
    [[NSUserDefaults standardUserDefaults]setObject:correctTokenId forKey:@"DeviceTokenString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}*/


-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // iOS 10 will handle notifications through other methods

    NSLog(@"HANDLE PUSH, didReceiveRemoteNotification: %@", userInfo);
    application.applicationIconBadgeNumber = 0;
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
    {
        NSLog(@"iOS version >= 10. Let NotificationCenter handle this one." );
        return;
    }
    
    else
    {
        NSLog(@"else called");
        if(application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground)
        {
                
                NSLog(@"InActive");
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.userInfo = userInfo;
                NSLog(@"userinfo:%@",userInfo);
                
                NSString *alertMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                
                NSLog(@"Alert Message = %@",alertMessage);
                
                
                NSString *albumCount = [[userInfo objectForKey:@"aps"] objectForKey:@"Video_Count"];
                
                int numValue = [albumCount intValue];
                
                NSLog(@"Get Album Count = %d",numValue);
                
                
                NSString *vStatus = [[userInfo objectForKey:@"aps"] objectForKey:@"Video_Status"];
                
                
                if ([vStatus isEqualToString:@"Duration Available"])
                {
                    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"videoStatus"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"videoStatus"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                
                [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                localNotification.alertBody = alertMessage;
                //localNotification.fireDate = [NSDate date];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                    }
        else
        {
            NSLog(@"App state active");
            
            //  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            //  localNotification.userInfo = userInfo;
            
            NSLog(@"userinfo:%@",userInfo);
            
            NSString *alertMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            
            NSString *albumCount = [[userInfo objectForKey:@"aps"] objectForKey:@"Video_Count"];
            
            NSString *vStatus = [[userInfo objectForKey:@"aps"] objectForKey:@"Video_Status"];
            
            
            if ([vStatus isEqualToString:@"Duration Available"])
            {
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"videoStatus"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"videoStatus"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            
            int numValue = [albumCount intValue];
            
            NSLog(@"Get Album Count = %d",numValue);
            
            [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSLog(@"Alert Message = %@",alertMessage);
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Video Received" message:@"Your video is ready now" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            }];
            [alert addAction:defaultAction];
            
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [[UIViewController alloc] init];
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            [alertWindow makeKeyAndVisible];
            [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            
            
            /*        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Document Received" message:[NSString stringWithFormat:@"New Document Received\n%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             
             [alertView show];
             
             UILocalNotification *localNotification = [[UILocalNotification alloc] init];
             localNotification.userInfo = userInfo;
             NSLog(@"userinfo:%@",userInfo);
             
             NSString *alertMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
             
             NSLog(@"Alert Message = %@",alertMessage);
             
             localNotification.soundName = UILocalNotificationDefaultSoundName;
             localNotification.alertBody = alertMessage;
             //localNotification.fireDate = [NSDate date];
             [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];*/
        }
    }
    
    // custom code to handle notification content
    
    /*   if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
     {
     NSLog( @"INACTIVE" );
     completionHandler( UIBackgroundFetchResultNewData );
     }
     else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
     {
     NSLog( @"BACKGROUND" );
     completionHandler( UIBackgroundFetchResultNewData );
     }  
     else  
     {  
     NSLog( @"FOREGROUND" );  
     completionHandler( UIBackgroundFetchResultNewData );  
     } */
}



-(void)sendtoServer
{
    NSLog(@"send to server called:%@",correctTokenId);
    
    @try
    {
        NSLog(@"try begin");
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=splash_value_url";
        
        NSDictionary *params = @{@"splash_val":@"0",@"device_token":correctTokenId,@"lang":@"iOS"};
        
        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             
             NSLog(@"App status response = %@",response);
             
         }
         
         failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
         }];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"catach:%@",exception);
    }
    @finally
    {
        NSLog(@"finally called");
    }
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NULL" forKey:@"DeviceTokenString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Test:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceTokenString"]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    
    
        
    NSLog(@"application:(UIApplication *)application");
    
    BOOL GoogleHandled = [GPPURLHandler handleURL:url
                                sourceApplication:sourceApplication
                                       annotation:annotation];
    
    BOOL wasHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                     openURL:url
                                                           sourceApplication:sourceApplication
                                                                  annotation:annotation];
    
    BOOL GsignInHandled= [[GIDSignIn sharedInstance] handleURL:url
                                            sourceApplication:sourceApplication
                                                   annotation:annotation];
    
    // You can add your app-specific url handling code here if needed
    
    
    
//    if ([[DBSession sharedSession] handleOpenURL:url]) {
//        if ([[DBSession sharedSession] isLinked]) {
//            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"OPEN_DROPBOX_VIEW" object:nil]];
//        }
//        return YES;
//    }
    
    
    NSString *scheme = [url scheme];
    if([@"flickrkitdemo" isEqualToString:scheme])
    {
        // I don't recommend doing it like this, it's just a demo... I use an authentication
        // controller singleton object in my projects
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
    }
        
    return wasHandled || GoogleHandled || GsignInHandled;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
    NSLog(@"openURL:(NSURL *)url options:(NSDic");
    
    if ([[Twitter sharedInstance] application:app openURL:url options:options])
    {
        return YES;
    }
    
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    
    
    if ([[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:nil])
    {
        return YES;
    }
    
    NSString *annotation = options[UIApplicationOpenURLOptionsAnnotationKey];

    
    if([[GIDSignIn sharedInstance] handleURL:url
                           sourceApplication:sourceApplication
                                  annotation:annotation])
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
    if (authResult != nil)
    {
        if ([authResult isSuccess])
        {
            NSLog(@"Success! User is logged into Dropbox.");
            
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"dropBoxVideo"] isEqualToString:@"dropboxVideo"])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DropboxVideoLogin" object:self];
            }
            
            else
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DropboxLogin"
                                                                   object:self];
            }
            
        
            return YES;
        }
        
    }
    
    if ([LISDKCallbackHandler shouldHandleUrl:url])
    {
        return [LISDKCallbackHandler application:app openURL:url sourceApplication:sourceApplication annotation:nil];
    }
    
    
    NSString *scheme = [url scheme];
    if([@"flickrkitdemo" isEqualToString:scheme])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
        
        return YES;
    }

    
    BOOL GoogleHandled = [GPPURLHandler handleURL:url
                                sourceApplication:sourceApplication
                                       annotation:nil];

    
    if (GoogleHandled)
    {
        return YES;
    }
    

    return NO;
}

/*
- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    relinkUserId = userId;
    [[[UIAlertView alloc] initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self
                      cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil] show];
}

#pragma mark - DBNetworkRequestDelegate methods
static int outstandingRequests;
- (void)networkRequestStarted
{
    outstandingRequests++;
    if (outstandingRequests == 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)networkRequestStopped
{
    outstandingRequests--;
    if (outstandingRequests == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}*/
/*
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    NSLog(@"background fetch result called");
    
    if ( application.applicationState == UIApplicationStateActive )
    {
        NSLog(@"App state active");
        
//      UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//      localNotification.userInfo = userInfo;
        NSLog(@"userinfo:%@",userInfo);
        
        NSString *alertMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        NSString *albumCount = [[userInfo objectForKey:@"aps"] objectForKey:@"Video_Count"];

        NSString *vStatus = [[userInfo objectForKey:@"aps"] objectForKey:@"Video_Status"];

        
        if ([vStatus isEqualToString:@"Duration Available"])
        {
            [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"videoStatus"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"videoStatus"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        
        int numValue = [albumCount intValue];
        
        NSLog(@"Get Album Count = %d",numValue);
        
        [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSLog(@"Alert Message = %@",alertMessage);
        
//        localNotification.soundName = UILocalNotificationDefaultSoundName;
//        
//        localNotification.alertBody = alertMessage;
//
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];


        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Video Received" message:@"Your video is ready now" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                                              {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        [alert addAction:defaultAction];
        
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        
        
/*        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Document Received" message:[NSString stringWithFormat:@"New Document Received\n%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
 
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        NSLog(@"userinfo:%@",userInfo);
        
        NSString *alertMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];

        NSLog(@"Alert Message = %@",alertMessage);
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = alertMessage;
        //localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];*/
 /*   }
    else
    {

        NSLog(@"InActive");
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        NSLog(@"userinfo:%@",userInfo);
        
        NSString *alertMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        NSLog(@"Alert Message = %@",alertMessage);
        
        
        NSString *albumCount = [[userInfo objectForKey:@"aps"] objectForKey:@"Video_Count"];
        
        int numValue = [albumCount intValue];
        
        NSLog(@"Get Album Count = %d",numValue);
        
        
        NSString *vStatus = [[userInfo objectForKey:@"aps"] objectForKey:@"Video_Status"];
        
        
        if ([vStatus isEqualToString:@"Duration Available"])
        {
            [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"videoStatus"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"videoStatus"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = alertMessage;
        //localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    }
}
*/

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
//    return [[FBSDKApplicationDelegate sharedInstance] application:app
//                                                          openURL:url
//                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//}
//

@end
