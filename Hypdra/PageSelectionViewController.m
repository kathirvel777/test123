//
//  PageSelectionViewController.m
//  Montage
//
//  Created by MacBookPro on 4/25/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "PageSelectionViewController.h"
#import "TabBarViewController.h"
#import "DEMORootViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "TestKit.h"
#import <SwipeBack/SwipeBack.h>
#import "CameraDemoViewController.h"
#import "PlayerDemoController.h"
#import "StandardViewController.h"
#import "CanvaViewController.h"


#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface PageSelectionViewController ()
{
    NSString *user_id,*planID,*Amount,*planInfo;
    int checkContent,i,albumCount;
    NSArray *textArray,*btnArray,*imgArray,*titleArray;
}

@end

@implementation PageSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getPlanStatus:)
                                                 name:@"getPlanStatus" object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];//UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    titleArray=[[NSMutableArray alloc]init];
    textArray =[[NSMutableArray alloc]init];
    btnArray =[[NSMutableArray alloc]init];
    imgArray =[[NSMutableArray alloc]init];
    
// titleArray=@[@"Gallery",@"Advanced",@"Wizard",@"My Album"];
    
    titleArray=@[@"A.I. Art",@"Canva Mate",@"Gallery",@"Wizard",@"Advanced",@"My Album"];
    
   // titleArray=@[@"Gallery",@"Wizard",@"My Album",@"AI Art"];
   // textArray= @[@"Just upload to start editing like a designer pro",@"Advanced features with full creative control make manual video editing simple",@"Automated video generation - get exactly what you want every time",@"Your Videos with edit and Share Option"];
    textArray= @[@"Apply the A.I style to your Image",@"Make your template like professionals",@"Just upload to start editing like a designer pro",@"Automated video generation - get exactly what you want every time",@"Advanced features with full creative control make manual video editing simple",@"Your Videos with edit and Share Option"];
    
   // btnArray = @[@"UPLOAD",@"MAKE",@"SELECT",@"VIEW"];
    
    btnArray = @[@"A.I. ART",@"CANVA MATE",@"UPLOAD",@"SELECT",@"MAKE",@"VIEW"];
    //imgArray = @[@"gallery",@"advanced-1",@"test",@"my-album"];
    imgArray = @[@"AiArt",@"canva",@"gallery",@"test",@"advanced-1",@"my-album"];
    
    checkContent = 0;
    i=0;
    
    self.imgForMenu.image=[UIImage imageNamed:[imgArray objectAtIndex:i]];
    self.txtForMenu.text=[textArray objectAtIndex:i];
    [self.btnMenu setTitle: [btnArray objectAtIndex:i] forState: UIControlStateNormal];
    self.title=[titleArray objectAtIndex:i];
    
    
    if (IS_PAD)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName,nil, NSForegroundColorAttributeName, nil];
        
        [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    }
    
    if (self.signOut)
    {
        [self signOutApp];
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CreateNewFinalDic"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification object:nil queue:[[NSOperationQueue alloc] init] usingBlock:^(NSNotification *note)
     {
         NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
         
         planID = [note object];
         
         NSLog(@"Purchased/Subscribed product Records: %@", [[TestKit sharedKit] valueForKey:@"purchaseRecord"]);
         
         if ([planID isEqualToString:@"com.ios.wizard.hypdra.premiummonthly"])
         {
             Amount=@"12.99";
             planInfo=@"PremiumMonth";
         }
         else if ([planID isEqualToString:@"com.ios.wizard.hypdra.premiumyearly"])
         {
             Amount=@"139.99";
             planInfo=@"PremiumAnnual";
         }
         else  if ([planID isEqualToString:@"com.ios.wizard.hypdra.standardmonthly"])
         {
             Amount=@"5.99";
             planInfo=@"StandardMonth";
         }
         else if ([planID isEqualToString:@"com.ios.wizard.hypdra.standardyearly"])
         {
             Amount=@"59.99";
             planInfo=@"StandardAnnual";
         }

         [self StoreReceiptIntoServer];
         
     }];
    
    [self.advanceWO.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?20:15]];
    [self.uploadWO.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?20:15]];
    [self.wizardWO.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?20:15]];
    [self.uploadWA.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?20:15]];
    [self.wizardWA.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?20:15]];
    [self.advanceWA.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?20:15]];
    [self.albumWA.titleLabel setFont: [UIFont systemFontOfSize:IS_PAD?20:15]];
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSwipeGesture:)];
    swipeGestureLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    
    [self.topView addGestureRecognizer:swipeGestureLeft];
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSwipeGesture:)];
    swipeGestureRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.topView addGestureRecognizer:swipeGestureRight];
}

