//
//  RegisterViewController.m
//  Montage
//
//  Created by MacBookPro on 4/24/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "RegisterViewController.h"
#import "REFrostedViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "RegisterOTPViewController.h"
#import "NetworkRechabilityMonitor.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"


#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASS @"[A-Za-z0-9]{4,20}"


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface RegisterViewController ()<UITextFieldDelegate,ClickDelegates>
{
    MBProgressHUD *hud;
    NSString *userId;
    NSString *email;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NetworkRechabilityMonitor startNetworkReachabilityMonitoring];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    self.name.rightView = imageView;
    
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.email.delegate = self;
    self.mobileNumber.delegate = self;
    self.password.delegate = self;
    
    self.firstName.tintColor = [UIColor whiteColor];
    self.lastName.tintColor = [UIColor whiteColor];
    self.email.tintColor = [UIColor whiteColor];
    self.password.tintColor = [UIColor whiteColor];
    self.mobileNumber.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];//UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.segmentForOTP.layer.cornerRadius = 15.0;
    
    self.segmentForOTP.layer.borderColor = [UIColor whiteColor].CGColor;
    self.segmentForOTP.layer.borderWidth = 1.0f;
    self.segmentForOTP.layer.masksToBounds = YES;
    
    self.segmentForOTP.selectedSegmentIndex=0;
    
    [[self.segmentForOTP.subviews objectAtIndex:0] setTintColor: UIColorFromRGB(0x2d2c65)];
    [[self.segmentForOTP.subviews objectAtIndex:1] setTintColor:UIColorFromRGB(0x2d2c65)];
    
    //    [[self.segmentForOTP.subviews objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
    
    //[self.segmentForOTP setImage:[UIImage imageNamed:@"orange_circle"] forSegmentAtIndex:0];
    [self.segmentForOTP setWidth:25 forSegmentAtIndex:0];
    [self.segmentForOTP setWidth:50 forSegmentAtIndex:1];
    [self.segmentForOTP setTitle:@"Email" forSegmentAtIndex:1];
    [self.segmentForOTP addTarget:self action:@selector(checkOnOffState:) forControlEvents:UIControlEventValueChanged];
    
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
    
    
    CALayer *FNBorder  =  [CALayer layer];
    CGFloat FNBorderWidth = 0.2;
    FNBorder.borderColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4].CGColor;
    border.frame = CGRectMake(0, self.firstName.frame.size.height - borderWidth, 0, self.firstName.frame.size.height);
    FNBorder.borderWidth = FNBorderWidth;
    [self.firstName.layer addSublayer:FNBorder];
    self.firstName.layer.masksToBounds = YES;
    
    UIColor *FNcolor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    NSString *FNplaceholderText = self.firstName.placeholder;
    self.firstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:FNplaceholderText attributes:@{NSForegroundColorAttributeName: FNcolor}];
    
    
    CALayer *LNBorder  =  [CALayer layer];
    CGFloat LNBorderWidth = 0.2;
    LNBorder.borderColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4].CGColor;
    LNBorder.frame = CGRectMake(0, self.lastName.frame.size.height - borderWidth, 0, self.lastName.frame.size.height);
    LNBorder.borderWidth = LNBorderWidth;
    [self.lastName.layer addSublayer:LNBorder];
    self.lastName.layer.masksToBounds = YES;
    
    UIColor *LNcolor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    NSString *LNplaceholderText = self.lastName.placeholder;
    self.lastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LNplaceholderText attributes:@{NSForegroundColorAttributeName: LNcolor}];
    
    CALayer *MobileBorder  =  [CALayer layer];
    CGFloat MobileBorderWidth = 0.2;
    MobileBorder.borderColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4].CGColor;
    MobileBorder.frame = CGRectMake(0, self.mobileNumber.frame.size.height - MobileBorderWidth, 0, self.mobileNumber.frame.size.height);
    MobileBorder.borderWidth = MobileBorderWidth;
    [self.mobileNumber.layer addSublayer:MobileBorder];
    self.mobileNumber.layer.masksToBounds = YES;
    
    UIColor *MobColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    NSString *MobPlaceholderText = self.mobileNumber.placeholder;
    self.mobileNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:MobPlaceholderText attributes:@{NSForegroundColorAttributeName: MobColor}];
    [self setupAlerts];
}
-(void)setupAlerts{
   // NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    _mobileNumber.delegate = self;
    _email.isMandatory =YES;
    _password.isMandatory = YES;
    _firstName.isMandatory = YES;
    _lastName.isMandatory = YES;
    [_email updateLengthValidationMsg:@"enter valid email"];
    [_firstName updateLengthValidationMsg:@"user name charaters limit should be come between 3-10"];
    [_lastName updateLengthValidationMsg:@"last name charaters limit should be come between 3-10"];
    [_password updateLengthValidationMsg:@"Password charaters limit should be come between 4-20"];
    [_email addRegx:REGEX_EMAIL withMsg:@"enter valid email"];
    [_password addRegx:REGEX_PASS withMsg:@"Password must contain min 4 and max 20 characters"];
    _mobileNumber.isMandatory = NO;
   // [_mobileNumber addRegx:phoneRegex withMsg:@"invalid number"];
    
    [_firstName addRegx:REGEX_USER_NAME withMsg:@"User name charaters limit should be come between 3-10"];
    [_lastName addRegx:REGEX_USER_NAME withMsg:@"User name charaters limit should be come between 3-10"];
    //    [Throws addRegx:REGEX_USER_NAME withMsg:@"Enter Valid Input"];
    //    [Bats addRegx:REGEX_USER_NAME withMsg:@"Enter Valid Input"];
    
}

