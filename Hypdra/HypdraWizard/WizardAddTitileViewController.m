//
//  WizardAddTitileViewController.m
//  Montage
//
//  Created by MacBookPro4 on 6/9/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "WizardAddTitileViewController.h"
#import "AFNetworking.h"
#import "DEMORootViewController.h"
#import "PageSelectionViewController.h"
#import "MBProgressHUD.h"
#import "MuiscTabViewController.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
@interface WizardAddTitileViewController ()<ClickDelegates>
{
    NSArray *imageDic;
    NSString *editingStyleId,*musicId,*musicType,*user_id;
    MBProgressHUD *hud;
    BOOL titleSelect;
}

@end

@implementation WizardAddTitileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    imageDic=[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"WizardImageDic"]];
    editingStyleId=[defaults objectForKey:@"EditingStyleID"];
    musicId=[defaults objectForKey:@"WizardMusicId"];
    musicType=[defaults objectForKey:@"WizardMusictype"];
    
    user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_ID"];
    NSLog(@"ImgDic:%@ \n editingid:%@ \n music id:%@ \n musictype:%@ ",imageDic,editingStyleId,musicId,musicType);
    
    UIColor *color = [UIColor whiteColor];
    self.wizardAlbumTitle.attributedText = [[NSAttributedString alloc] initWithString:@"Add a Title" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.wizardAlbumTitle setFont:[UIFont systemFontOfSize:19]];
    self.wizardAlbumTitle.delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.wizardAlbumTitle becomeFirstResponder];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)createFinalVideo:(id)sender
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
        if (self.wizardAlbumTitle.text.length == 0)
        {
            //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Enter a name for this album" preferredStyle:UIAlertControllerStyleAlert];
            //
            //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
            //                             {
            //                                 [self.wizardAlbumTitle becomeFirstResponder];
            //                             }];
            //
            //
            //        [alertController addAction:ok];
            //
            //        [self presentViewController:alertController animated:YES completion:nil];
            
            
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Enter a name for this album" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor navyBlue];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
            
        }
        else
        {
            
            //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"ACCEPT TERMS"
            //          message:@"By creating an video, you agree to the Hypdra Terms of Service and Privacy Policy."
            //          preferredStyle:UIAlertControllerStyleAlert];
            //
            //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"I Agree" style:UIAlertActionStyleDefault
            //           handler:^(UIAlertAction * action)
            //         {
            //                     [self setParams];
            //         }];
            //        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
            //
            //        [alert addAction:ok];
            //        [alert addAction:noButton];
            //
            //        [self presentViewController:alert animated:YES completion:nil];
            
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ACCEPT TERMS" message:@"By creating an video, you agree to the Hypdra Terms of Service and Privacy Policy." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //
            //        [alert show];
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"By creating an video, you agree to the Hypdra Terms, Service and Privacy Policy." withTitle:@"ACCEPT TERMS" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.hidden = YES;
            popUp.accessibilityHint =@"AcceptTermsAndConditions";
            popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
            popUp.inputTextField.hidden = YES;
            [popUp show];
            
        }
        
        /*
         if (titleSelect == true)
         {
         
         }
         else
         {
         UIAlertController * alert=[UIAlertController
         
         alertControllerWithTitle:@"Error" message:@"Select, I Agree" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* yesButton = [UIAlertAction
         actionWithTitle:@"Ok"
         style:UIAlertActionStyleDefault
         handler:^(UIAlertAction * action)
         {
         
         }];
         
         [alert addAction:yesButton];
         
         [self presentViewController:alert animated:YES completion:nil];
         }*/
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqualToString: @"ACCEPT TERMS"]) {
        
        [self setParams];
    }
    else
    {
        [self.wizardAlbumTitle becomeFirstResponder];
    }
    
}


-(void)setParams
{
    NSString *title=self.wizardAlbumTitle.text;
    
    
    NSLog(@"Wizard Title = %@",title);
    
    
    /*    if (self.wizardAlbumTitle.text.length == 0)
     {
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Enter a name for this album" preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
     
     [alertController addAction:ok];
     
     [self presentViewController:alertController animated:YES completion:nil];
     }
     else
     {*/
    
    [self sendAlbum:title];
    
    
    /*        UIAlertController * alert=[UIAlertController
     alertControllerWithTitle:@"Alert" message:@"We started generating your video. You will get an notification as soon the video is ready"preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* yesButton = [UIAlertAction
     actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action)
     {
     }];
     
     [alert addAction:yesButton];
     
     [self presentViewController:alert animated:YES completion:nil];*/
    
    //    }
    
}

