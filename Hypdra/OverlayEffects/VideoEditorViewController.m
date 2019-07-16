//
//  VideoEditorViewController.m
//  Montage
//
//  Created by Srinivasan on 23/10/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "VideoEditorViewController.h"
#import "OverlayEffectViewController.h"
#import "AFNetworking.h"
#import "DEMORootViewController.h"
#import "MBProgressHUD.h"
#import <AVKit/AVKit.h>
#import "SJVideoPlayer.h"
#import <Masonry.h>
#import "VideosViewController.h"
#import "VideoEffectsViewController.h"
#import "EditVideoEditorViewController.h"
#import "TrimViewController.h"
#import "SwipeBack.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "JWGCircleCounter.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface VideoEditorViewController ()<UIGestureRecognizerDelegate,ClickDelegates>
{
    MBProgressHUD *hud;
    NSString *videoOverlayPath,*totalDuration;
    JWGCircleCounter *circleCounter;
    int totalSeconds;
    
}

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;

@end

@implementation VideoEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled=NO;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        self.editTop.constant=-20;
        self.effectTop.constant=-20;
        self.trimTop.constant=-20;
        self.overlayTop.constant=-20;
        
    }
    self.bgView.layer.cornerRadius=self.bgView.frame.size.width/2;
    
    [self setShadow:self.editOutlet];
    [self setShadow:self.overlayOutlet];
    [self setShadow:self.effectOutlet];
    [self setShadow:self.trimOutlet];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setShadowImage:[UIImage alloc]]
    ;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _user_id = [defaults valueForKey:@"USER_ID"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewHide) name:@"viewhide" object:nil];
    
}

-(void)bufferCircularProgress
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"bufferCircularProgress"];
    [circleCounter stop];
}

-(void)resumeCircularProgress
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"resumeCircularProgress"];
    
    [circleCounter resume];
}

-(void)showCircularProgress
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"showCircularProgress"];
    
    NSArray *components = [totalDuration componentsSeparatedByString:@":"];
    
    // NSArray *components = [[[NSUserDefaults standardUserDefaults]objectForKey:@"durationTime"]componentsSeparatedByString:@":"];
    
    int hours,minutes,seconds;
    
    if(components.count==2)
    {
        hours=0;
        minutes=[[components objectAtIndex:0] intValue];
        seconds=[[components objectAtIndex:1]intValue];
    }
    
    else
    {
        hours=[[components objectAtIndex:0] intValue];
        minutes=[[components objectAtIndex:1] intValue];
        seconds=[[components objectAtIndex:2]intValue];
    }
    
    @try
    {
        totalSeconds=(hours*3600)+(minutes*60)+seconds;
        
        [circleCounter startWithSeconds:totalSeconds];
        
        //if(totalSeconds)
        // [circleCounter startWithSeconds:totalSeconds];
        
        //        else
        //            [circleCounter startWithSeconds:2];
        //
    }@catch(NSException *exception)
    {
        
    }
    
}

-(void)setShadow:(UIButton*)button
{
    button.layer.shadowRadius = 1.5f;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    button.layer.shadowOpacity = 0.5f;
    button.layer.masksToBounds = NO;
    [[button imageView] setContentMode: UIViewContentModeScaleAspectFit];
    //[button setImage:[UIImage imageNamed:stretchImage] forState:UIControlStateNormal];
}

-(void)timeUpdate:(NSNotification *)notify
{
    NSTimeInterval time =[SJVideoPlayer sharedPlayer].currentTime;
    NSLog(@"my time %f",time);
    
    //   int minutes = floor(time/60);
    //   int seconds = round(time - minutes * 60);
    //   int currentSec = (minutes*60)+seconds;
    
    NSDictionary* userInfo = notify.userInfo;
    totalDuration =  [userInfo valueForKey:@"DurationTime"];
    NSLog(@"The tot durrr is %@",totalDuration);
    
}

