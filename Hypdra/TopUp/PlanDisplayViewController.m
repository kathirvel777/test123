//
//  PlanDisplayViewController.m
//  SampleTest
//
//  Created by apple on 17/08/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "PlanDisplayViewController.h"
#import "TestKit.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "InviteFriendsViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"
@import InMobiSDK;
@import GoogleMobileAds;
//@import InMobiAdapter;

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define INMOBI_INTERSTITIAL_PLACEMENT   1545439909314
//#define INMOBI_INTERSTITIAL_PLACEMENT   @"rewardedVide"
@interface PlanDisplayViewController ()<GADRewardBasedVideoAdDelegate,ClickDelegates,IMNativeDelegate,UnityAdsDelegate>
{
    
    NSArray *minAry,*minAryVal,*SpcAry,*SpcAryVal;
    NSString *min,*spc,*user_id,*product,*value,*amount;
    BOOL minutes,space;
    NSMutableArray *currentPlan;
    
    MBProgressHUD *hud,*hud_1;
    
    int rewardedCount,spaceCount;
    NSString *buyRewardMin,*creditPoints,*sendPoints,*operation,*todayRewardCount,*currentDate,*ValuesToExtend,*RewardedFor,*VideoSection,*VideoId;
    
}
@end

@implementation PlanDisplayViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont fontWithName:@"FuturaT-Book" size:22]}];
    
    delay(0.15,
          ^{
              [self.minList closeAllComponentsAnimated:YES];
              [self.spcList closeAllComponentsAnimated:YES];
              
          });
    
    //    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [self setShadow:self.chooseMinutes];
    [self setShadow:self.chooseSpace];
    [self setShadow:self.creditsView];
    
    rewardedCount = 5;
    spaceCount = 5;
    
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    
    min = @"10 Minute";
    spc = @"1 GB";
    
    minAry = @[@"10 Minute",@"20 Minute",@"30 Minute",@"40 Minute",@"50 Minute",@"60 Minute",@"70 Minute",@"80 Minute",@"90 Minute",@"100 Minute"];
    
    minAryVal = @[@"$1.99 USD",@"$2.99 USD",@"$3.99 USD",@"$4.99 USD",@"$5.99 USD",@"$6.99 USD",@"$7.99 USD",@"$8.99 USD",@"$9.99 USD",@"$10.99 USD"];
    
    SpcAry = @[@"1 GB",@"2 GB",@"3 GB",@"4 GB",@"10 GB",@"20 GB",@"50 GB",@"100 GB",@"250 GB",@"500 GB",@"1 TB"];
    
    SpcAryVal = @[@"$0.99 USD",@"$1.99 USD",@"$2.99 USD",@"$3.99 USD",@"$5.99 USD",@"$9.99 USD",@"$19.99 USD",@"$29.99 USD",@"$64.99 USD",@"$119.99 USD",@"$219.99 USD"];
    
    [[self.minVideo imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.invitFrnd imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.minPurch imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.spcPurch imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.spcInvite imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.spcVideo imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"topupMinSpc" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendSerevr:)
                                                 name:@"topupMinSpc" object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];//UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = false;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    //    self.transparentView.hidden=YES;
    //    self.minutesPopUp.hidden=YES;
    //    self.spacePopUp.hidden=YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(oneMinuteTab:)];
    self.oneMinuteView.tag=1;
    [self.oneMinuteView addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(threeMinuteTab:)];
    self.threeMinuteView.tag=1;
    [self.threeMinuteView addGestureRecognizer:singleFingerTap1];
    
    self.lblPoints.text=@"1 Minute";
    self.pointsInfo.text=@"Use 30 Points to get 1 Minute";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Date:%@",currentDate);
    
    //For InMobi Ad's Initialization
    
    self.interstitial = [[IMInterstitial alloc] initWithPlacementId:INMOBI_INTERSTITIAL_PLACEMENT delegate:self];
    [self.interstitial load];

    //For UnityAd's initialization
    
    //[UnityAds initialize:@"2618877" delegate:self];
    [UnityAds initialize:@"2936788" delegate:self];
}

- (void)oneMinuteTab:(UITapGestureRecognizer *)recognizer
{
    self.imgOneMin.image=[UIImage imageNamed:@"circle_withfill"];
    self.imgThreeMin.image=[UIImage imageNamed:@"circle_withoutfill"];
    buyRewardMin=@"1";
    self.lblPoints.text=@"1 Minute";
    self.pointsInfo.text=@"Use 30 Points to get 1 Minute";
    
}

