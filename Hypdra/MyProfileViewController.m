//
//  MyProfileViewController.m
//  DemoExpandable
//
//  Created by MacBookPro on 7/29/17.
//  Copyright © 2017 seek. All rights reserved.


#import "MyProfileViewController.h"
#import "REFrostedViewController.h"
#import "ProfileEditViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <SwipeBack/SwipeBack.h>
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"
#import "PlanDisplayViewController.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

//#import "CircleProgressBar.h"

@interface MyProfileViewController ()<ClickDelegates>
{
    int i;
    NSString *user_id;
    
    float totalSpace,usedSpace,completePercentage,storagePer,totalSec,usedSec,minPer;
    
    float ttlSpace,usSpace;
    
    MBProgressHUD *hud;
}

@property (nonatomic, assign) CGFloat localProgress;

@end


@implementation MyProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setShadow:self.firstView];
    [self setShadow:self.secondView];
    [self setShadow:self.thirdView];
    [self setShadow:self.fourthView];
    
    //    self.userName.userInteractionEnabled = false;
    
    self.userEmailLabel.numberOfLines=3;
    
    self.proImage.contentMode = UIViewContentModeScaleAspectFill;
    
    i = 0;
    
    [[self.profileBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [[self.textBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    //[self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor whiteColor],
//       NSFontAttributeName:[UIFont fontWithName:@"FuturaT-Book" size:22]}];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.profileImage.layer setCornerRadius:self.profileImage.frame.size.width/2];
    [self.profileImage.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.profileImage.layer setShadowRadius:4.0f];
    [self.profileImage.layer setShadowOffset:CGSizeMake(0, -3)];
    [self.profileImage.layer setShadowOpacity:0.5f];
    
    
    [self.proImage.layer setCornerRadius:self.proImage.frame.size.width/2];
    //[self.proImage.layer setBorderWidth:1];
    [self.proImage.layer setBorderColor:[[UIColor colorWithRed:78.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1] CGColor] ];
    [self.proImage.layer setMasksToBounds:YES];
    
   /* self.proImage.layer.cornerRadius = self.proImage.frame.size.width/2;
    self.proImage.layer.masksToBounds = YES;
    
    self.proImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.proImage.layer.borderWidth = 1.5f;
    self.proImage.clipsToBounds = YES;*/
    
    self.userNameLabel.text =  [[NSUserDefaults standardUserDefaults]valueForKey:@"Profilename"];
    
    self.userEmailLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"Email_ID"];
    
    NSString *proPic = [[NSUserDefaults standardUserDefaults]valueForKey:@"ProfilePic"];
    
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:proPic] placeholderImage:[UIImage imageNamed:@"Person-placeholder"]];
    
}

- (void)storageProgress
{
    
    float fval = (storagePer/100);
    
    NSLog(@"fval = %f",fval);
    
    [UIView animateWithDuration:3
                     animations:
     ^{
         self.storageView.progressValue = fval;
     }
                     completion:^(BOOL finished1)
     {
         //         self.storagePercentage.text = @"50%";
     }];
}