- (void)getPlanStatus:(NSNotification *)note
{
    [self planStatus];
}

-(void)planStatus
{
    NSDictionary *parameters =@{@"lang":@"iOS",@"User_ID":user_id};
    
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=get_plan_status";
    
    NSError *error;      // Initialize NSError
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add parameters to NSMutableURLRequest

    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
      {
          if (!error)
          {
              NSDictionary *responseValue=responseObject;
              NSString *status=[responseValue objectForKey:@"status"];
              
              if([status isEqualToString:@"1"])
              {

                  NSDictionary *subDic=[responseValue objectForKey:@"data"];
                  NSLog(@"getPlanStatus:%@",subDic);
                  
                  [[NSUserDefaults standardUserDefaults]setObject:[subDic objectForKey:@"audio_recording"] forKey:@"audio_recording"];
                  
                  [[NSUserDefaults standardUserDefaults]setObject:[subDic objectForKey:@"video_recording"] forKey:@"video_recording"];
                  
                  [[NSUserDefaults standardUserDefaults]setObject:[subDic objectForKey:@"resolution_downloads"] forKey:@"resolution_downloads"];
                  
                  [[NSUserDefaults standardUserDefaults]setObject:[subDic objectForKey:@"embedded_src"] forKey:@"embedded_src"];
                  
              }
              [[NSNotificationCenter defaultCenter] removeObserver:@"getPlanStatus"];
          }
      }]resume];
}

-(void)handleSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    int j;
    if(albumCount == 0)
    {
        j=5;
       // j=2;
    }
    else
    {
         j=6;
        // j=3;
    }
    if(gesture.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        
        if(i<j)
        {
            NSLog(@"leftswipeI:%d",i);
            i++;
            NSLog(@"After ++I:%d",i);
            if(i==j)
            {
                self.imgForMenu.image=[UIImage imageNamed:[imgArray objectAtIndex:i-1]];
                self.txtForMenu.text=[textArray objectAtIndex:i-1];
                [self.btnMenu setTitle: [btnArray objectAtIndex:i-1] forState: UIControlStateNormal];
                self.title=[titleArray objectAtIndex:i-1];
                i--;
                
            }
            else
            {
                self.imgForMenu.image=[UIImage imageNamed:[imgArray objectAtIndex:i]];
                self.txtForMenu.text=[textArray objectAtIndex:i];
                [self.btnMenu setTitle: [btnArray objectAtIndex:i] forState: UIControlStateNormal];
                self.title=[titleArray objectAtIndex:i];
                
                
                CATransition *transition = [CATransition animation];
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.duration = 0.3f;
                
                transition.type = kCATransitionPush;//@"rippleEffect";//@"UIViewKeyframeAnimationOptionCalculationModeLinear";
                transition.subtype = kCATransitionFromRight; //@"fromTop";
                
                [UIView setAnimationTransition:(int)transition forView:self.topView                                                       cache:NO];
                [UIView setAnimationDuration:1.0f];
                [[self.topView layer] addAnimation:transition forKey:nil];
                [UIView commitAnimations];
            }
        }
    }
    else if(gesture.direction==UISwipeGestureRecognizerDirectionRight)
    {
        if(albumCount==0)
        {
            if(i==5)
            {
                i=4;
            }
//            if(i==2)
//            {
//                i=1;
//            }
        }
        else
        {
            if(i==6)
            {
                i=5;
            }
//            if(i==3)
//            {
//                i=2;
//            }
        }
        if(i!=0)
        {
            NSLog(@"Rightswipe:%d",i);
            i--;
            NSLog(@"After --:%d",i);
            
            self.imgForMenu.image=[UIImage imageNamed:[imgArray objectAtIndex:i]];
            self.txtForMenu.text=[textArray objectAtIndex:i];
            [self.btnMenu setTitle: [btnArray objectAtIndex:i] forState: UIControlStateNormal];
            self.title=[titleArray objectAtIndex:i];
            
            CATransition *transition = [CATransition animation];
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.duration = 0.3f;
            transition.type = kCATransitionPush;
            
            transition.subtype = kCATransitionFromLeft; //@"fromTop";
            
            [UIView setAnimationTransition:(int)transition forView:self.topView                                                       cache:NO];
            [UIView setAnimationDuration:1.0f];
            [[self.topView layer] addAnimation:transition forKey:nil];
            [UIView commitAnimations];
        }
    }
}

