//
//  PlanSettingViewController.m
//  Montage
//
//  Created by MacBookPro on 7/27/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "PlanSettingViewController.h"
#import "TestKit.h"
#import "AFNetworking.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"


@interface PlanSettingViewController ()<ClickDelegates>
{
    UITapGestureRecognizer *tapValue,*tapValue1;
    NSArray *minAry,*SpcAry;
    NSMutableArray *currentPlan;
    NSString *min,*spc,*user_id,*product,*value,*amount;
    BOOL minutes,space;

    NSString *yourPlan;
    NSString *plan,*renewalDate;
}
@end

@implementation PlanSettingViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
 
//    tapValue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPosition:)];
//    [tapValue setNumberOfTapsRequired:1];
//    tapValue.delegate=self;
//    
//    [self.minutesTopView addGestureRecognizer:tapValue];
//    
//    
//    tapValue1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPosition1:)];
//    [tapValue1 setNumberOfTapsRequired:1];
//    tapValue1.delegate=self;
//    
//    [self.spaceTopView addGestureRecognizer:tapValue1];
    
    
    
//    @property (strong, nonatomic) IBOutlet UILabel *chooseMin;
//    
//    @property (strong, nonatomic) IBOutlet UILabel *usedMin;
//    
//    @property (strong, nonatomic) IBOutlet UILabel *usedMinLabel;
//    
//    @property (strong, nonatomic) IBOutlet UILabel *availMinLabel;
//    
//    @property (strong, nonatomic) IBOutlet UILabel *availMin;
//    
//    @property (strong, nonatomic) IBOutlet UILabel *usedSpaces;
//    
//    @property (strong, nonatomic) IBOutlet UILabel *chooseSpace;
//    
//    
//    @property (strong, nonatomic) IBOutlet UILabel *usedSpaceLabel;
//    
//    @property (strong, nonatomic) IBOutlet UILabel *availSpaceLabel;
//    
//    @property (strong, nonatomic) IBOutlet UILabel *availSpace;

    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        [self.chooseMin setFont:[UIFont systemFontOfSize:11]];
        [self.usedMin setFont:[UIFont systemFontOfSize:11]];
        [self.usedMinLabel setFont:[UIFont systemFontOfSize:11]];
        [self.availMinLabel setFont:[UIFont systemFontOfSize:11]];
        [self.availMin setFont:[UIFont systemFontOfSize:11]];
        [self.usedSpaces setFont:[UIFont systemFontOfSize:11]];
        [self.chooseSpace setFont:[UIFont systemFontOfSize:11]];
        [self.usedSpaceLabel setFont:[UIFont systemFontOfSize:11]];
        [self.availSpaceLabel setFont:[UIFont systemFontOfSize:11]];
        [self.availSpace setFont:[UIFont systemFontOfSize:11]];
        [self.ttlSpace setFont:[UIFont systemFontOfSize:11]];
        [self.usSpace setFont:[UIFont systemFontOfSize:11]];
//        [self.planDetail setFont:[UIFont systemFontOfSize:14]];
    }
    else
    {
        
    }
    
    [[self.minExpnd imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.spcExpnd imageView] setContentMode: UIViewContentModeScaleAspectFit];

    min = @"Minutes";
    spc = @"Space";
    
    minAry = @[@"5 Minute - $1",@"10 Minute - $2",@"20 Minute - $3",@"30 Minute - $4",@"40 Minute - $5",@"50 Minute - $6",@"60 Minute - $7",@"70 Minute - $8",@"80 Minute - $9",@"90 Minute - $10",@"100 Minute - $11"];
    
    SpcAry = @[@"1 GB/mo - $1",@"2 GB/mo - $2",@"3 GB/mo - $3",@"4 GB/mo - $4",@"10 GB/mo - $6",@"20 GB/mo - $10",@"50 GB/mo - $20",@"100 GB/mo - $30",@"250 GB/mo - $65",@"500 GB/mo - $120",@"1 TB/mo - $220"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"topupMinSpc" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendSerevr:)
                                                 name:@"topupMinSpc" object:nil];
    
    minutes=false;
    space=false;

}