-(void)viewHide
{
    self.viewHiding=@"second";
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if([self.viewHiding isEqualToString:@"first"])
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self getVideoURL];
    }
    
    if([self.viewHiding isEqualToString:@"second"])
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"If you want to add more properties for your Video ?" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"AppliedEffects";
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        popUp.outSideTap = NO;
        [popUp show];
    }
    
    [self loadVideos];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeUpdate:)
                                                 name:@"currentTime"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCircularProgress)
                                                 name:@"showCircularProgress"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bufferCircularProgress)
                                                 name:@"bufferCircularProgress"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeCircularProgress)
                                                 name:@"resumeCircularProgress"
                                               object:nil];
    
}

-(void)loadVideos
{
    videoOverlayPath =[[NSUserDefaults standardUserDefaults]
                       stringForKey:@"videoPathValue"];
    
    [self loadVideoPlayer];
    
    [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:videoOverlayPath] jumpedToTime:self.currentTime];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    
    [[SJVideoPlayer sharedPlayer] stop];
}

-(void)loadVideoPlayer
{
    @try
    {
        SJVideoPlayer *player = [SJVideoPlayer sharedPlayer];
        [player.presentView addSubview:player.control.view];
        player.control.isCircularView = YES;
        UIView *playerView=[SJVideoPlayer sharedPlayer].view;
        player.control.maskLayer = [CALayer layer];
        player.control.maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        // maskLayer.frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
        playerView.layer.mask =  player.control.maskLayer;
        
        CGFloat diameter = MIN(playerView.frame.size.width, playerView.frame.size.height) * 0.5;
        
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer: player.control.player];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = CGRectMake((playerView.frame.size.width - diameter) / 2,
                                 (playerView.frame.size.height - diameter) / 2,
                                 diameter, diameter);
        
        layer.cornerRadius = diameter / 2;
        layer.masksToBounds = YES;
        
        [playerView.superview.layer addSublayer:layer];
        
        [player.presentView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.edges.offset(0);
         }];
        
        [player.control.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.edges.offset(0);
         }];
        
        // circleCounter = [[JWGCircleCounter alloc] initWithFrame:CGRectMake(15,-5,300,300)];
        
//        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
//            circleCounter = [[JWGCircleCounter alloc] initWithFrame:CGRectMake(25,-3,self.closeView.frame.size.width-50,self.closeView.frame.size.height)];
        
//        else
//            circleCounter = [[JWGCircleCounter alloc] initWithFrame:CGRectMake(114,-5,self.closeView.frame.size.width-220,self.closeView.frame.size.height)];
        
        //[self.closeView addSubview:circleCounter];
        [self.closeView addSubview:player.view];
        [self.closeView.layer setCornerRadius:self.closeView.frame.size.width/2];
        [self.closeView.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.closeView.layer setShadowRadius:2.0f];
        [self.closeView.layer setShadowOffset:CGSizeMake(0, 0.0)];
        [self.closeView.layer setShadowOpacity:0.3f];
        if (IS_PAD)
        {
            [player.view mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.top.offset(0);
                 make.leading.trailing.offset(0);
                 make.height.equalTo(player.view.mas_width).multipliedBy(10.0 / 15);
             }
             ];
        }
        else
        {
            [player.view mas_makeConstraints:^(MASConstraintMaker *make)
             {
                 make.top.offset(0);
                 make.leading.trailing.offset(0);
                 //make.height.equalTo(player.view.mas_width).multipliedBy(9.0/15);
                 make.height.equalTo(player.view.mas_width).multipliedBy(13.0/15);
                 
             }];
        }
        
#pragma mark - Setting Player
        
        [player playerSettings:^(SJVideoPlayerSettings * _Nonnull settings)
         {
             settings.traceColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                   green:arc4random() % 256 / 255.0
                                                    blue:arc4random() % 256 / 255.0
                                                   alpha:1];
             settings.trackColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                   green:arc4random() % 256 / 255.0
                                                    blue:arc4random() % 256 / 255.0
                                                   alpha:1];
             settings.bufferColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                    green:arc4random() % 256 / 255.0
                                                     blue:arc4random() % 256 / 255.0
                                                    alpha:1];
             settings.replayBtnTitle = @"Replay";
             settings.replayBtnFontSize = 12;
         }];
        