-(void)testServer
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/Twilio/InviteSMS.php"];
    
    NSDictionary *params = @{@"User_ID":@"4",@"Contacts":@"+1 (917) 498-9143,+1 (646) 229-9712"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"test Server:%@",responseObject);
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         //responseBlock(nil, FALSE, error);
     }];
    
    //    [manager.session invalidateAndCancel];
}


//
//-(void)shareVal
//{
//    NSLog(@"NShar = %@",self.nStr);
//}
//

-(void)StoreReceiptIntoServer
{
    NSString *jsonString,*statusID;
    user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_ID"];

    
    NSDictionary *jsonResponse = [[NSUserDefaults standardUserDefaults]objectForKey:@"PurchaseReceipt"];
    NSLog(@"jsonResponse in home:%@",jsonResponse);
    NSMutableArray *inAppReceipts = [jsonResponse objectForKey:@"latest_receipt_info"];
    
    NSArray *autorenewal_status=[jsonResponse objectForKey:@"pending_renewal_info"];
    
    for(NSDictionary *dct in autorenewal_status)
    {
        if ([[dct objectForKey:@"auto_renew_product_id"] isEqualToString:planID])
        {
            statusID = [dct objectForKey:@"auto_renew_status"];
            
            break;
        }
    }
    
    NSLog(@"inAppreceipt in home:%@",inAppReceipts);
    
    
    NSLog(@"store receipt into server called");
    
    //  NSLog(@"array in store receipt in server:%@",jarray);
    //  NSLog(@"user reg id in store receipt:%@",userRegID);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inAppReceipts options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    } else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
        NSLog(@"Got an string: %@", jsonString);
    }
    
    
    // NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/api/api.php?rquest=iOSMembershipPaymentInfo"];
    
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=iOSProductPaymentInfo"];
    
    NSDictionary *params = @{@"TransactionInfo":jsonString,@"User_ID":user_id,@"ProductID":planID,@"ProductInfo":planInfo,@"Status":statusID,@"Amount":Amount};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"response object in storereceipt:%@",responseObject);
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error storereceipt: %@", error);

     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    self.navigationController.swipeBackEnabled = NO;
    
    int count = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"AlbumCount"];
    
    albumCount=count;
    int count1 = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"AlbumCount1"];
    
    NSLog(@"Album Count = %d",count);
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ChoosenImagesandVideos"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MainArray"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    /* if (count == 0 && count1 == 0)
     {
     self.withAlbum.hidden = true;
     self.withoutAlbum.hidden = false;
     }
     else
     {*/
    self.withAlbum.hidden = false;
    self.withoutAlbum.hidden = true;
    //    }
    
    /*   NSURL *myURL = [NSURL URLWithString:@"http://108.175.2.116/montage/api/edit_image/1805726850No_title.mp4"];
     
     NSData *urlData = [NSData dataWithContentsOfURL:myURL];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"3f.mp4"];
     [urlData writeToFile:filePath atomically:YES];*/
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    NSLog(@"User ID = %@",user_id);
    
    [self planStatus];
    [self checkMembershipStatus];
    
    [UIView transitionWithView:self.btnFree
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.btnFree.layer.cornerRadius=self.btnFree.frame.size.height/2;
                        self.btnFree.clipsToBounds=YES;
                        self.btnFree.layer.borderColor=[UIColor whiteColor].CGColor;
                        self.btnFree.layer.borderWidth=1.0;
                        
                    }
                    completion:NULL];
    [UIView transitionWithView:self.btnStandard
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.btnStandard.layer.cornerRadius=self.btnStandard.frame.size.height/2;
                        self.btnStandard.clipsToBounds=YES;
                        self.btnStandard.layer.borderColor=[UIColor whiteColor].CGColor;
                        self.btnStandard.layer.borderWidth=1.0;
                        
                    }
                    completion:NULL];
    
    [UIView transitionWithView:self.btnPremium
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.btnPremium.layer.cornerRadius=self.btnPremium.frame.size.height/2;
                        self.btnPremium.clipsToBounds=YES;
                        self.btnPremium.layer.borderColor=[UIColor whiteColor].CGColor;
                        self.btnPremium.layer.borderWidth=1.0;
                        
                    }
                    completion:NULL];
}