- (void)threeMinuteTab:(UITapGestureRecognizer *)recognizer
{
    self.imgOneMin.image=[UIImage imageNamed:@"circle_withoutfill"];
    self.imgThreeMin.image=[UIImage imageNamed:@"circle_withfill"];
    buyRewardMin=@"3";
    self.lblPoints.text=@"3 Minute";
    self.pointsInfo.text=@"Use 50 Points to get 1 Minute";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.minList closeAllComponentsAnimated:YES];
    
    [self.spcList closeAllComponentsAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    self.transparentView.hidden=YES;
    self.minutesPopUp.hidden=YES;
    self.spacePopUp.hidden=YES;
    
    [self currentPlan];
    
}


-(void)setShadow:(UIView*)demoView
{
    demoView.layer.shadowColor = [UIColor blackColor].CGColor;
    demoView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    demoView.layer.shadowOpacity = 0.5f;
    
}



- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component
{
    return 60;
}


- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    
    //    NSLog(@"No of Rows");
    
    if (dropdownMenu == self.minList)
    {
        return [minAry count];
    }
    else
    {
        return [SpcAry count];
    }
    
    return 0;
    
}

/*
 - (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component
 {
 
 if (dropdownMenu == self.minutesList)
 {
 return min;
 }
 else
 {
 return spc;
 }
 
 return @"";
 
 }*/


- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component
{
    
    UIFont *font;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        font = [UIFont fontWithName:@"FuturaT-Book" size:17.0];
    }
    else
    {
        font = [UIFont fontWithName:@"FuturaT-Book" size:18.0];
    }
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    if (dropdownMenu == self.minList)
    {
        attrString = [[NSAttributedString alloc] initWithString:min attributes:attrsDictionary];
    }
    else
    {
        attrString = [[NSAttributedString alloc] initWithString:spc attributes:attrsDictionary];
    }
    
    return attrString;
    
}


/*
 - (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 
 if (dropdownMenu == self.minutesList)
 {
 return minAry[row];
 }
 else
 {
 return SpcAry[row];
 }
 
 return @"";
 
 }
 */


- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    UIFont *font;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        font = [UIFont fontWithName:@"FuturaT-Book" size:15.0];
    }
    else
    {
        font = [UIFont fontWithName:@"FuturaT-Book" size:16.0];
    }
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    
    NSAttributedString *attrString;
    
    if (dropdownMenu == self.minList)
    {
        attrString = [[NSAttributedString alloc] initWithString:minAry[row] attributes:attrsDictionary];
    }
    else
    {
        attrString = [[NSAttributedString alloc] initWithString:SpcAry[row] attributes:attrsDictionary];
    }
    
    return attrString;
}



- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    /*    NSString *colorString = self.colors[row];
     self.textLabel.text = colorString;
     
     UIColor *color = UIColorWithHexString(colorString);
     self.view.backgroundColor = color;
     //    self.childViewController.shapeView.strokeColor = color;
     
     delay(0.15, ^{
     [dropdownMenu closeAllComponentsAnimated:YES];
     });*/
    
    if (dropdownMenu == self.minList)
    {
        
        min = minAry[row];
        
        //spc = @"1 GB";
        
        self.minValLabel.text = minAryVal[row];
        
        delay(0.15,
              ^{
                  [dropdownMenu closeAllComponentsAnimated:YES];
                  
                  [self.minList reloadAllComponents];
                  
                  [self.spcList reloadAllComponents];
                  
                  
                  //                  [self.minExpnd sendActionsForControlEvents:UIControlEventTouchUpInside];
                  
              });
    }
    else
    {
        
        spc = SpcAry[row];
        
       // min = @"10 Minutes";
        
        
        self.spcValLabel.text = SpcAryVal[row];
        
        delay(0.15,
              ^{
                  [dropdownMenu closeAllComponentsAnimated:YES];
                  
                  [self.minList reloadAllComponents];
                  
                  [self.spcList reloadAllComponents];
                  
                  //                  [self.spcExpnd sendActionsForControlEvents:UIControlEventTouchUpInside];
                  
              });
    }
    
}

static inline void delay(NSTimeInterval delay, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}


