//
//  BillingDisplayViewController.m
//  SampleTest
//
//  Created by MacBookPro on 8/17/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "BillingDisplayViewController.h"
#import "BillingTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface BillingDisplayViewController ()<ClickDelegates>
{
    NSArray *minAry;
    NSMutableArray *amunt,*startDates,*expiredDates,*pymtType,*prodct;

    NSString *user_id;
    MBProgressHUD *hud;

}


@end

@implementation BillingDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    minAry = @[@"5 Minute - $1",@"10 Minute - $2",@"20 Minute - $3",@"30 Minute - $4",@"40 Minute - $5",@"50 Minute - $6",@"60 Minute - $7",@"70 Minute - $8",@"80 Minute - $9",@"90 Minute - $10",@"100 Minute - $11"];

    [self setShadow:self.bView];
    [self setShadow:self.borderView];
        
    amunt = [[NSMutableArray alloc]init];
    startDates = [[NSMutableArray alloc]init];
    expiredDates=[[NSMutableArray alloc]init];
    pymtType = [[NSMutableArray alloc]init];
    prodct = [[NSMutableArray alloc]init];
    
    //[[self.print imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    UITapGestureRecognizer *tapValue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPosition:)];
    [tapValue setNumberOfTapsRequired:1];
    tapValue.delegate=self;
    
    [self.blurView addGestureRecognizer:tapValue];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.blurView.hidden=YES;
    self.popUpView.hidden=YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    UIView *view=[[UIView alloc]init];
    
    view.backgroundColor = [UIColor darkGrayColor];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    view.frame = CGRectMake(0, 0, _popUpView.frame.size.width+35, 1);
    
    else
        view.frame = CGRectMake(0, 0, _popUpView.frame.size.width+_popUpView.frame.size.width-62, 1);
    
    [_bottomView addSubview:view];
    
    [self getSerevr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setShadow:(UIView*)demoView
{
    demoView.layer.shadowColor = [UIColor blackColor].CGColor;
    demoView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    demoView.layer.shadowOpacity = 0.5f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [amunt count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    BillingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[BillingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.bDate.text = startDates[indexPath.row];
    cell.bType.text = pymtType[indexPath.row];
    cell.bPayment.text = amunt[indexPath.row];
    
    cell.viewDetails.tag = indexPath.row;
    [cell.viewDetails addTarget:self action:@selector(viewPaymentDetails:) forControlEvents:UIControlEventTouchUpInside];
    
    //prodct[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return 80;
//}
//

-(void)viewPaymentDetails:(UIButton*)sender
{
    NSLog(@"Tag:%d",sender.tag);
    
    self.blurView.hidden=false;
    self.popUpView.hidden=false;
    NSString *type,*startDate,*expiryDate,*payment;
    
    type=[pymtType objectAtIndex:sender.tag];
    startDate=[startDates objectAtIndex:sender.tag];
    expiryDate=[expiredDates objectAtIndex:sender.tag];
    payment=[amunt objectAtIndex:sender.tag];

    if([type isEqualToString:@"item"])
    {
        self.expiredDate.hidden=true;
        self.bView.hidden=true;
        
        self.plan.text=[NSString stringWithFormat:@"%@", type];
        self.payment.text=[NSString stringWithFormat:@"%@", payment];
        self.startDate.text=[NSString stringWithFormat:@"%@", startDate];

    }
    else
    {
        self.expiredDate.hidden=false;
        self.bView.hidden=true;
        
        self.plan.text=[NSString stringWithFormat:@"%@", type];
        self.payment.text=[NSString stringWithFormat:@"%@", payment];
        self.startDate.text=[NSString stringWithFormat:@"%@", startDate];
        self.expiredDate.text=[NSString stringWithFormat:@"%@", expiryDate];

    }
}
-(void)tapPosition:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
    }
                     completion:^(BOOL finished)
     {
         self.blurView.hidden=true;
         self.bView.hidden=false;
         self.popUpView.hidden = true;
     }];
    
}

- (void)getSerevr
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeDeterminate;
    //    hud.progress = progress;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=PaymentHistory"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Billing Response:%@",responseObject);
         
         NSArray *ary = [responseObject objectForKey:@"PaymentHistory"];
         
         for (NSDictionary *dct in ary)
         {
             [amunt addObject:[dct objectForKey:@"Amount"]];
             [startDates addObject:[dct objectForKey:@"Date"]];
             [expiredDates addObject:[dct objectForKey:@"Expire"]];
             [pymtType addObject:[dct objectForKey:@"Type"]];
             [prodct addObject:[dct objectForKey:@"Product"]];
         }
         
         [self.tableView reloadData];
         
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

- (IBAction)printAtn:(id)sender
{
    
}

- (IBAction)downloadAction:(id)sender
{
 UIGraphicsBeginImageContextWithOptions(self.sceenShotForPrint.bounds.size, YES, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.sceenShotForPrint.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"UIImage:%@",snapshotImage);
    
   // NSData *imgData=UIImagePNGRepresentation(snapshotImage);
    
    UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (IBAction)close_btn:(id)sender {
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
    }
                     completion:^(BOOL finished)
     {
         self.blurView.hidden=true;
         self.bView.hidden=false;
         self.popUpView.hidden = true;
     }];
    
}
// And if you wish add this selector method in code;

- (void) image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info;
{
    if (error != NULL)
    {
        // handle error
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Saved" message:@"Kindly check your Photos" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
//
//    [alertController addAction:ok];
//
//    [self presentViewController:alertController animated:YES completion:nil];
     
        NSLog(@"Error:%@",error);
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try Again!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
       
    }
    else
    {
        // handle ok status
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Try Again!" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
     
       
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please check your Photos" withTitle:@"Saved" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

-(void)takeScreenShot
{
 UIGraphicsBeginImageContextWithOptions(self.sceenShotForPrint.bounds.size, YES, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.sceenShotForPrint.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"UIImage:%@",snapshotImage);
    NSData *imgData=UIImagePNGRepresentation(snapshotImage);
    
    if ([UIPrintInteractionController canPrintData:imgData])
    {
        //:self.imageURL]) {
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.jobName = @"Hypdra";//self.imageURL.lastPathComponent;
        printInfo.outputType = UIPrintInfoOutputGeneral;
        
        UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
        printController.printInfo = printInfo;
        
        printController.printingItem = imgData;
        
        //self.imageURL;
        
        [printController presentAnimated:true completionHandler: nil];
    }
}

- (IBAction)printAction:(id)sender
{
    [self takeScreenShot];

}

- (IBAction)backAction:(id)sender {
    
//    if (IS_PAD)
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
        
   // }
}

-(void) okClicked:(CustomPopUp *)alertView{
    
    [alertView hide];
    alertView = nil;
}

-(void)cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    
    [alertView hide];
    alertView= nil;
    
}
- (IBAction)DOwnload_actn:(id)sender {
}
@end
