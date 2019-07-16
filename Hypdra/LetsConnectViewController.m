//
//  LetsConnectViewController.m
//  Montage
//
//  Created by MacBookPro on 7/7/17.
//  Copyright © 2017 sssn. All rights reserved.


#import "LetsConnectViewController.h"
#import "DEMORootViewController.h"
#import "AFNetworking.h"
#import "UIColor+Utils.h"
#import "CustomPopUp.h"

@interface LetsConnectViewController ()<UITextFieldDelegate,ClickDelegates>

@end

@implementation LetsConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"hoshiTFColor" object:nil];
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.7;
    border.borderColor = [UIColor navyBlue].CGColor;
    border.frame = CGRectMake(0, self.email.frame.size.height - borderWidth, 0, self.email.frame.size.height);
    [self.email.layer addSublayer:border];
    self.email.layer.masksToBounds = YES;
    
    //    UIColor *color = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    //    NSString *placeholderText = self.email.placeholder;
    //    self.email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
    
    CALayer *PwdBorder  =  [CALayer layer];
    CGFloat PassBorderWidth = 0.2;
    PwdBorder.borderColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4].CGColor;
    border.frame = CGRectMake(0, self.message.frame.size.height - borderWidth, 0, self.message.frame.size.height);
    PwdBorder.borderWidth = PassBorderWidth;
    [self.message.layer addSublayer:PwdBorder];
    self.message.layer.masksToBounds = YES;
    
    //    UIColor *Pwdcolor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    //    NSString *PwdplaceholderText = self.message.placeholder;
    //    self.message.attributedPlaceholder = [[NSAttributedString alloc] initWithString:PwdplaceholderText attributes:@{NSForegroundColorAttributeName: Pwdcolor}];
    
    
    CALayer *FNBorder  =  [CALayer layer];
    CGFloat FNBorderWidth = 0.2;
    FNBorder.borderColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4].CGColor;
    border.frame = CGRectMake(0, self.firstName.frame.size.height - borderWidth, 0, self.firstName.frame.size.height);
    FNBorder.borderWidth = FNBorderWidth;
    [self.firstName.layer addSublayer:FNBorder];
    self.firstName.layer.masksToBounds = YES;
    
    //    UIColor *FNcolor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    //    NSString *FNplaceholderText = self.firstName.placeholder;
    //    self.firstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:FNplaceholderText attributes:@{NSForegroundColorAttributeName: FNcolor}];
    
    
    CALayer *LNBorder  =  [CALayer layer];
    CGFloat LNBorderWidth = 0.2;
    LNBorder.borderColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4].CGColor;
    LNBorder.frame = CGRectMake(0, self.lastName.frame.size.height - borderWidth, 0, self.lastName.frame.size.height);
    LNBorder.borderWidth = LNBorderWidth;
    [self.lastName.layer addSublayer:LNBorder];
    self.lastName.layer.masksToBounds = YES;
    
    //    UIColor *LNcolor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
    //    NSString *LNplaceholderText = self.lastName.placeholder;
    //    self.lastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LNplaceholderText attributes:@{NSForegroundColorAttributeName: LNcolor}];
    
    CALayer *MobileBorder  =  [CALayer layer];
    CGFloat MobileBorderWidth = 0.2;
    MobileBorder.borderColor = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4].CGColor;
    MobileBorder.frame = CGRectMake(0, self.mobileNo.frame.size.height - MobileBorderWidth, 0, self.mobileNo.frame.size.height);
    MobileBorder.borderWidth = MobileBorderWidth;
    [self.mobileNo.layer addSublayer:MobileBorder];
    self.mobileNo.layer.masksToBounds = YES;
    
    [self setUpPadding:self.firstName];
    [self setUpPadding:self.lastName];
    [self setUpPadding:self.email];
    [self setUpPadding:self.mobileNo];
    [self setUpPadding:self.message];

}
-(void)setUpPadding:(UITextField *)txtfield{
    
    UIColor *MobColor = [UIColor darkGrayColor];
    NSString *MobPlaceholderText = txtfield.placeholder;
    txtfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:MobPlaceholderText attributes:@{NSForegroundColorAttributeName: MobColor}];
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
                        CGFloat borderWidth = 0.9;
                        border.borderColor = [UIColor navyBlue].CGColor;
                        [border setFrame:CGRectMake(0, (self.email.frame.size.height -borderWidth), self.email.frame.size.width, borderWidth)];
                        border.borderWidth = borderWidth;
                        self.email.layer.masksToBounds = YES;
                        
                        
                        NSArray *PasslayerAry = self.message.layer.sublayers;
                        CALayer *PwdBorder  = PasslayerAry[0];
                        CGFloat PassBorderWidth = 0.9;
                        PwdBorder.borderColor = [UIColor navyBlue].CGColor;
                        [PwdBorder setFrame:CGRectMake(0, self.message.frame.size.height - borderWidth, self.message.frame.size.width, self.message.frame.size.height)];
                        PwdBorder.borderWidth = PassBorderWidth;
                        self.message.layer.masksToBounds = YES;
                        
                        
                        NSArray *FNlayerAry = self.firstName.layer.sublayers;
                        CALayer *FNborder  = FNlayerAry[0];
                        CGFloat FNborderWidth = 0.9;
                        FNborder.borderColor = [UIColor navyBlue].CGColor;
                        [FNborder setFrame:CGRectMake(0, (self.firstName.frame.size.height -FNborderWidth), self.firstName.frame.size.width, FNborderWidth)];
                        FNborder.borderWidth = FNborderWidth;
                        self.firstName.layer.masksToBounds = YES;
                        
                        NSArray *LNlayerAry = self.lastName.layer.sublayers;
                        CALayer *LNborder  = LNlayerAry[0];
                        CGFloat LNborderWidth = 0.9;
                        LNborder.borderColor = [UIColor navyBlue].CGColor;
                        [LNborder setFrame:CGRectMake(0, (self.lastName.frame.size.height -LNborderWidth), self.lastName.frame.size.width, LNborderWidth)];
                        LNborder.borderWidth = LNborderWidth;
                        self.lastName.layer.masksToBounds = YES;
                        
                        NSArray *MoblayerAry = self.mobileNo.layer.sublayers;
                        CALayer *Mobborder  = MoblayerAry[0];
                        CGFloat MobborderWidth = 0.9;
                        Mobborder.borderColor = [UIColor navyBlue].CGColor;
                        [Mobborder setFrame:CGRectMake(0, (self.mobileNo.frame.size.height -MobborderWidth), self.mobileNo.frame.size.width, MobborderWidth)];
                        Mobborder.borderWidth = MobborderWidth;
                        self.mobileNo.layer.masksToBounds = YES;
                        
                    }
                    completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)submit:(id)sender
{
    @try
    {
        
        NSDictionary *parameters =@{@"First_Name":self.firstName.text,@"Last_Name":self.lastName.text,@"EmailID":self.email.text,@"MobileNum":self.mobileNo.text,@"Message":self.message.text};
        
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=SupportURL";
        
        NSError *error;      // Initialize NSError
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  
              }
              else
              {
                  NSLog(@"Error123: %@, %@, %@", error, response,  responseObject);
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor navyBlue];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
              }
          }]resume];
    }@catch(NSException *exception)
    {
        
    }
}

