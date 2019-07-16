//
//  MyStyleVC.m
//  Hypdra
//
//  Created by Mac on 12/26/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "MyStyleVC.h"
#import "AdvanceMyImagesCell.h"
#import "DEMORootViewController.h"
#import "UIImageView+WebCache.h"
#import <ImageIO/ImageIO.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "TestKit.h"
@import InMobiSDK;
@import GoogleMobileAds;
#import <Lottie/Lottie.h>


#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define INMOBI_INTERSTITIAL_PLACEMENT   1545439909314


#define URL @"https://www.hypdra.com/api/api.php?rquest=user_style_image"

@interface MyStyleVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ClickDelegates,UIImagePickerControllerDelegate,GADRewardBasedVideoAdDelegate,UnityAdsDelegate>{

    NSMutableArray *finalArray,*OnlyImages,*shareArray;
    NSString *user_id;
    AdvanceMyImagesCell *cell;
    MBProgressHUD *hud,*hud_1;
    LOTAnimationView *animationView;

    NSString *creditPoints;
    NSMutableURLRequest *request;
}

@end

@implementation MyStyleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    creditPoints =(NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:@"credit_points"];
    self.available_credits_lbl.text =[NSString stringWithFormat:@"Available Credits: %@", creditPoints];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    animationView = [LOTAnimationView animationNamed:@"loading_h"];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    [animationView setCenter:self.view.center];
    animationView.loopAnimation = YES;

    
    [self.collectionView setCollectionViewLayout:flowLayout];
self.collectionView.contentInset=UIEdgeInsetsMake(15, 15, 15, 15);
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    [self getImages];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openGallery:)
                                                 name:@"UploadOneAIStyle" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
//    [animationView removeFromSuperview];
//    [_BlurView removeFromSuperview];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UploadOneAIStyle" object:nil];
}
- (void)openGallery:(NSNotification *)note{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
    _purchaseView.hidden = NO;
    _blurView.hidden = NO;
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
-(void)getImages
{
    @try
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=user_styles";
        NSDictionary *parameters = @{@"User_id":user_id,@"lang":@"iOS"};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8",@"application/json", nil];
        manager.responseSerializer = responseSerializer;
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSLog(@"ImageViewResponse == %@",responseObject);

                  NSMutableDictionary *response=responseObject;
                  
                  NSLog(@"Image Response %@",response);

                  finalArray = [[NSMutableArray alloc]init];
                 NSString *status = [response objectForKey:@"status"];
                  if ([status isEqualToString:@"True"])
                  {
                  NSArray *statusArray = [response objectForKey:@"Styles"];
                  
                  NSDictionary *stsDict = [statusArray objectAtIndex:0];
                  
                  NSString *status = [stsDict objectForKey:@"Preview"];
                      finalArray = [statusArray mutableCopy];
    NSLog(@"Final Array in uploadimg:%@",finalArray);
                      if([finalArray count] == 0)
                      {

                      }
                      else
                      {
                    dispatch_async(dispatch_get_main_queue(), ^{
                              
                              [self.collectionView reloadData];
                          });
                          
                          [hud hideAnimated:YES];
                      }
                  }
                  else
                  {
                      NSLog(@"No Image Found");
                      [hud hideAnimated:YES];
                  }
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  [hud hideAnimated:YES];
              }
              
          }]resume];
    }
    @catch (NSException *exception)
    {
        NSLog(@"img Catch:%@",exception);
    }
    @finally
    {
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [finalArray count];
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"AdvanceMyImagesCell";
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth = 0.2f;
    cell.alpha = 1.0;
    NSURL *imageURL = [[finalArray objectAtIndex:indexPath.row]objectForKey:@"Image_Path"];
    
    //fileURLWithPath:DocDir];
    
    [cell.img sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
    // cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-border.png"]];
    
    
    cell.contentView.layer.cornerRadius = 12;
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.layer.borderWidth = 2;
    cell.contentView.layer.borderColor = [[UIColor clearColor]CGColor];
    cell.layer.shadowRadius = 2;
    cell.layer.cornerRadius = 12;
    cell.layer.masksToBounds = NO;
    [[cell layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    
    [[cell layer] setShadowOffset:CGSizeMake(0,2)];
    [[cell layer] setShadowOpacity:1];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:12];
    [[cell layer] setShadowPath:[path CGPath]];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   NSDictionary *dic =[finalArray objectAtIndex:indexPath.row];
    NSMutableDictionary *finalDic = [dic mutableCopy];
    [finalDic setValue:@"2" forKey:@"action_type"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:dic]  forKey:@"AIStyleDic"];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_23" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake((collectionView.frame.size.width/3)-20, (collectionView.frame.size.width/3)-20);
    }
    else
    {
        return CGSizeMake((collectionView.frame.size.width/2)-20, (collectionView.frame.size.width/2)-20);
    }
}

