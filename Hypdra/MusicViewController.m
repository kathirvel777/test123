//
//  MusicViewController.m
//  Montage
//
//  Created by MacBookPro on 4/26/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MusicViewController.h"
#import "UploadMusicCollectionCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "IQAudioCropperViewController.h"
#import "IQAudioRecorderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "AudioPlayerViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMORootViewController.h"
#import "TabBarViewController.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "UIImageView+WebCache.h"
#import "BackgroundManager.h"
#import <Lottie/Lottie.h>
#import "TestKit.h"




#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define URL @"https://www.hypdra.com/api/api.php?rquest=user_upload_music"

@interface MusicViewController ()<MPMediaPickerControllerDelegate,IQAudioRecorderViewControllerDelegate,IQAudioCropperViewControllerDelegate,ClickDelegates,UITextFieldDelegate>
{
    NSString *user_id,*deleteName;
    NSMutableArray *MusicName;
    // int HigestImageCount,count;
    NSData *Musicdata;
    NSMutableURLRequest *request;
    LOTAnimationView *animationView;
    NSString *extension;
    
    int delPos;
    
    NSString *songTitle;
    
    MBProgressHUD *hud_1;
    
    NSString *finalAudioID,*Credits,*MusicUploaded;
    
    NSString *globalDataPath,*audioFilePath;
    NSString *audioDuration;
    NSIndexPath *selectedValue;
    
    int selected_cell_index,arrCount;
    
    NSString *cropAudioPath,*cropAudioName;
    BOOL isAnyMusicAction,isMembershipPlan;
    BackgroundManager* _bgManager;


    
}

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation MusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isAnyMusicAction=NO;
    
    [self setRecordVideo];
    
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"Music"]];
    
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myPath error:NULL];
    
    NSMutableArray *mp3Files = [[NSMutableArray alloc] init];
    
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSString *filename = (NSString *)obj;
         NSString *extensions = [[filename pathExtension] lowercaseString];
         if ([extensions isEqualToString:@"m4a"])
         {
             [mp3Files addObject:[myPath stringByAppendingPathComponent:filename]];
         }
     }];
    
    
    NSLog(@"Files = %@",mp3Files);
    
    [self localDelete];
    
    // Do any additional setup after loading the view.
    
    MusicName=[[NSMutableArray alloc]init];
    
    //    UIImage *img=[UIImage imageNamed:@"plus-icon-black-2.png"];
    
    //    [_btnchooseMusic setImage:img forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddMusic:)
                                                 name:@"postMusic" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteMultipleItems:) name:@"postMusicDelete" object:nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:10.0f];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    self.collectionView.bounces = false;
    
    //    [flowLayout setSectionInset:UIEdgeInsetsMake(2, 2, 2, 2)];
    
    //    [self getmusicfromlocal];
    
    _currentWindow = [UIApplication sharedApplication].keyWindow;
    
    _BlurView = [[UIView alloc]initWithFrame:CGRectMake(_currentWindow.frame.origin.x, _currentWindow.frame.origin.y, _currentWindow.frame.size.width, _currentWindow.frame.size.height)];
    
    _BlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    // [self getData];
    
    [[self.rcAudio imageView] setContentMode: UIViewContentModeScaleAspectFit];
    animationView = [LOTAnimationView animationNamed:@"loading_h"];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    [animationView setCenter:self.view.center];
    animationView.loopAnimation = YES;

    
}
- (void)deleteMultipleItems:(NSNotification *)notify

{
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to delete the selected music ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.accessibilityHint = @"MultipleDelete";
    popUp.okay.hidden = YES;
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor= [UIColor blueBlack];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.inputTextField.hidden = YES;
    [popUp show];
}