-(void)tapPosition:(UITapGestureRecognizer *)recognizer
{
    
//    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//        self.socialView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
//    }
//                     completion:^(BOOL finished)
//     {
//         self.topSocialView.hidden = true;
//         self.socialView.hidden = true;
//     }];

    
    self.minutesView.hidden = true;
    
//    self.minutesTopView.hidden = true;
//    self.spaceTopView.hidden = true;
    
    self.spaceView.hidden = true;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    
    self.minHght.constant = 0;
    self.spaceHght.constant = 0;
    
    self.minutesView.hidden = true;
    self.spaceView.hidden = true;


    
    
    
    [self currentPlan];

}

-(void)tapPosition1:(UITapGestureRecognizer *)recognizer
{
    self.minutesView.hidden = true;
//    self.minutesTopView.hidden = true;
//    self.spaceTopView.hidden = true;
    self.spaceView.hidden = true;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSLog(@"viewWillLayoutSubviews Called");
}


-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    
  self.topView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.topView.frame.size.width, self.topView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    NSLog(@"viewDidLayoutSubviews Called");
    
//  self.scrollView.contentSize = self.mainView.frame.size;
    
    
//    [self.mainView layoutIfNeeded];
//    CGFloat borderWidth = 2.0f;
//    
//    self.minDisList = CGRectInset(self.minDisList, -borderWidth, -borderWidth);
//    self.minDisList.borderColor = [UIColor yellowColor].CGColor;
//    self.minDisList.borderWidth = borderWidth;


 //   self.scrollView.contentSize = self.topMainView.frame.size;
   
    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, self.minDisList.frame.size.height+self.minDisList.frame.size.height);
    
    self.subMainView.frame=CGRectMake(self.subMainView.frame.origin.x, self.subMainView.frame.origin.y, self.subMainView.frame.size.width,self.minDisList.frame.size.height+self.spaceDisList.frame.size.height+20);
    
   // self.subMainView.layer.borderColor=[UIColor darkGrayColor].CGColor;
   // self.subMainView.layer.borderWidth = 1.0f;
    
    self.minDisList.layer.borderColor=[UIColor grayColor].CGColor;
    self.minDisList.layer.borderWidth = 1.0f;
    
    self.minutesView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.minutesView.layer.borderWidth = 1.0f;
    
    self.spaceView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.spaceView.layer.borderWidth = 1.0f;
    
    self.spaceDisList.layer.borderColor=[UIColor grayColor].CGColor;
    self.spaceDisList.layer.borderWidth = 1.0f;
    
    //  self.topView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.topView.frame.size.width, self.topView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
}


-(void)currentPlan
{
 
    NSLog(@"checkmembership:%@",user_id);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSError *error;
    
//    NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/api/api.php?rquest=CurrentPlanOfUser"];
  
    NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/api/api.php?rquest=UserInformation"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         
         //        tableDataFromServer=[responseObject objectForKey:@"View_Registration_Details"];
         //        NSLog(@"Json%@",tableDataFromServer);
         
         currentPlan=responseObject;
         NSLog(@"Check Membership Status:%@",responseObject);
         
        // Month Payments Agreement For Standard with Amount 5 USD/Month
         plan=[currentPlan valueForKey:@"Plan"];
         NSString *amount=[currentPlan valueForKey:@"Amount"];
         renewalDate=[currentPlan valueForKey:@"RenewDate"];
         
         self.planDetail.text=plan;
         
         yourPlan=[NSString stringWithFormat:@"Month Payments Agreement For %@ with Amount %@",plan,amount ];
         
         self.viewPlanOrRenewal.text=yourPlan;
         
         
         NSString *str = [responseObject objectForKey:@"TotalSpace"];
         NSString *str1 = [responseObject objectForKey:@"TotalUsedSpace"];
         
         float ttlSpace = [str floatValue];
         float usSpace = [str1 floatValue];

         NSString *fin =  [NSString stringWithFormat:@"%.02fGB",ttlSpace];
         NSString *fin1 =  [NSString stringWithFormat:@"%.02fGB",usSpace];
        
         self.ttlSpace.text = fin;
         self.usSpace.text = fin1;
         
         self.usedMin.text = [responseObject objectForKey:@"TotalUsedDuration"];
         
         self.availMin.text = [responseObject objectForKey:@"TotalDuration"];
         
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}