-(IBAction)checkOnOffState:(id)sender
{
    UISegmentedControl* tempSeg=(UISegmentedControl *)sender;
    
    if(tempSeg.selectedSegmentIndex==0)
    {
        [tempSeg setTitle:@"Email" forSegmentAtIndex:1];
        
        [tempSeg setImage:[UIImage imageNamed:@"10-blue-dart"] forSegmentAtIndex:0];
        
        //        [[self.segmentForOTP.subviews objectAtIndex:1] setTintColor: [UIColor whiteColor]];
        //        [[self.segmentForOTP.subviews objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
        
        [self.segmentForOTP setWidth:25 forSegmentAtIndex:0];
        [self.segmentForOTP setWidth:50 forSegmentAtIndex:1];
        
        
        // [tempSeg setImage:[UIImage imageNamed:@"off.png"] forSegmentAtIndex:1];
    }
    else{
        [tempSeg setTitle:@"Phone" forSegmentAtIndex:0];
        
        //     [tempSeg setImage:[UIImage imageNamed:@"on.png"] forSegmentAtIndex:0];
        [tempSeg setImage:[UIImage imageNamed:@"10-blue-dart"] forSegmentAtIndex:1];
        
        //        [[self.segmentForOTP.subviews objectAtIndex:0] setTintColor: [UIColor whiteColor]];
        //        [[self.segmentForOTP.subviews objectAtIndex:1] setBackgroundColor:[UIColor whiteColor]];
        
        [self.segmentForOTP setWidth:25 forSegmentAtIndex:1];
        [self.segmentForOTP setWidth:50 forSegmentAtIndex:0];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [self change:self.user];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
                        
                        
                        NSArray *FNlayerAry = self.firstName.layer.sublayers;
                        CALayer *FNborder  = FNlayerAry[0];
                        CGFloat FNborderWidth = 0.7;
                        FNborder.borderColor = [UIColor whiteColor].CGColor;
                        [FNborder setFrame:CGRectMake(0, (self.firstName.frame.size.height -FNborderWidth), self.firstName.frame.size.width, FNborderWidth)];
                        FNborder.borderWidth = FNborderWidth;
                        self.firstName.layer.masksToBounds = YES;
                        
                        NSArray *LNlayerAry = self.lastName.layer.sublayers;
                        CALayer *LNborder  = LNlayerAry[0];
                        CGFloat LNborderWidth = 0.7;
                        LNborder.borderColor = [UIColor whiteColor].CGColor;
                        [LNborder setFrame:CGRectMake(0, (self.lastName.frame.size.height -LNborderWidth), self.lastName.frame.size.width, LNborderWidth)];
                        LNborder.borderWidth = LNborderWidth;
                        self.lastName.layer.masksToBounds = YES;
                        
                        NSArray *MoblayerAry = self.mobileNumber.layer.sublayers;
                        CALayer *Mobborder  = MoblayerAry[0];
                        CGFloat MobborderWidth = 0.7;
                        Mobborder.borderColor = [UIColor whiteColor].CGColor;
                        [Mobborder setFrame:CGRectMake(0, (self.mobileNumber.frame.size.height -MobborderWidth), self.mobileNumber.frame.size.width, MobborderWidth)];
                        Mobborder.borderWidth = MobborderWidth;
                        self.mobileNumber.layer.masksToBounds = YES;
                        
                    }
                    completion:NULL];
}

-(void)change:(UITextField*)text
{
    
}

- (IBAction)back:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"signOut"];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FirstView"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}


