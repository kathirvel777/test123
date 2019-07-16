//
//  InviteFriendsViewController.m
//  Montage
//
//  Created by MacBookPro on 7/19/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "AFNetworking.h"
#import "KBContactsSelectionViewController.h"
#import "PCCPViewController.h"
#import "MBProgressHUD.h"
#import <TwitterKit/TwitterKit.h>
#import <linkedin-sdk/LISDK.h>
#import "WYPopoverController.h"
#import "GmailContactsViewController.h"
#import <SwipeBack/SwipeBack.h>
#import "YahooContactsViewController.h"
#import "OutlookViewController.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"
#import "UIView+Toast.h"
#import "GmailContactsViewController.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define phoneRegex @"[0-9]{10,15}"

@interface InviteFriendsViewController ()<KBContactsSelectionViewControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,ClickDelegates,UITextViewDelegate,FBSDKSharingDelegate,FBSDKAppInviteDialogDelegate>
{
    KBContactsSelectionViewController *vc;
    
    NSString *user_id,*cntryCodeFull,*mblNumber,*inviteFor;
    
    UITapGestureRecognizer *tapRecognizer,*tapReg;
    
    WYPopoverController *popoverController;
    
    MBProgressHUD *hud;
}
@end

@implementation InviteFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *mainTitleLabel;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        mainTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.lblView1.frame.origin.x+45,0, self.lblView1.frame.size.width-70, self.lblView1.frame.size.height)];
        
        mainTitleLabel.font = [UIFont fontWithName:@"FuturaT-Book" size:21.0f];
    }
    
    else
    {
        mainTitleLabel= [[UILabel alloc] initWithFrame:CGRectMake(_lblView1.frame.size.width/2,0, self.lblView1.frame.size.width, self.lblView1.frame.size.height)];
        
        mainTitleLabel.font = [UIFont fontWithName:@"FuturaT-Book" size:25.0f];
        
    }
    
    mainTitleLabel.textColor = [UIColor blackColor];
    
    mainTitleLabel.numberOfLines = 2;
    mainTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
    mainTitleLabel.text = @"Invite Friend We value friendship.\nAt exactly $20ds";
    mainTitleLabel.textColor=[UIColor whiteColor];
    
    //[self.lblView1 addSubview:mainTitleLabel];
    
    UILabel *subTitleLabel;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lblView2.frame.origin.x+45,0, self.lblView2.frame.size.width, self.lblView2.frame.size.height)];
        
        subTitleLabel.font = [UIFont fontWithName:@"FuturaT-Book" size:15.0f];
        
        subTitleLabel.numberOfLines = 3;
        _lblView2.alpha=0.7;
        
    }
    
    else
    {
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lblView2.frame.size.width/2,0, self.view.frame.size.width, self.lblView2.frame.size.height)];
        
        subTitleLabel.font = [UIFont fontWithName:@"FuturaT-Book" size:22.0f];
        subTitleLabel.numberOfLines = 3;
        _lblView2.alpha=0.5;
        
    }
    
    subTitleLabel.textColor = [UIColor blackColor];
    
    subTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    subTitleLabel.text = @"Refer your friends to us,and they'll each get $20.On top\n of that,we'll give you $20 for each friend that books\n their first flight through hypdra.com";
    
    subTitleLabel.textColor=[UIColor whiteColor];
    
    //  [self.lblView2 addSubview:subTitleLabel];
    
    inviteFor=[[NSUserDefaults standardUserDefaults]stringForKey:@"InviteFor"];
    
    self.otpsView.layer.cornerRadius = 5;
    self.otpsView.layer.masksToBounds = true;
    
    self.sndView.layer.cornerRadius = 5;
    self.sndView.layer.masksToBounds = true;
    
    cntryCodeFull = @"+91";
    
    self.secondView.hidden = true;
    self.topView.hidden = true;
    
    self.otpCode.enabled = false;
    self.resendCodeValue.enabled = false;
    
    self.phoneNumber.delegate = self;
    self.countryCode.delegate = self;
    
    [[self.closeVal imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureMethod:)];
    
    tapRecognizer.numberOfTapsRequired = 1;
    
    [self.getCountryView addGestureRecognizer:tapRecognizer];
    
    tapReg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRegMethod:)];
    
    tapReg.numberOfTapsRequired = 1;
    
    tapReg.delegate = self;
    
    [self.inviteInner addGestureRecognizer:tapReg];
    
    
    [[self.otpCloseBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    _phoneNumber.delegate = self;
    
    [_mobileNumber updateLengthValidationMsg:@"enter valid mobile number"];
    [_mobileNumber addRegx:phoneRegex withMsg:@"enter valid mobile number"];
    _RefferenceCode_lbl.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"referral_code"];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.linkedInTextView.text = @"Message";
    self.linkedInTextView.textColor = [UIColor lightGrayColor];
    self.linkedInTextView.delegate = self;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    self.navigationController.swipeBackEnabled = NO;
    
    
    self.inviteTop.hidden = true;
    
    self.inviteInner.hidden = true;
    
    self.otpTop.hidden = true;
    
    self.otpInner.hidden = true;
    
    
    
    NSLog(@"User ID = %@",user_id);
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [LISDKSessionManager clearSession];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)faceBookInvite{
    NSURL *fbURL = [NSURL URLWithString:@"fb://"];//or whatever url you're checking
    
    if ([[UIApplication sharedApplication] canOpenURL:fbURL])
    {
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
       // content.quote=@"Learn quick and simple ways for people to share content from your app or website to Facebook.";
        content.quote=[NSString stringWithFormat:@"%@ gave you 300 Credits to purchase Pro asserts on Hypdra.\n Hypdra Video Editor is a powerful yet easy-to-use video processing program for your videos. \n Join video clips and photos with zero quality loss, apply stylish video effects and filters, add music, titles, and much more. \n\n Hypdra Referral Code : %@ \n\n Download the Hypdra app using the below link \n %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"],[[NSUserDefaults standardUserDefaults]objectForKey:@"referral_code"],@"https://www.hypdra.com"];
        // [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
        
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.fromViewController = self;
        dialog.shareContent = content;
        dialog.mode = FBSDKShareDialogModeFeedWeb;
        dialog.delegate = self;
        [dialog show];
        
    }
    else
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Facebook app is not found" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
}
- (IBAction)facebookBtn:(id)sender
{
    [self getReferralCode:@"facebook"];
}



- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults :(NSDictionary*)results
{
    
    NSURL *fbURL = [NSURL URLWithString:@"fb://"];
    if (![[UIApplication sharedApplication] canOpenURL:fbURL])
        if (results[@"postId"]) {
            NSLog(@"Sweet, they shared, and Facebook isn't installed.");
        } else {
            NSLog(@"The post didn't complete, they probably switched back to the app");
        }
        else {
            NSLog(@"Sweet, they shared, and Facebook is installed.");
        }
    
    
    NSLog(@"%@",results);
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Successfully posted" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
    popUp.okay.backgroundColor = [UIColor lightGreen];
    popUp.agreeBtn.hidden = YES;
    popUp.cancelBtn.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"FB: CANCELED SHARER=%@\n",[sharer debugDescription]);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try Again" withTitle:@"Some error occured" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.backgroundColor = [UIColor lightGreen];
    popUp.agreeBtn.hidden = YES;
    popUp.cancelBtn.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
}

- (IBAction)myContacts:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults]stringForKey:@"otpStatus"]isEqualToString:@"oldOTP"])
    {
        self.enterOTP.text = @"";
        
        self.otpTop.hidden = true;
        
        self.otpInner.hidden = true;
        
        vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:nil];
        
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        //[self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        cntryCodeFull = @"+91";
        
        self.mobileNumber.text = @"";
        
        self.enterOTP.text = @"";
        
        self.countryImage.image = [UIImage imageNamed:@"india"];
        
        self.cntryCodeLabel.text = cntryCodeFull;
        
        self.inviteTop.hidden = false;
        
        self.inviteInner.hidden = false;
        
        self.linkedInView.hidden=false;
        
    }
    
}