- (void)minutesProgress
{
    
    float fval = (minPer/100);
    
    [UIView animateWithDuration:3
                     animations:
     ^{
         self.minutesView.progressValue = fval;
     }
                     completion:^(BOOL finished1)
     {
         //         self.minutesPercentage.text = @"50%";
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    self.navigationController.swipeBackEnabled = NO;
    
    NSLog(@"User ID = %@",user_id);
    
    [self testServer];
    
}

-(void)testServer
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeDeterminate;
    //    hud.progress = progress;
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [_currentWindow addSubview:_BlurView];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=UserInformation"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"UserInformation:%@",responseObject);
         
         NSString *str = [responseObject objectForKey:@"TotalSpace"];

         NSString *str1 = [responseObject objectForKey:@"TotalUsedSpace"];
         //NSString *str2 = [responseObject objectForKey:@"TotalUsedSpace"];
         
         totalSpace =  [str floatValue];
         usedSpace = [str1 floatValue];
         
         storagePer = (usedSpace/totalSpace)*100;
         
         NSLog(@"storagePer = %f",storagePer);
         
         ttlSpace = [str floatValue];
         usSpace = [str1 floatValue];
         //storagePer = (usSpace/ttlSpace)*100;
         
         NSLog(@"totalSpace = %f",totalSpace);
         NSLog(@"usedSpace = %f",usedSpace);
         
         //        completePercentage = (usedSpace/totalSpace) * 100;
         
         NSMutableString *mStr = [[NSMutableString alloc]init];
         
         [mStr appendString:[NSString stringWithFormat:@"%d",(int)storagePer]];
         
         [mStr appendString:@"%"];
         NSLog(@"storagePercentage = %@",mStr);
         
         self.storagePercentage.text = mStr;
         
         [self storageProgress];
         
         //used space
         NSString *usedSpc=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"TotalUsedSpace"]];
         
         float usedSpac=[usedSpc floatValue];
         self.usedSpace.text=[NSString stringWithFormat:@"%.3f GB",usedSpac];
         
         //total space
         NSString *totalSpc=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"TotalSpace"]];
         
         float totSpac=[totalSpc floatValue];
         self.totalSpace.text=[NSString stringWithFormat:@"%.03f GB",totSpac];
         
         //Remain space
         NSString *remainSpc=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"RemainingSpace"]];
         
         float remainSpac=[remainSpc floatValue];
         self.availSpace.text=[NSString stringWithFormat:@"%.3f GB",remainSpac];
         
         //         NSString *fin =  [NSString stringWithFormat:@"%.02fGB/%.02fGB",usSpace,ttlSpace];
         //
         //
         //         self.spaceDuration.text = fin;
         self.usedMinDur.text = [responseObject objectForKey:@"TotalUsedDuration"];
         
         /*        self.totalMinDur.text = [responseObject objectForKey:@"TotalDuration"];
          
          self.usedMinDur.text = [responseObject objectForKey:@"TotalUsedDuration"];*/
         
         //totalMin = [self calMin:[responseObject objectForKey:@"TotalDuration"]];
         totalSec = [self secondsForTimeString:[responseObject objectForKey:@"TotalDuration"]].floatValue;
         usedSec = [self secondsForTimeString:[responseObject objectForKey:@"TotalUsedDuration"]].floatValue;
         //usedMin = [self calMin:[responseObject objectForKey:@"TotalUsedDuration"]];
         
         minPer = (usedSec/totalSec)*100;
         
         NSMutableString *mMtr = [[NSMutableString alloc]init];
         
         [mMtr appendString:[NSString stringWithFormat:@"%d",(int)minPer]];
         
         [mMtr appendString:@"%"];
         
         NSLog(@"minutesPercentage = %@",mMtr);
         
         self.minutesPercentage.text = mMtr;
         
         NSString *min =  [NSString stringWithFormat:@"%@ Min / %@ Min",[responseObject objectForKey:@"TotalUsedDuration"],[responseObject objectForKey:@"TotalDuration"]];
         
         self.usedLabel.text=[responseObject objectForKey:@"TotalUsedDuration"];
         
         self.availableLabel.text=[responseObject objectForKey:@"RemainingDuration"];
         
         self.totalLabel.text=[responseObject objectForKey:@"TotalDuration"];
         self.avilable_Credits.text = [responseObject objectForKey:@"credit_points"];
        
         [self minutesProgress];
         
         [hud hideAnimated:YES];
         [_BlurView removeFromSuperview];
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         [hud hideAnimated:YES];
         
         [_BlurView removeFromSuperview];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         //responseBlock(nil, FALSE, error);
     }];
    
}

