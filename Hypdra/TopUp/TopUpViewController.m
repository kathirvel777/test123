//
//  TopUpViewController.m
//  Montage
//
//  Created by MacBookPro on 7/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "TopUpViewController.h"
#import "TestKit.h"
#import "AFNetworking.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"

@interface TopUpViewController ()<ClickDelegates>
{

    NSArray *minAry,*SpcAry;
    
    NSString *min,*spc,*user_id,*product,*value,*amount;
    
}
@end

@implementation TopUpViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    min = @"Minutes";
    
    spc = @"Space";
    
    minAry = @[@"5 Minute - $1",@"10 Minute - $2",@"20 Minute - $3",@"30 Minute - $4",@"40 Minute - $5",@"50 Minute - $6",@"60 Minute - $7",@"70 Minute - $8",@"80 Minute - $9",@"90 Minute - $10",@"100 Minute - $11"];
    
    SpcAry = @[@"1 GB/mo - $1",@"2 GB/mo - $2",@"3 GB/mo - $3",@"4 GB/mo - $4",@"10 GB/mo - $6",@"20 GB/mo - $10",@"50 GB/mo - $20",@"100 GB/mo - $30",@"250 GB/mo - $65",@"500 GB/mo - $120",@"1 TB/mo - $220"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"topupMinSpc" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendSerevr:)
                                                 name:@"topupMinSpc" object:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);

}


- (IBAction)minutesBtn:(id)sender
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

- (IBAction)spaceBtn:(id)sender
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
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:11.0];
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
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:11.0];
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
    
//    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=AddTopUps";
    
    NSDictionary *params = @{@"User_ID":user_id,@"Product":product,@"Value":value,@"Amount":amount};
    
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

- (IBAction)back:(id)sender
{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}

@end
