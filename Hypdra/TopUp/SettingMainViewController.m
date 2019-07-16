//
//  SettingMainViewController.m
//  SampleTest
//
//  Created by MacBookPro on 8/16/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SettingMainViewController.h"
#import "PlanDisplayViewController.h"
#import "ReferralDisplayViewController.h"
#import "BillingDisplayViewController.h"
#import "AFNetworking.h"
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
#import <SwipeBack/SwipeBack.h>
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"
#import "KBContactsSelectionViewController.h"
#import "PCCPViewController.h"
#import "WYPopoverController.h"

#define phoneRegex @"[0-9]{10,15}"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface SettingMainViewController ()<KBContactsSelectionViewControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,ClickDelegates,UITextViewDelegate>
{
    NSMutableArray *currentPlan;
    
    NSMutableString *nxtRnwDate,*pymtType;
    KBContactsSelectionViewController *vc;
    
    NSString *user_id,*cntryCodeFull,*mblNumber,*inviteFor;
    
    UITapGestureRecognizer *tapRecognizer,*tapReg;
    
    WYPopoverController *popoverController;
    
    MBProgressHUD *hud;
}
@end

@implementation SettingMainViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    nxtRnwDate = [[NSMutableString alloc]init];
    
    pymtType = [[NSMutableString alloc]init];
    
    [self setShadow:self.planView];
    [self setShadow:self.detailView];
    [self setShadow:self.referralView];
    [self setShadow:self.historyView];
    
    [[self.plan imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.detail imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.referral imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.history imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];//UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    //NEW-ZZZZ
    self.otpsView.layer.cornerRadius = 5;
    self.otpsView.layer.masksToBounds = true;
    
    self.sndView.layer.cornerRadius = 5;
    self.sndView.layer.masksToBounds = true;
    
    cntryCodeFull = @"+91";
    
    //self.secondView.hidden = true;
    self.topView.hidden = true;
    
    self.otpCode.enabled = false;
    // self.resendCodeValue.enabled = false;
    
    self.phoneNumber.delegate = self;
    self.countryCode.delegate = self;
    
    //[[self.closeVal imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureMethod:)];
    
    tapRecognizer.numberOfTapsRequired = 1;
    
    [self.getCountryView addGestureRecognizer:tapRecognizer];
    
    tapReg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRegMethod:)];
    
    tapReg.numberOfTapsRequired = 1;
    
    tapReg.delegate = self;
    
    [self.inviteInner addGestureRecognizer:tapReg];
    
    
    [[self.otpCloseBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [_mobileNumber updateLengthValidationMsg:@"enter valid mobile number"];
    [_mobileNumber addRegx:phoneRegex withMsg:@"enter valid mobile number"];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"TwoWayVerifyEnabled"]){
        [self.Otp_switch setOn:YES animated:YES];
    }else
        [self.Otp_switch setOn:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    self.navigationController.swipeBackEnabled = NO;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    self.inviteTop.hidden = true;
    
    self.inviteInner.hidden = true;
    
    self.otpTop.hidden = true;
    
    self.otpInner.hidden = true;
    [self currentPlan];
    
}


-(void)setShadow:(UIView*)demoView
{
    demoView.layer.shadowColor = [UIColor blackColor].CGColor;
    demoView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    demoView.layer.shadowOpacity = 0.8f;
}


- (IBAction)closeBtn:(id)sender
{
    self.topView.hidden = true;
    self.selectionView.hidden = true;
}

- (IBAction)detailsBtn:(id)sender
{
    self.topView.hidden = false;
    self.selectionView.hidden = false;
    
    self.nxtBillDate.text = nxtRnwDate;
    self.pymtMethod.text = pymtType;
}

- (IBAction)historyBtn:(id)sender
{
    //if (IS_PAD)
    //    {
    //
    //        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
    //
    //        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //        [vc awakeFromNib:@"demo_billingHistory" arg:@"menuController"];
    //
    //        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //        [self presentViewController:vc animated:YES completion:NULL];
    //    }
    //    else
    //    {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_billingHistory" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    // }
}

- (IBAction)referralBtn:(id)sender
{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_referral" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    //  }
    
}