- (IBAction)minuteBtn:(id)sender
{
    
//    self.minutesView.hidden = false;
//    self.minutesTopView.hidden = false;
//    self.spaceTopView.hidden = true;
//    self.spaceView.hidden = true;
    
    
    if (self.minutesView.isHidden)
    {
        minutes=true;
        
//        [self.minExpnd setImage:[UIImage imageNamed:@"128-plus-1"] forState:UIControlStateNormal];

        [UIView animateWithDuration:.5 animations:^{
            
            //  self.view2.alpha = 0;
            
            self.minutesView.hidden = false;
            
            self.minHght.constant=263;
            
            [self.mainView layoutIfNeeded];
            
        }];
        
//        [self.minExpnd setImage:[UIImage imageNamed:@"128-plus-1"] forState:UIControlStateNormal];

    }
    else
    {
        
        minutes=false;
        
        
//        [self.minExpnd setImage:[UIImage imageNamed:@"128-less"] forState:UIControlStateNormal];

        [UIView animateWithDuration:.5 animations:^{
            
            //  self.view2.alpha = 0;
            
            self.minutesView.hidden = true;
            
            self.minHght.constant=0;
            
            [self.mainView layoutIfNeeded];
            
        }];
        
//        [self.minExpnd setImage:[UIImage imageNamed:@"128-less"] forState:UIControlStateNormal];
        
    }
    //self.scrollView.contentSize = self.mainView.frame.size;

    CGFloat rect;
    
    if(minutes==true && space==true)
    {
        rect=self.minDisList.frame.size.height+self.spaceDisList.frame.size.height+self.minutesView.frame.size.height+self.spaceView.frame.size.height+20;
        
      //  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, rect);
        
    }
    else if (minutes==true && space==false)
    {
        rect=self.minDisList.frame.size.height+self.spaceDisList.frame.size.height+self.minutesView.frame.size.height+20;
        
       // self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,rect );
    }
    else if (minutes==false && space==true)
    {
        rect=self.minDisList.frame.size.height+self.spaceDisList.frame.size.height+self.spaceView.frame.size.height+20;
        
       // self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, rect);
    }
    else
    {
        rect=self.minDisList.frame.size.height+self.spaceDisList.frame.size.height;
        
       
    }
    
     self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,rect+80);
    
    self.subMainView.frame=CGRectMake(self.subMainView.frame.origin.x, self.subMainView.frame.origin.y, self.subMainView.frame.size.width, rect+20);
    
    NSLog(@"Height = %f",self.mainView.frame.size.height);

}

- (IBAction)yourPlan:(id)sender
{
    
    NSLog(@"Plan = %@",plan);

    self.planDes.text=yourPlan;
}

- (IBAction)renewalDate:(id)sender
{
    
    NSLog(@"renewalDate = %@",renewalDate);
    
    self.planDes.text=renewalDate;
}

