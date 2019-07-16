//
//  ProfileEditViewController.m
//  DemoExpandable
//
//  Created by MacBookPro on 8/2/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "DEMORootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SwipeBack/SwipeBack.h>
#import "TabBarViewController.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASS @"[A-Za-z0-9]{4,20}"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface ProfileEditViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,ClickDelegates>
{
    NSString *user_id;
    UITapGestureRecognizer *tapRecognizer;
    
    UIImagePickerController *picker1,*imagePickerController;
    
    MBProgressHUD *hud;
}
@end

@implementation ProfileEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setShadow:self.change_profile_superView];
    
    [self setShadow:self.change_pass_superView];
    
    self.scrollView.bounces = false;
    
    //    [self setShadow:self.thirdView];
    
    //    self.userName.userInteractionEnabled = false;
    
    //    self.profileImage.layer.masksToBounds = YES;
    //    self.profileImage.layer.cornerRadius = 28.0;
    //    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    //    self.profileImage.layer.borderWidth = 1.5f;
    //    //    self.profileImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //    //    imageView.layer.shouldRasterize = YES;
    //    self.profileImage.clipsToBounds = YES;
    //
    
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.profileImage.userInteractionEnabled = YES; //disabled by default
    
    
    self.userName.text =  [[NSUserDefaults standardUserDefaults]valueForKey:@"Profilename"];
    
    self.userEmail.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"Email_ID"];
    
    NSString *proPic = [[NSUserDefaults standardUserDefaults]valueForKey:@"ProfilePic"];
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:proPic] placeholderImage:[UIImage imageNamed:@"Person-placeholder"]];
    
    self.profileImage.contentMode = UIViewContentModeScaleToFill;
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    
    [self.profileImage addGestureRecognizer:tapRecognizer];
    
    tapRecognizer.numberOfTapsRequired=1;
    
    self.navigationController.delegate = self;
    self.userCountry.delegate = self;
    self.userNewEmail.delegate = self;
    self.userConfirmEmail.delegate = self;
    self.userCurrentPwd.delegate = self;
    self.userNewPwd.delegate = self;
    self.userConfirmEmail.delegate = self;
    self.userConfirmPwd.delegate = self;
    
    self.userCountry.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userNewEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userConfirmEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userCurrentPwd.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userNewPwd.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userConfirmEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userConfirmPwd.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.userCurrentPwd.secureTextEntry = YES;
    self.userNewPwd.secureTextEntry = YES;
    self.userConfirmPwd.secureTextEntry = YES;
    
    [self setUpPadding:_userNewEmail];
    [self setUpPadding:_userConfirmEmail];
    [self setUpPadding:_userCountry];
    [self setUpPadding:_userCurrentPwd];
    [self setUpPadding:_userNewPwd];
    [self setUpPadding:_userConfirmPwd];

   
    

    [self setupAlerts];
}
-(void)setUpPadding:(UITextField *)txtfield{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, txtfield.frame.size.height)];
    txtfield.leftView = paddingView;
    txtfield.leftViewMode = UITextFieldViewModeAlways;
    txtfield.layer.cornerRadius = 2;
    txtfield.layer.borderWidth = 1.0;
    txtfield.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    UIColor *MobColor = [UIColor lightGrayColor];
    NSString *MobPlaceholderText = txtfield.placeholder;
    txtfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:MobPlaceholderText attributes:@{NSForegroundColorAttributeName: MobColor}];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.profileView.layer setCornerRadius:self.profileImage.frame.size.width/2];
    [self.profileView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.profileView.layer setShadowRadius:2.0f];
    [self.profileView.layer setShadowOffset:CGSizeMake(0, 0.0)];
    [self.profileView.layer setShadowOpacity:0.3f];
    
    
    [self.profileImage.layer setCornerRadius:self.profileImage.frame.size.width/2];
    //[self.proImage.layer setBorderWidth:1];
    //[self.profileImage.layer setBorderColor:[[UIColor colorWithRed:78.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1] CGColor] ];
    [self.profileImage.layer setMasksToBounds:YES];
}
-(void)setupAlerts{
    
    // NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    _userNewEmail.isMandatory =YES;
    
    _userConfirmEmail.isMandatory = YES;
    _userCurrentPwd.isMandatory = YES;
    _userNewPwd.isMandatory = YES;
    _userConfirmPwd.isMandatory = YES;
    [_userNewEmail updateLengthValidationMsg:@"enter valid email"];
    [_userConfirmEmail updateLengthValidationMsg:@"enter valid email"];
    
    [_userCurrentPwd updateLengthValidationMsg:@"Password charaters limit should be come between 4-20"];
    [_userNewPwd updateLengthValidationMsg:@"Password charaters limit should be come between 4-20"];
    [_userConfirmPwd updateLengthValidationMsg:@"Password charaters limit should be come between 4-20"];
    
    [_userNewEmail addRegx:REGEX_EMAIL withMsg:@"enter valid email"];
    [_userConfirmEmail addRegx:REGEX_EMAIL withMsg:@"enter valid email"];
    [_userCurrentPwd addRegx:REGEX_PASS withMsg:@"Password charaters limit should be come between 4-20"];
    [_userNewPwd addRegx:REGEX_PASS withMsg:@"Password charaters limit should be come between 4-20"];
    [_userConfirmPwd addRegx:REGEX_PASS withMsg:@"Password charaters limit should be come between 4-20"];
   
}