- (IBAction)planBtn:(id)sender
{
    
   /* UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_planDisplay" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];*/
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    PlanDisplayViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PlanDisplay"];
    
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(void)currentPlan
{
    
    nxtRnwDate = [[NSMutableString alloc]init];
    
    pymtType = [[NSMutableString alloc]init];
    
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
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         currentPlan=responseObject;
         
         NSLog(@"Check Membership Status:%@",responseObject);
         
         [nxtRnwDate appendString:@"Next Bill Date : "];
         
         [nxtRnwDate appendString:[currentPlan valueForKey:@"RenewDate"]];
         
         [pymtType appendString:@"Payment Method : "];
         
         [pymtType appendString:[currentPlan valueForKey:@"PaymentMethod"]];
         NSString *plan = (NSString *)[currentPlan valueForKey:@"Plan"];
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
         NSString *status =(NSString *)[currentPlan valueForKey:@"verification_status"];
         
         if([status isEqualToString:@"1"]){
             [self.Otp_switch setOn:YES animated:YES];
             [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TwoWayVerifyEnabled"];
         }else{
             [self.Otp_switch setOn:NO animated:YES];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"TwoWayVerifyEnabled"];
         }
         
         [hud hideAnimated:YES];
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         [hud hideAnimated:YES];
         
         //         UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
         //                                                                       message:@"Could not connect to server"
         //                                                                preferredStyle:UIAlertControllerStyleAlert];
         //
         //         UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
         //                                                             style:UIAlertActionStyleDefault
         //                                                           handler:nil];
         //
         //
         //         [alert addAction:yesButton];
         //
         //         [self presentViewController:alert animated:YES completion:nil];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
     }];
    
}

- (IBAction)menu:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:4 forKey:@"SelectedIndex"];
    
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
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

- (IBAction)switch_plans:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    [[NSUserDefaults standardUserDefaults]setValue:@"Free" forKey:@"Plan"];
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    NSLog(@"Cancel");
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""])
    {
        
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
-(void)gestureRegMethod:(UITapGestureRecognizer*)sender
{
    
    [self.mobileNumber resignFirstResponder];
    
    self.inviteTop.hidden = true;
    
    self.inviteInner.hidden = true;
    [self.Otp_switch setOn:NO animated:YES];
    
}

-(void)gestureMethod:(UITapGestureRecognizer*)sender
{
    
    [self.mobileNumber resignFirstResponder];
    
    PCCPViewController *pccp = [[PCCPViewController alloc] initWithCompletion:^(id countryDic)
                                {
                                    [self updateViewsWithCountryDic:countryDic];
                                }];
    
    [pccp setIsUsingChinese:false];
    
    //    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    //
    //    [self presentViewController:naviVC animated:YES completion:NULL];
    
    
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:pccp];
    
    popoverController.delegate = self;
    
    
    
    popoverController.popoverContentSize = CGSizeMake(250, 350);
    
    [popoverController presentPopoverFromRect:self.pick.frame
                                       inView:self.pick.superview
                     permittedArrowDirections:WYPopoverArrowDirectionAny
                                     animated:YES
                                      options:WYPopoverAnimationOptionFadeWithScale];
    
}

- (void)updateViewsWithCountryDic:(NSDictionary*)countryDic
{
    
    [popoverController dismissPopoverAnimated:YES];
    
    //    [_label setText:[NSString stringWithFormat:@"country_code: %@\ncountry_en: %@\ncountry_cn: %@\nphone_code: %@",countryDic[@"country_code"],countryDic[@"country_en"],countryDic[@"country_cn"],countryDic[@"phone_code"]]];
    
    
    NSString *en = countryDic[@"country_code"];
    
    NSString *code = countryDic[@"phone_code"];
    
    
    NSString *cmplete = [NSString stringWithFormat:@"%@ +%@",en,code];
    
    
    cntryCodeFull = [NSString stringWithFormat:@"+%@",code];
    
    
    NSLog(@"Country Code = %@",cntryCodeFull);
    
    self.cntryCodeLabel.text = cmplete;
    
    [self.countryImage setImage:[PCCPViewController imageForCountryCode:countryDic[@"country_code"]]];
    
}


- (IBAction)getOTP:(id)sender {
    if (![self.mobileNumber validate])
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter valid mobile number" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        [self.mobileNumber resignFirstResponder];
        [self getOTP];
    }
}
- (IBAction)otpClose:(id)sender {
    
    self.enterOTP.text = @"";
    self.otpTop.hidden = true;
    self.otpInner.hidden = true;
    
}
- (IBAction)submitOTP:(id)sender {
    
    if (self.enterOTP.text.length == 0)
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter valid OTP" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        [self.enterOTP resignFirstResponder];
        [self sndOTP];
        [[NSUserDefaults standardUserDefaults]setValue:@"oldOTP" forKey:@"otpStatus"];
    }
}
-(void)getOTP
{
    [[NSUserDefaults standardUserDefaults]setValue:cntryCodeFull forKey:@"CountryCode"];
    [[NSUserDefaults standardUserDefaults]setValue:self.mobileNumber.text forKey:@"MobileNumber"];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URLString;
    NSDictionary *params;
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"TwoWayVerifyEnabled"]){
        URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=DisableTwoWayVerificationOTP"];
        params = @{@"User_ID":user_id};
    }else{
        URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=EnableTwoWayVerificationOTP"];
        params = @{@"userId":user_id,@"lang":@"iOS",@"CountryCode":cntryCodeFull,@"mobileNumber":self.mobileNumber.text};
    }
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Verify Code for getotp = %@",responseObject);
         NSDictionary *stsDict = [responseObject objectForKey:@"TwoWayVerificationOTP"];
         NSString *status = [NSString stringWithFormat:@"%@",[stsDict objectForKey:@"Status"]];
         
         if ([status isEqualToString:@"1"])
         {
             [hud hideAnimated:YES];
             // NSString *cyCode = [stsDict objectForKey:@"CountryCode"];
             NSString *mbNu = [stsDict objectForKey:@"MobileNumber"];
             // mblNumber = [NSString stringWithFormat:@"%@%@",cyCode,mbNu];
             mblNumber = [NSString stringWithFormat:@"%@",mbNu];
             self.inviteTop.hidden = true;
             self.inviteInner.hidden = true;
             self.enterOTP.text = @"";
             self.otpTop.hidden = false;
             self.otpInner.hidden = false;
         }
         else
         {
             [hud hideAnimated:YES];
             self.inviteTop.hidden = true;
             self.inviteInner.hidden = true;
         }
         
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error Verify Code = %@", error);
         
         [hud hideAnimated:YES];
         self.inviteTop.hidden = true;
         self.inviteInner.hidden = true;
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
     }];
}

