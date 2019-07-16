//
//  AIWorkSpaceViewController.m
//  Hypdra
//
//  Created by Mac on 12/26/18.
//  Copyright © 2018 sssn. All rights reserved.
//
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "AIWorkSpaceViewController.h"
#import "DEMORootViewController.h"
@import InMobiSDK;
@import GoogleMobileAds;

#define INMOBI_INTERSTITIAL_PLACEMENT   1545439909314

@interface AIWorkSpaceViewController ()<ClickDelegates,UIImagePickerControllerDelegate,GADRewardBasedVideoAdDelegate,UnityAdsDelegate>{
  NSMutableURLRequest *request;
    NSString *user_id,*ActionType,*Action_Id;
    MBProgressHUD *hud;
    UIImage *chosenImage;
    NSMutableDictionary *AIStyleDic;
}

@end

@implementation AIWorkSpaceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    user_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_ID"];
    [self.Choose_Imag_outlet.superview.layer setCornerRadius:5];
    [self.Choose_Imag_outlet.superview.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.Choose_Imag_outlet.superview.layer setShadowRadius:4.0f];
    [self.Choose_Imag_outlet.superview.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.Choose_Imag_outlet.superview.layer setShadowOpacity:1.0f];
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    [self.Choose_Imag_outlet.layer setCornerRadius:5];
    
    [self.Choose_Imag_outlet.layer setBorderColor:[[UIColor colorWithRed:78.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1] CGColor] ];
    [self.Choose_Imag_outlet.layer setMasksToBounds:YES];
    
    [self.Choose_Style_outlet.superview.layer setCornerRadius:5];
    [self.Choose_Style_outlet.superview.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.Choose_Style_outlet.superview.layer setShadowRadius:4.0f];
    [self.Choose_Style_outlet.superview.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.Choose_Style_outlet.superview.layer setShadowOpacity:1.0f];
    [self.Choose_Style_outlet.layer setCornerRadius:5];
    [self.Choose_Style_outlet.layer setBorderColor:[[UIColor colorWithRed:78.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1] CGColor] ];
    [self.Choose_Style_outlet.layer setMasksToBounds:YES];
    [self checkUserDefaults];
}

-(void)checkUserDefaults{

    AIStyleDic=[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"AIStyleDic"]]mutableCopy];
    if(!(AIStyleDic == nil || [AIStyleDic isEqual:[NSNull null]])){
    NSURL *imageURL = [NSURL URLWithString:[AIStyleDic objectForKey:@"Preview"]];
    [_Choose_Style_outlet setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]] forState:UIControlStateNormal];
        _choose_your_style_Lbl.text = @"";
    //_Choose_Style_outlet.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    _Choose_Imag_outlet.clipsToBounds = true;
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AIImage"];
        if(imageData != nil){
            chosenImage =  [UIImage imageWithData:imageData];
            [_Choose_Imag_outlet setImage:chosenImage forState:UIControlStateNormal];
            __choose_Your_Image_Lbl.text =@"";
            //_Choose_Imag_outlet.imageView.contentMode = UIViewContentModeScaleToFill;
            _Choose_Imag_outlet.clipsToBounds = true;
        }
        
    

        
    }
}


- (IBAction)Choose_Img_actn:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose the Photo type" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:picker animated:YES completion:nil];
        //button click event
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [alert dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [alert addAction:gallery];
    [alert addAction:camera];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}