-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender
{
    
//    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
//                                                                  message:@"Do you want to change ?"
//                                                           preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction * action)
//                                {
//
//                                    imagePickerController = [[UIImagePickerController alloc] init];
//                                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                                    imagePickerController.delegate = self;
//                                    [self presentViewController:imagePickerController animated:YES completion:nil];
//
//                                }];
//
//    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction * action)
//                               {
//
//                               }];
//
//    [alert addAction:yesButton];
//    [alert addAction:noButton];
//
//    [self presentViewController:alert animated:YES completion:nil];
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to reset" withTitle:@"Reset" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.accessibilityHint = @"ChangeProfileImage";
    popUp.okay.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //  self.profileImage.image = image;
    [self updateProfilePic:image];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
 - (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
 {
 
 if([navigationController.viewControllers containsObject:self])
 {
 NSLog(@"push");
 }
 else
 {
 NSLog(@"pop");
 
 
 if([self.userCurrentPwd isFirstResponder])
 {
 //            [self.userCurrentPwd resignFirstResponder];
 self.view.frame = CGRectOffset(self.view.frame, 0, -140);
 
 NSLog(@"pop1");
 
 }
 else if([self.userNewPwd isFirstResponder])
 {
 //            [self.userNewPwd resignFirstResponder];
 self.view.frame = CGRectOffset(self.view.frame, 0, 140);
 
 NSLog(@"pop2");
 
 
 }
 else if([self.userConfirmPwd isFirstResponder])
 {
 //            [self.userConfirmPwd resignFirstResponder];
 self.view.frame = CGRectOffset(self.view.frame, 0, 140);
 
 NSLog(@"pop3");
 
 }
 
 }
 
 
 
 }*/

-(IBAction)gotoLibrary:(id)sender
{
    picker1 = [[UIImagePickerController alloc]init];
    //picker.modalPresentationStyle=UIModalPresentationCurrentContext;
    picker1.delegate=self;
    
    picker1.allowsEditing = YES;
    
    [picker1 setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:picker1 animated:YES completion:nil];
}

/*
 -(BOOL)returnInternetConnectionStatus
 {
 if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
 {
 //connection unavailable
 }
 else
 {
 //connection available
 }
 }*/

-(void)setShadow:(UIView*)demoView
{
    
    demoView.layer.cornerRadius = 10;
//    demoView.layer.shadowColor = [UIColor blackColor].CGColor;
//    demoView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    demoView.layer.shadowOpacity = 0.8f;
    
    NSArray *subViews = demoView.subviews;
    UIView *subView = subViews[0];
    subView.layer.cornerRadius = 10;
    [subView.layer setMasksToBounds:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.swipeBackEnabled = NO;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


- (void)didReceiveMemoryWarning
{
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

- (IBAction)updateProfile:(id)sender
{
    
    if([self.userNewEmail validate] && [self.userConfirmEmail validate])
    {
        if ([self.userNewEmail.text isEqualToString:self.userConfirmEmail.text])
        {
            /*        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             manager.requestSerializer = [AFJSONRequestSerializer serializer];
             
             [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
             [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
             [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
             manager.securityPolicy.allowInvalidCertificates = YES;
             
             //            NSDictionary *params = @{@"User_Name":@"Ragu",@"Email_ID": self.email.text,@"Password":self.password.text,};
             
             NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
             
             NSLog(@"Device Token = %@",deviceToken);
             
             NSDictionary *params = @{@"User_id":user_id,@"edit_email_id": self.userConfirmEmail.text,@"country":self.userCountry.text,@"edit_user_profile_pic":@"",@"lang":@"iOS"};
             
             [manager POST:@"https://www.hypdra.com/api/api.php?rquest=edit_user_details" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
             {
             NSLog(@"Login Json Response:%@",responseObject);
             }
             failure:^(NSURLSessionTask *operation, NSError *error)
             {
             NSLog(@"Error: %@", error);
             }];*/
            
            
            [self sendServer];
            
        }
        else
        {
            //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Email not match" preferredStyle:UIAlertControllerStyleAlert];
            //
            //            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            //
            //            [alertController addAction:ok];
            //
            //            [self presentViewController:alertController animated:YES completion:nil];
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Invalid mail Id" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor navyBlue];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
        }
    }
    else
    {
        
        if([self.userCurrentPwd isFirstResponder])
        {
            [self.userCurrentPwd resignFirstResponder];
        }
        else if([self.userNewPwd isFirstResponder])
        {
            [self.userNewPwd resignFirstResponder];
        }
        else if([self.userConfirmPwd isFirstResponder])
        {
            [self.userConfirmPwd resignFirstResponder];
        }
        else
        {
            
            //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid data" preferredStyle:UIAlertControllerStyleAlert];
            //
            //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            //
            //        [alertController addAction:ok];
            //
            //        [self presentViewController:alertController animated:YES completion:nil];
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Invalid data" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor navyBlue];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
        }
    }
    
}

- (IBAction)changePassword:(id)sender
{
    
    if([self.userCurrentPwd validate] && [self.userNewPwd validate] && [self.userConfirmPwd validate])
    {
        if ([self.userNewPwd.text isEqualToString:self.userConfirmPwd.text])
        {
            /*            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
             manager.responseSerializer = [AFJSONResponseSerializer serializer];
             manager.requestSerializer = [AFJSONRequestSerializer serializer];
             
             [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
             [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
             [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
             manager.securityPolicy.allowInvalidCertificates = YES;
             
             //            NSDictionary *params = @{@"User_Name":@"Ragu",@"Email_ID": self.email.text,@"Password":self.password.text,};
             
             NSString *deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceTokenString"];
             
             NSLog(@"Device Token = %@",deviceToken);
             
             NSDictionary *params = @{@"User_id":user_id,@"current_password": self.userCurrentPwd.text,@"new_password":self.userNewPwd.text,@"lang":@"iOS"};
             
             
             [manager POST:@"https://www.hypdra.com/api/api.php?rquest=change_password" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
             {
             NSLog(@"Login Json Response:%@",responseObject);
             }
             failure:^(NSURLSessionTask *operation, NSError *error)
             {
             NSLog(@"Error: %@", error);
             }];*/
            
            
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //    hud.mode = MBProgressHUDModeDeterminate;
            //    hud.progress = progress;
            
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
            
            [_currentWindow addSubview:_BlurView];
            
            NSDictionary *params = @{@"User_id":user_id,@"current_password": self.userCurrentPwd.text,@"new_password":self.userNewPwd.text,@"lang":@"iOS"};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager POST:@"https://www.hypdra.com/api/api.php?rquest=change_password" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 NSLog(@"Change Password Response: %@", responseObject);
                 
                 [hud hideAnimated:YES];
                 
                 [_BlurView removeFromSuperview];
                 
                 NSDictionary *dct = responseObject;
                 
                 NSString *str = [dct objectForKey:@"status"];
                 
                 if ([str isEqualToString:@"True"])
                 {
                     //                     UIAlertController * alert = [UIAlertController
                     //                    alertControllerWithTitle:@"Success"
                     //                    message:@"Your profile has been updated"
                     //            preferredStyle:UIAlertControllerStyleAlert];
                     //
                     //                     UIAlertAction* yesButton = [UIAlertAction
                     //                    actionWithTitle:@"Ok"
                     //                    style:UIAlertActionStyleDefault
                     //                    handler:^(UIAlertAction * action)
                     //                     {
                     //                         self.userCurrentPwd.text = @"";
                     //                         self.userNewPwd.text = @"";
                     //                         self.userConfirmPwd.text = @"";
                     //
                     //                     }];
                     //
                     //                     [alert addAction:yesButton];
                     //
                     //                     [self presentViewController:alert animated:YES completion:nil];
                     
                     CustomPopUp *popUp = [CustomPopUp new];
                     [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your profile has been updated" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                     popUp.okay.backgroundColor = [UIColor lightGreen];
                     popUp.accessibilityHint = @"ProfileUpdated";
                     popUp.agreeBtn.hidden = YES;
                     popUp.cancelBtn.hidden = YES;
                     popUp.inputTextField.hidden = YES;
                     [popUp show];
                     
                 }
                 else
                 {
                     //                     UIAlertController * alert = [UIAlertController
                     //                     alertControllerWithTitle:@"Error"
                     //                     message:@"Password is Mismatch"
                     //                 preferredStyle:UIAlertControllerStyleAlert];
                     //
                     //                     UIAlertAction* yesButton = [UIAlertAction
                     //                     actionWithTitle:@"Ok"
                     //                     style:UIAlertActionStyleDefault
                     //                     handler:^(UIAlertAction * action)
                     //                     {
                     //                         self.userCurrentPwd.text = @"";
                     //                         self.userNewPwd.text = @"";
                     //                         self.userConfirmPwd.text = @"";
                     //
                     //                     }];
                     //
                     //                     [alert addAction:yesButton];
                     //
                     //                     [self presentViewController:alert animated:YES completion:nil];
                     
                     CustomPopUp *popUp = [CustomPopUp new];
                     [popUp initAlertwithParent:self withDelegate:self withMsg:@"Invalid Password" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                     popUp.okay.backgroundColor = [UIColor navyBlue];
                     popUp.accessibilityHint = @"PasswordMismatch";
                     popUp.agreeBtn.hidden = YES;
                     popUp.cancelBtn.hidden = YES;
                     popUp.inputTextField.hidden = YES;
                     [popUp show];
                 }
             }
             
                  failure:^(NSURLSessionTask *operation, NSError *error)
             {
                 
                 [hud hideAnimated:YES];
                 
                 [_BlurView removeFromSuperview];
                 
                 NSLog(@"Change Password Error: %@", error);
                 
                 //                 UIAlertController * alert = [UIAlertController
                 //                  alertControllerWithTitle:@"Error"
                 //                  message:@"Could not connect to server"
                 //              preferredStyle:UIAlertControllerStyleAlert];
                 //
                 //                 UIAlertAction* yesButton = [UIAlertAction
                 //                      actionWithTitle:@"Ok"
                 //                     style:UIAlertActionStyleDefault
                 //                     handler:^(UIAlertAction * action)
                 //                 {
                 //                      self.userCurrentPwd.text = @"";
                 //                      self.userNewPwd.text = @"";
                 //                      self.userConfirmPwd.text = @"";
                 //
                 //                 }];
                 //
                 //                 [alert addAction:yesButton];
                 //
                 //                 [self presentViewController:alert animated:YES completion:nil];
                 
                 CustomPopUp *popUp = [CustomPopUp new];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                 popUp.okay.backgroundColor = [UIColor navyBlue];
                 popUp.accessibilityHint = @"ServerNotConnected";
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
                 
             }];
            
        }
        else
        {
            //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password doesn't match" preferredStyle:UIAlertControllerStyleAlert];
            //
            //            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            //
            //            [alertController addAction:ok];
            //
            //            [self presentViewController:alertController animated:YES completion:nil];
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Password doesn't match" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor navyBlue];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
        }
    }
    else
    {
        if([self.userCurrentPwd hasText])
        {
            [self.userCurrentPwd resignFirstResponder];
        }
        else if([self.userNewPwd hasText])
        {
            [self.userNewPwd resignFirstResponder];
        }
        else if([self.userConfirmPwd hasText])
        {
            [self.userConfirmPwd resignFirstResponder];
        }
        
        
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid data" preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        //        [alertController addAction:ok];
        //
        //        [self presentViewController:alertController animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Invalid data" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
}

- (IBAction)done:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)updateProfilePic:(UIImage *)image
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    hud.mode = MBProgressHUDModeDeterminate;
    //    hud.progress = progress;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [_currentWindow addSubview:_BlurView];
    
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=edit_user_profile_picture";
    
    NSData *data = UIImagePNGRepresentation(image);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        
                                        [formData appendPartWithFileData:data name:@"edit_user_profile_pic" fileName:@"img.png" mimeType:@"image/jpeg"];
                                        
                                        [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                        
                                        [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_id"];
                                    } error:nil];
    
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
                                         //Update the progress view
                                         //                          [progressView setProgress:uploadProgress.fractionCompleted];
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Change Profile Error: %@", error);
                          
                          [hud hideAnimated:YES];
                          
                          [_BlurView removeFromSuperview];
                          
                          
                          //              UIAlertController * alert=[UIAlertController
                          //
                          //              alertControllerWithTitle:@"Alert" message:@"Error, Tryagain..!"preferredStyle:UIAlertControllerStyleAlert];
                          //
                          //              UIAlertAction* yesButton = [UIAlertAction
                          //                  actionWithTitle:@"Ok"
                          //                style:UIAlertActionStyleDefault
                          //                handler:nil];
                          //
                          //              [alert addAction:yesButton];
                          //
                          //              [self presentViewController:alert animated:YES completion:nil];
                          
                          CustomPopUp *popUp = [CustomPopUp new];
                          [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try again..!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                          popUp.okay.backgroundColor = [UIColor navyBlue];
                          popUp.agreeBtn.hidden = YES;
                          popUp.cancelBtn.hidden = YES;
                          popUp.inputTextField.hidden = YES;
                          [popUp show];
                          
                      }
                      else
                      {
                          
                          [hud hideAnimated:YES];
                          
                          [_BlurView removeFromSuperview];
                          
                          NSMutableDictionary *json=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"response for profile:%@",json);
                          
                          NSString *status = [json objectForKey:@"status"];
                          
                          if ([status isEqualToString:@"True"])
                          {
                              
                              NSLog(@"Success");
                              
                              NSArray *resArray1 = [json objectForKey:@"EditUserDetails"];
                              
                              NSDictionary *stsDict = [resArray1 objectAtIndex:0];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[stsDict objectForKey:@"Profile_Pic_Path"] forKey:@"ProfilePic"];
                              [[NSUserDefaults standardUserDefaults]synchronize];
                              
                              //                UIAlertController * alert = [UIAlertController
                              //                alertControllerWithTitle:@"Success"
                              //                message:@"Your profile has been updated"
                              //                preferredStyle:UIAlertControllerStyleAlert];
                              //
                              //              UIAlertAction* yesButton = [UIAlertAction
                              //              actionWithTitle:@"Ok"
                              //              style:UIAlertActionStyleDefault
                              //              handler:^(UIAlertAction * action)
                              //              {
                              //                  self.profileImage.image=image;
                              //              }];
                              //
                              //
                              //              [alert addAction:yesButton];
                              //
                              //              [self presentViewController:alert animated:YES completion:nil];
                              
                              CustomPopUp *popUp = [CustomPopUp new];
                              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your profile has been updated" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                              popUp.okay.backgroundColor = [UIColor lightGreen];
                              
                              popUp.agreeBtn.hidden = YES;
                              popUp.cancelBtn.hidden = YES;
                              popUp.inputTextField.hidden = YES;
                              [popUp show];
                              self.profileImage.image=image;
                          }
                          else
                          {
                              
                              //                  UIAlertController * alert=[UIAlertController
                              //                 alertControllerWithTitle:@"Alert" message:@"Error, Tryagain..!"preferredStyle:UIAlertControllerStyleAlert];
                              //
                              //                  UIAlertAction* yesButton = [UIAlertAction
                              //                      actionWithTitle:@"Ok"
                              //                      style:UIAlertActionStyleDefault
                              //                      handler:nil];
                              //
                              //                  [alert addAction:yesButton];
                              //
                              //                  [self presentViewController:alert animated:YES completion:nil];
                              
                              CustomPopUp *popUp = [CustomPopUp new];
                              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try again..!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                              popUp.okay.backgroundColor = [UIColor navyBlue];
                              
                              popUp.agreeBtn.hidden = YES;
                              popUp.cancelBtn.hidden = YES;
                              popUp.inputTextField.hidden = YES;
                              [popUp show];
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
    
}


-(void)sendServer
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    hud.mode = MBProgressHUDModeDeterminate;
    //    hud.progress = progress;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [_currentWindow addSubview:_BlurView];
    
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=edit_user_details";
    
    NSData *data = UIImagePNGRepresentation(self.profileImage.image);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        
                                        //  [formData appendPartWithFileData:data name:@"edit_user_profile_pic" fileName:@"img.png" mimeType:@"image/jpeg"];
                                        
                                        [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                        
                                        [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_id"];
                                        
                                        [formData appendPartWithFormData:[self.userNewEmail.text dataUsingEncoding:NSUTF8StringEncoding] name:@"edit_email_id"];
                                        
                                        [formData appendPartWithFormData:[self.userCountry.text dataUsingEncoding:NSUTF8StringEncoding] name:@"country"];
                                        
                                    } error:nil];
    
    
    //    request.timeoutInterval= 20; // add paramerets to NSMutableURLRequest
    
    //        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
    //        [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //
    //        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
    
    
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
                                         //Update the progress view
                                         //                          [progressView setProgress:uploadProgress.fractionCompleted];
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Change Profile Error: %@", error);
                          
                          [hud hideAnimated:YES];
                          
                          [_BlurView removeFromSuperview];
                          
                          
                          self.userCountry.text = @"";
                          self.userNewEmail.text = @"";
                          self.userConfirmEmail.text = @"";
                          
                          
                          //                          UIAlertController * alert=[UIAlertController
                          //
                          //                                                     alertControllerWithTitle:@"Alert" message:@"Error, Tryagain..!"preferredStyle:UIAlertControllerStyleAlert];
                          //
                          //                          UIAlertAction* yesButton = [UIAlertAction
                          //                                                      actionWithTitle:@"Ok"
                          //                                                      style:UIAlertActionStyleDefault
                          //                                                      handler:nil];
                          //
                          //                          [alert addAction:yesButton];
                          //
                          //                          [self presentViewController:alert animated:YES completion:nil];
                          
                          CustomPopUp *popUp = [CustomPopUp new];
                          [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try again..!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                          popUp.okay.backgroundColor = [UIColor navyBlue];
                          
                          popUp.agreeBtn.hidden = YES;
                          popUp.cancelBtn.hidden = YES;
                          popUp.inputTextField.hidden = YES;
                          [popUp show];
                          
                      }
                      else
                      {
                          
                          [hud hideAnimated:YES];
                          
                          [_BlurView removeFromSuperview];
                          
                          NSMutableDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"response for profile:%@",responsseObject);
                          
                          NSArray *resArray = [responsseObject objectForKey:@"Response_array"];
                          
                          NSDictionary *stsDict = [resArray objectAtIndex:0];
                          
                          NSString *status = [stsDict objectForKey:@"status"];
                          
                          if ([status isEqualToString:@"True"])
                          {
                              
                              NSLog(@"Success");
                              
                              NSArray *resArray = [responsseObject objectForKey:@"EditUserDetails"];
                              
                              NSDictionary *stsDict = [resArray objectAtIndex:0];
                              
                              [[NSUserDefaults standardUserDefaults]setValue:[stsDict objectForKey:@"Email_ID"] forKey:@"Email_ID"];
                              
                              //   [[NSUserDefaults standardUserDefaults]setValue:[stsDict objectForKey:@"Profile_Pic_Path"] forKey:@"ProfilePic"];
                              [[NSUserDefaults standardUserDefaults]synchronize];
                              
                              //                              UIAlertController * alert = [UIAlertController
                              //                                                           alertControllerWithTitle:@"Success"
                              //                                                           message:@"Your profile has been updated"
                              //                                                           preferredStyle:UIAlertControllerStyleAlert];
                              //
                              //                              UIAlertAction* yesButton = [UIAlertAction
                              //                                                          actionWithTitle:@"Ok"
                              //                                                          style:UIAlertActionStyleDefault
                              //                                                          handler:^(UIAlertAction * action)
                              //                                                          {
                              //                                                              self.userCountry.text = @"";
                              //                                                              self.userNewEmail.text = @"";
                              //                                                              self.userConfirmEmail.text = @"";
                              //                                                          }];
                              //
                              //                              [alert addAction:yesButton];
                              //
                              //                              [self presentViewController:alert animated:YES completion:nil];
                              
                              
                              CustomPopUp *popUp = [CustomPopUp new];
                              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your profile has been updated" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                              popUp.okay.backgroundColor = [UIColor lightGreen];
                              popUp.accessibilityHint = @"ProfileDataUpdated";
                              popUp.agreeBtn.hidden = YES;
                              popUp.cancelBtn.hidden = YES;
                              popUp.inputTextField.hidden = YES;
                              [popUp show];
                          }
                          else
                          {
                              
                              self.userCountry.text = @"";
                              self.userNewEmail.text = @"";
                              self.userConfirmEmail.text = @"";
                              
                              //                              UIAlertController * alert=[UIAlertController
                              //
                              //                                                         alertControllerWithTitle:@"Alert" message:@"Email Exists ..!"preferredStyle:UIAlertControllerStyleAlert];
                              //
                              //                              UIAlertAction* yesButton = [UIAlertAction
                              //                                                          actionWithTitle:@"Ok"
                              //                                                          style:UIAlertActionStyleDefault
                              //                                                          handler:nil];
                              //
                              //                              [alert addAction:yesButton];
                              //
                              //                              [self presentViewController:alert animated:YES completion:nil];
                              
                              CustomPopUp *popUp = [CustomPopUp new];
                              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Email Exists ..!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                              popUp.okay.backgroundColor = [UIColor navyBlue];
                              
                              popUp.agreeBtn.hidden = YES;
                              popUp.cancelBtn.hidden = YES;
                              popUp.inputTextField.hidden = YES;
                              [popUp show];}
                          
                      }
                  }];
    
    [uploadTask resume];
    
}
/*
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 NSLog(@"textFieldShouldReturn");
 
 [textField resignFirstResponder];
 
 return YES;
 }*/


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSString *proPic = [[NSUserDefaults standardUserDefaults]valueForKey:@"ProfilePic"];
    
    [[SDImageCache sharedImageCache] removeImageForKey:proPic fromDisk:YES];
    
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    
    if(self.userCurrentPwd == textField)
    {
        const int movementDistance = -130; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
        [UIView commitAnimations];
        
    }
    else if(textField == self.userNewPwd)
    {
        const int movementDistance = -130; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
        [UIView commitAnimations];
        
    }
    else if(textField == self.userConfirmPwd)
    {
        const int movementDistance = -130; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
        [UIView commitAnimations];
        
    }
    
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"ServerNotConnected"]){
        
        self.userCurrentPwd.text = @"";
        self.userNewPwd.text = @"";
        self.userConfirmPwd.text = @"";
    }else if([alertView.accessibilityHint isEqualToString:@"ProfileUpdated"]){
        self.userCurrentPwd.text = @"";
        self.userNewPwd.text = @"";
        self.userConfirmPwd.text = @"";
    }else if([alertView.accessibilityHint isEqualToString:@"PasswordMismatch"]){
        self.userCurrentPwd.text = @"";
        self.userNewPwd.text = @"";
        self.userConfirmPwd.text = @"";
    }else if([alertView.accessibilityHint isEqualToString:@"ProfileDataUpdated"]){
        self.userCountry.text = @"";
        self.userNewEmail.text = @"";
        self.userConfirmEmail.text = @"";
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
    if([alertView.accessibilityHint isEqualToString:@"ChangeProfileImage"]){
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    [alertView hide];
    alertView = nil;
}


- (IBAction)profile_pic_edit_btn:(id)sender {
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to reset" withTitle:@"Reset" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.accessibilityHint = @"ChangeProfileImage";
    popUp.okay.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
}
@end
