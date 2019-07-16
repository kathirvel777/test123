//
//  RegisterOTPViewController.m
//  Montage
//
//  Created by MacBookPro4 on 1/21/18.
//  Copyright © 2018 sssn. All rights reserved.

#import "RegisterOTPViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NetworkRechabilityMonitor.h"
#import "DEMOHomeViewController.h"
#import "DEMORootViewController.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "SwipeBack.h"


@interface RegisterOTPViewController ()<UITextFieldDelegate,ClickDelegates>
{
    MBProgressHUD *hud;
    NSDictionary *stsDict;
    dispatch_group_t group;

}

@end

@implementation RegisterOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NetworkRechabilityMonitor startNetworkReachabilityMonitoring];
    self.navigationController.swipeBackEnabled=NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)submitAction:(id)sender
{
    if (![NetworkRechabilityMonitor checkNetworkStatus])
    {
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
        NSString *otp=[NSString stringWithFormat:@"%@%@%@%@%@%@",self.text1.text,self.text2.text,self.text3.text,self.text4.text,self.text5.text,self.text6.text];
    if (otp.length == 0)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
//            message:@"Enter valid OTP"
//            delegate:self cancelButtonTitle:@"OK"
//            otherButtonTitles:nil];
//
//        [alert show];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter valid OTP" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    else
    {
        //[self.enterOTP resignFirstResponder];
        
        [self sndOTP:otp];
    }
 }
}

-(void)sndOTP:(NSString *)otp
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URLString;
    NSDictionary *params;
    if([self.Type isEqualToString:@"FirstTime"]){
   URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=HypdraAccountConfirmation"];
    
    params = @{@"lang":@"iOS",@"ComfirmationCode":otp,@"Email_ID":self.email};
    }else{
        
        URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=TwoWayVerificationloginOTPConfirm"];
        
        params = @{@"lang":@"iOS",@"otpNumber":otp,@"User_ID":self.user_ID};
    }
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Verifed Code = %@",responseObject);
         if([self.Type isEqualToString:@"FirstTime"]){
         NSArray *statusArray = [responseObject objectForKey:@"HypdraAccountConfirmation"];
         stsDict = [statusArray objectAtIndex:0];
         }else{
             stsDict = responseObject;
             stsDict = [stsDict objectForKey:@"TwoWayAccountVerificationOTP"];
         }
         NSString *status = [stsDict objectForKey:@"status"];
         
         
         if ([status isEqualToString:@"success"])
         {
             
             [hud hideAnimated:YES];
             
        CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"OTP Confirmed" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.accessibilityHint=@"OTPConfirmed";
             popUp.inputTextField.hidden = YES;
             [popUp show];
            /* UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Success"
                message:@"OTP Confirmed"
                preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action)
                {
              
                    self.enterOTP.text = @"";
                    
                    [self LoadAllData];
                   
                }];
           
             [alert addAction:yesButton];
             [self presentViewController:alert animated:YES completion:nil];*/
         }
         
         else
         {
             [hud hideAnimated:YES];
             
            // self.enterOTP.text = @"";
             
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
//                message:@"Invalid OTP or EMAIL"
//                delegate:self cancelButtonTitle:@"OK"
//                otherButtonTitles:nil];
//
//             [alert show];
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try again, invalid OTP" withTitle:@"Warning!" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             self.text1.text=self.text2.text=self.text3.text=self.text4.text=self.text5.text=self.text6.text=@"";
         }
     }
    failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error Verifed Code = %@", error);
         
         [hud hideAnimated:YES];
         
        // self.enterOTP.text = @"";
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
            message:@"Could not connect to server"
            delegate:self cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
         
         [alert show];
         
     }];
    
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

                [hud hideAnimated:YES];
                                
                NSLog(@"Final Response Before = %@",stsDict);
                                  
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                  
                NSString *minAvil=[stsDict objectForKey:@"Duration Status"];
                                  
                NSString *spcAvil = [stsDict objectForKey:@"Space Status"];
                                  
                [defaults setValue:minAvil forKey:@"minAvil"];
                                  
                [defaults setValue:spcAvil forKey:@"spcAvil"];
                                  
                NSString *MemberShipType = [stsDict objectForKey:@"Plan"];
                                  
                [defaults setValue:MemberShipType forKey:@"MemberShipType"];
                                  
                NSString *albumCount = [stsDict objectForKey:@"advance_album_count"];
                                  
                NSString *albumCount1 = [stsDict objectForKey:@"wizard_album_count"];
                            
                _user_ID=[stsDict objectForKey:@"user_id"];
                                  
                int numValue = [albumCount intValue];
                                  
                int numValue1 = [albumCount1 intValue];
                                  
                NSLog(@"Login Album Count = %d",numValue);
                                  
                NSLog(@"Login Wizard Count = %d",numValue1);
                                  
                [defaults setInteger:numValue forKey:@"AlbumCount"];
                                  
                                  [defaults setInteger:numValue1 forKey:@"AlbumCount1"];
                                  
                                  [defaults setValue:_user_ID forKey:@"USER_ID"];
                                  
                                  NSString *profilePic = [stsDict objectForKey:@"User_Profile_Pic"];
                                  
                                  NSString *profileName = [stsDict objectForKey:@"User_name"];
                                  
                                  [defaults setValue:profilePic forKey:@"ProfilePic"];
                                  
                                  [defaults setValue:profileName forKey:@"Profilename"];
                                  
                                  [defaults setValue:profilePic forKey:@"ProfilePic"];
                                  
                                  [defaults setValue:[stsDict objectForKey:@"Email_ID"] forKey:@"Email_ID"];
                                  
                                //  [defaults setValue:stsDict forKey:@"USER_ID"];
                                  
                                  [defaults synchronize];
                                  
                                  
                                  NSLog(@"Final Before Login");
                                  
                                  
                                  UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                                  
                                  [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
                                  
                                  vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                  [self presentViewController:vc1 animated:YES completion:nil];
                                  
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


- (IBAction)resendOTP:(id)sender
{
    if (![NetworkRechabilityMonitor checkNetworkStatus])
    {
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
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=ResendAccountVerificationOTP"];
    
    NSDictionary *params = @{@"lang":@"iOS",@"EmailID":self.email};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Verifed Code = %@",responseObject);
         
         NSDictionary *statusArray = [responseObject objectForKey:@"ResendAccountVerificationOTP"];
         
        // NSDictionary *stsDict = [statusArray objectAtIndex:0];
         
         NSString *status = [NSString stringWithFormat:@"%@",[statusArray  objectForKey:@"Status"]];
         
         if ([status isEqualToString:@"1"])
         {
             
             [hud hideAnimated:YES];
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please Check your email!." withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             popUp.accessibilityHint=@"resendotp";
             [popUp show];
            
           /*  UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                message:@"Kindly Check your mail!."
                preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action)
                {
                    
                }];
             
             self.enterOTP.text = @"";
             
             [alert addAction:yesButton];
             [self presentViewController:alert animated:YES completion:nil];*/

         }
         
//         else
//         {
//             [hud hideAnimated:YES];
//
//             self.enterOTP.text = @"";
//
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
//                message:@"Invalid OTP or EMAIL"
//                delegate:self cancelButtonTitle:@"OK"
//                otherButtonTitles:nil];
//
//             [alert show];
//
//         }
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error Verifed Code = %@", error);
         
         [hud hideAnimated:YES];
         
        // self.enterOTP.text = @"";
         
         // self.OtpOuter.hidden = true;
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
//         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//            message:@"Could not connect to server"
//            delegate:self cancelButtonTitle:@"OK"
//            otherButtonTitles:nil];
//
//         [alert show];
         
     }];
 }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if ((textField.text.length >= 1) && (string.length > 0))
