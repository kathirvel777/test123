//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
//#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"
#import "RKSwipeBetweenViewControllers.h"
#import "MyImages.h"
#import "UIImageView+WebCache.h"
#import "PrivacyViewController.h"
#import "AboutViewController.h"
#import "LetsConnectViewController.h"
#import "DEMORootViewController.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "MenuTableViewCell.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "PageSelectionViewController.h"
#import <UserNotifications/UserNotifications.h>

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define URL @"https://www.hypdra.com/api/api.php?rquest=user_profile_update"

@interface DEMOMenuViewController ()<ClickDelegates>
{
    NSMutableURLRequest *request;
    
    NSString *user_id;
    
    UITapGestureRecognizer *tapGestureRecognizer;
    
    NSArray *standArray;
    
    NSArray *titles;
    UISwitch *mySwitch;
}

@end

@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //    titles = @[@"Dashboard", @"My Album", @"Notifications",@"Settings",@"Support",@"Membership",@"About",@"Terms",@"Privacy",@"Sign Out"];
    //
    //    standArray = @[@"dashboard_128",@"my_album_128",@"notification_128",@"settings_128",@"support.png",@"membership_128",@"about_90",@"terms_90",@"privacy_90",@"sign_out_90"];
    
    titles = @[@"Dashboard", @"My Album", @"Notifications",@"Membership",@"Settings",@"Support",@"About us",@"Terms",@"Privacy",@"Sign Out"];
    
    standArray = @[@"dashboard_128",@"my_album_128",@"notification_128",@"membership_128",@"settings_128",@"support.png",@"about_90",@"terms_90",@"privacy_90",@"sign_out_90"];
    
    
    /*    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
     self.tableView.delegate = self;
     self.tableView.dataSource = self;
     self.tableView.opaque = NO;
     self.tableView.backgroundColor = [UIColor clearColor];
     
     self.tableView.tableHeaderView = ({
     
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
     
     
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
     imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
     imageView.image = [UIImage imageNamed:@"letter-m-icon-png-12.png"];
     imageView.layer.masksToBounds = YES;
     imageView.layer.cornerRadius = 50.0;
     imageView.layer.borderColor = [UIColor whiteColor].CGColor;
     imageView.layer.borderWidth = 1.5f;
     imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
     imageView.layer.shouldRasterize = YES;
     imageView.clipsToBounds = YES;
     
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
     label.text = @"Montage";
     label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
     label.backgroundColor = [UIColor clearColor];
     label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
     [label sizeToFit];
     label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
     
     /*        UIView *iView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
     
     iView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
     
     //        iView.backgroundColor = [UIColor greenColor];
     
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
     
     UIImage *img = [UIImage imageNamed:@"64-edit.png"];
     
     [button setBackgroundImage:img  forState:UIControlStateNormal];
     
     button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
     
     button.frame = CGRectMake(0, 40.0, 25, 25);
     
     //        view.backgroundColor = [UIColor blueColor];
     
     
     
     [view addSubview:imageView];
     
     [view addSubview:label];
     
     
     tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
     
     tapGestureRecognizer.numberOfTapsRequired = 1;
     
     
     [view addGestureRecognizer:tapGestureRecognizer];
     
     //        [view addSubview:iView];
     
     //        [iView addSubview:button];
     
     view;
     });*/
    
    
    
    NSString *proPic = [[NSUserDefaults standardUserDefaults]valueForKey:@"ProfilePic"];
    //
    //    self.profileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:proPic]]];
    //
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:proPic] placeholderImage:[UIImage imageNamed:@"image-icon"]];
    
    /*    if ([proPic isEqualToString:@"https://hypdra.com/user_profile_pic/uploads.jpg"])
     {
     [self.profileImage sd_setImageWithURL:[NSURL URLWithString:proPic] placeholderImage:[UIImage imageNamed:@"Person-placeholder"]];
     }
     else
     {
     [self.profileImage sd_setImageWithURL:[NSURL URLWithString:@"https://hypdra.com/user_profile_pic/uploads.jpg"] placeholderImage:[UIImage imageNamed:@"Person-placeholder"]];
     }*/
    
    self.userName.text =  [[NSUserDefaults standardUserDefaults]valueForKey:@"Profilename"];
    
    self.userEmailLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"Email_ID"];
    
    self.userEmailLabel.adjustsFontSizeToFitWidth=YES;
    
    self.tableViewDemo.bounces = false;
    
    self.tableViewDemo.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.toProfile addGestureRecognizer:tapGestureRecognizer];
    //[_profile_pic_superView removeConstraint:_ProfilePicHeightHighPrio];
    //_ProfilePicHeightHighPrio.active = YES;