- (IBAction)back:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
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
        [self.mobileNo becomeFirstResponder];
    }
    else if (textField == self.mobileNo)
    {
        [textField resignFirstResponder];
        [self.message becomeFirstResponder];
    }
    //    else if (textField == self.password)
    //    {
    //        [textField resignFirstResponder];
    //        [self goToVerificationPage];
    //    }
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{ [UIView transitionWithView:textField
                    duration:0.4
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                      NSArray *layerAry = textField.layer.sublayers;
                      CALayer *border  = layerAry[0];
                      CGFloat borderWidth = 2.0;
                      border.borderColor = [UIColor navyBlue].CGColor;
                      [border setFrame:CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height)];
                      border.borderWidth = borderWidth;
                      
                      textField.layer.masksToBounds = YES;
                      
                      
                      
                      //                      UIColor *color = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.0];
                      //                      NSString *placeholderText = textField.placeholder;
                      //                      textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
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
                        CGFloat borderWidth = 0.9;
                        border.borderColor = [UIColor navyBlue].CGColor;
                        [border setFrame:CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height)];
                        border.borderWidth = borderWidth;
                        
                        textField.layer.masksToBounds = YES;
                        
                        //                        UIColor *color = [UIColor colorWithRed:1 green:1 blue:0.8 alpha:0.4];
                        //                        NSString *placeholderText = textField.placeholder;
                        //                        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
                    }
                    completion:NULL];
    // [self animateTextField:textField up:NO];
}

- (IBAction)menu:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:5 forKey:@"SelectedIndex"];
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    [self.frostedViewController presentMenuViewController];
}

-(void) okClicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView=nil;
    
}

-(void) cancelClicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}

@end