- (void) contactSend:(NSString *)sel
{
    NSLog(@"Got Result = %@",sel);
    [vc.navigationController popViewControllerAnimated:YES];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [_currentWindow addSubview:_BlurView];
    
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        //  NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/api/api.php?rquest=UserInformation"];
        
        // NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/Twilio/InviteSMS.php"];
        
        
        NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/Twilio/InviteSMS.php"];
        
        NSDictionary *params = @{@"User_ID":user_id,@"Contacts":sel,@"InviteFor":inviteFor,@"InviteThrough":@"",@"InviteSection":@"advance",@"VideoId":@"",@"CountryCode":cntryCodeFull};
        
        [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
         {
             NSLog(@"test Server:%@",responseObject);
             
             NSDictionary *inviteSms=responseObject;
             NSArray *inviteSmsArr=[inviteSms objectForKey:@"InviteSMS"];
             
             NSDictionary *status=[inviteSmsArr objectAtIndex:0];
             NSString *messageStatus=[status objectForKey:@"message"];
             
             if([messageStatus isEqualToString:@"NOT OK"])
             {
                 CustomPopUp *popUp = [CustomPopUp new];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Incorrect number" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                 popUp.okay.backgroundColor = [UIColor navyBlue];
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
                 NSLog(@"Incorrect number");
             }
             
             else
             {
                 CustomPopUp *popUp = [CustomPopUp new];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your invitation has been sent successfully" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                 popUp.okay.backgroundColor = [UIColor lightGreen];
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
                 NSLog(@"correct number");
             }
             [hud hideAnimated:YES];
             
             [_BlurView removeFromSuperview];
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             
             [hud hideAnimated:YES];
             
             [_BlurView removeFromSuperview];
             
             //responseBlock(nil, FALSE, error);
         }];
    }
}
-(void)twitterInvite
{
    BOOL twInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]];
    
    if(twInstalled)
    {
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    NSURL *utl = [NSURL URLWithString:@"https://www.hypdra.com/"];
    
    [composer setURL:utl];
        
   // [composer setText:[NSString stringWithFormat:@"%@ gave you 300 Credits to purchase Pro asserts on Hypdra.\n Hypdra Video Editor is a powerful yet easy-to-use video processing program for your videos. \n Join video clips and photos with zero quality loss, apply stylish video effects and filters, add music, titles, and much more. \n\n Hypdra Referral Code : %@ \n\n Download the Hypdra app using the below link \n",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"],[[NSUserDefaults standardUserDefaults]objectForKey:@"ReferralCode"]]];
        
    [composer setText:[NSString stringWithFormat:@"Refer code : %@",_RefferenceCode_lbl.text]];
    //    [composer setImage:[UIImage imageNamed:@"twitterkit"]];
    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result)
     {
         if (result == TWTRComposerResultCancelled)
         {
             NSLog(@"Tweet composition cancelled");
         }
         else {
             NSLog(@"Sending Tweet!");
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Tweeted successfully" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
         }
     }];
    }
    else
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Twitter not installed" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

- (IBAction)twitterBtn:(id)sender
{
   // [self getReferralCode:@"twitter"];
    [self twitterInvite];
    
}

- (IBAction)gmailBtn:(id)sender
{

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    
    GmailContactsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"inviteGmailFriends"];
    
    // [vc awakeFromNib:@"gmail_navigate" arg:@"menuController"];
    
    //vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:vc animated:YES];

    //[self presentViewController:vc animated:YES completion:NULL];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)linkedIn:(id)sender
{
    
    self.linkedInTextView.text = @"Message";
    self.linkedInTextView.textColor = [UIColor lightGrayColor];
    self.linkedInTextView.delegate = self;
    self.otpTop.hidden=false;
    self.otpInner.hidden=false;
    self.otpsView.hidden=true;
    self.linkedInView.hidden=false;

}

- (IBAction)yahooSignIn:(id)sender
{
    //    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    //
    //    YahooContactsViewController *gc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"yahoo"];
    //
    //    [self.navigationController pushViewController:gc animated:YES];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"yahoo" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:vc animated:YES];

    //[self presentViewController:vc animated:YES completion:NULL];
    
}

-(void)sendValue
{
    NSString *url = @"https://api.linkedin.com/v1/people/~/shares";
    NSString *str = @"Your String";
    NSString *payload = @"Your Payload";
    //    if ([LISDKSessionManager hasValidSession])
    //    {
    //        [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:payload
    //                                             success:^(LISDKAPIResponse *response)
    //        {
    //                                                 // do something with response
    //                                                 NSLog(@"%s","success called!");
    //                                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Linkedin" message:@"Shared successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //                                                 [alert show];
    //                                             }
    //                                               error:^(LISDKAPIError *apiError)
    //                                                {
    //                                                   // do something with error
    //                                                    NSLog(@"Error = %@",apiError);
    //
    //                                               }];
    //    }
    //
    
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION,LISDK_W_SHARE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION, nil];
    
    
    //    [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState)
    //    {
    
    //         NSLog(@"%s","success called!");
    //
    //         LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
    //
    //
    //         NSLog(@"value=%@ isvalid=%@",[session value],[session isValid] ? @"YES" : @"NO");
    //
    //
    //         NSLog(@"Session  : %@", session.description);
    //
    //
    //         if ([LISDKSessionManager hasValidSession])
    //
    //         {
    //
    //             [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:payload
    //
    //                                                  success:^(LISDKAPIResponse *response)
    //
    //              {
    //
    //                  NSLog(@"success in posting %@",response);
    //
    //
    //
    //              }
    //
    //                                                    error:^(LISDKAPIError *apiError)
    //
    //              {
    //
    //                  NSLog(@"Error in post: %@",apiError);
    //
    //              }];
    //
    //         }
    //     }];
    
}