#pragma mark - 1 Level More Settings
        
        SJVideoPlayerMoreSetting.titleFontSize = 12;
        
        SJVideoPlayerMoreSetting *model0 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_like_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
            NSLog(@"clicked %@", model.title);
            [[SJVideoPlayer sharedPlayer] showTitle:@"Title"];
        }];
        
        
        SJVideoPlayerMoreSetting *model2 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_favorite_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
            NSLog(@"clicked %@", model.title);
            [[SJVideoPlayer sharedPlayer] showTitle:model.title];
        }];
        
        
#pragma mark - 2 Level More Settings
        
        SJVideoPlayerMoreSettingTwoSetting *twoS0 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:nil clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
            [[SJVideoPlayer sharedPlayer] showTitle:model.title];
        }];
        
        SJVideoPlayerMoreSettingTwoSetting *twoS1 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:nil clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
            [[SJVideoPlayer sharedPlayer] showTitle:model.title];
        }];
        
#pragma mark - 1 Level More Settings
        
        SJVideoPlayerMoreSetting *model1 =
        [[SJVideoPlayerMoreSetting alloc] initWithTitle:@""
                                                  image:[UIImage imageNamed:@"db_audio_play_download_n"]
                                         showTowSetting:YES
                                     twoSettingTopTitle:@""
                                        twoSettingItems:@[twoS0, twoS1]
                                        clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {}];
        
        
#pragma mark - 2 Level More Settings
        
        SJVideoPlayerMoreSettingTwoSetting.topTitleFontSize = 14;
        
        SJVideoPlayerMoreSettingTwoSetting *twoSetting0 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"QQ" image:[UIImage imageNamed:@"db_login_qq"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model)
                                                           {
                                                               [[SJVideoPlayer sharedPlayer] showTitle:model.title];
                                                           }];
        
        SJVideoPlayerMoreSettingTwoSetting *twoSetting1 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_login_weibo"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
            [[SJVideoPlayer sharedPlayer] showTitle:model.title];
        }];
        
        SJVideoPlayerMoreSettingTwoSetting *twoSetting2 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_login_weixin"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
            [[SJVideoPlayer sharedPlayer] showTitle:model.title];
        }];
        
        SJVideoPlayerMoreSetting *model3 =
        [[SJVideoPlayerMoreSetting alloc] initWithTitle:@""
                                                  image:[UIImage imageNamed:@"db_audio_play_share_n"]
                                         showTowSetting:YES
                                     twoSettingTopTitle:@""
                                        twoSettingItems:@[twoSetting0, twoSetting1, twoSetting2]  // 2级 Settings
                                        clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {}];
        
        [player moreSettings:^(NSMutableArray<SJVideoPlayerMoreSetting *> * _Nonnull moreSettings)
         {
             
         }];
    }
    @catch(NSException *exception)
    {
        
    }
}