- (IBAction)rightSide:(id)sender
{
    NSLog(@"Clicked..");
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqualToString: @"ACCEPT TERMS"]) {
        email=self.email.text;
        [self sndServer];
    }
}

- (IBAction)createAccount:(id)sender
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
        if(([self.firstName validate] && [self.lastName validate] && [self.email validate]  &&[self.password validate]))
        {
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you have Referral code?" withTitle:@"Referral" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
            popUp.cancelBtn.backgroundColor=[UIColor blueBlack];
            [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
            
            popUp.okay.hidden = YES;
            popUp.inputTextField.hidden = YES;
            popUp.accessibilityHint=@"ReferralCode";
            [popUp show];
            
        }
        else
        {
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

-(void)sndServer
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
    
    NSLog(@"Device Token = %@",deviceToken);
    
    NSDictionary *parameters = @{@"First_Name":self.firstName.text ,@"Last_Name": self.lastName.text,@"Email_ID":self.email.text,@"Password":self.password.text,@"lang":@"ios",@"device_token":deviceToken,@"social_media_email":@"0",@"refferal_code":@"",@"mobile_id":self.mobileNumber.text,@"wifi_ip_address":@"",@"user_profile_pic":@""};
    
    //  NSDictionary *parameters = @{@"First_Name":self.firstName.text ,@"Last_Name": self.lastName.text,@"Email_ID":self.email.text,@"Password":self.password.text,@"lang":@"ios",@"device_token":deviceToken,@"social_media_email":@"0",@"refferal_code":@"",@"mobile_id":self.mobileNumber.text,@"wifi_ip_address":@"",@"user_profile_pic":@"",@"refferal_code":textfield value};
    
    
    NSString *URLString = @"https://hypdra.com/api/api.php?rquest=register";
    
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
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
      {
          if (!error)
          {
              NSLog(@"Register Response:%@",responseObject);
              
              NSString *res = [responseObject objectForKey:@"status"];
              
              if([res isEqualToString:@"Success"])
              {
                  NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                  
                  userId = [responseObject objectForKey:@"User_Id"];
                  
                  // [defaults setValue:userId forKey:@"USER_ID"];
                  
                  [defaults setValue:@"Duration Available" forKey:@"minAvil"];
                  
                  [defaults setValue:@"Space Available" forKey:@"spcAvil"];
                  
                  [defaults synchronize];
                  
                  self.firstName.text = @"";
                  self.lastName.text = @"";
                  self.email.text = @"";
                  self.mobileNumber.text = @"";
                  self.password.text = @"";
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"We've sent you an OTP to verify your email address" withTitle:@"One more step to go" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  popUp.accessibilityHint=@"AcceptTerms";
                  [popUp show];
                  [hud hideAnimated:YES];
                  
              }
              else
              {
                  
                  [hud hideAnimated:YES];
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Email ID already exists" withTitle:@"Invalid Credentials" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor navyBlue];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  
                  // UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Credentials" message:@"Email ID exists" preferredStyle:UIAlertControllerStyleAlert];
                  //
                  //             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                  //
                  //             [alert addAction:okAction];
                  //
                  //             [self presentViewController:alert animated:YES completion:nil];
              }
          }
          else
          {
              NSLog(@"Error: %@", error);
              
              [hud hideAnimated:YES];
              
              CustomPopUp *popUp = [CustomPopUp new];
              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
              popUp.okay.backgroundColor = [UIColor navyBlue];
              popUp.agreeBtn.hidden = YES;
              popUp.cancelBtn.hidden = YES;
              popUp.inputTextField.hidden = YES;
              [popUp show];
              
              //         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not conenct to server" preferredStyle:UIAlertControllerStyleAlert];
              //
              //         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
              //
              //         [alert addAction:okAction];
              //
              //         [self presentViewController:alert animated:YES completion:nil];
              
          }
          
      }]resume];
    
}