- (IBAction)spaceBtn:(id)sender
{
    
//    self.minutesView.hidden = true;
//    self.minutesTopView.hidden = true;
//    self.spaceTopView.hidden = false;
//    self.spaceView.hidden = false;

    if (self.spaceView.isHidden)
    {
        space=true;
        
//        [self.spcExpnd setImage:[UIImage imageNamed:@"128-plus-1"] forState:UIControlStateNormal];

        [UIView animateWithDuration:.5 animations:^{
            
            //  self.view2.alpha = 0;
            
            self.spaceView.hidden = false;
            
            self.spaceHght.constant=263;
            
            [self.mainView layoutIfNeeded];
            
        }];
        
        
//        [self.spcExpnd setImage:[UIImage imageNamed:@"128-plus-1"] forState:UIControlStateNormal];
    }
    else
    {
        space=false;
        
        
//        [self.spcExpnd setImage:[UIImage imageNamed:@"128-less"] forState:UIControlStateNormal];

        [UIView animateWithDuration:.5 animations:^{
            
            //  self.view2.alpha = 0;
            
            self.spaceView.hidden = true;
            
            self.spaceHght.constant=0;
            
            [self.mainView layoutIfNeeded];
            
        }];
        
//        [self.spcExpnd setImage:[UIImage imageNamed:@"128-less"] forState:UIControlStateNormal];
    }
    
    //self.scrollView.contentSize = self.mainView.frame.size;
    
    CGFloat rect;
    
    if(minutes==true && space==true)
    {
        rect=self.minDisList.frame.size.height+self.spaceDisList.frame.size.height+self.minutesView.frame.size.height+self.spaceView.frame.size.height+20;
        
        //  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, rect);
        
    }
    else if (minutes==true && space==false)
    {
        rect=self.minDisList.frame.size.height+self.spaceDisList.frame.size.height+self.minutesView.frame.size.height+20;
        
        // self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,rect );
    }
    else if (minutes==false && space==true)
    {
        rect=self.minDisList.frame.size.height+self.spaceDisList.frame.size.height+self.spaceView.frame.size.height+20;
        
        // self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, rect);
    }
    else
    {
        rect=self.minDisList.frame.size.height+self.spaceDisList.frame.size.height;
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,rect+80);
    
    self.subMainView.frame=CGRectMake(self.subMainView.frame.origin.x, self.subMainView.frame.origin.y, self.subMainView.frame.size.width, rect+20);
    
    NSLog(@"Height = %f",self.mainView.frame.size.height);



}