//    {
//        NSInteger nextTag = textField.tag + 1;
//        // Try to find next responder
//        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//        if (! nextResponder)
//            nextResponder = [textField.superview viewWithTag:1];
//
//        if (nextResponder)
//            // Found next responder, so set it.
//            [nextResponder becomeFirstResponder];
//
//        return NO;
//    }
//    return YES;
    
    NSLog(@"String in textfield:%@",string);
    NSLog(@"Text length:%lu",textField.text.length);
    
    UIResponder* nextResponder,*prevResponder;
  
    if ((textField.text.length < 1) && (string.length > 0))
    {

        NSInteger nextTag = textField.tag + 1;
        nextResponder = [textField.superview viewWithTag:nextTag];

        if (! nextResponder){
            [textField resignFirstResponder];
          
        }
        textField.text = string;
        if (nextResponder)
            [nextResponder becomeFirstResponder];

        return NO;

    }
    else if ((textField.text.length >= 1) && (string.length > 0)){
        //FOR MAXIMUM 1 TEXT

        NSInteger nextTag = textField.tag + 1;
         nextResponder = [textField.superview viewWithTag:nextTag];
        if (! nextResponder){
            [textField resignFirstResponder];
           // nextResponder = [textField.superview viewWithTag:1];
        }
        textField.text = string;
        if (nextResponder)
            [nextResponder becomeFirstResponder];

        return NO;
    }
    else if ((textField.text.length >= 1) && (string.length == 0)){
        // on deleteing value from Textfield

        NSInteger prevTag = textField.tag - 1;

        // Try to find prev responder
         prevResponder = [textField.superview viewWithTag:prevTag];

        if (! prevResponder){
          [textField resignFirstResponder];
            //prevResponder = [textField.superview viewWithTag:1];
        }
        textField.text = string;

        if (prevResponder)
            // Found next responder, so set it.
            [prevResponder becomeFirstResponder];

        return NO;
    }

    return YES;
}

- (IBAction)backAction:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

-(void) okClicked:(CustomPopUp *)alertView{
   
    if([alertView.accessibilityHint isEqualToString:@"OTPConfirmed"])
    {
       // self.enterOTP.text = @"";
        
        [self LoadAllData];
    }
    else if([alertView.accessibilityHint isEqualToString:@"resendotp"])
    {
       // self.enterOTP.text = @"";
        
    }
    
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}

@end