/*
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 
 NSLog(@"textFieldShouldReturn");
 
 [textField resignFirstResponder];
 
 
 //    if (textField == self.email)
 //    {
 //        [textField resignFirstResponder];
 //        [self.password becomeFirstResponder];
 //    }
 //    else if (textField == self.password)
 //    {
 //        [textField resignFirstResponder];
 //    }
 return YES;
 }*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSLog(@"textFieldShouldReturn");
    
    if (textField == self.firstName)
    {
        [textField resignFirstResponder];
        [self.lastName becomeFirstResponder];
    }
    else if (textField == self.lastName)
    {
        [textField resignFirstResponder];
        [self.email becomeFirstResponder];
    }
    else if (textField == self.email)
    {
        [textField resignFirstResponder];
        [self.mobileNumber becomeFirstResponder];
    }
    else if (textField == self.mobileNumber)
    {
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    else if (textField == self.password)
    {
        [textField resignFirstResponder];
        [self goToVerificationPage];
    }
    
    return YES;
}

-(void)goToVerificationPage
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
        
        if(([self.firstName validate] || [self.lastName validate] || [self.email validate]  ||[self.password validate]))
        {
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you have Referral code?" withTitle:@"Referral" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
            popUp.cancelBtn.backgroundColor=[UIColor blueBlack];
            [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
            popUp.okay.hidden = YES;
            popUp.inputTextField.hidden = YES;
            popUp.accessibilityHint=@"ReferralCode";
            [popUp show];
            
        }
        else
        {
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
}

//-(void)animateTextField:(UITextField*)textField up:(BOOL)up
//{
//    if (textField == self.password)
//    {
//        const int movementDistance = -130; // tweak as needed
//        const float movementDuration = 0.3f; // tweak as needed
//
//        int movement = (up ? movementDistance : -movementDistance);
//
//        [UIView beginAnimations: @"animateTextField" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: movementDuration];
//        self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
//        [UIView commitAnimations];
//
//    }
//    else if(textField == self.email)
//    {
//        const int movementDistance = -50; // tweak as needed
//        const float movementDuration = 0.3f; // tweak as needed
//
//        int movement = (up ? movementDistance : -movementDistance);
//
//        [UIView beginAnimations: @"animateTextField" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: movementDuration];
//        self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
//        [UIView commitAnimations];
//    }
//}

-(void)submitReferal:(NSString*)referalCode
{
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"We've sent you an OTP to verify your email address" withTitle:@"One more step to go" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.backgroundColor = [UIColor lightGreen];
    popUp.agreeBtn.hidden = YES;
    popUp.cancelBtn.hidden = YES;
    popUp.inputTextField.hidden = YES;
    popUp.accessibilityHint=@"AcceptTerms";
    [popUp show];
}

-(void) okClicked:(CustomPopUp *)alertView
{
    if([alertView.accessibilityHint isEqualToString:@"AcceptTerms"])
    {
        [alertView hide];
        alertView=nil;
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        RegisterOTPViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OTPScreen"];
        vc.Type = @"FirstTime";
        vc.email=email;
        vc.user_ID=userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([alertView.accessibilityHint isEqualToString:@"SubmitReferral"])
    {
        NSString *referCode=[NSString stringWithFormat:@"%lu",alertView.inputTextField.text.length];
        
        if([referCode isEqualToString:@"0"])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.tintColor=[UIColor whiteColor];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"Enter referral code";
            hud.label.textColor=[UIColor colorWithRed:(41/255.0) green:(44/255.0) blue:(101/255.0) alpha:1];
            hud.margin = 10.f;
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                hud.yOffset = 500.f;
            else
                hud.yOffset=230.0f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hideAnimated:YES afterDelay:1];
        }
        else
        {
            email=self.email.text;
            [self sndServer];
            [alertView hide];
            alertView=nil;
        }
    }
    else
    {
        [alertView hide];
        alertView = nil;
    }
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@"ReferralCode"])
    {
        email=self.email.text;
        [self sndServer];
    }
    
    else if([alertView.accessibilityHint isEqualToString:@"AcceptTerms"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        RegisterOTPViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OTPScreen"];
        
        vc.email=email;
        vc.user_ID=userId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    [alertView hide];
    alertView = nil;
    NSLog(@"Cancel");
}

-(void)agreeCLicked:(CustomPopUp *)alertView
{
    if([alertView.accessibilityHint isEqualToString:@"ReferralCode"])
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"" withTitle:@"Referral" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        [popUp.okay setTitle:@"Submit" forState:UIControlStateNormal];
        popUp.cancelBtn.hidden=YES;
        popUp.agreeBtn.hidden = YES;
        popUp.inputTextField.hidden = NO;
        popUp.accessibilityHint=@"SubmitReferral";
        popUp.inputTextField.placeholder=@"Referral Code";
        [popUp show];
    }
    
    [alertView hide];
    alertView = nil;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(textField == _mobileNumber){
        
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            for (int i = 0; i < [string length]; i++) {
                unichar c = [string characterAtIndex:i];
                if (![myCharSet characterIsMember:c]) {
                    return NO;
                }
            }
      
        if(range.length + range.location > textField.text.length){
        return NO;
        }

    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 15;
    }else{
        return YES;
    }
}
@end