- (NSNumber *)secondsForTimeString:(NSString *)string {
    
    NSArray *components = [string componentsSeparatedByString:@":"];
    
    NSInteger hours   = [[components objectAtIndex:0] integerValue];
    NSInteger minutes = [[components objectAtIndex:1] integerValue];
    NSInteger seconds = [[components objectAtIndex:2] integerValue];
    
    return [NSNumber numberWithInteger:(hours * 60 * 60) + (minutes * 60) + seconds];
}

-(int)calMin:(NSString*)val
{
    
    NSString *zeroString = @"00:00:00";
    NSString *timeString = val;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *zeroDate = [dateFormatter dateFromString:zeroString];
    NSDate *offsetDate = [dateFormatter dateFromString:timeString];
    NSTimeInterval timeDifference = [offsetDate timeIntervalSinceDate:zeroDate];
    CGFloat minutes = (timeDifference/60);
    NSLog(@"%0.2fmins",minutes);
    
    NSInteger num = (NSInteger) minutes;
    
    //    NSString *tempString = [NSString stringWithFormat:@"%d",num];
    //
    return num;
    
    /*    NSString *timeString = val;
     
     NSLog(@"timeString = %@",val);
     
     
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     formatter.dateFormat = @"hh:mm:ss";
     NSDate *timeDate = [formatter dateFromString:timeString];
     
     formatter.dateFormat = @"hh";
     int hours = [[formatter stringFromDate:timeDate] intValue];
     formatter.dateFormat = @"mm";
     int minutes = [[formatter stringFromDate:timeDate] intValue];
     formatter.dateFormat = @"ss";
     int seconds = [[formatter stringFromDate:timeDate] intValue];
     
     float timeInMinutes = hours * 60 + minutes + seconds / 60.0;
     
     NSLog(@"%d%d%d",hours,minutes,seconds);
     
     NSLog(@"timeInMinutes = %f",timeInMinutes);*/
    
}


- (void)setupProgressView3
{
    self.progressView.tintColor = [UIColor purpleColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
    self.progressView.centralView = label;
    
    self.progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress)
    {
        //        [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%d%%", i]];
        
        [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%d%%",usedSpace]];
        
    };
}

- (void)updateProgress:(NSTimer *)timer
{
    
    _localProgress = ((int)((_localProgress * 100.0f) + 1.01) % 100) / 100.0f;
    
    i = i+1;
    
    //    _localProgress = _localProgress + 1;
    
    [self.progressView setProgress:_localProgress];
    
    //    NSLog(@"Progress = %f",_localProgress);
    
    NSLog(@"I = %d",i);
    NSLog(@"Complete = %d",completePercentage);
    
    if (completePercentage == 0)
    {
        [timer invalidate];
        timer = nil;
    }
    else if (i == completePercentage)
    {
        NSLog(@"Enter");
        
        [timer invalidate];
        timer = nil;
        
    }
    else if (completePercentage == 100)
    {
        [timer invalidate];
        timer = nil;
    }
    
}


-(void)setShadow:(UIView*)demoView
{
    demoView.layer.shadowColor = [UIColor blackColor].CGColor;
    demoView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    demoView.layer.shadowOpacity = 0.8f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (IBAction)userNameEdit:(id)sender
{
    
}

- (IBAction)menu:(id)sender
{
    [self.view endEditing:YES];
    
    [self.frostedViewController.view endEditing:YES];
    
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)editProfile:(id)sender
{
    
    // if (IS_PAD)
    //    {
    //
    //        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
    //
    //        ProfileEditViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfileEdit"];
    //
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
    //    else
    //    {
    //
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    ProfileEditViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfileEdit"];
    
    [self.navigationController pushViewController:vc animated:YES];
    // }
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

- (IBAction)AddStorage_btn:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_planDisplay" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)AddMinutes_btn:(id)sender {
    /*UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_planDisplay" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];*/
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    PlanDisplayViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PlanDisplay"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)AddCredits_btn:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"demo_planDisplay" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}
@end
