//
//  ForgotPasswordController.m
//  SampleTest
//
//  Created by MacBookPro on 8/18/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "ForgotPasswordController.h"
#import "AFNetworking.h"
#import "DEMORootViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

@interface ForgotPasswordController ()<UITextFieldDelegate,ClickDelegates>{
    MBProgressHUD *hud;
    
}

@end

@implementation ForgotPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.forgotText.delegate = self;
    self.forgotText.tintColor= [UIColor whiteColor];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];//UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.7;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, self.forgotText.frame.size.height - borderWidth, 0, self.forgotText.frame.size.height);
    [self.forgotText.layer addSublayer:border];
    self.forgotText.layer.masksToBounds = YES;
    
    UIColor *color = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    NSString *placeholderText = self.forgotText.placeholder;
    self.forgotText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{ [UIView transitionWithView:self.forgotText
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
    //[self animateTextField:textField up:YES];
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
    // [self animateTextField:textField up:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [UIView transitionWithView:self.forgotText
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        NSArray *layerAry = self.forgotText.layer.sublayers;
                        CALayer *border  = layerAry[0];
                        CGFloat borderWidth = 0.7;
                        border.borderColor = [UIColor whiteColor].CGColor;
                        [border setFrame:CGRectMake(0, (self.forgotText.frame.size.height -borderWidth), self.forgotText.frame.size.width, borderWidth)];
                        border.borderWidth = borderWidth;
                        self.forgotText.layer.masksToBounds = YES;
                    }
                    completion:NULL];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendDataToServer];
    
    return YES;
}

-(void)sendDataToServer
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
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
        if (self.forgotText.text.length == 0)
        {
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter Registered ID" withTitle:@"Invalid ID" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor lightGreen];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            popUp.accessibilityHint=@"Invalid_Email";
            [popUp show];
            /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
             message:@"Enter valid ID"
             delegate:self
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
             [alert show];
             */
            //        UIAlertController * alert=[UIAlertController
            //
            //                                   alertControllerWithTitle:@"Alert" message:@"Enter valid ID"preferredStyle:UIAlertControllerStyleAlert];
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
            
        }
        else
        {
            [self sendServer];
            
        }
    }
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self animateTextField:textField up:YES];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self animateTextField:textField up:NO];
//}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ResetPwd:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
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
        if (self.forgotText.text.length == 0)
        {
           CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter Registered ID" withTitle:@"Invalid ID" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor lightGreen];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            popUp.accessibilityHint=@"Invalid_Email";
            [popUp show];
         /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Enter valid ID"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            */
            //        UIAlertController * alert=[UIAlertController
            //
            //                                   alertControllerWithTitle:@"Alert" message:@"Enter valid ID"preferredStyle:UIAlertControllerStyleAlert];
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
            
        }
        else
        {
            [self sendServer];
            
        }
    }
}

- (IBAction)registerBtn:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
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
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_1" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
}

-(void)sendServer
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
    
    NSLog(@"Login Device Token = %@",deviceToken);
    
    NSDictionary *parameters = @{@"Email_ID":self.forgotText.text , @"lang":@"ios"};
    
    NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=forget_password";
    
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
          
          NSLog(@"ForgotPasswordResponse  = %@",responseObject);
          NSDictionary *dic = responseObject;
          NSLog(@"MESSAGE%@",[dic valueForKey:@"msg"]);
          NSString *result = [NSString stringWithFormat:@"%@", [dic valueForKey:@"result"]];
          
          if (!error)
          {
              if([result isEqualToString:@"1"])
              {
                  [hud hideAnimated:YES];
                  
                  
              /*    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Password Reset!"
                                                                                message:@"Kindly check your Email to reset your password"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                  
                  UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * _Nonnull action)
                                              {
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              }];
                  
                  [alert addAction:yesButton];
                  
                  [self presentViewController:alert animated:YES completion:nil];
                  
                  */
                 CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Kindly check your Email to reset your password" withTitle:@"Password Reset" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.accessibilityHint = @"PasswordReset";
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
              }
              else
              {
                  [hud hideAnimated:YES];
                  //                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset"
                  //                                                                  message:@"Kindly enter valid email."
                  //                                                                 delegate:self cancelButtonTitle:@"OK"
                  //                                                        otherButtonTitles:nil];
                  //
                  //                  [alert show];
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please enter valid email." withTitle:@"Password Reset" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  popUp.accessibilityHint=@"Invalid_Email";
                  [popUp show];
              }
          }
          else
          {
              [hud hideAnimated:YES];
              //              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
              //                                                              message:@"could not connect to server"
              //                                                             delegate:self cancelButtonTitle:@"OK"
              //                                                    otherButtonTitles:nil];
              //
              //              [alert show];
              
              CustomPopUp *popUp = [CustomPopUp new];
              [popUp initAlertwithParent:self withDelegate:self withMsg:@"could not connect to server." withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
              popUp.okay.backgroundColor = [UIColor lightGreen];
              popUp.agreeBtn.hidden = YES;
              popUp.cancelBtn.hidden = YES;
              popUp.inputTextField.hidden = YES;
              [popUp show];
              
              NSLog(@"Error: %@", error);
          }
          
      }]resume];
}
-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"PasswordReset"])
    {
        [alertView hide];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if([alertView.accessibilityHint isEqualToString:@"Invalid_Email"])
    {
        [alertView hide];
    }
    [alertView hide];
    alertView=nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
}

@end