//    _ProfilePicLowPrio.active = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812.0f)
            NSLog(@"iPhone X");
        _ProfilePicHeightHighPrio.priority = 250;
        [_profile_pic_superView layoutIfNeeded];
    }
    
    
    
   /* UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone) {
        
    }*/
}


- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    
    // if (IS_PAD)
    //    {
    //        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
    //
    //        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //        [vc awakeFromNib:@"contentController_14" arg:@"menuController"];
    //
    //        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //        [self presentViewController:vc animated:YES completion:NULL];
    //    }
    //    else
    //    {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_14" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    // }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    _Bool active = notificationSettings.types == UIUserNotificationTypeNone ? NO: YES;
    if(active)
        [mySwitch setOn:YES];
    else
        [mySwitch setOn:NO];
    
}


- (void)aMethod:(UIButton*)button
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    else
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

/*
 -(void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:YES];
 
 
 NSString *proPic = [[NSUserDefaults standardUserDefaults]valueForKey:@"ProfilePic"];
 
 [[SDImageCache sharedImageCache] removeImageForKey:proPic fromDisk:YES];
 
 }*/

-(void)viewDidAppear:(BOOL)animated{
    
    self.profile_pic_superView.layer.cornerRadius = self.profile_pic_superView.frame.size.width/2;
    self.profile_pic_superView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.profile_pic_superView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.profile_pic_superView.layer.shadowOpacity = 0.8f;
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    [self.profileImage.layer setMasksToBounds:YES];
    NSString *proPic = [[NSUserDefaults standardUserDefaults]valueForKey:@"ProfilePic"];
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:proPic] placeholderImage:[UIImage imageNamed:@"image-icon"]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.profileImage.image = chosenImage;
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    
    [self sendImage:imageData];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)sendImage : (NSData*)data
{
    if( [self setImageParams:data])
    {
        NSLog(@"Enter block");
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
         {
             NSLog(@"Response = %@",urlResponse);
         }];
        
        NSLog(@"Image Sent");
    }
    else
    {
        NSLog(@"Image Failed...");
    }
}


