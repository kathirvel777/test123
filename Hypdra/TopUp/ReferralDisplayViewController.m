//
//  ReferralDisplayViewController.m
//  SampleTest
//
//  Created by MacBookPro on 8/17/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "ReferralDisplayViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface ReferralDisplayViewController ()<ClickDelegates>
{
    MBProgressHUD *hud;
    NSString *user_id;
    NSArray *ary;
    int i;
}

@end

@implementation ReferralDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
//    self.navigationController.navigationBar.shadowImage = [UIImage new];//UIImageNamed:@"transparent.png"
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];

    [self setShadow:self.rView];
    
    self.rView.hidden=true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setShadow:(UIView*)demoView
{
    demoView.layer.shadowColor = [UIColor blackColor].CGColor;
    demoView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    demoView.layer.shadowOpacity = 0.5f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    [self getSerevr];
}

- (void)getSerevr
{
    i=0;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeDeterminate;
    //    hud.progress = progress;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=ViewRefferalDetails"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Billing Response:%@",responseObject);
         
         NSArray *referralValue = [responseObject objectForKey:@"ViewRefferalDetails"];

         if([[referralValue valueForKey:@"status"] isEqualToString:@"Success"])
         {
        
            ary=[referralValue valueForKey:@"users"];
         
            self.referredEmail.text=[[ary objectAtIndex:i]valueForKey:@"receiver_email_id"];
            self.update.text=[[ary objectAtIndex:i]valueForKey:@"created"];
            self.earned.text=[[ary objectAtIndex:i]valueForKey:@"invite_for"];
            self.referredStatus.text=[[ary objectAtIndex:i]valueForKey:@"status"];
            self.validTill.text=[[ary objectAtIndex:i]valueForKey:@"valid_till"];
            self.rView.hidden=false;
             
//         for (NSDictionary *dct in ary)
//         {
//
//         }
         }
         else
         {
//             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"No Referral Details Found" preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
//
//             [alertController addAction:ok];
//
//             [self presentViewController:alertController animated:YES completion:nil];
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"No Referral Details Found" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.accessibilityHint=@"Referral";

             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
         }
         
         [hud hideAnimated:YES];
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Billing Error: %@", error);
         
         [hud hideAnimated:YES];
         
//         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not connect to sever" preferredStyle:UIAlertControllerStyleAlert];
//
//         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
//
//         [alertController addAction:ok];
//
//         [self presentViewController:alertController animated:YES completion:nil];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to sever" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.accessibilityHint=@"Referral";
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
     }];
    
    
    /*  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     
     [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
     
     [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
     
     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     
     manager.securityPolicy.allowInvalidCertificates = YES;
     
     //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
     
     //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=PaymentHistory";
     
     NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=PaymentHistory";
     
     NSDictionary *params = @{@"User_ID":@"4",@"lang":@"iOS"};
     
     [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
     NSLog(@"Json Payment Response:%@",responseObject);
     
     NSArray *ary = [responseObject objectForKey:@"PaymentHistory"];
     
     for (NSDictionary *dct in ary)
     {
     [amunt addObject:[dct objectForKey:@"Amount"]];
     [dat addObject:[dct objectForKey:@"Date"]];
     [pymtType addObject:[dct objectForKey:@"PaymentType"]];
     [prodct addObject:[dct objectForKey:@"Product"]];
     
     }
     
     [self.tableView reloadData];
     
     /*         NSString *someString = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)amunt.count];
     
     self.firstLabel.text = @"1";
     
     self.lastLabel.text = someString;
     
     [self makeValues];
     
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
     NSLog(@"Error: %@", error);
     }];*/
    
}

- (IBAction)nextReferralAction:(id)sender
{
    [UIView animateWithDuration:.5 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if(i!=ary.count-1)
        {
        CATransition *transition = [CATransition animation];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
       // transition.duration = 0.3f;
       // transition.type =@"flip";
        [transition setDuration:0.5];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromRight];
        
       // transition.subtype = @"fromTop";
        
        [UIView setAnimationTransition:(int)transition forView:self.rView                                                       cache:NO];
        [UIView setAnimationDuration:1.0f];
        [[self.rView layer] addAnimation:transition forKey:nil];
        [UIView commitAnimations];
        }
    }
        completion:^(BOOL finished) {
                         
            if(i<ary.count-1)
            {
                i++;
                self.referredEmail.text=[[ary objectAtIndex:i]valueForKey:@"receiver_email_id"];
                self.update.text=[[ary objectAtIndex:i]valueForKey:@"created"];
                self.earned.text=[[ary objectAtIndex:i]valueForKey:@"invite_for"];
                self.referredStatus.text=[[ary objectAtIndex:i]valueForKey:@"status"];
                self.validTill.text=[[ary objectAtIndex:i]valueForKey:@"valid_till"];
            }
    }];
}

- (IBAction)backReferralAction:(id)sender
{
    
    [UIView animateWithDuration:.5 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if(i!=0)
        {
        CATransition *transition = [CATransition animation];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        // transition.duration = 0.3f;
        // transition.type =@"flip";
        [transition setDuration:0.5];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromLeft];
        
        // transition.subtype = @"fromTop";
        
        [UIView setAnimationTransition:(int)transition forView:self.rView                                                       cache:NO];
        [UIView setAnimationDuration:1.0f];
        [[self.rView layer] addAnimation:transition forKey:nil];
        [UIView commitAnimations];
        }
    }
                     completion:^(BOOL finished) {
                         
    
    if(i>0)
    {
        i--;
        self.referredEmail.text=[[ary objectAtIndex:i]valueForKey:@"receiver_email_id"];
        self.update.text=[[ary objectAtIndex:i]valueForKey:@"created"];;
        self.earned.text=[[ary objectAtIndex:i]valueForKey:@"invite_for"];
        self.referredStatus.text=[[ary objectAtIndex:i]valueForKey:@"status"];
        self.validTill.text=[[ary objectAtIndex:i]valueForKey:@"valid_till"];
    }
                         
      }];
}

-(void) okClicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@"Referral"])
    {
        
//        if (IS_PAD)
//        {
//            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
//
//            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//            [vc awakeFromNib:@"content_Controller15" arg:@"menuController"];
//
//            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//            [self presentViewController:vc animated:YES completion:NULL];
//        }
//        else
//        {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
                
            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                
            [vc awakeFromNib:@"content_Controller15" arg:@"menuController"];
                
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
            [self presentViewController:vc animated:YES completion:NULL];
            
       // }
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
    
    [alertView hide];
    alertView= nil;
    
}
- (IBAction)backAction:(id)sender
{
    
   // if (IS_PAD)
//    {
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
//
//        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//        [vc awakeFromNib:@"content_Controller15" arg:@"menuController"];
//
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//        [self presentViewController:vc animated:YES completion:NULL];
//    }
//    else
//    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"content_Controller15" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
  //  }
}

@end