- (IBAction)minPurchase:(id)sender
{
//    if ([min isEqualToString:@"5 Minute"])
//    {
//
//        product = @"minutes";
//        value = @"5";
//        amount = @"1";
//
//        [TestKit setcFrom:@"Minutes"];
//
//        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.fiveMinutes"];
//
//    }else
  if ([min isEqualToString:@"10 Minute"])
    {
        
        product = @"minutes";
        value = @"10";
        amount = @"2";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.tenminutes"];
        
    }
    else if ([min isEqualToString:@"20 Minute"])
    {
        
        product = @"minutes";
        value = @"20";
        amount = @"3";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.twentyminutes"];
        
    }
    else if ([min isEqualToString:@"30 Minute"])
    {
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.thirtyminutes"];
        
    }
    else if ([min isEqualToString:@"40 Minute"])
    {
        
        product = @"minutes";
        value = @"40";
        amount = @"5";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.fortyminutes"];
        
    }
    else if ([min isEqualToString:@"50 Minute"])
    {
        
        product = @"minutes";
        value = @"50";
        amount = @"6";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.fifityminutes"];
        
    }
    else if ([min isEqualToString:@"60 Minute"])
    {
        
        product = @"minutes";
        value = @"60";
        amount = @"7";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.sixtyminutes"];
        
    }
    else if ([min isEqualToString:@"70 Minute"])
    {
        
        product = @"minutes";
        value = @"70";
        amount = @"8";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.seventyminutes"];
        
    }
    else if ([min isEqualToString:@"80 Minute"])
    {
        
        product = @"minutes";
        value = @"80";
        amount = @"9";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.eightyminutes"];
        
    }
    else if ([min isEqualToString:@"90 Minute"])
    {
        
        product = @"minutes";
        value = @"90";
        amount = @"10";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.ninetyminutes"];
        
    }
    else if ([min isEqualToString:@"100 Minute"])
    {
        
        product = @"minutes";
        value = @"100";
        amount = @"11";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.hundredminutes"];
        
    }
    else
    {
        //        UIAlertController * alert = [UIAlertController
        //                                     alertControllerWithTitle:@"Error"
        //                                     message:@"Select any one of Option ...!"
        //                                     preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction
        //                                    actionWithTitle:@"Ok"
        //                                    style:UIAlertActionStyleDefault
        //                                    handler:nil];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Select any one of Option ...!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
}

- (IBAction)spcPurchase:(id)sender
{
    // if ([spc isEqualToString:@"1 GB/mo"])
    
    
    if ([spc isEqualToString:@"1 GB"])
    {
        
        product = @"space";
        value = @"1";
        amount = @"10";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.onegb"];
        
    }
    else if ([spc isEqualToString:@"2 GB"])
    {
        
        product = @"space";
        value = @"2";
        amount = @"2";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.twogb"];
        
        
    }
    else if ([spc isEqualToString:@"3 GB"])
    {
        
        product = @"space";
        value = @"3";
        amount = @"3";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.threegb"];
    }
    else if ([spc isEqualToString:@"4 GB"])
    {
        
        product = @"space";
        value = @"4";
        amount = @"4";
        
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.fourgb"];
        
        
    }
    else if ([spc isEqualToString:@"10 GB"])
    {
        
        product = @"space";
        value = @"10";
        amount = @"6";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.tengb"];
    }
    else if ([spc isEqualToString:@"20 GB"])
    {
        product = @"space";
        value = @"20";
        amount = @"10";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.twentygb"];
    }
    else if ([spc isEqualToString:@"50 GB"])
    {
        product = @"space";
        value = @"50";
        amount = @"20";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.fiftygb"];
        
    }
    else if ([spc isEqualToString:@"100 GB"])
    {
        
        product = @"space";
        value = @"100";
        amount = @"30";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.hundredgb"];
        
        
    }
    else if ([spc isEqualToString:@"250 GB"])
    {
        
        product = @"space";
        value = @"250";
        amount = @"65";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.twofiftygb"];
        
        
    }
    else if ([spc isEqualToString:@"500 GB"])
    {
        
        product = @"space";
        value = @"500";
        amount = @"120";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.fivehundred"];
        
        
    }
    else if ([spc isEqualToString:@"1 TB"])
    {
        
        product = @"space";
        value = @"1000";
        amount = @"220";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.onetb"];
    }
    else
    {
        //  UIAlertController * alert = [UIAlertController
        //                                     alertControllerWithTitle:@"Error"
        //                                     message:@"Select any one of Option ...!"
        //                                     preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction
        //                                    actionWithTitle:@"Ok"
        //                                    style:UIAlertActionStyleDefault
        //                                    handler:nil];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Select any one of Option ...!" withTitle:@"Warning" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

-(void)currentPlan
{
  
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSError *error;
    
    //    NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/api/api.php?rquest=CurrentPlanOfUser"];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=UserInformation"];
    
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"Date":currentDate};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         currentPlan=responseObject;
         NSLog(@"Check Membership Status:%@",responseObject);
         NSString *plan = [currentPlan valueForKey:@"Plan"] ;
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
         self.planDis.text =[currentPlan valueForKey:@"Plan"];
         NSString *amount=[currentPlan valueForKey:@"Amount"];
         
         self.amtDis.text = amount;
         
         NSMutableString *str = [[NSMutableString alloc]init];
         
         [str appendString:@"Renewal Date : "];
         
         [str appendString:[currentPlan valueForKey:@"RenewDate"]];
         
         //[str appendString:@" | Per Month"];
         
         self.renuDateDisp.text = str;
         
         creditPoints = [currentPlan valueForKey:@"credit_points"];
         todayRewardCount = [currentPlan valueForKey:@"reward_count"];
         
         [[NSUserDefaults standardUserDefaults]setObject:creditPoints forKey:@"credit_points"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         [hud hideAnimated:YES];
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         [hud hideAnimated:YES];
         
         
         //             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not connect to server" preferredStyle:UIAlertControllerStyleAlert];
         //
         //             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
         //
         //             [alertController addAction:ok];
         //
         //             [self presentViewController:alertController animated:YES completion:nil];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor lightGreen];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
         
     }];
}



- (IBAction)InviteFrndSpc:(id)sender
{
    NSLog(@"Invite Frnds");
    
    [[NSUserDefaults standardUserDefaults]setObject:@"Space" forKey:@"InviteFor"];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"InviteThrough"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"InviteVideoID"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    InviteFriendsViewController *vc;
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    
    vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InviteFriends"];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)InviteFrndMin:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"Minutes" forKey:@"InviteFor"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"InviteThrough"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"InviteVideoID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSLog(@"Invite Frnds");
    InviteFriendsViewController *vc;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InviteFriends"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)RewardedVideoSpc:(id)sender
{
    [self startGame];
}

- (IBAction)RewardedVideoMin:(id)sender
{
    [self startNewGame];
}


- (void)startGame
{

    hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (![[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [self requestRewardedVideo];
    }
    
}


- (void)startNewGame
{
    
    //    [activityIndicatorView startAnimating];
    
    NSString *rCount;
    
    if (rewardedCount > 0)
    {
        rCount = [NSString stringWithFormat:@"You have to watch %d video to get Space",rewardedCount];
    }
    else
    {
        rCount = [NSString stringWithFormat:@"You are eligible for get Space"];
    }
    
    [self.navigationController.view makeToast:rCount];
    
    hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (![[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [self requestRewardedVideo];
    }
    
}

- (void)requestRewardedVideo
{
    GADRequest *request = [GADRequest request];
    
    // request.testDevices = @[ @"a62a692472925f313860e6e547f159d7" ];
    //GADInMobiExtras *extras = [[GADInMobiExtras alloc] init];
    // extras.ageGroup = kIMSDKLogLevelNone;
    // extras.areaCode = @"12345";
    // [request registerAdNetworkExtras:extras];
    
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                           withAdUnitID:@"ca-app-pub-5459327557802742/7998640371"];
    
    //@"ca-app-pub-3940256099942544/1712485313"];
}


- (void)endGame
{
    
    if ([[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
    else
    {
        [[[UIAlertView alloc]
          initWithTitle:@"Interstitial not ready"
          message:@"The interstitial didn't finish " @"loading or failed to load"
          delegate:self
          cancelButtonTitle:@"Drat"
          otherButtonTitles:nil] show];
    }
}


#pragma mark UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //    [self startNewGame];
}

#pragma mark GADRewardBasedVideoAdDelegate implementation

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Rewarded video adapter class name: %@", rewardBasedVideoAd.adNetworkClassName);
    
    //    [activityIndicatorView stopAnimating];
    
    [hud_1 hideAnimated:YES];
    
    if ([[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
    else
    {
        [[[UIAlertView alloc]
          initWithTitle:@"Interstitial not ready"
          message:@"The interstitial didn't finish " @"loading or failed to load"
          delegate:self
          cancelButtonTitle:@"Drat"
          otherButtonTitles:nil] show];
    }
    
    NSLog(@"Reward based video ad is received.");
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad is closed.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward
{
    
    NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf", reward.type,[reward.amount doubleValue]];
    
    NSLog(@"%@", rewardMessage);
    
    sendPoints=@"10";
    operation=@"add";
    [self reduecePoints];
    
    //    rewardedCount -= 1;
    //
    //    spaceCount -=1;
    //
    //    if (rewardedCount == 0)
    //    {
    //        [self sendServer];
    //
    //        rewardedCount = 5;
    //    }
    //
    //    if (spaceCount == 0)
    //    {
    //        [self sendSpaceServer];
    //
    //        spaceCount = 5;
    //    }
}

-(void)sendSpaceServer
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=NonPaymentBenefits"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"Video_ID":@"",@"Section":@"minutes",@"Product":@"space",@"Value":@"20",@"BuyType":@"reward"};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Rewarded Response:%@",responseObject);
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Rewarded Error: %@", error);
     }];
}

-(void)sendServer
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=NonPaymentBenefits"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"Video_ID":@"",@"Section":@"minutes",@"Product":@"minutes",@"Value":@"20",@"BuyType":@"reward"};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Rewarded Response:%@",responseObject);
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Rewarded Error: %@", error);
     }];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad will leave application.");
    
    [hud_1 hideAnimated:YES];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error
{
    NSLog(@"Reward based video ad failed to load.");
    
    NSString *rCount = [NSString stringWithFormat:@"Try Again..."];
    
    [hud_1 hideAnimated:YES];
    
    [self.navigationController.view makeToast:rCount];
}


- (void)sendSerevr:(NSNotification *)note
{
    
    NSLog(@"Minutes / Space");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    
    //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=AddTopUps";
    
    NSDictionary *params = @{@"User_ID":user_id,@"ProductID":[note object],@"Product":product,@"Value":value,@"Amount":amount,@"Status":@"1"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json Payment Response:%@",responseObject);
         
         //         [self sendaaSpaceServer];
         
         //self.paymentResult = @"true";
         
         //         self.manageWaterBtn.hidden = false;
         //         self.removeWaterBtn.hidden = true;
         //
         //         self.topRemove.hidden = true;
         //
         //         self.afterRemove.hidden = true;
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         [self sendaaSpaceServer];
         
     }];
}


-(void)sendaaSpaceServer
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/GetReceipt.php"];
    
    NSDictionary *params = @{@"receiptData":[[NSUserDefaults standardUserDefaults]objectForKey:@"ltsReceipt"]};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Rewarded Response:%@",responseObject);
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Rewarded Error: %@", error);
     }];
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}