-(void)checkMembershipStatus
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
  NSString *toDayDate = [formatter stringFromDate:[NSDate date]];
    NSLog(@"checkmembership:%@",user_id);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
   
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=UserInformation"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"Date":toDayDate};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Check Membership Status:%@",responseObject);
        
         [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"credit_points"] forKey:@"credit_points"];

        [[NSUserDefaults standardUserDefaults]setValue:[responseObject valueForKey:@"reward_count"] forKey:@"reward_count"];
        NSString *plan = [responseObject valueForKey:@"Plan"] ;
         [[NSUserDefaults standardUserDefaults]setValue:plan forKey:@"ExactMemberShipType"];
         if([plan isEqualToString:@"Basic(Free)"]){
             [[NSUserDefaults standardUserDefaults]setValue:@"Basic" forKey:@"MemberShipType"];
         }
         else if([plan isEqualToString:@"StandardAnnual"]){
             [[NSUserDefaults standardUserDefaults]setValue:@"Standard" forKey:@"MemberShipType"];
             
         }else if ([plan isEqualToString:@"StandardMonth"]){
             [[NSUserDefaults standardUserDefaults]setValue:@"Standard" forKey:@"MemberShipType"];
             
         }else if ([plan isEqualToString:@"PremiumMonth"]){
             [[NSUserDefaults standardUserDefaults]setValue:@"Premium" forKey:@"MemberShipType"];
             
         }else if ([plan isEqualToString:@"PremiumAnnual"]){
             [[NSUserDefaults standardUserDefaults]setValue:@"Premium" forKey:@"MemberShipType"];
             
         }
         [[NSUserDefaults standardUserDefaults]synchronize];
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error Membership Status: %@", error);
     }];
    
    /*   [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
     //        tableDataFromServer=[responseObject objectForKey:@"View_Registration_Details"];
     //        NSLog(@"Json%@",tableDataFromServer);
     
     NSLog(@"Check Membership Status:%@",responseObject);
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
     NSLog(@"Error Membership Status: %@", error);
     //responseBlock(nil, FALSE, error);
     }];*/
}


-(void)signOutApp
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Sign Out...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager setLoginBehavior:FBSDKLoginBehaviorWeb];
            loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
            [[FBSDKLoginManager new] logOut];
            [loginManager logOut];
            
            
            if ([FBSDKAccessToken currentAccessToken])
            {
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [FBSDKProfile setCurrentProfile:nil];
            }
            
            [[GPPSignIn sharedInstance] signOut];
            [[GPPSignIn sharedInstance] disconnect];
            
            
            NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
            
            
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"signOut"];
            
            [[NSUserDefaults standardUserDefaults]setValue:str forKey:@"DeviceTokenString"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSError *error = nil;
            
            for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error])
            {
                [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
            }
            
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FirstView"];
            
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:vc animated:YES completion:NULL];
            
            
        });
    });
    
}

- (IBAction)signOut:(id)sender
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Sign Out...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager setLoginBehavior:FBSDKLoginBehaviorWeb];
            loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
            [[FBSDKLoginManager new] logOut];
            [loginManager logOut];
            
            
            if ([FBSDKAccessToken currentAccessToken])
            {
                [FBSDKAccessToken setCurrentAccessToken:nil];
                [FBSDKProfile setCurrentProfile:nil];
            }
            
            [[GPPSignIn sharedInstance] signOut];
            [[GPPSignIn sharedInstance] disconnect];
            
            
            NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
            
            
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"signOut"];
            
            [[NSUserDefaults standardUserDefaults]setValue:str forKey:@"DeviceTokenString"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            
            NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSError *error = nil;
            
            for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error])
            {
                [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
            }
            
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            ViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FirstView"];
            
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:vc animated:YES completion:NULL];
            
            
        });
    });
    
}

- (void)doSomeWorkWithProgress
{
    //    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        //        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.view].progress = progress;
        });
        
        usleep(25000);
    }
}

-(int)checkImage
{
    
    checkContent = 0;
    
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:myPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *SharedFinalplistPath = [myPath stringByAppendingPathComponent:@"DataList.plist"];
    
    NSMutableArray *finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    
    checkContent = (int)[finalArray count];
    
    
    NSLog(@"checkContent = %d",checkContent);
    
    
    return checkContent;
    
}