- (IBAction)Add_btn:(id)sender {
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        _purchaseView.hidden = NO;
        _blurView.hidden = NO;
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadOneAIStyle" object:nil];
    }
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self sendImageToServer:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    _purchaseView.hidden = YES;
    _blurView.hidden = YES;
}

-(void)sendImageToServer:(UIImage *)img
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
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
             NSString *status = [dic objectForKey:@"status"];
             if( [status isEqualToString:@"True"]){
                 
                 CustomPopUp *popUp = [CustomPopUp new];
                 
                     [popUp initAlertwithParent:self withDelegate:self withMsg:@"Image has been uploaded successfully" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                 popUp.okay.backgroundColor = [UIColor lightGreen];
                 popUp.accessibilityHint =@"ImageUploadedSuccess";
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
                 
                 [hud hideAnimated:YES];
//                 [animationView removeFromSuperview];
//                 [_BlurView removeFromSuperview];

                [self getImages];
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:finalArray.count-1 inSection:0];
                 
                 [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                 
             }
         }];
    }else{

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
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_style_pic\"; filename=\"%@.png\"\r\n", @"Uploaded_file"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];
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

- (IBAction)close_actn:(id)sender {
    _purchaseView.hidden = YES;
    _blurView.hidden = YES;
}

- (IBAction)Redeem_actn:(id)sender {
    if([creditPoints intValue] >= 30)
    {
//        purchase_type=@"3";
//        [self updateUnlockPayment];
        [self reduecePoints];
    }
    else
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have enough Credit Points to upload image" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
}

- (IBAction)pay_actn:(id)sender {
    
    [TestKit setcFrom:@"UploadOneAIStyle"];
    [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.one.ai.style"];
}
-(void)reduecePoints
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer = responseSerializer;
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=update_points";
    
    NSDictionary *params = @{@"User_ID":user_id,@"operation":@"minus",@"points":@"30",@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json minutes Reward Response:%@",responseObject);
         
         creditPoints=[responseObject objectForKey:@"credit_points"];
         
         self.available_credits_lbl.text=[NSString stringWithFormat:@"Available Credits: %@", creditPoints];
         
         [[NSUserDefaults standardUserDefaults]setObject:creditPoints forKey:@"credit_points"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadOneAIStyle" object:nil];
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
}
- (IBAction)watchAddVideo_actn:(id)sender {
    [self startGame];
}
- (void)startGame
{
    
    hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
    
    [hud_1 hideAnimated:YES];
    
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
    NSLog(@"Reward based video ad is closed.");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadOneAIStyle" object:nil];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward
{
    
    NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf", reward.type,[reward.amount doubleValue]];
    
    NSLog(@"%@", rewardMessage);
    
   
  //  [self reduecePoints];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadOneAIStyle" object:nil];
}
- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad will leave application.");
    
    [hud_1 hideAnimated:YES];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error
{
    NSLog(@"Reward based video ad failed to load.");
    
    NSString *rCount = [NSString stringWithFormat:@"Try Again..."];
    
    [hud_1 hideAnimated:YES];
    
   // [self.navigationController.view makeToast:rCount];
    
}
- (IBAction)upgrade_actn:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}
-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"BoxLoginFailed"]){
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ImageUploadedSuccess"]){
        
        
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
    
}
@end