-(void)loadMusic
{
    @try
    {
        
        NSLog(@"Enter Music Group");
        
        hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud_1.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud_1.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        
        //        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_particular_user_audio_dtls";
        //
        //
        //        NSDictionary *parameters = @{@"user_id":user_id,@"lang":@"iOS"};
        //
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_admin_music_category_content";
        
        NSDictionary *parameters = @{@"User_ID":user_id,@"music_category":@"My Music",@"lang":@"iOS"};
        
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
                  isAnyMusicAction=NO;
                  NSMutableDictionary *response=responseObject;
                  
                  NSLog(@"Music Response = %@",response);
                 Credits = [response objectForKey:@"credit_points"];
                  MusicUploaded = @"7";//[response objectForKey:@"music_upload"];
                  NSArray *MusicArray = [response objectForKey:@"view_admin_music_category_content"];
                  
                  MusicName = [[NSMutableArray alloc]init];
                  
                  //                  NSArray *statusArray = [response objectForKey:@"Response_array"];
                  //
                  //                  NSDictionary *stsDict = [statusArray objectAtIndex:0];
                  //
                  NSString *status=[NSString stringWithFormat:@"%@",[response objectForKey:@"status"]];
                  
                  if ([status isEqualToString:@"1"])
                  {
                      
                      MusicName=[MusicArray mutableCopy];
 
                      [hud_1 hideAnimated:YES];
                      
                  }
                  else
                  {
                      NSLog(@"Music Not Found..");
                      self.pageViewImgView.hidden=NO;
                      self.pageViewImgView.image=[UIImage imageNamed:@"500-music.png"];
                      [hud_1 hideAnimated:YES];
                      
                  }
                  
              }
              else
              {
                  NSLog(@"Error for Music :");
                  [hud_1 hideAnimated:YES];
              };
              
              if (MusicName.count == 0)
              {
                  self.collectView.hidden = true;
                  self.pageView.hidden = false;
              }
              else
              {
                  self.collectView.hidden = false;
                  self.pageView.hidden = true;
                  [self.collectionView reloadData];
                  
//                  NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                  
//                  [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                  
              }
              
              if(MusicName.count>1){
                  
                  NSInteger item = MusicName.count-1;
              }
              
              if (MusicName.count == 0)
                  [self.pageView addSubview:_recordAdioRzblVw];
              else
                  [self.collectionView.superview addSubview:_recordAdioRzblVw];
          }]resume];
    }
    @catch(NSException *exc)
    {
        NSLog(@"Music Catch:%@",exc);
        [hud_1 hideAnimated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    CGRect adFrame=self.collectView.frame;
    adFrame.origin.y=1.5;
    self.collectView.frame=adFrame;
    
    if (MusicName.count == 0)
        [self.pageView addSubview:_recordAdioRzblVw];
    else
        [self.collectionView.superview addSubview:_recordAdioRzblVw];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
    TabBarViewController *tabContrl = self.tabBarController;
    tabContrl.TttleLable.text = @"My Music";
    tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"12-PLUS.png"];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [_recordAdioRzblVw removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    CGRect adFrame=self.collectView.frame;
    adFrame.origin.y=1.5;
    self.collectView.frame=adFrame;
    
    NSLog(@"viewWillAppear");
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    // [self getmusicfromlocal];
    
    NSLog(@"User Id = %@",user_id);
    
    if(isAnyMusicAction==NO)
    {
        [self loadMusic];
    }
    
    
    /*    if (MusicName.count == 0)
     {
     self.collectView.hidden = true;
     self.pageView.hidden = false;
     }
     else
     {
     self.collectView.hidden = false;
     self.pageView.hidden = true;
     }*/
    
    //    self.secondView.frame = CGRectMake(0, 149, 10, 10);
    //
    //    self.secondView.backgroundColor = [UIColor yellowColor];
    
    NSString *restrictionForResolution=[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"];
    
    NSLog(@"Restriction:%@",restrictionForResolution);
    
    if([restrictionForResolution isEqualToString:@"Basic"])
    {
        arrCount=30;
        isMembershipPlan=NO;
    }
    else if([restrictionForResolution isEqualToString:@"Standard"])
    {
        arrCount=100;
        isMembershipPlan=YES;
    }
    else if([restrictionForResolution isEqualToString:@"Premium"]) {
        arrCount=200;
        isMembershipPlan=YES;
    }
    else
    {
        arrCount=30;
        isMembershipPlan=NO;
    }
    if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        
        [self.ADView removeFromSuperview];
    }
}

- (void)AddMusic:(NSNotification *)note
{
    isAnyMusicAction=YES;
    
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
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        NSString *minAvil=[defaults valueForKey:@"minAvil"];
        
        NSString *spcAvil = [defaults valueForKey:@"spcAvil"];
        
            if(MusicName.count<arrCount)
            {
                if ([spcAvil isEqualToString:@"Space Available"])
                {
                    MPMediaPickerController *picker =
                    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
                    
                    picker.delegate = self;
                    picker.allowsPickingMultipleItems   = NO;
                    picker.prompt                       = NSLocalizedString (@"Select any song from the list", @"Prompt to user to choose some songs to play");
                    
                    // [self presentModalViewController: picker animated: YES];
                    [self presentViewController:picker animated:YES completion:nil];
                }
                else
                {
                    CustomPopUp *popUp = [CustomPopUp new];
                    [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have space" withTitle:@"Sory" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                    popUp.okay.backgroundColor = [UIColor navyBlue];
                    popUp.agreeBtn.hidden = YES;
                    popUp.cancelBtn.hidden = YES;
                    popUp.inputTextField.hidden = YES;
                    [popUp show];
                }
            }
            else
            {
               /* CustomPopUp *popUp = [CustomPopUp new];
                [popUp initAlertwithParent:self withDelegate:self withMsg:@"Kindly, Upgrade your Plan to Add more musics!!!" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                popUp.okay.hidden = YES;
                popUp.accessibilityHint =@"ConfirmToUpgrade";
                
                popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
                popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
                popUp.inputTextField.hidden = YES;
                [popUp show];*/
                self.purchaseView.hidden = NO;
            }
 //       }
//        else
//        {
//            //  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"You Exceed the limit of your music count. kindly delete some musics!!!" preferredStyle:UIAlertControllerStyleAlert];
//            //
//            //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//            //         {
//            //
//            //
//            //         }];
//            //
//            //        [alertController addAction:ok];
//            //
//            //        [self presentViewController:alertController animated:YES completion:nil];
//
//            CustomPopUp *popUp = [CustomPopUp new];
//            [popUp initAlertwithParent:self withDelegate:self withMsg:@"You Exceed the limit of your music count. kindly delete some musics!!!" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
//            popUp.okay.backgroundColor = [UIColor lightGreen];
//            popUp.agreeBtn.hidden = YES;
//            popUp.cancelBtn.hidden = YES;
//            popUp.inputTextField.hidden = YES;
//            [popUp show];
//
//        }
    }
}

-(void)viewDidLayoutSubviews
{
    CGRect adFrame=self.collectView.frame;
    adFrame.origin.y=1.5;
    self.collectView.frame=adFrame;
    
    //self.secondView.frame = CGRectMake(0,  0, self.secondView.frame.size.width, self.secondView.frame.size.height -50);
    
//    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
//
//    NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upload:(id)sender
{
    //[self getmusicfromlocal];
    isAnyMusicAction=YES;
    
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    picker.delegate = self;
    picker.allowsPickingMultipleItems   = NO;
    picker.prompt                       = NSLocalizedString (@"Select any song from the list", @"Prompt to user to choose some songs to play");
    
    // [self presentModalViewController: picker animated: YES];
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
   /* hud_1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud_1.mode = MBProgressHUDModeAnnularDeterminate;
    hud_1.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
    */
    [_currentWindow addSubview:_BlurView];
    [_currentWindow addSubview:animationView];
    
    [animationView playWithCompletion:^(BOOL animationFinished) {
        // ...
    }];

    
    
    MusicName = [[NSMutableArray alloc]init];
    
    //    [self.view setUserInteractionEnabled:NO];
    
    __block NSData *assetData = nil;
    
    //    MPMediaItem *theChosenSong = [[mediaItemCollection items]objectAtIndex:0];
    //    NSString *songTitle = [theChosenSong valueForProperty:MPMediaItemPropertyTitle];
    //    NSURL *assetURL = [theChosenSong valueForProperty:MPMediaItemPropertyAssetURL];
    //    AVURLAsset  *songAsset  = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    //    NSLog(@"asset url:%@",assetURL);
    
    MPMediaItem *theChosenSong = [[mediaItemCollection items]objectAtIndex:0];
    songTitle = [theChosenSong valueForProperty:MPMediaItemPropertyTitle];
    NSString *f=[theChosenSong valueForKey:MPMediaItemPropertyArtwork];
    
    NSURL *url = [theChosenSong valueForProperty: MPMediaItemPropertyAssetURL];
    NSLog(@"Song Title:%@",songTitle);
    NSLog(@"Song art:%@",f);
    
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: url options:nil];
    
    //mine
    
    CMTime durationV = songAsset.duration;
    
    NSUInteger dTotalSeconds = CMTimeGetSeconds(durationV);
    
    NSUInteger dHours = floor(dTotalSeconds / 3600);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    
    audioDuration = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
    
    //mine
    
    
    NSData *d1=[NSData dataWithContentsOfURL:url];
    NSLog(@"d1:%@",d1);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset presetName:AVAssetExportPresetAppleM4A];
    
    exporter.outputFileType = @"com.apple.m4a-audio";
   // exporter.outputFileType = @"AVFileTypeMPEG4";

    /*    NSLog(@"export.supportedFileTypes : %@",exporter.supportedFileTypes);
     
     NSLog(@"Exporter:%@",exporter);
     
     exporter.outputFileType = @"com.apple.quicktime-movie";
     
     extension = (__bridge  NSString *)UTTypeCopyPreferredTagWithClass((__bridge  CFStringRef)exporter.outputFileType, kUTTagClassFilenameExtension);
     
     NSLog(@"extension %@",extension);*/
    
    
    /*    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString * myDocumentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
     
     //    [[NSDate date] timeIntervalSince1970];
     //    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
     //    NSString *intervalSeconds = [NSString stringWithFormat:@"%0.0f",seconds];
     
     
     NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
     
     NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
     NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:@"/Music"];
     
     NSError *error;
     
     if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
     [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];*/
    
    
    
    
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocumentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *documentsPathlist = [myDocumentsDirectory stringByAppendingPathComponent:@"/Music"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *intervalSeconds = [NSString stringWithFormat:@"%@",@"music123"];
    
    //   NSString *fname=[NSString stringWithFormat:@"%@$%@$%@",user_id,songTitle,intervalSeconds];
    
    NSString * fileName = [NSString stringWithFormat:@"%@.m4a",intervalSeconds];
    
    NSString *dataPath = [documentsPathlist stringByAppendingFormat:@"/%@",fileName];
    
    NSLog(@"dataPath = %@",dataPath);
    
    globalDataPath = dataPath;
    
    // NSString *exportFile = [myDocumentsDirectory stringByAppendingPathComponent:dataPath];
    
    //    NSURL *exportURL = [NSURL fileURLWithPath:dataPath];
    //
    //      exporter.outputURL = exportURL;
    
    // NSString *exportFile = [myDocumentsDirectory stringByAppendingPathComponent:dataPath];
    
    NSURL *exportURL = [NSURL fileURLWithPath:dataPath];
    NSLog(@"exported url is %@",exportURL);
    exporter.outputURL = exportURL;
    
    [exporter exportAsynchronouslyWithCompletionHandler:
     ^{
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             int exportStatus = exporter.status;
             
             switch (exportStatus)
             {
                 case AVAssetExportSessionStatusFailed:
                 {
                     NSError *exportError = exporter.error;
                     NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                     
                     [hud_1 hideAnimated:YES];
                     [_BlurView removeFromSuperview];
                     
                     break;
                }
                 case AVAssetExportSessionStatusCompleted:
                 {
                     NSLog (@"AVAssetExportSessionStatusCompleted:%@",myDocumentsDirectory);
                     
                     //  [d1 writeToFile:[myDocumentsDirectory stringByAppendingPathComponent:fileName] atomically:YES];
                     
                     //        Musicdata = [NSData dataWithContentsOfFile: [myDocumentsDirectory stringByAppendingPathComponent:fileName]];
                     
                     //         NSLog(@"Assest Data:%@",Musicdata);
                     
                     //         NSLog(@"Path:%@",[myDocumentsDirectory stringByAppendingPathComponent:fileName]);
                     
                     NSData *data=[NSData dataWithContentsOfFile:globalDataPath];
                     if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"] && MusicUploaded.integerValue >= 7){
                         
                    [self FileName:(NSString *)songTitle Data:(NSData *)data];
                         
                     }else{
    if(Credits.integerValue < 30){
        CustomPopUp *popUp = [CustomPopUp new];
        
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Sorry you don't have enough credits" withTitle:@"Upgrade Membership" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.accessibilityHint = @"ConfirmToUpgrade";
        // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        popUp.okay.hidden =YES;
        [popUp.agreeBtn setTitle:@"Upgrade" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }else{
        
        CustomPopUp *popUp = [CustomPopUp new];
        int availablecredits = Credits.intValue;
        NSString *msg = [NSString stringWithFormat:@"Available credit: %@ | Credit Needed: 30", Credits];
        [popUp initAlertwithParent:self withDelegate:self withMsg:msg withTitle:@"Pay Using Credit Balance" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.accessibilityHint = @"Redeem";
        // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        popUp.okay.hidden =YES;
        [popUp.agreeBtn setTitle:@"Redeem" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
                     }
                     
                     //[self getmusicfromlocal];
                     //DLog(@"Data %@",data);
                     //data = nil;
                     //[self FileName:(NSString *)fileName Data:(NSData *)Musicdata];
                     
                     break;
                     
                 }
                 case AVAssetExportSessionStatusUnknown:
                 {
                     [hud_1 hideAnimated:YES];
                     [_BlurView removeFromSuperview];
                     NSLog(@"AVAssetExportSessionStatusUnknown"); break;
                 }
                 case AVAssetExportSessionStatusExporting:
                 {
                     NSLog(@"AVAssetExportSessionStatusExporting"); break;
                 }
                 case AVAssetExportSessionStatusCancelled:
                 {
                     [hud_1 hideAnimated:YES];
                     [_BlurView removeFromSuperview];
                     NSLog(@"AVAssetExportSessionStatusCancelled"); break;
                 }
                 case AVAssetExportSessionStatusWaiting:
                 {
                     [hud_1 hideAnimated:YES];
                     [_BlurView removeFromSuperview];
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting"); break;
                 }
                 default:
                 {
                     [hud_1 hideAnimated:YES];
                     [_BlurView removeFromSuperview];
                     NSLog(@"didn't get export status"); break;
                 }
             }
         });
     }];
}

//
//+(void)getData
//{
//
//}


/*{
 [self dismissViewControllerAnimated:YES completion:nil];
 
 __block NSData *assetData = nil;
 
 //    MPMediaItem *theChosenSong = [[mediaItemCollection items]objectAtIndex:0];
 //    NSString *songTitle = [theChosenSong valueForProperty:MPMediaItemPropertyTitle];
 //    NSURL *assetURL = [theChosenSong valueForProperty:MPMediaItemPropertyAssetURL];
 //    AVURLAsset  *songAsset  = [AVURLAsset URLAssetWithURL:assetURL options:nil];
 //    NSLog(@"asset url:%@",assetURL);
 
 MPMediaItem *theChosenSong = [[mediaItemCollection items]objectAtIndex:0];
 NSString *songTitle = [theChosenSong valueForProperty:MPMediaItemPropertyTitle];
 NSString *f=[theChosenSong valueForKey:MPMediaItemPropertyArtwork];
 
 [self mediaItemToData:theChosenSong];
 
 
 /*    MPMediaItemArtwork *artworkPrev = [theChosenSong valueForProperty:MPMediaItemPropertyArtwork];
 if (artworkPrev != nil)
 {
 UIImage *img = [artworkPrev imageWithSize:CGSizeMake(65, 65)];
 
 self.albumImg.image = img;
 
 NSData *data = UIImagePNGRepresentation(img);
 
 NSLog(@"Album Image = %@",data);
 
 //        UIImageView *imgNew = [[UIImageView alloc] initWithImage:img];
 //        imgNew.frame = CGRectMake(-15,-20, 65, 65);
 }
 
 NSURL *url = [theChosenSong valueForProperty: MPMediaItemPropertyAssetURL];
 NSLog(@"Song Title:%@",songTitle);
 NSLog(@"Song art:%@",f);
 NSLog(@"Song URL:%@",url);
 
 AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: url options:nil];
 NSData *d1=[NSData dataWithContentsOfURL:url];
 
 //    NSURL *urls = [theChosenSong valueForProperty: MPMediaItemPropertyAssetURL];
 //    NSError *errors = nil;
 //    NSData *audioData = [NSData dataWithContentsOfURL:urls options:nil error:&errors];
 //    if(!audioData) NSLog(@"error while reading from %@ - %@", [urls absoluteString], [errors localizedDescription]);
 
 //    NSLog(@"d1:%@",assetData);
 
 AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset presetName:AVAssetExportPresetAppleM4A];
 
 NSLog(@"Exporter:%@",exporter);
 
 exporter.outputFileType = @"com.apple.m4a-audio";
 
 NSError *error;
 NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
 
 NSString *documentsPathlist = [pathfinalPlist objectAtIndex:0];
 // NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyMusic"]];
 
 if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
 [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];
 
 NSString *SharedFinalplistPath = [documentsPathlist stringByAppendingPathComponent:@"MyMusic.plist"];
 
 MusicName = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
 
 if (MusicName == nil)
 {
 MusicName = [[NSMutableArray alloc]init];
 }
 
 NSLog(@"MusicPlistPath:%@",SharedFinalplistPath);
 
 NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
 
 HigestImageCount++;
 
 [dic setValue:songTitle forKey:@"MusicTitle"];
 
 [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"MusicId"];
 
 [MusicName addObject:dic];
 
 [MusicName writeToFile:SharedFinalplistPath atomically:YES];
 
 [self.collectionView reloadData];
 
 [self FileName:(NSString *)songTitle MusicID:(NSString *)[NSString stringWithFormat:@"%d",HigestImageCount] Data:(NSData *)d1];
 
 }*/

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    //[self dismissModalViewControllerAnimated: YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//-(void)getmusicfromlocal
//{
//    HigestImageCount = 0;
//
//    MusicName = [[NSMutableArray alloc]init];
//
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Music"];
//
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
//
//    NSString *SharedFinalplistPath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyMusic.plist"]];
//
//    MusicName = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
//
//    NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
//
//    if (plist == nil)
//    {
//        plist = [[NSMutableArray alloc]init];
//    }
//
//    NSLog(@"After Delete Music = %@",plist);
//
//
//    for(NSDictionary *dic in plist)
//    {
//        NSString *StringId = [dic valueForKey:@"MusicId"];
//        int temInt = StringId.intValue;
//
//        NSLog(@"temInt = %d",temInt);
//
//        if(temInt>HigestImageCount)
//        {
//            HigestImageCount=temInt;
//
//            NSLog(@"swap temInt = %d",temInt);
//        }
//    }
//
//    NSLog(@"Music HigestImageCount = %d",HigestImageCount);
//
//    if (plist.count == 0)
//    {
//        self.collectView.hidden = true;
//        self.pageView.hidden = false;
//    }
//    else
//    {
//        self.collectView.hidden = false;
//        self.pageView.hidden = true;
//    }
//
//    [self.collectionView reloadData];
//
//}

/*
-(void) beginBackgroundUploadTask
{
    if(self.backgroundTask != UIBackgroundTaskInvalid)
    {
        [self endBackgroundUploadTask];
    }
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        
    }];
}
-(void) endBackgroundUploadTask
{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask ];
    self. backgroundTask = UIBackgroundTaskInvalid;
}
*/
-(void)FileName:(NSString *)fileName Data:(NSData *)Musicdata1
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
        
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        [hud_1 hideAnimated:YES];
        [_BlurView removeFromSuperview];
        
    }
    
    else
    {
        NSLog(@"File name in server:%@",fileName);
        
        if (fileName == nil || fileName == (id)[NSNull null])
        {
            fileName = @"Unknown";
        }
        
        NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                         {
                                             
                                             [formData appendPartWithFileData:Musicdata1 name:@"upload_files" fileName:@"uploads.m4a" mimeType:@"audio/m4a"];
                                             
                                             // [formData appendPartWithFormData:[RandID dataUsingEncoding:NSUTF8StringEncoding] name:@"aud_id"];
                                             
                                             //        NSLog(@"randdd id %@",RandID);
                                             
                                             [formData appendPartWithFormData:[fileName dataUsingEncoding:NSUTF8StringEncoding] name:@"audio_name"];
                                             
                                             NSLog(@"fillleee name %@",fileName);
                                             
                                             [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                             
                                             [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"size"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"created_date"];
                                             
                                             [formData appendPartWithFormData:[audioDuration dataUsingEncoding:NSUTF8StringEncoding] name:@"audio_duration"];
                                             
                                         } error:nil];
        
        
        if(_bgManager == nil)
            _bgManager = [[BackgroundManager alloc]init];
        
        [_bgManager startTask];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:requests
                      progress:^(NSProgress * _Nonnull uploadProgress)
                      {
                          dispatch_async(dispatch_get_main_queue(),
                                         ^{
                                             
/*[MBProgressHUD HUDForView:self.navigationController.view].progress = uploadProgress.fractionCompleted;
                                             
                                        */
                                         });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                      {
                          if (error)
                          {
                              NSLog(@"Error For Music: %@", error);
                              
                              /*[hud_1 hideAnimated:YES];*/
                              [animationView removeFromSuperview];
                              
                              [_BlurView removeFromSuperview];
                              
                              [self localDelete];
                              
                              //  [self rollback];
                              
                              //                          UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Upload failed"
                              //                                                                                        message:@"Your upload could not be completed.\nTry again ?"
                              //                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                              //
                              //                          UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                              //                                                                              style:UIAlertActionStyleDefault
                              //                                                                            handler:nil];
                              //
                              //                          [alert addAction:yesButton];
                              //
                              //                          [self presentViewController:alert animated:YES completion:nil];
                              CustomPopUp *popUp = [CustomPopUp new];
                              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your upload could not be completed.\nTry again ?" withTitle:@"Upload failed" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                              popUp.okay.backgroundColor = [UIColor navyBlue];
                              popUp.agreeBtn.hidden = YES;
                              popUp.cancelBtn.hidden = YES;
                              popUp.inputTextField.hidden = YES;
                              [popUp show];
                              
                          }
                          else
                          {
                              [self localDelete];
                              
                              NSDictionary *responsseObject;
                              
                              id object = [NSJSONSerialization
                                           JSONObjectWithData:responseObject
                                           options:kNilOptions
                                           error:&error];
                              
                              if ([object isKindOfClass:[NSDictionary class]] == YES)
                              {
                                  
                                  NSLog(@"Dictionary rx from server");
                                  
                                  responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                  
                                  NSLog(@"Response For Music:%@",responsseObject);
                                  
                                  [self EditedLocalValue];
                                  
                                  /*[hud_1 hideAnimated:YES];*/
                                  [animationView removeFromSuperview];
                                  
                                  [_BlurView removeFromSuperview];
                                  
                                  NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                  
                                  NSString *minAvil=[responsseObject objectForKey:@"Duration Status"];
                                  
                                  NSString *spcAvil = [responsseObject objectForKey:@"Space Status"];
                                  [defaults setValue:minAvil forKey:@"minAvil"];
                                  [defaults setValue:spcAvil forKey:@"spcAvil"];
                                  [defaults synchronize];
                                  
                                  if([[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"] && MusicUploaded.integerValue >= 7){
                                      
                                      [self reducePoints];
                                  }
                                  
                                  CustomPopUp *popUp = [CustomPopUp new];
                                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Music has been uploaded successfully" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                                  popUp.okay.backgroundColor = [UIColor lightGreen];
                                  popUp.accessibilityHint =@"MusicUploaded";
                                  
                                  popUp.agreeBtn.hidden= YES;
                                  popUp.cancelBtn.hidden= YES;
                                  popUp.inputTextField.hidden = YES;
                                  [popUp show];
                                  //                         [self getmusicfromlocal];
                                  
                              }
                              else
                              {
                                  /*[hud_1 hideAnimated:YES];*/
                                  [animationView removeFromSuperview];
                                  [_BlurView removeFromSuperview];
                                  
                                  //  [self rollback];
                                  
                                  //                              UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
                                  //                                                                                            message:@"Could not connect to server"
                                  //                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                  //
                                  //                              UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                  //                                                                                  style:UIAlertActionStyleDefault
                                  //                                                                                handler:nil];
                                  //
                                  //                              [alert addAction:yesButton];
                                  //
                                  //                              [self presentViewController:alert animated:YES completion:nil];
                                  
                                  
                                  CustomPopUp *popUp = [CustomPopUp new];
                                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                                  popUp.okay.backgroundColor = [UIColor navyBlue];
                                  popUp.agreeBtn.hidden = YES;
                                  popUp.cancelBtn.hidden = YES;
                                  popUp.inputTextField.hidden = YES;
                                  [popUp show];
                              }
                              
                          }
                          [_bgManager endTask];

                          
                      }];
        //[self endBackgroundUploadTask];
        [uploadTask resume];
        
      
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MusicName.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    UploadMusicCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //    cell.layer.borderWidth = 0.2f;
    
    cell.alpha = 1.0;
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    UIImage *img=[UIImage imageNamed:@"music_img"];
    NSDictionary *dic = [MusicName objectAtIndex:indexPath.row];
    
    NSString *StringId = [dic valueForKey:@"aud_id"];
    NSString *Title = [dic valueForKey:@"Audio_name"];
    NSString *DurationVal=[dic valueForKey:@"duration"];
    
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
    
    cell.ImgView.image=[UIImage imageNamed:@"300-place-holder"];
    
    NSLog(@"Music Title song:%@",Title);
    cell.title.text=Title;
    cell.duration.text=DurationVal;
    
    cell.aboveTopView.tag = indexPath.row;
    cell.topView.tag = indexPath.row;
    
    cell.delete.tag = indexPath.row;
    [cell.delete addTarget:self action:@selector(close_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.playBtn.tag = indexPath.row;
    [cell.playBtn addTarget:self action:@selector(play_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.cropMusic.tag = indexPath.row;
    [cell.cropMusic addTarget:self action:@selector(crop_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        cell.aboveTopView.hidden = false;
        cell.topView.hidden = false;
    }
    else
    {
        cell.aboveTopView.hidden = true;
        cell.topView.hidden = true;
    }
    
    return cell;
}


-(void)play_btn:(UIButton*)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
        //                                          message:@"Internet connection is down"
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
        
        isAnyMusicAction=YES;
        
        /*NSURL *url=[[NSURL alloc] initWithString:@"https://hypdra.com/api/Audio/3833.m4a"];
         
         AVPlayer *player = [AVPlayer playerWithURL:url];
         
         AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
         [self presentViewController:controller animated:YES completion:nil];
         controller.player = player;
         [player play];*/
        
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        //    UIAlertController * alert=[UIAlertController
        //            alertControllerWithTitle:@"Confirm" message:@"Do you want to play ?" preferredStyle:UIAlertControllerStyleAlert];
        //
        //    UIAlertAction* yesButton = [UIAlertAction
        //            actionWithTitle:@"Yes"
        //            style:UIAlertActionStyleDefault
        //            handler:^(UIAlertAction * action)
        //            {
        //                [self okButtonsPressed:sendIndex];
        //
        //            }];
        //    UIAlertAction* noButton = [UIAlertAction
        //            actionWithTitle:@"No"
        //            style:UIAlertActionStyleDefault
        //            handler:^(UIAlertAction * action)
        //            {
        //
        //                [self cancelButtonPressed];
        //
        //            }];
        //
        //    [alert addAction:yesButton];
        //    [alert addAction:noButton];
        //
        //    [self presentViewController:alert animated:YES completion:nil];
        [self okButtonsPressed:sendIndex];
       /* CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to play ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToPlay";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];*/
        
    }
    
}

- (void)okButtonsPressed:(NSString*)getIndex
{
    NSLog(@"Play Action");
    
    int i=[getIndex intValue];
    
    NSString *urlString=[[MusicName objectAtIndex:i]valueForKey:@"Audio_Path"];
    
    NSURL *url=[[NSURL alloc] initWithString:urlString];
    
    AVPlayer *player = [AVPlayer playerWithURL:url];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    
    [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
    
    controller.allowsPictureInPicturePlayback = YES;
    
    [self presentViewController:controller animated:YES completion:nil];
    
    controller.player = player;
    [player play];
}


-(void)crop_btn:(UIButton*)sender
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
        isAnyMusicAction=YES;
        
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        //    UIAlertController * alert=[UIAlertController
        //        alertControllerWithTitle:@"Confirm" message:@"Are you sure to edit ?"preferredStyle:UIAlertControllerStyleAlert];
        //
        //    UIAlertAction* yesButton = [UIAlertAction
        //        actionWithTitle:@"Yes"
        //        style:UIAlertActionStyleDefault
        //        handler:^(UIAlertAction * action)
        //        {
        //            [self okButtonPressed:sendIndex];
        //
        //        }];
        //
        //    UIAlertAction* noButton = [UIAlertAction
        //        actionWithTitle:@"No"
        //        style:UIAlertActionStyleDefault
        //        handler:^(UIAlertAction * action)
        //        {
        //                [self cancelButtonPressed];
        //        }];
        //
        //    [alert addAction:yesButton];
        //    [alert addAction:noButton];
        //
        //    [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to edit the music ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToEdit";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%d",sender.tag];
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
}

- (void)cancelButtonPressed
{
    
}

- (void)okButtonPressed:(NSString*)getIndex
{
   /* hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud_1.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud_1.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];*/
    
    NSLog(@"Crop Action");
    
    int i=[getIndex intValue];
    
    cropAudioPath = [[MusicName objectAtIndex:i] valueForKey:@"Audio_Path"];
    cropAudioName = [[MusicName objectAtIndex:i] valueForKey:@"Audio_name"];
    
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
    
    [self doSomeNetworkWorkWithProgress];
}

- (void)doSomeNetworkWorkWithProgress
{
    NSLog(@"doSomeNetworkWorkWithProgress = %@",cropAudioPath);
    if (cropAudioPath == nil)
    {
        
        NSLog(@"cropVideoURL NULL");
        
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:true];
        
        //        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.BlurView];
        //        [hud hideAnimated:YES];
        
        //        [hud hideAnimated:YES];
        
        
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Music Not Found" preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        //
        //        [alertController addAction:okAction];
        //
        //        [self presentViewController:alertController animated: YES completion: nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Music not found" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    else
    {
        
        [self EditedLocalValue];
        
        static dispatch_once_t onceToken;
        static NSURLSession *session=nil;
        
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.ios.images.hypdra"];
        
        session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURL *url=[NSURL URLWithString:cropAudioPath];
        
        NSURLSessionDownloadTask* task = [session downloadTaskWithRequest:[NSURLRequest requestWithURL:url]];
        
        [task resume];
    }
}
/*{
 
 NSLog(@"doSomeNetworkWorkWithProgress Begin = %@",cropAudioPath);
 
 NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
 
 NSURL *audioURL = [NSURL URLWithString:cropAudioPath];
 NSURLRequest *request = [NSURLRequest requestWithURL:audioURL];
 
 NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress)
 {
 
 dispatch_async(dispatch_get_main_queue(), ^{
 //Update the progress view
 //            [_myProgressView setProgress:downloadProgress.fractionCompleted];
 
 
 NSLog(@"Begin");
 
 MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
 hud.mode = MBProgressHUDModeDeterminate;
 hud.progress = downloadProgress.fractionCompleted;
 
 });
 
 
 
 } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
 NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
 return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
 } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
 {
 // Do operation after download is complete
 MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
 
 [hud hideAnimated:YES];
 
 }];
 
 [downloadTask resume];
 
 NSLog(@"doSomeNetworkWorkWithProgress end");
 
 }*/

/*
 {
 
 NSLog(@"doSomeNetworkWorkWithProgress = %@",cropAudioPath);
 
 NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
 NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
 NSURL *audioURL = [NSURL URLWithString:@"http://108.175.2.116/montage/api/Audio/1672174977_Hey Baby.mp3"];
 NSURLSessionDownloadTask *task = [session downloadTaskWithURL:audioURL];
 
 [task resume];
 }*/

- (void)cancelWork:(id)sender
{
    NSLog(@"Cancelled the work");
    //    self.canceled = YES;
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat percentDone = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
    // Notify user.
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    // Either move the data from the location to a permanent location, or do something with the data at that location.
    NSLog(@"Finished:%@",[location path]);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    //getting application's document directory path
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    //adding a new folder to the documents directory path
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/tempSong/"];
    
    //Checking for directory existence and creating if not already exists
    if(![fileManager fileExistsAtPath:appDir])
    {
        [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    //retrieving the filename from the response and appending it again to the path
    //this path "appDir" will be used as the target path
    //        appDir =  [appDir stringByAppendingFormat:@"/%@",[[downloadTask response] suggestedFilename]];
    
    appDir =  [appDir stringByAppendingPathComponent:@"Sample123.m4a"];
    
    //checking for file existence and deleting if already present.
    /*        if([fileManager fileExistsAtPath:appDir])
     {
     NSLog([fileManager removeItemAtPath:appDir error:&error]?@"deleted":@"not deleted");
     }*/
    
    NSLog(@"AppDir = %@",appDir);
    
    //moving the file from temp location to app's own directory
    BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:appDir error:&error];
    
    NSLog(fileCopied ? @"Yes" : @"No");
    
    [hud_1 hideAnimated:YES];
    
    [self openCrop:appDir];
    
}

-(void)openCrop:(NSString*)dataPath
{
    
    IQAudioCropperViewController *controller1 = [[IQAudioCropperViewController alloc] initWithFilePath:dataPath];
    
    controller1.delegate = self;
    
    [self presentAudioCropperViewControllerAnimated:controller1];
    
}

/*
 -(void)audioRecorderController:(IQAudioRecorderViewController *)controller didFinishWithAudioAtPath:(NSString *)filePath
 {
 //    audioFilePath = filePath;
 //    buttonPlayAudio.enabled = YES;
 [controller dismissViewControllerAnimated:YES completion:nil];
 
 NSError *error;
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 
 NSString *appDir = [documentsDirectory stringByAppendingPathComponent:@"/tempSong/"];
 
 // Get documents folder
 NSString *newFilePath = [appDir stringByAppendingPathComponent:@"sample.m4a"];
 
 NSLog(@"Final Cropped = %@",newFilePath);
 
 }
 
 -(void)audioRecorderControllerDidCancel:(IQAudioRecorderViewController *)controller
 {
 //    buttonPlayAudio.enabled = NO;
 [controller dismissViewControllerAnimated:YES completion:nil];
 }
 */

-(void)audioRecorderController:(nonnull IQAudioCropperViewController*)controller didFinishWithAudioAtPath:(nonnull NSString*)filePath
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    audioFilePath = filePath;
    NSURL *audioURL = [NSURL fileURLWithPath:audioFilePath];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: audioURL options:nil];
    
    //mine
    
    CMTime durationV = songAsset.duration;
    
    NSUInteger dTotalSeconds = CMTimeGetSeconds(durationV);
    
    NSUInteger dHours = floor(dTotalSeconds / 3600);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    
    audioDuration = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"" withTitle:@"Enter a audio name" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.hidden=YES;
    popUp.agreeBtn.hidden = NO;
    popUp.cancelBtn.hidden = NO;
    popUp.inputTextField.hidden = NO;
    popUp.inputTextField.delegate=self;
    
    popUp.agreeBtn.backgroundColor=[UIColor navyBlue];
    popUp.cancelBtn.backgroundColor=[UIColor blueBlack];
    popUp.accessibilityHint=@"CroppedMusic";
    [popUp show];
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
 {
 [controller dismissViewControllerAnimated:YES completion:nil];
 
 //[self getmusicfromlocal];
 
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 
 NSString *appDir = [documentsDirectory stringByAppendingPathComponent:@"/tempSong/"];
 
 // Get documents folder
 NSString *newFilePath = [appDir stringByAppendingPathComponent:@"sample.m4a"];
 
 NSLog(@"Final Cropped = %@",newFilePath);
 
 SCLAlertView *alert = [[SCLAlertView alloc] init];
 [alert setHorizontalButtons:YES];
 
 SCLTextView *evenField = [alert addTextField:@"Enter a audio name"];
 
 alert.customViewColor = UIColorFromRGB(0x4186F2);
 
 [alert addButton:@"Ok" validationBlock:^BOOL
 {
 if (evenField.text.length == 0)
 {
 
 
 CustomPopUp *popUp = [CustomPopUp new];
 [popUp initAlertwithParent:self withDelegate:self withMsg:@"You forgot to enter a file name" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
 popUp.okay.backgroundColor = [UIColor navyBlue];
 popUp.agreeBtn.hidden = YES;
 popUp.cancelBtn.hidden = YES;
 popUp.inputTextField.hidden = YES;
 [popUp show];
 
 [evenField becomeFirstResponder];
 
 return NO;
 }
 
 return YES;
 }
 
 actionBlock:
 ^{
 //        [[[UIAlertView alloc] initWithTitle:@"Great Job!" message:@"Thanks for playing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
 
 hud_1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
 
 hud_1.mode = MBProgressHUDModeAnnularDeterminate;
 hud_1.label.text = NSLocalizedString(@"Uploading...", @"HUD loading title");
 
 [_currentWindow addSubview:_BlurView];
 
 cropAudioName = evenField.text;
 
 NSLog(@"Crop File Name = %@",cropAudioName);
 
 [self sendEditAudio:newFilePath];
 
 }];
 
 [alert showEdit:self title:@"Alert" subTitle:@"Enter the file name" closeButtonTitle:@"Cancel" duration:0];
 }
 */

-(void)sendEditAudio:(NSString *)getID
{
    NSData *data = [NSData dataWithContentsOfFile:getID];
    
    //NSLog(@"Edited Music NSData = = %lu",(unsigned long)data.length);
    
    [self FileName:(NSString *)cropAudioName Data:(NSData *)data];
    
}

-(void)EditedLocalValue
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/tempSong/"];
    
    if([fileManager fileExistsAtPath:appDir])
    {
        NSLog([fileManager removeItemAtPath:appDir error:&error]?@"deleted":@"not deleted");
    }
    
}

-(void)audioCropperControllerDidCancel:(nonnull IQAudioCropperViewController*)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
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

-(void)close_btn:(UIButton*)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"check Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    else
    {
        isAnyMusicAction=YES;
        
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        //    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure you want to delete the selected image?"preferredStyle:UIAlertControllerStyleAlert];
        //
        //    UIAlertAction* yesButton = [UIAlertAction
        //        actionWithTitle:@"Yes"
        //        style:UIAlertActionStyleDefault
        //        handler:^(UIAlertAction * action)
        //        {
        //            NSString *delID = [[MusicName objectAtIndex:sender.tag]valueForKey:@"aud_id"];
        //
        //            delPos = (int)sender.tag;
        //
        //            [self deleteAudio:delID];
        //
        //        }];
        //    UIAlertAction* noButton = [UIAlertAction
        //           actionWithTitle:@"No"
        //           style:UIAlertActionStyleDefault
        //           handler:^(UIAlertAction * action)
        //       {
        //               [self cancelButtonPressed];
        //       }];
        //
        //    [alert addAction:yesButton];
        //    [alert addAction:noButton];
        //
        //    [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to delete the selected music ?" withTitle:@"Delete" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToDelete";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}


-(void)deleteAudio:(NSString*)deleteID
{
    
    hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud_1.label.text = NSLocalizedString(@"Deleting...", @"HUD loading title");
    
    hud_1.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud_1.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSLog(@"User id = %@",user_id);
    NSLog(@"Audio id = %@",deleteID);
    
    
    NSDictionary *params = @{@"user_id":user_id ,@"audio_id":deleteID,@"lang":@"ios"};
    
    [manager POST:@"https://www.hypdra.com/api/api.php?rquest=delete_user_upload_audio" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Delete Music Response:%@",responseObject);
         
         NSDictionary *dct = responseObject;
         
         NSString *str = [dct objectForKey:@"status"];
         
         if ([str isEqualToString:@"True"])
         {
             
             [hud_1 hideAnimated:YES];
             
             self.selectedItemIndexPath = nil;
             
             [self localDelete];
             
             NSIndexPath *myIP = [NSIndexPath indexPathForRow:delPos inSection:0] ;
             
             NSArray *deleteItems = @[myIP];
             
             [MusicName removeObjectAtIndex:delPos];
             
             [self.collectionView deleteItemsAtIndexPaths:deleteItems];
             
             if(MusicName.count==0)
             {
                 self.collectView.hidden=YES;
                 self.pageView.hidden=NO;
                 
                 self.pageViewImgView.hidden=NO;
                 self.pageViewImgView.image=[UIImage imageNamed:@"500-image.png"];
             }
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Selected music has been removed" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.accessibilityHint =@"MusicRemoved";
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
         }
         else
         {
             
             [hud_1 hideAnimated:YES];
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
         }
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         [hud_1 hideAnimated:YES];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
     }];
}

-(void)localDelete
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    
    NSString *myPath1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"Music"]];
    
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:myPath1];
    NSString *file;
    
    while (file = [dirEnum nextObject])
    {
        if ([[file pathExtension] isEqualToString:@"m4a"])
        {
            NSString *file1=[myPath1 stringByAppendingPathComponent:file];
            
            [fileManager removeItemAtPath:file1 error:&error];
            
            NSLog(@"Music File Removed");
        }
    }
}

/*    NSString *SharedFinalplistPath = [myPath1 stringByAppendingPathComponent:@"MyMusic.plist"];
 
 NSLog(@"Music Plist = %@",SharedFinalplistPath);
 
 NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
 
 NSLog(@"Music Array = %@",plist);
 
 for(NSDictionary *dic in plist)
 {
 NSLog(@"Delete loop called");
 
 NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 
 NSString *myPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"Music"]];
 
 myPath = [myPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[dic valueForKey:@"MusicId"]]];
 
 BOOL success = [fileManager removeItemAtPath:myPath error:&error];
 
 if (success)
 {
 NSLog(@"Music Deleted Path:%@",myPath);
 }
 else
 {
 NSLog(@"Music not Deleted Path:%@",myPath);
 
 }
 }*/

/*    NSString *SharedFinalplistPath = [myPath1 stringByAppendingPathComponent:@"DataList.plist"];
 
 NSLog(@"SharedFinalplistPath%@",SharedFinalplistPath);
 
 NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
 
 if (plist == nil)
 {
 plist = [[NSMutableArray alloc]init];
 }
 
 NSLog(@"plist:%@",plist);
 
 for(NSDictionary *dic in plist)
 {
 NSLog(@"loop called");
 
 if( [[dic valueForKey:@"Id"] isEqualToString:deleteName])
 {
 [plist removeObject:dic];
 break;
 }
 }
 
 [plist writeToFile:SharedFinalplistPath atomically:YES];
 
 if (success)
 {
 UIAlertView *removedSuccessFullyAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
 
 [removedSuccessFullyAlert show];
 
 self.collectView.hidden = false;
 self.pageView.hidden = true;
 [self.collectionView reloadData];
 }
 else
 {
 NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
 }*/



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];

    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
    // if it's the same as the one we just tapped on, then we're unselecting it
            self.selectedItemIndexPath = nil;
        }
        
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        
        self.selectedItemIndexPath = indexPath;
    }
    
    // and now only reload only the cells that need updating
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
}