- (IBAction)minutePurchase:(id)sender
{
 
    
    if ([min isEqualToString:@"5 Minute - $1"])
    {
        
        product = @"minutes";
        value = @"5";
        amount = @"1";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.oneminute"];
        
    }
    else if ([min isEqualToString:@"10 Minute - $2"])
    {
        
        product = @"minutes";
        value = @"10";
        amount = @"2";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.tenminute"];
        
    }
    else if ([min isEqualToString:@"20 Minute - $3"])
    {
        
        product = @"minutes";
        value = @"20";
        amount = @"3";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.twentyminutes"];
        
    }
    else if ([min isEqualToString:@"30 Minute - $4"])
    {
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.thirtyminutes"];
        
    }
    else if ([min isEqualToString:@"40 Minute - $5"])
    {
        
        product = @"minutes";
        value = @"40";
        amount = @"5";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.foutyminutes"];
        
    }
    else if ([min isEqualToString:@"50 Minute - $6"])
    {
        
        product = @"minutes";
        value = @"50";
        amount = @"6";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.fiftyminutes"];
        
    }
    else if ([min isEqualToString:@"60 Minute - $7"])
    {
        
        product = @"minutes";
        value = @"60";
        amount = @"7";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.sixtyminutes"];
        
    }
    else if ([min isEqualToString:@"70 Minute - $8"])
    {
        
        product = @"minutes";
        value = @"70";
        amount = @"8";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.seventyminutes"];
        
    }
    else if ([min isEqualToString:@"80 Minute - $9"])
    {
        
        product = @"minutes";
        value = @"80";
        amount = @"9";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.eightyminutes"];
        
    }
    else if ([min isEqualToString:@"90 Minute - $10"])
    {
        
        product = @"minutes";
        value = @"90";
        amount = @"10";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.ninetyminutes"];
        
    }
    else if ([min isEqualToString:@"100 Minute - $11"])
    {
        
        product = @"minutes";
        value = @"100";
        amount = @"11";
        
        [TestKit setcFrom:@"Minutes"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.hundredminutes"];
        
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Select any one of Option ...!" withTitle:@"Warning" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
}

- (IBAction)spacePurchase:(id)sender
{
    
    
    if ([spc isEqualToString:@"1 GB/mo - $1"])
    {
        
        product = @"space";
        value = @"1";
        amount = @"10";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spaceone"];
        
    }
    else if ([spc isEqualToString:@"2 GB/mo - $2"])
    {
        
        product = @"space";
        value = @"2";
        amount = @"2";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacetwo"];
        
        
    }
    else if ([spc isEqualToString:@"3 GB/mo - $3"])
    {
        
        product = @"space";
        value = @"3";
        amount = @"3";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacethree"];
        
        
    }
    else if ([spc isEqualToString:@"4 GB/mo - $4"])
    {
        
        product = @"space";
        value = @"4";
        amount = @"4";
        
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacefour"];
        
        
    }
    else if ([spc isEqualToString:@"10 GB/mo - $6"])
    {
        
        product = @"space";
        value = @"10";
        amount = @"6";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spaceten"];
        
        
    }
    else if ([spc isEqualToString:@"20 GB/mo - $10"])
    {
        product = @"space";
        value = @"20";
        amount = @"10";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacetwenty"];
        
        
    }
    else if ([spc isEqualToString:@"50 GB/mo - $20"])
    {
        product = @"space";
        value = @"50";
        amount = @"20";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacefifthy"];
        
        
    }
    else if ([spc isEqualToString:@"100 GB/mo - $30"])
    {
        
        product = @"space";
        value = @"100";
        amount = @"30";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacehundred"];
        
        
    }
    else if ([spc isEqualToString:@"250 GB/mo - $65"])
    {
        
        product = @"space";
        value = @"250";
        amount = @"65";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacetwofifthy"];
        
        
    }
    else if ([spc isEqualToString:@"500 GB/mo - $120"])
    {
        
        product = @"space";
        value = @"500";
        amount = @"120";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacefivehundred"];
        
        
    }
    else if ([spc isEqualToString:@"1 TB/mo - $220"])
    {
        
        product = @"space";
        value = @"1000";
        amount = @"220";
        
        [TestKit setcFrom:@"Space"];
        
        [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.mobile.ios.testiapnew.spacethousand"];
        
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
    
    if (dropdownMenu == self.minutesList)
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
        font = [UIFont fontWithName:@"Helvetica Neue" size:9.0];
    }
    else
    {
        font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    }
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    NSAttributedString *attrString;
    
    if (dropdownMenu == self.minutesList)
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
        font = [UIFont fontWithName:@"Helvetica Neue" size:9.0];
    }
    else
    {
        font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    }
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    
    
    NSAttributedString *attrString;
    
    if (dropdownMenu == self.minutesList)
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
    
    if (dropdownMenu == self.minutesList)
    {
        
        min = minAry[row];
        
        spc = @"Space";
        
        delay(0.15,
              ^{
                  [dropdownMenu closeAllComponentsAnimated:YES];
                  
                  [self.minutesList reloadAllComponents];
                  
                  [self.spaceList reloadAllComponents];
                  
                  
//                  [self.minExpnd sendActionsForControlEvents:UIControlEventTouchUpInside];
                  
              });
    }
    else
    {
        
        spc = SpcAry[row];
        
        min = @"Minutes";
        
        delay(0.15,
              ^{
                  [dropdownMenu closeAllComponentsAnimated:YES];
                  
                  [self.spaceList reloadAllComponents];
                  
                  [self.minutesList reloadAllComponents];
                  
//                  [self.spcExpnd sendActionsForControlEvents:UIControlEventTouchUpInside];
                  
              });
    }
    
}

static inline void delay(NSTimeInterval delay, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}


- (void)sendSerevr:(NSNotification *)note
{
    
    NSLog(@"Minutes / Space");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    
    
    
    NSString *jsonString;
    
    NSDictionary *getDict =  [[NSUserDefaults standardUserDefaults]objectForKey:@"ConsumeReceipt"];

    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:getDict options:NSJSONWritingPrettyPrinted error:nil];
    
    if (! jsonData)
    {
//        NSLog(@"Got an error: %@", error);
    } else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
        NSLog(@"Got an string: %@", jsonString);
    }


//    NSString *getTran = note.userInfo;
    
    
    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    NSDictionary *params = @{@"User_ID":user_id,@"Product":product,@"Value":value,@"Amount":amount,@"TransactionInfo":jsonString,@"ProductID":[note object],@"Status":@"1"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json Payment Response:%@",responseObject);
         
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
     }];
    
}
-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
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

@end