-(void)getVideoURL
{
    @try
    {
        NSDictionary *parameters =@{@"user_id":_user_id,@"lang":@"iOS",@"image_id":_finalVideoID};
        
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=view_particular_video_path";
        
        NSError *error;      // Initialize NSError
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              
              if (!error)
              {
                  NSLog(@"The res is %@",responseObject);
                  NSMutableArray *responseArray=[responseObject objectForKey:@"Response_array"];
                  NSString *resStatus=[[responseArray objectAtIndex:0] objectForKey:@"msg"];
                  
                  if([resStatus isEqualToString:@"Found"])
                  {
                      NSMutableArray *MusicArray = [responseObject objectForKey:@"view_particular_video_path"];
                      
                      for(NSDictionary *imageDic in MusicArray)
                      {
                          _videopath = [imageDic objectForKey:@"Image_Path"];
                      }
                      
                      [[NSUserDefaults standardUserDefaults] setObject:_videopath forKey:@"videoPathValue"];
                      
                      [self loadVideos];
                      
                      
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                      NSURL *url = [[NSURL alloc] initWithString:_videopath];
                      UIImage *thumbnailImage = [self generateThumbImage:url];
                      UIImage *blurImage=[self blurredImageWithImage:thumbnailImage];
                      
                      [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(blurImage) forKey:@"blurimage"];
                      
                      [hud hideAnimated:YES afterDelay:1.0];
                  }
                  else
                  {
                      //                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Try Again" message:@"Couldn't find a video" preferredStyle:UIAlertControllerStyleAlert];
                      //
                      //                      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                      //                          [alertController addAction:ok];
                      //
                      //                      [self presentViewController:alertController animated:YES completion:nil];
                      
                      CustomPopUp *popUp = [CustomPopUp new];
                      [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try Again video not found" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                      popUp.okay.backgroundColor = [UIColor navyBlue];
                      popUp.agreeBtn.hidden = YES;
                      popUp.cancelBtn.hidden = YES;
                      popUp.inputTextField.hidden = YES;
                      [popUp show];
                      [hud hideAnimated:YES];
                  }
              }
              else
              {
                  NSLog(@"Error123: %@, %@, %@", error, response,  responseObject);
                  NSLog(@"Error : %@", error);
                  
                  //                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Try Again" message:@"Couldn't connect to server " preferredStyle:UIAlertControllerStyleAlert];
                  //
                  //                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                  //                  [alertController addAction:ok];
                  //
                  //                  [self presentViewController:alertController animated:YES completion:nil];
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor navyBlue];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  [hud hideAnimated:YES];
                  
              }
          }]resume];
        
    }
    @catch (NSException *exception)
    {
    }
    
}

- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage
{
    NSData *pictureData = UIImagePNGRepresentation(sourceImage);
    
    CGImageSourceRef BlurImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)pictureData, NULL);
    CFDictionaryRef BlurOptions = (__bridge CFDictionaryRef) @{
                                                               (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                               (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                               (id) kCGImageSourceThumbnailMaxPixelSize : @(25)
                                                               };
    // Generate the thumbnail
    CGImageRef Blurthumbnail = CGImageSourceCreateThumbnailAtIndex(BlurImageSource, 0, BlurOptions);
    if (NULL != BlurImageSource)
        CFRelease(BlurImageSource);
    
    UIImage* scaledBlurImage = [UIImage imageWithCGImage:Blurthumbnail];
    
    return scaledBlurImage;
}

-(UIImage *)generateThumbImage : (NSURL *)filepath
{
    NSURL *url = filepath;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 1000;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    return thumbnail;
}

- (IBAction)backAction:(id)sender
{
    
    NSString *valueToSave = @"videoPage";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"videoIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"videoPathValue"];
    
    NSArray *array = [self.navigationController viewControllers];
    
    [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
    
    /*
     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
     
     DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
     
     [vc awakeFromNib:@"contentController_2" arg:@"menuController"];
     
     vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     
     [self presentViewController:vc animated:YES completion:NULL];
     */
}


-(void)applyTap:(UITapGestureRecognizer *)recognizer
{
    
}

-(void) navigateToApply:(UIGestureRecognizer*)recognizer
{}

//- (IBAction)applyAction:(id)sender
//{
//    @try
//    {
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:@"saveToUpload"
//             object:self];
//
//        NSLog(@"tapped");
//
//        NSString *valueToSave = @"videoPage";
//
//        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"videoIndex"];
//
//        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"didSelectTap"];
//
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
//
//        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//        [vc awakeFromNib:@"contentController_2" arg:@"menuController"];
//
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//        [self presentViewController:vc animated:YES completion:NULL];
//
//    }
//    @catch (NSException *exception)
//    {
//        NSLog(@"excepp %@",exception);
//    }
//
//}

-(void)EditedLocalValue
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/tempVideo1/"];
    
    if([fileManager fileExistsAtPath:appDir])
    {
        NSLog([fileManager removeItemAtPath:appDir error:&error]?@"deleted":@"not deleted");
    }
    else{
        NSLog(@"file doesn't exist");
    }
    
    if([_isFromTrimVC isEqualToString:@"yes"])
    {
        _videopath=[[NSUserDefaults standardUserDefaults]stringForKey:@"videoPathValue"];
        NSLog(@"Trim video path:%@",_videopath);
    }
    [self doSomeNetworkWorkWithProgress];
    
}

- (void)doSomeNetworkWorkWithProgress
{
    
    NSLog(@"doSomeNetworkWorkWithProgress = %@",_videopath);
    
    NSLog(@"cropVideoURL = %@",_videopath);
    
    if (_videopath == nil)
    {
        
        NSLog(@"cropVideoURL NULL");
        
        //        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.BlurView];
        //        [hud hideAnimated:YES];
        
        //        [hud hideAnimated:YES];
        
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Video Not Found" preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
        //                                   {
        //                                       NSLog(@"OK");
        //
        //                                       //            [hud hideAnimated:YES];
        //                                       //            [_BlurView removeFromSuperview];
        //                                   }];
        //
        //        [alertController addAction:okAction];
        //        [self presentViewController:alertController animated: YES completion: nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Video Not Found" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        NSURL *audioURL;
        
        //        if([_isFromTrimVC isEqualToString:@"yes"])
        //        {
        //            audioURL=[NSURL fileURLWithPath:_videopath];
        //        }
        //        else
        //        {
        audioURL = [NSURL URLWithString:_videopath];
        // }
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:audioURL];
        [task resume];
        
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // Do something with the data at location...
    NSLog(@"location:%@",location);
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        //        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //        hud.customView = imageView;
        //        hud.mode = MBProgressHUDModeCustomView;
        //        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:3.f];
    });
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    //getting application's document directory path
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    //adding a new folder to the documents directory path
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/tempVideo1/"];
    
    //Checking for directory existence and creating if not already exists
    if(![fileManager fileExistsAtPath:appDir])
    {
        [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    //retrieving the filename from the response and appending it again to the path
    //this path "appDir" will be used as the target path
    //        appDir =  [appDir stringByAppendingFormat:@"/%@",[[downloadTask response] suggestedFilename]];
    
    appDir =  [appDir stringByAppendingPathComponent:@"samplevideo.mp4"];
    
    //checking for file existence and deleting if already present.
    /*        if([fileManager fileExistsAtPath:appDir])
     {
     NSLog([fileManager removeItemAtPath:appDir error:&error]?@"deleted":@"not deleted");
     }*/
    
    NSLog(@"AppDir = %@",appDir);
    
    //moving the file from temp location to app's own directory
    BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:appDir error:&error];
    
    NSLog(fileCopied ? @"Yes" : @"No");
    
    [[NSUserDefaults standardUserDefaults]setObject:appDir forKey:@"appDir"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    TrimViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TrimVideo"];
    
    //  vc.currentVideoID = _finalVideoID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
   
    if([alertView.accessibilityHint isEqualToString:@"AppliedEffects"])
    {
        [alertView hide];
        alertView = nil;
        
        [self loadingHud];
    }
    
    [alertView hide];
    alertView = nil;
    
}

- (void)agreeCLicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView = nil;
}

-(void)loadingHud
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorOnMainThread:@selector(saveToUpload) withObject:nil waitUntilDone:NO];
    
}

-(void)saveToUpload
{
    @try
    {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"saveToUpload"
         object:self];
        
        NSLog(@"tapped");
        
        NSString *valueToSave = @"videoPage";
        
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"videoIndex"];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"didSelectTap"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSArray *array = [self.navigationController viewControllers];
        
        [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
        
        [hud hideAnimated:YES];
        self.applyTopView.hidden=YES;
        self.applyBackView.hidden=YES;
        
    }
    @catch (NSException *exception)
    {
        
    }
}

- (IBAction)editTap:(id)sender
{
    
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    EditVideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"EditVideoEditor"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)overlayTap:(id)sender
{
    
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    OverlayEffectViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"overlayController"];
    vc.isPageFirst=@"first";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)effectTap:(id)sender {
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    VideoEffectsViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"effectController"];
    vc.videoPath=self.videopath;
    vc.isPageFirst=@"first";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)trimTap:(id)sender {
    
    // [self EditedLocalValue];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    TrimViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TrimVideo"];
    
    //  vc.currentVideoID = _finalVideoID;
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end