- (IBAction)submitCode:(id)sender
{
    if (self.phoneNumber.text.length == 0 && self.countryCode.text.length == 0)
    {
        
    }
    else
    {
        [self getOTP];
    }
}


-(void)getOTP
{
    self.linkedInView.hidden=true;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/Twilio/SendVerifyCode.php"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"CountryCode":cntryCodeFull,@"MobileNumber":self.mobileNumber.text};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Verify Code for getotp = %@",responseObject);
         
         NSArray *statusArray = [responseObject objectForKey:@"HYPDRA_OTP"];
         
         NSDictionary *stsDict = [statusArray objectAtIndex:0];
         
         NSString *status = [stsDict objectForKey:@"result"];
         
         if ([status isEqualToString:@"true"])
         {
             
             [hud hideAnimated:YES];
             
             
             // NSString *cyCode = [stsDict objectForKey:@"CountryCode"];
             
             NSString *mbNu = [stsDict objectForKey:@"MobileNumber"];
             
             
             //             mblNumber = [NSString stringWithFormat:@"%@%@",cyCode,mbNu];
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
         
         
         //         UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
         //            message:@"Could not connect to server"
         //           preferredStyle:UIAlertControllerStyleAlert];
         //
         //         UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
         //            style:UIAlertActionStyleDefault
         //            handler:nil];
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



- (IBAction)closeBtn:(id)sender
{
    
    self.otpCode.text = @"";
    
    self.countryCode.text = @"";
    
    self.phoneNumber.text = @"";
    
    self.secondView.hidden = true;
    self.topView.hidden = true;
    
    
    self.otpCode.enabled = false;
    self.resendCodeValue.enabled = false;
    
    self.submitCodeValue.enabled = true;
    
    
    [self.enterOTP resignFirstResponder];
}

- (IBAction)resendCode:(id)sender
{
    //    if (self.otpCode.text.length == 0)
    //    {
    //
    //    }
    //    else
    //    {
    [self getOTP];
    // }
}

-(void)sndOTP
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/Twilio/ConfirmOTP.php"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"CountryCode":cntryCodeFull,@"MobileNumber":mblNumber,@"OTP":self.enterOTP.text};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Verifed Code = %@",responseObject);
         
         NSArray *statusArray = [responseObject objectForKey:@"HYPDRA_OTP_CONFIRM"];
         NSDictionary *stsDict = [statusArray objectAtIndex:0];
         
         NSString *status = [stsDict objectForKey:@"result"];
         
         if ([status isEqualToString:@"true"])
         {
             
             [hud hideAnimated:YES];
             
             //            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Success"
             //                                                                           message:@"Mobile Number Confirmed"
             //                                                                    preferredStyle:UIAlertControllerStyleAlert];
             //
             //             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
             //                                                                 style:UIAlertActionStyleDefault
             //                                                               handler:^(UIAlertAction * action)
             //             {
             //
             //
             //                 self.enterOTP.text = @"";
             //
             //
             //                 self.otpTop.hidden = true;
             //
             //                 self.otpInner.hidden = true;
             //
             //
             //                 vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:nil];
             //
             //                 vc.delegate = self;
             //
             //                 [self presentViewController:vc animated:YES completion:nil];
             //
             //             }];
             //
             //            [alert addAction:yesButton];
             //
             //            [self presentViewController:alert animated:YES completion:nil];
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Mobile Number Confirmed" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
             popUp.accessibilityHint = @"MobileNumberConfirmed";
             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
         }
         
         else
         {
             [hud hideAnimated:YES];
             
             self.enterOTP.text = @"";
             self.otpTop.hidden = true;
             self.otpInner.hidden = true;
             
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


/*
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 
 NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
 
 int length = (int)[currentString length];
 
 NSLog(@"CurrentString = %@",currentString);
 
 if (self.countryCode == textField)
 {
 if (length == 2)
 {
 
 self.countryCode.text = currentString;
 
 [self.phoneNumber becomeFirstResponder];
 return NO;
 }
 
 }
 
 if (self.phoneNumber == textField)
 {
 if (length == 10)
 {
 self.phoneNumber.text = currentString;
 
 [self.phoneNumber resignFirstResponder];
 return NO;
 }
 
 }
 return YES;
 }
 */


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != self.inviteInner)
    {
        return NO;
    }
    return YES;
}