- (IBAction)Choose_Style_actn:(id)sender {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    [vc awakeFromNib:@"contentController_24" arg:@"menuController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
   chosenImage = info[UIImagePickerControllerOriginalImage];
    //_Choose_Imag_outlet.contentMode = UIViewContentModeScaleAspectFit;
    [_Choose_Imag_outlet setImage:chosenImage forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(chosenImage) forKey:@"AIImage"];

    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendImageToServer:(UIImage *)img
{

    NSLog(@"");
    NSData *data = UIImagePNGRepresentation(img);
    if([self setImageParams:data])
    {
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
         {
             NSLog(@"added successfully:%@",data);
             NSLog(@"URLResponse:%@",urlResponse);

             NSDictionary *responseObject=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
             NSLog(@"response for image:%@",responseObject);
             NSDictionary *dic = responseObject;
             NSString *status = [dic objectForKey:@"result"];
             if([status intValue] == 1){
                 [_Choose_Imag_outlet setImage:nil forState:UIControlStateNormal];
                 [_Choose_Style_outlet setImage:nil forState:UIControlStateNormal];
                 CustomPopUp *popUp = [CustomPopUp new];
                 popUp.accessibilityHint=@"AISUCCESS";
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your art is getting generated. It will be placed on your album in a moment!" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                 popUp.okay.backgroundColor = [UIColor lightGreen];
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
                 
             }
             [hud hideAnimated:YES];
         }];
        
    }else{
        [hud hideAnimated:YES];

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
            [request setURL:[NSURL URLWithString:@"https://www.hypdra.com/NeuralArt/IOS_AI_Art.php"]];
            [request setHTTPMethod:@"POST"];
            //[request setCachePolicy:NSURLCacheStorageNotAllowed];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            
            [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_image_style\"; filename=\"%@.png\"\r\n", @"Uploaded_file"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];

            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ActionType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[ActionType dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ActionID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[Action_Id dataUsingEncoding:NSUTF8StringEncoding]];
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
- (IBAction)Apply_actn:(id)sender {
   
    Action_Id = (NSString *)[AIStyleDic objectForKey:@"id"];
    ActionType = (NSString *)[AIStyleDic objectForKey:@"action_type"];
    if(!(Action_Id == nil || [Action_Id isEqual:[NSNull null]])){
        if(!(ActionType == nil || [ActionType isEqual:[NSNull null]])){
            if(chosenImage != nil){
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AIStyleDic"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AIImage"];
                hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self sendImageToServer:chosenImage];
            }else{
                CustomPopUp *popUp = [CustomPopUp new];
                [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please Choose an Image" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                popUp.okay.backgroundColor = [UIColor lightGreen];
                popUp.agreeBtn.hidden = YES;
                popUp.cancelBtn.hidden = YES;
                popUp.inputTextField.hidden = YES;
                [popUp show];
            }
        }
        
    }else{
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please Choose the Style" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
}
- (void)startGame
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (![[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [self requestRewardedVideo];
    }
}
- (void)requestRewardedVideo
{
    GADRequest *request = [GADRequest request];
    
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                           withAdUnitID:@"ca-app-pub-5459327557802742/7998640371"];
    
}

#pragma mark GADRewardBasedVideoAdDelegate implementation

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Rewarded video adapter class name: %@", rewardBasedVideoAd.adNetworkClassName);
    
    //    [activityIndicatorView stopAnimating];
    
    [hud hideAnimated:YES];
    
    if ([[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
    else
    {
        [[[UIAlertView alloc]
          initWithTitle:@"Interstitial not ready"
          message:@"The interstitial didn't finish " @"loading or failed to load"
          delegate:self
          cancelButtonTitle:@"Drat"
          otherButtonTitles:nil] show];
    }
    
    NSLog(@"Reward based video ad is received.");
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
   [self.tabBarController setSelectedIndex:1];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward
{
    
    NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf", reward.type,[reward.amount doubleValue]];
    
    NSLog(@"%@", rewardMessage);
    
    
    //  [self reduecePoints];
    [self.tabBarController setSelectedIndex:1];
}
- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad will leave application.");
    
    [hud hideAnimated:YES];
    [self.tabBarController setSelectedIndex:1];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error
{
    NSLog(@"Reward based video ad failed to load.");
    
    NSString *rCount = [NSString stringWithFormat:@"Try Again..."];
    
    [hud hideAnimated:YES];
    [self.tabBarController setSelectedIndex:1];
    // [self.navigationController.view makeToast:rCount];
    
}
-(void) okClicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@"AISUCCESS"])
    {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
             [self startGame];
        }else{
            [self.tabBarController setSelectedIndex:1];
        }
       
    }
    
    
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}
-(void)interstitialDidReceiveAd:(IMInterstitial *)interstitial {
    NSLog(@"InMobi Interstitial received an ad");
}
/**
 * Notifies the delegate that the interstitial has finished loading and can be shown instantly.
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial {
    NSLog(@"InMobi Interstitial finished loading");
    
}
/**
 * Notifies the delegate that the interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error {
    NSLog(@"InMobi Interstitial failed to load with error : %@", error);
    [self startGame];
}

-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    NSLog(@"InMobi Interstitial completed rewarded action. Rewards : %@", rewards);
    
    
}

/**
 * Notifies the delegate that the interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial {
    
    NSLog(@"InMobi Interstitial will be dismissed");
    self.interstitial = [[IMInterstitial alloc] initWithPlacementId:INMOBI_INTERSTITIAL_PLACEMENT delegate:self];
    [self.interstitial load];
    
    
    //[self reduecePoints];
}

/**
 * Notifies the delegate that the interstitial has been dismissed.
 */
-(void)interstitialDidDismiss:(IMInterstitial*)interstitial {
    NSLog(@"InMobi Interstitial has been dismissed");
}

//Unity Ad's Delegate

- (void)unityAdsReady:(NSString *)placementId{
    NSLog(@"Unity ad is ready");
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    
    NSLog(@"Unity error:%ld",(long)error);
    //[self startGame];
}

- (void)unityAdsDidStart:(NSString *)placementId{
    NSLog(@"Unity Started:");
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
    NSLog(@"Unity ads did finished");
    
    
    //[self reduecePoints];
    
}
@end