-(void)sendServer
{
    
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=testing_ios";
    
    UIImage *img = [UIImage imageNamed:@"text-xxl.png"];
    
    NSData *dfs = UIImagePNGRepresentation(img);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        
                                        [formData appendPartWithFileData:dfs name:@"upload_files" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                        
                                        [formData appendPartWithFormData:[@"10" dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
                                        
                                        [formData appendPartWithFormData:[@"4" dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
                                        
                                    } error:nil];
    
    
    request.timeoutInterval= 20; // add paramerets to NSMutableURLRequest
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Change Profile Error: %@", error);
                          
                      }
                      else
                      {
                          //                          NSLog(@"Change Profile Response %@ %@", response, responseObject);
                          
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"response for profile:%@",responsseObject);
                      }
                  }];
    [uploadTask resume];
}

- (IBAction)btnMenuAction:(id)sender
{
    if(i==5||i==6)
    //if(i==2)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        // }
    }
   // else if(i==3||i==4){
    else if(i==0){
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_23" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AIStyleDic"];
        [self presentViewController:vc animated:YES completion:NULL];
    }else if (i==1)
    {
         UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
         
         CanvaViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"canva"];
         
         [self.navigationController pushViewController:vc animated:YES];
    }
    else if (i==2)
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        [vc awakeFromNib:@"contentController_2" arg:@"menuController"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else if (i==3)
    {
        //WIZARD
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        NSString *minAvil=[defaults valueForKey:@"minAvil"];
        
        if ([minAvil isEqualToString:@"Duration Available"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"wizImgPath"];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardMusicId"];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TenSTemplateDic"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardIconPath"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardEffectsName"];
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
            
            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            
            [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:vc animated:YES completion:NULL];
        }
        else
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
                                                                          message:@"You do not have minutes"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else if (i==4)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        NSString *minAvil=[defaults valueForKey:@"minAvil"];
        
        //    NSString *spcAvil = [defaults valueForKey:@"spcAvil"];
        
        if ([minAvil isEqualToString:@"Duration Available"])
        {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"Advance" forKey:@"isWizardOrAdvance"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
            
            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            
            [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
            
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:vc animated:YES completion:NULL];
        }
        else
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
                                                                          message:@"You do not have minutes"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)btnFreeAction:(id)sender
{
    {
        // if (IS_PAD)
        //        {
        //            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
        //
        //            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        //
        //            [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        //
        //            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //            [self presentViewController:vc animated:YES completion:NULL];
        //        }
        //        else
        //        {
        //
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        [[NSUserDefaults standardUserDefaults]setValue:@"Free" forKey:@"Plan"];
        // }
        
    }
}

- (IBAction)btnStandardAction:(id)sender
{
    {
        // if (IS_PAD)
        //        {
        //            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
        //
        //
        //
        //            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        //
        //            [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        //
        //            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //            [self presentViewController:vc animated:YES completion:NULL];
        //        }
        //        else
        //        {
        [[NSUserDefaults standardUserDefaults]setValue:@"Standard" forKey:@"Plan"];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        // }
        
    }
}

- (IBAction)btnPremiumAction:(id)sender
{
    {
        //if (IS_PAD)
        //        {
        //            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
        //
        //
        //            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        //
        //            [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        //
        //            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //            [self presentViewController:vc animated:YES completion:NULL];
        //        }
        //        else
        //        {
        [[NSUserDefaults standardUserDefaults]setValue:@"Premium" forKey:@"Plan"];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        // }
        
    }
}

@end

/*
 @interface URLWrapper:UIActivityItemProvider
 
 @property (nonatomic, strong) NSURL *url;
 
 @end
 
 @implementation URLWrapper
 
 + (instancetype)activityItemSourceUrlWithUrl:(NSURL *)url {
 URLWrapper *wrapper = [[self alloc] initWithPlaceholderItem:@""];
 wrapper.url = url;
 
 return wrapper;
 }
 
 - (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
 return [self activityViewController:activityViewController itemForActivityType:nil];
 }
 
 - (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
 return self.url;
 }
 
 - (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size {
 UIImage* thumbnail = [UIImage imageNamed:@"1.jpg"];
 return thumbnail;
 }
 
 @end*/