/*
 - (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
 {
 UploadMusicCollectionCell* cell = (UploadMusicCollectionCell*)[collectionView  cellForItemAtIndexPath:indexPath];
 
 cell.aboveTopView.hidden = true;
 
 cell.topView.hidden = true;
 
 //    cell.alpha = 1;
 }
 */

- (IBAction)recordAudio:(id)sender
{
    IQAudioRecorderViewController *controller = [[IQAudioRecorderViewController alloc] init];
    controller.delegate = self;
    [self presentAudioRecorderViewControllerAnimated:controller];
}


-(void)audioRecorderControllerDidCancel:(IQAudioRecorderViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)setRecordVideo
{
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        _recordAdioRzblVw = [[SPUserResizableView alloc] initWithFrame:CGRectMake(10, self.collectView.frame.size.height-150, 100, 100)];
    
    else
        _recordAdioRzblVw = [[SPUserResizableView alloc] initWithFrame:CGRectMake(10, self.collectView.frame.size.height+150, 100, 100)];
    
    _recordAdoImgVw = [[UIImageView alloc]initWithFrame:_recordAdioRzblVw.bounds];
    _recordAdoImgVw.image = [UIImage imageNamed:@"audio_128.png"];
    _recordAdoImgVw.contentMode = UIViewContentModeCenter;
    
    _recordAdoImgVw.contentMode = UIViewContentModeScaleAspectFit;
    
    //_OpenCmraImgViw.alpha=0.3;
    
    _recordAdioRzblVw.contentView = _recordAdoImgVw;
    _recordAdioRzblVw.delegate = self;
    _recordAdioRzblVw.contentView.layer.cornerRadius = 15;
    _recordAdioRzblVw.contentView.backgroundColor = [UIColor whiteColor];
    _recordAdioRzblVw.contentView.alpha = 0.5;
    
    _recordAdioRzblVw.resizableStatus = NO;
    
    //   _lastEditedView = _currentlyEditingView;
    //   _currentlyEditingView = _mainResizableView;
    //   [_currentlyEditingView showEditingHandles];
    //   [_currentlyEditingView.cancel setHidden:YES];
    
    [_recordAdioRzblVw hideEditingHandles];
    [_recordAdioRzblVw.cancel removeFromSuperview];
    [_recordAdioRzblVw removeBorder];
    
}

- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView
{
    userResizableView.contentView.alpha = 1.0f;
}

-(void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView
{
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:
     ^{
         userResizableView.contentView.alpha = 0.5;
     }
                     completion:^(BOOL finished)
     {
         
     }];
}

-(void)openCamera
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"])
    {
        NSLog(@"RecordAudio");
        IQAudioRecorderViewController *controller = [[IQAudioRecorderViewController alloc] init];
        
        controller.delegate = self;
        
        [self presentAudioRecorderViewControllerAnimated:controller];
  }
}
-(void)reducePoints
{
    
    NSLog(@"Minutes / Space");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    
    //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=update_points";
    
    NSDictionary *params = @{@"User_ID":user_id,@"operation":@"minus",@"points":@"30",@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json minutes Reward Response:%@",responseObject);
         if([[responseObject objectForKey:@"status"] isEqualToString:@"Success"]){
             Credits=[responseObject objectForKey:@"credit_points"];
             
             [[NSUserDefaults standardUserDefaults]setObject:Credits forKey:@"credit_points"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
         }
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
}
-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"MusicRemoved"]){
        [self loadMusic];
    }else if([alertView.accessibilityHint isEqualToString:@"MusicUploaded"]){
        [self loadMusic];
    }
    
    else if([alertView.accessibilityHint isEqualToString:@"nilLength"])
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"" withTitle:@"Enter music name" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden=YES;
        popUp.agreeBtn.hidden = NO;
        popUp.cancelBtn.hidden = NO;
        popUp.inputTextField.hidden = NO;
        popUp.agreeBtn.backgroundColor=[UIColor navyBlue];
        popUp.cancelBtn.backgroundColor=[UIColor blueBlack];
        popUp.accessibilityHint=@"CroppedMusic";
        popUp.agreeBtn.titleLabel.text = @"Okay";
        [popUp show];
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToDelete"]){
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToEdit"]){
        
        
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToPlay"]){
        
       
    }else if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        [hud_1 hideAnimated:YES];
        [_BlurView removeFromSuperview];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToUpgrade"]){
        [hud_1 hideAnimated:YES];
        [_BlurView removeFromSuperview];
    }
    [self cancelButtonPressed];
    [alertView hide];
    alertView = nil;
    NSLog(@"Cancel");
}
- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToUpgrade"]){
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        // }
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToDelete"]){
        NSString *delID = [[MusicName objectAtIndex:alertView.accessibilityValue.integerValue]valueForKey:@"aud_id"];
        
        delPos = (int)alertView.accessibilityValue.integerValue;
        
        [self deleteAudio:delID];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToPlay"]){
        NSString *sendIndex = alertView.accessibilityValue;
        [self okButtonsPressed:sendIndex];
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToEdit"]){
        
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)alertView.accessibilityHint.integerValue];
        [self okButtonPressed:sendIndex];
        
    }
    else if([alertView.accessibilityHint isEqualToString:@"CroppedMusic"])
    {
        
        if (alertView.inputTextField.text.length == 0)
        {
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"You forgot to enter a file name" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor navyBlue];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            popUp.accessibilityHint=@"nilLength";
            [popUp show];
        }
        
        else
        {
           /* hud_1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            hud_1.mode = MBProgressHUDModeAnnularDeterminate;
            hud_1.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");*/
            [_currentWindow addSubview:_BlurView];
            [_currentWindow addSubview:animationView];
            
            [animationView playWithCompletion:^(BOOL animationFinished) {
                // ...
            }];
            NSDictionary *parameters =@{@"lang":@"iOS",@"User_ID":user_id,@"type":@"audio_recording"};
            
            NSString *url=@"https://www.hypdra.com/api/api.php?rquest=update_plan_status";
            
            NSError *error;      // Initialize NSError
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
            
            NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];  // make NSMutableURL req
            
            req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add parameters to NSMutableURLRequest
            [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
            
            [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
              {
                  
                  if (!error)
                  {
                      NSDictionary *resp=responseObject;
                      if([[resp objectForKey:@"status"] isEqualToString:@"1"])
                      {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"getPlanStatus" object:nil];
                      }
                  }
                  
              }]resume];
            
            
            cropAudioName = alertView.inputTextField.text;
            
            NSLog(@"Crop File Name = %@",cropAudioName);
            
            [self sendEditAudio:audioFilePath];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
            
            NSDate *currentDate = [NSDate date];
            cropAudioName = [formatter stringFromDate:currentDate];
        }
    }else if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        
        NSData *data=[NSData dataWithContentsOfFile:globalDataPath];
        [self FileName:(NSString *)songTitle Data:(NSData *)data];
        
    }
    
    [alertView hide];
    alertView = nil;
}

- (IBAction)close_purchaseView:(id)sender
{
    self.purchaseView.hidden=YES;
    self.topView.hidden=YES;
}

- (IBAction)Pay:(id)sender
{
    //purchase_type=@"4";
    
    [TestKit setcFrom:@"UploadOneMusic"];
    
    [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.onemusic"];
}

- (IBAction)Redeem:(id)sender
{
    /*if([creditPoints intValue] >= 30)
    {
        //purchase_type=@"3";
        [self updateUnlockPayment];
    }
    else
    {
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have enough Credit Points to unlock ! kindly watch videos to get more points" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }*/
}

@end