-(void) okClicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    
    [alertView hide];
    alertView = nil;
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@""]){
        
    }
    
    [alertView hide];
    alertView = nil;
    
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    /*UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"content_Controller15" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];*/
    
}

- (IBAction)spaceNoThanks:(id)sender
{
    self.transparentView.hidden=YES;
    self.minutesPopUp.hidden=YES;
    self.spacePopUp.hidden=YES;
}

- (IBAction)getSpace:(id)sender
{
    RewardedFor =@"Space";
    ValuesToExtend = @"1.024";
    if([creditPoints intValue] >= 120)
    {
        operation=@"minus";
        sendPoints = @"120";
        [self reduecePoints];
    }
    else{
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have enough Credit Points to get Space! kindly watch videos to get more points" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

- (IBAction)minutesNoThanks:(id)sender
{
    self.transparentView.hidden=YES;
    self.minutesPopUp.hidden=YES;
    self.spacePopUp.hidden=YES;
}

- (IBAction)getMinutes:(id)sender
{
    RewardedFor = @"Minutes";
    if([buyRewardMin isEqualToString:@"1"])
    {
        
        ValuesToExtend = @"1";
        sendPoints =@"30";
    }
    else
    {
        ValuesToExtend =@"3";
        sendPoints=@"50";
    }
    
    if([creditPoints intValue] >= [sendPoints intValue])
    {
        operation=@"minus";
        
        [self reduecePoints];
        
    }
    else{
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have enough Credit Points to get minutes!Kindly watch videos to get more points" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

- (IBAction)useCreditsToGetMinutes:(id)sender
{
    self.transparentView.hidden=NO;
    self.minutesPopUp.hidden=NO;
}

- (IBAction)useCreditsToGetSpaces:(id)sender
{
    self.transparentView.hidden=NO;
    self.spacePopUp.hidden=NO;
}

-(void)reduecePoints
{
    
    NSLog(@"Minutes / Space");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    
    //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=update_points";
    NSString *operationCount;
    
    if([operation isEqualToString:@"minus"])
    {
        operationCount = @"0";
    }
    else
    {
        operationCount = @"1";
    }
    
    NSDictionary *params = @{@"User_ID":user_id,@"operation":operation,@"points":sendPoints,@"lang":@"iOS",@"Date":currentDate,@"reward_count":operationCount};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operations, id responseObject)
     {
         NSLog(@"Update credit Response:%@",responseObject);

         creditPoints=[responseObject objectForKey:@"credit_points"];
         todayRewardCount=[responseObject objectForKey:@"reward_count"];
         
         [[NSUserDefaults standardUserDefaults]setObject:creditPoints forKey:@"credit_points"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         self.transparentView.hidden=YES;
         self.minutesPopUp.hidden=YES;
         self.spacePopUp.hidden=YES;
         if(![operation isEqualToString:@"add"])
         {
             [self UpdateSpaceAndMinutes];

         }
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
}
- (void)UpdateSpaceAndMinutes{

    NSLog(@"Minutes / Space");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    
    //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=UpdateRewardedVideoDetails";
    NSString *operationCount;
    
    if([operation isEqualToString:@"minus"])
    {
        operationCount = @"0";
    }
    else
    {
        operationCount = @"1";
    }
    
    NSDictionary *params = @{@"User_ID":user_id,@"ValuesToExtend":ValuesToExtend,@"RewardedFor":RewardedFor,@"lang":@"iOS",@"VideoSection":@"",@"VideoId":@""};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Updated Space And Minutes:%@",responseObject);
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
}
- (IBAction)getGiftPoints:(id)sender
{
    if([todayRewardCount intValue]<15)
    {
        //[self startGame];
        if([todayRewardCount intValue]%2==0)
        {
            if (_interstitial.isReady) {
                [_interstitial showFromViewController:self];
            }
            else{
                [self startGame];
            }
        }
        else
        {
            if ([UnityAds isReady:@"rewardedVideo"]) {
                
                [UnityAds show:self placementId:@"rewardedVideo"];
            }
            else
            {
                [self startGame];
            }
        }
    }
    else
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You crossed the today limation points,Try tomorrow!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

-(void)interstitialDidReceiveAd:(IMInterstitial *)interstitial {
    NSLog(@"InMobi Interstitial received an ad");
}
/**
 * Notifies the delegate that the interstitial has finished loading and can be shown instantly.
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial {
    NSLog(@"InMobi Interstitial finished loading");
    
}
/**
 * Notifies the delegate that the interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error {
    NSLog(@"InMobi Interstitial failed to load with error : %@", error);
    [self startGame];
}

-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    NSLog(@"InMobi Interstitial completed rewarded action. Rewards : %@", rewards);
    
    
}

/**
 * Notifies the delegate that the interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial {
    
    NSLog(@"InMobi Interstitial will be dismissed");
    self.interstitial = [[IMInterstitial alloc] initWithPlacementId:INMOBI_INTERSTITIAL_PLACEMENT delegate:self];
    [self.interstitial load];
    
    sendPoints=@"10";
    operation=@"add";
    [self reduecePoints];
}

/**
 * Notifies the delegate that the interstitial has been dismissed.
 */
-(void)interstitialDidDismiss:(IMInterstitial*)interstitial {
    NSLog(@"InMobi Interstitial has been dismissed");
}

//Unity Ad's Delegate

- (void)unityAdsReady:(NSString *)placementId{
    NSLog(@"Unity ad is ready");
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
   
    NSLog(@"Unity error:%ld",(long)error);
    //[self startGame];
}

- (void)unityAdsDidStart:(NSString *)placementId{
    NSLog(@"Unity Started:");
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
        NSLog(@"Unity ads did finished");
    
    sendPoints=@"10";
    operation=@"add";
    [self reduecePoints];
    
}
@end