-(void)sendAlbum:(NSString*)title
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSLog(@"Send Album");
    
    NSString *jsonString;
    NSError *error;
    
    NSDictionary *fDict = @{@"FinalTemplates":imageDic};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fDict options:NSJSONWritingPrettyPrinted
                        // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (!jsonData)
    {
        NSLog(@"Got an error: %@", error);
    } else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
    }
    
    NSLog(@"final wizard string:%@",jsonString);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setTimeoutInterval:150];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    //            NSDictionary *params = @{@"User_Name":@"Ragu",@"Email_ID": self.email.text,@"Password":self.password.text,};
    NSLog(@"User Id %@",user_id);
    
    NSDictionary *params = @{@"Dictionary":jsonString,@"User_ID": user_id,@"editing_style":editingStyleId,@"title":title,@"lang":@"ios",@"music":musicId,@"music_type":musicType};
    
    NSLog(@"NSData %@",jsonString);
    
    /*    [manager POST:@"http://108.175.2.116/montage/api/api.php?rquest=advance_final_details" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
     NSLog(@"FinalVideoResponse %@",responseObject);
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
     NSLog(@"Error Video Build: %@", error);
     //responseBlock(nil, FALSE, error);
     }];*/
    
    [manager POST:@"https://www.hypdra.com/api/api.php?rquest=wizard_final_save" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"Success: %@", responseObject);
         
         [hud hideAnimated:YES];
         
         //         UIAlertController * alert = [UIAlertController
         //             alertControllerWithTitle:@"Alert"
         //              message:@"Your video is in progess.You will be notified as soon the video is ready./n Do you wanna see the status in Myalbum ?" preferredStyle:UIAlertControllerStyleAlert];
         //
         //         UIAlertAction* yesButton = [UIAlertAction
         //             actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
         //                 handler:^(UIAlertAction * action)
         //                 {
         //                     [self backTo];
         //                 }];
         //
         //         [alert addAction:yesButton];
         //
         //         [self presentViewController:alert animated:YES completion:nil];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your video is in progess.You will be notified as soon the video is ready.\n Do you wanna see the status in Myalbum ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.hidden = YES;
         popUp.accessibilityHint =@"ConfirmToGoMyalbum";
         
         popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
         popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
         [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
         [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
         
         
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"Error Video Build: %@", error);
         
         [hud hideAnimated:YES];
         
         //         UIAlertController * alert = [UIAlertController
         //         alertControllerWithTitle:@"Alert"
         //          message:@"Could not connect to server"
         //         preferredStyle:UIAlertControllerStyleAlert];
         //
         //         UIAlertAction* yesButton = [UIAlertAction
         //             actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
         //             handler:^(UIAlertAction * action)
         //             {
         //                  [self backTo];
         //             }];
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


-(void)backTo
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ChoosenImagesandVideos"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MainArray"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
    
    vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc1 animated:YES completion:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    
    if (theTextField == self.wizardAlbumTitle)
    {
        [theTextField resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"TextField did begin called");
    self.wizardAlbumTitle.text=nil;
    
}

- (IBAction)backAction:(id)sender
{
    //    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //    [vc awakeFromNib:@"contentController_6" arg:@"menuController"];
    //
    //    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //    [self presentViewController:vc animated:YES completion:NULL];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MuiscTabViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MuiscTab"];
    
    //        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:vc];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)agreeBtn:(id)sender
{
    NSLog(@"Title selected");
    
    titleSelect = true;
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }else if([alertView.accessibilityHint isEqualToString:@""]){
    }else if([alertView.accessibilityHint isEqualToString:@""]){
    }
    
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToGoMyalbum"]){
        [self backTo];
    }else if([alertView.accessibilityHint isEqualToString:@"AcceptTermsAndConditions"]){
        [self.wizardAlbumTitle becomeFirstResponder];
    }
    [alertView hide];
    alertView = nil;
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToGoMyalbum"]){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NavigationFromWizardToAlbum"];
       // if (IS_PAD)
//        {
//            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbumiPad" bundle:nil];
//
//            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//            [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
//
//            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//            [self presentViewController:vc animated:YES completion:NULL];
//        }
//        else
//        {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NavigationFromWizardToAlbum"];
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
            
            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            
            [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
            
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:vc animated:YES completion:NULL];
       // }
    }else if([alertView.accessibilityHint isEqualToString:@"AcceptTermsAndConditions"]){
        [self setParams];
    }else if([alertView.accessibilityHint isEqualToString:@""]){
        
    }

    [alertView hide];
    alertView = nil;
}

@end