-(void)gestureRegMethod:(UITapGestureRecognizer*)sender
{
    
    [self.mobileNumber resignFirstResponder];
    
    self.inviteTop.hidden = true;
    
    self.inviteInner.hidden = true;
    
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


- (IBAction)getOTP:(id)sender
{
    
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

- (IBAction)otpClose:(id)sender
{
    
    self.enterOTP.text = @"";
    
    self.otpTop.hidden = true;
    
    self.otpInner.hidden = true;
    
}
- (IBAction)submitOTP:(id)sender
{
    if (self.enterOTP.text.length == 0)
    {
        //        UIAlertController * alert=[UIAlertController
        //
        //                                   alertControllerWithTitle:@"Alert" message:@"Enter valid OTP"preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction
        //                                    actionWithTitle:@"Ok"
        //                                    style:UIAlertActionStyleDefault
        //                                    handler:nil];
        //
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
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

- (IBAction)outlookBtn:(id)sender
{
    //    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    //
    //    OutlookViewController *gc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"outlook"];
    //
    //    [self.navigationController pushViewController:gc animated:YES];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"outlook" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:vc animated:YES];

   // [self presentViewController:vc animated:YES completion:NULL];
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"MobileNumberConfirmed"]){
        self.enterOTP.text = @"";
        
        self.otpTop.hidden = true;
        
        self.otpInner.hidden = true;
        
        vc = [KBContactsSelectionViewController contactsSelectionViewControllerWithConfiguration:nil];
        
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];

        //[self presentViewController:vc animated:YES completion:nil];
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
        
    }
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
}
- (IBAction)linkedInCancel:(id)sender {
    self.linkedInTextView.text=@"";
    self.otpTop.hidden = true;
    
    self.otpInner.hidden = true;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.linkedInTextView.text = @"";
    self.linkedInTextView.textColor = [UIColor blackColor];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if(self.linkedInTextView.text.length == 0){
        self.linkedInTextView.textColor = [UIColor lightGrayColor];
        self.linkedInTextView.text = @"Message";
        [self.linkedInTextView resignFirstResponder];
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    if(self.linkedInTextView.text.length == 0)
    {
        self.linkedInTextView.textColor = [UIColor lightGrayColor];
        self.linkedInTextView.text = @"Message";
        [self.linkedInTextView resignFirstResponder];
    }
    return true;
}
-(void)linkedINInvite{
    self.otpTop.hidden = true;
    self.otpInner.hidden = true;
    
    NSString *url = @"https://api.linkedin.com/v1/people/~/shares";
    NSString *refer = @"Refferal Code - ";
    NSString *payload = [NSString stringWithFormat:@"{\"comment\":\"%@ %@ https://www.hypdra.com\",\"visibility\":{ \"code\":\"anyone\" }}",self.linkedInTextView.text,[refer stringByAppendingString:_RefferenceCode_lbl.text]] ;
    
    //  NSString *payload = @"{\"comment\":\"Check out hypdra.com! https://www.hypdra.com\",\"visibility\":{ \"code\":\"anyone\" }}";
    
    
    // NSString *payload = @"{\"content\":{ \"title\":\"Hydra Invite\" },\"content\":{ \"description\":\"Montage Application\" },\"content\":{ \"submitted-url\":\"http://linkd.in/1FC2PyG\" },\"comment\":\"Check out developer.linkedin.com! http://linkd.in/1FC2PyG\",\"visibility\":{ \"code\":\"anyone\" }}";
    
    NSData *data = [payload dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"json is %@",json);
    
    NSMutableDictionary *jsonVal=json;
    
    NSMutableDictionary *subContent=[jsonVal objectForKey:@"content"];
    NSString *titleVal=[subContent objectForKey:@"title"];
    titleVal=self.linkedInTextView.text;
    //  [jsonVal setValue:@"hi" forKey:@"title"];
    
    /*    NSURL *likedInURL = [NSURL URLWithString:@"linkedin://profile?id=[id]"];
     if ([[UIApplication sharedApplication] canOpenURL: likedInURL])
     {
     [[UIApplication sharedApplication] openURL: likedInURL];
     }
     else
     {
     NSLog(@"Not Installed");
     }*/
    
    
    //
    if ([LISDKSessionManager hasValidSession])
    {
        [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:payload
                                             success:^(LISDKAPIResponse *response)
         {
             NSLog(@"Success Shared");
             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 CustomPopUp *popUp = [CustomPopUp new];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your, Post has been shared" withTitle:@"" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                 popUp.okay.backgroundColor = [UIColor lightGreen];
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
             });
         }
                                               error:^(LISDKAPIError *apiError)
         {
             NSLog(@"Share Error = %@",apiError);
         }];
        
    }
    else
    {
        
        NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION,LISDK_W_SHARE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION, nil];
        
        [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState)
         {
             
             NSLog(@"%s","success called!");
             NSLog(@"State = %@",returnState);
             
             [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:payload
                                                  success:^(LISDKAPIResponse *response)
              {
                  NSLog(@"Success Shared");
                  
                  dispatch_sync(dispatch_get_main_queue(), ^{
                      CustomPopUp *popUp = [CustomPopUp new];
                      [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your, Post has been shared" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                      popUp.okay.backgroundColor = [UIColor lightGreen];
                      popUp.agreeBtn.hidden = YES;
                      popUp.cancelBtn.hidden = YES;
                      popUp.inputTextField.hidden = YES;
                      [popUp show];
                  });
              }
                                                    error:^(LISDKAPIError *apiError)
              {
                  NSLog(@"Error = %@",apiError);
              }];
             
         }
                                        errorBlock:^(NSError *error)
         {
             NSLog(@"%s","error called!");
         }];
    }
}