- (IBAction)resendCode:(id)sender{
    [self getOTP];
}

- (IBAction)switch_btn:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        
        cntryCodeFull = @"+91";
        
        self.mobileNumber.text = @"";
        self.enterOTP.text = @"";
        self.countryImage.image = [UIImage imageNamed:@"india"];
        self.cntryCodeLabel.text = cntryCodeFull;
        self.inviteTop.hidden = false;
        self.inviteInner.hidden = false;
    }else{
        NSLog(@"Switch is OFF");
        
        self.mobileNumber.text = (NSString *)[[NSUserDefaults standardUserDefaults]valueForKey:@"MobileNumber"];
        cntryCodeFull =(NSString *)[[NSUserDefaults standardUserDefaults]valueForKey:@"CountryCode"];
        self.enterOTP.text = @"";
        [self getOTP];

        self.cntryCodeLabel.text = cntryCodeFull;
    }
}
-(void)sndOTP
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URLString;
    NSDictionary *params;
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"TwoWayVerifyEnabled"]){
        
        URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=DisableTwoWayVerificationOTPconfirm"];
        params = @{@"User_ID":user_id,@"lang":@"iOS",@"otpNumber":self.enterOTP.text};
        
    }else{
        URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=TwoWayVerificationOTPConfirm"];
        params = @{@"userId":user_id,@"lang":@"iOS",@"otpNumber":self.enterOTP.text};
        
    }
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Verifed Code = %@",responseObject);
         
         NSDictionary *stsDict = [responseObject objectForKey:@"TwoWayVerificationOTP"];
         
         NSString *status = [NSString stringWithFormat:@"%@",[stsDict objectForKey:@"Status"]];
         
         if ([status isEqualToString:@"1"])
         {
             [hud hideAnimated:YES];
             CustomPopUp *popUp = [CustomPopUp new];
             if([[NSUserDefaults standardUserDefaults]boolForKey:@"TwoWayVerifyEnabled"]){
                 [self.Otp_switch setOn:NO animated:NO];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"TwoWayVerifyEnabled"];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Two way verification disabled" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                 
             }else{
                 [self.Otp_switch setOn:YES animated:YES];
                 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TwoWayVerifyEnabled"];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Two way verification enabled" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
             }

             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
             self.enterOTP.text = @"";
             self.otpTop.hidden = true;
             self.otpInner.hidden = true;
         }
         
         else
         {
             [hud hideAnimated:YES];
             
             self.enterOTP.text = @"";
             self.otpTop.hidden = true;
             self.otpInner.hidden = true;
             if([[NSUserDefaults standardUserDefaults]boolForKey:@"TwoWayVerifyEnabled"]){
                 [self.Otp_switch setOn:YES animated:YES];
                 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TwoWayVerifyEnabled"];
             }else{
                 [self.Otp_switch setOn:NO animated:YES];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"TwoWayVerifyEnabled"];
             }
             
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Mobile Number Confirmation Failed" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
         }
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error Verifed Code = %@", error);
         
         [hud hideAnimated:YES];
         
         self.enterOTP.text = @"";
         
         self.otpTop.hidden = true;
         
         self.otpInner.hidden = true;
         
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
         if([[NSUserDefaults standardUserDefaults]boolForKey:@"TwoWayVerifyEnabled"]){
             [self.Otp_switch setOn:YES animated:YES];
             [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TwoWayVerifyEnabled"];
         }else{
             [self.Otp_switch setOn:NO animated:YES];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"TwoWayVerifyEnabled"];
         }
         
     }];
}

@end