-(BOOL)setImageParams:(NSData *)imgData
{
    @try
    {
        if (imgData!=nil)
        {
            
            NSLog(@"Enter Image send");
            
            request = [NSMutableURLRequest new];
            request.timeoutInterval = 20.0;
            [request setURL:[NSURL URLWithString:URL]];
            [request setHTTPMethod:@"POST"];
            //[request setCachePolicy:NSURLCacheStorageNotAllowed];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            
            [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_profile_pic\"; filename=\"%@.jpg\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"After Values");
            [request setHTTPBody:body];
            NSLog(@"From Body");
            [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
            NSLog(@"After Content length");
            
            return TRUE;
            
        }
        else
        {
            return FALSE;
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Send Image Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Send Image Finally...");
    }
}




#pragma mark -
#pragma mark UITableView Delegate




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor =[UIColor whiteColor]; //[UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"FuturaT-Book" size:16];
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
 {
 if (sectionIndex == 0)
 return nil;
 
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
 view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
 
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
 label.text = @"Friends Online";
 label.font = [UIFont systemFontOfSize:15];
 label.textColor = [UIColor whiteColor];
 label.backgroundColor = [UIColor clearColor];
 [label sizeToFit];
 [view addSubview:label];
 
 return view;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
 {
 if (sectionIndex == 0)
 return 0;
 
 return 34;
 }*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    [tableView cellForRowAtIndexPath:indexPath].contentView.backgroundColor = [UIColor sideMenuCellBGColor];
    
    [[NSUserDefaults standardUserDefaults]setInteger:-1 forKey:@"SelectedIndex"];
    
    if (indexPath.row == 0)
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
        // [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (indexPath.row == 1)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    if (indexPath.row == 2)
    {
       // [tableView cellForRowAtIndexPath:indexPath].contentView.backgroundColor = [UIColor colorWithRed:96/255.0 green:92/255.0 blue:163/255.0 alpha:1];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    }
    
    if (indexPath.row == 3)
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    if(indexPath.row == 4)
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"content_Controller15" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    
    if (indexPath.row == 5)
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_9" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
    if (indexPath.row == 6)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMONavigationController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"contentController_10"];
        
        [self.frostedViewController setContentViewController:vc];//set Display1Controller's instance to the frostedViewController
        [self.frostedViewController hideMenuViewController]; //used to hide side menu
    }
    //    {
    //
    //
    //        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    //
    //        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //        [vc awakeFromNib:@"contentController_10" arg:@"menuController"];
    //
    //        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //        [self presentViewController:vc animated:YES completion:NULL];
    //
    //    }
    
    if (indexPath.row == 7)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_15" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    
    if (indexPath.row == 8)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_8" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    if (indexPath.row == 9)
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to sign out of your account ?" withTitle:@"Sign Out" withImage:[UIImage imageNamed:@"logout_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToSignOut";
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Sign out" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
        
    }
}

/*
 - (void)doSomeWorkWithProgress
 {
 //    self.canceled = NO;
 // This just increases the progress indicator in a loop.
 float progress = 0.0f;
 while (progress < 1.0f)
 {
 //        if (self.canceled) break;
 progress += 0.01f;
 dispatch_async(dispatch_get_main_queue(), ^{
 // Instead we could have also passed a reference to the HUD
 // to the HUD to myProgressTask as a method parameter.
 [MBProgressHUD HUDForView:self.view].progress = progress;
 });
 
 usleep(25000);
 }
 }*/

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuTableViewCell";
    
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    if(indexPath.row == [[NSUserDefaults standardUserDefaults]integerForKey:@"SelectedIndex"]){
        cell.contentView.backgroundColor =
        [UIColor sideMenuCellBGColor];
        
    }
    
    if(indexPath.row == 2){
        
        mySwitch = [[UISwitch alloc] init];
        mySwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
        [mySwitch setCenter:CGPointMake(cell.contentView.frame.size.width/1.6 , cell.frame.size.height/1.5)];
        [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:mySwitch];
        
         UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        _Bool active = notificationSettings.types == UIUserNotificationTypeNone ? NO: YES;
        if(active)
            [mySwitch setOn:YES];
        else
            [mySwitch setOn:NO];
    }
    
    if(indexPath.row==6)
    {
        UILabel *versionLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.menuOption.frame.origin.x+cell.menuOption.frame.size.width+85, 10, cell.frame.size.width/3, cell.frame.size.height/2)];
        
        //        UILabel *versionLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width/1.78, 5, cell.frame.size.width/3, cell.frame.size.height/2)];
        //
        versionLabel.text=@"Version";
        versionLabel.textColor=[UIColor whiteColor];
        versionLabel.font=[UIFont fontWithName:@"FuturaT-Book" size:16.0];
        [cell.contentView addSubview:versionLabel];
        
        UILabel *versionNumberLbl=[[UILabel alloc]initWithFrame:CGRectMake(cell.menuOption.frame.origin.x+cell.menuOption.frame.size.width+85, versionLabel.frame.size.height+10, cell.frame.size.width/3, cell.frame.size.height/2)];
        versionNumberLbl.text=@"1.00.01";
        versionNumberLbl.textColor=[UIColor whiteColor];
        versionNumberLbl.font=[UIFont fontWithName:@"FuturaT-Book" size:16.0];
        [cell.contentView addSubview:versionNumberLbl];
    }
    
    [cell.img setContentMode:UIViewContentModeScaleAspectFit];
    
    cell.img.image = [UIImage imageNamed:standArray[indexPath.row]];
    
    //    if (indexPath.section == 0)
    //    {
    cell.menuOption.textColor = [UIColor whiteColor];
    
    cell.menuOption.text = titles[indexPath.row];
    /*    }
     else
     {
     //        NSArray *titles = @[@"John Appleseed", @"John Doe", @"Test User"];
     //        cell.textLabel.text = titles[indexPath.row];
     }*/
    
    return cell;
}

- (void)changeSwitch:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
    if([sender isOn]){
        [mySwitch setOn:YES];
        NSLog(@"Switch is ON");
    } else{
        [mySwitch setOn:NO];

        NSLog(@"Switch is OFF");
    }
    

}

- (IBAction)pickProfile:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToSignOut"]){

    }
    [alertView hide];
    alertView = nil;
}

- (void)agreeCLicked:(CustomPopUp *)alertView {
    
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToSignOut"]){

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PageSelectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
        
        vc.signOut = true;
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    [alertView hide];
    alertView = nil;
    
}

@end