- (IBAction)linkedInShare:(id)sender
{
    [self getReferralCode:@"linkedin"];
}

-(void)getReferralCode:(NSString *)inviteThrough{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=InviteFriendsThroughSocialMedia"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"InviteFor":@"space",@"InviteThrough":inviteThrough,@"InviteSection":@"",@"VideoId":@""};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"ReferID = %@",responseObject);
         
         
         [hud hideAnimated:YES];
         
         if([inviteThrough isEqualToString:@"facebook"]){
             [self faceBookInvite];
         }else if([inviteThrough isEqualToString:@"twitter"]){
             [self twitterInvite];
         }else if([inviteThrough isEqualToString:@"linkedin"]){
             [self linkedINInvite];
         }
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error Verify Code = %@", error);
         
         
         [hud hideAnimated:YES];
         
         self.inviteTop.hidden = true;
         
         self.inviteInner.hidden = true;
         
         
         //         UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
         //            message:@"Could not connect to server"
         //           preferredStyle:UIAlertControllerStyleAlert];
         //
         //         UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
         //            style:UIAlertActionStyleDefault
         //            handler:nil];
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
- (IBAction)backAction:(id)sender
{
    //if (IS_PAD)
    //    {
    //
    //
    //        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
    //
    //        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //        [vc awakeFromNib:@"demo_planDisplay" arg:@"menuController"];
    //
    //        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //        [self presentViewController:vc animated:YES completion:NULL];
    //    }
    //    else
    //    {
    //
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_planDisplay" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)switch_btn:(id)sender
{
    
}

- (IBAction)whatsappAction:(id)sender
{
    NSString *userName=[[NSUserDefaults standardUserDefaults]valueForKey:@"Profilename"];
    
    NSString *urlToShare=@"https://play.google.com/store/apps/details?id=com.brain.brainyviral \n Here you are referrred with code \n";
    
    
    NSString *sharingText=[NSString stringWithFormat:@"%@ gave you 300 Credits to purchase Pro asserts on Hypdra Video Editor is a powerful yet easy-to-use video processing program for your videos.Join video clips and photos with zero quality loss, apply stylish video effects and filters, add music, titles, and much more.\n %@ %@ ",userName,urlToShare,_RefferenceCode_lbl.text];
    
    NSString* strSharingText = [sharingText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //This is whatsApp url working only when you having app in your Apple device
    
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",strSharingText]];
    
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else
    {
        [self.view makeToast:@"Whatsapp not installed" duration:1.0 position:CSToastPositionCenter];
    }
}

- (IBAction)hangoutAction:(id)sender
{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(textField == _phoneNumber){
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 15;
    }else{
        return YES;
    }
}
@end

