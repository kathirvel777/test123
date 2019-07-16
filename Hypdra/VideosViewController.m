//
//  VideosViewController.m
//  Montage
//
//  Created by MacBookPro on 4/26/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "VideosViewController.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "UploadVideoCollectionCell.h"
#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "TrimViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <ImageIO/ImageIO.h>
#import "VideosDemoViewController.h"
#import "VideoEditorViewController.h"
#import "DropboxDownloadFileViewControlller.h"
#import "DropboxIntegrationViewController.h"
#import "DropboxVideoViewController.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "ODCollectionViewController.h"
#import "GDriveViewController.h"
//@import BoxContentSDK;
//#import "BOXSampleFolderViewController.h"
#import "TabBarViewController.h"
#import "DEMORootViewController.h"
#import "DEMOHomeViewController.h"
#import "PlayVideoViewController.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import <Lottie/Lottie.h>


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface VideosViewController ()<UIImagePickerControllerDelegate,UICollectionViewDelegate,UINavigationControllerDelegate,VideoDemoViewControllerDelegate,DropBoxVideoImportDelegate,ODVideoImportDelegate,GDriveImportDelegate,ClickDelegates>
{
    NSMutableArray *imageName,*sendImage,*VideoName,*fullImage,*thumbImage,*MultipleDeleteItemsAry,*MultipleDeleteIndexPathAry,*durationVal;
    NSString *user_id,*imageID;
    NSMutableURLRequest *request;
    NSString *imgName,*deleteName;
    NSString *finalVideoID,*cropVideoURL,*cropVideoName,*Credits,*VideoUploaded;
    
    VKVideoPlayerViewController *viewController;
    
    VideosDemoViewController *videoDemo;
    DropboxVideoViewController *dropBoxVc;
    
    UIImagePickerController *picker;
    
    NSMutableArray *finalArray,*OnlyImages;
    int deleteTag;
    
    NSIndexPath *ShareBtn;
    
    LOTAnimationView *animationView;
    
    NSIndexPath *selectedValue;
    UITapGestureRecognizer *tapValue;
    ODCollectionViewController *ODCollectionVc;
    BOOL isImagePick,isDeleteMode,isMembershipPlan;
    MBProgressHUD *hud;
    
    //#define URL @"https://www.hypdra.com/api/api.php?rquest=image_upload"
    
#define URL @"https://hypdra.com/api/api.php?rquest=image_upload_final"
    
    //  #define URL @"http://seekitechdemo.com/ar/api.php?request=updateVideo"
    
}

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation VideosViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callFinishedVideo:)
                                                 name:@"saveToUpload"
                                               object:nil];
    
    isImagePick = NO;
    tapValue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPosition:)];
    [tapValue setNumberOfTapsRequired:1];
    tapValue.delegate=self;
    
    [self.SocialView addGestureRecognizer:tapValue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxVideoLogin) name:@"DropboxVideoLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishedVideoEdit:)
                                                 name:@"UploadEditedVideo" object:nil];
    
    [[self.videoCamera imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [self deleteLocalValue];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage= [[NSMutableArray alloc]init];
    
    finalArray = [[NSMutableArray alloc]init];
    sendImage = [[NSMutableArray alloc]init];
    MultipleDeleteItemsAry = [[NSMutableArray alloc]init];
    MultipleDeleteIndexPathAry = [[NSMutableArray alloc]init];
    
    durationVal=[[NSMutableArray alloc]init];
    
    
    //OnlyImages = [[NSMutableArray alloc]init];
    
    /*    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
     [flowLayout setMinimumInteritemSpacing:4.0f];
     
     [flowLayout setMinimumLineSpacing:5.0f];
     
     [self.CollectionView setCollectionViewLayout:flowLayout];
     
     [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];*/
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:10.0f];
    
    [self.CollectionView setCollectionViewLayout:flowLayout];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    // Do any additional setup after loading the view.
    //[self getName];
    
    self.CollectionView.bounces = false;
    _currentWindow = [UIApplication sharedApplication].keyWindow;
    
    _BlurView = [[UIView alloc]initWithFrame:CGRectMake(_currentWindow.frame.origin.x, _currentWindow.frame.origin.y, _currentWindow.frame.size.width, _currentWindow.frame.size.height)];
    _BlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.minimumPressDuration = 1.0;
    [self.CollectionView addGestureRecognizer:lpgr];
    self.CollectionView.allowsMultipleSelection = YES;
    [self setRecordVideo];
    //[self UserPlanLimitsTracking];
    [self getVideos];
    
    animationView = [LOTAnimationView animationNamed:@"loading_h"];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    [animationView setCenter:self.view.center];
    animationView.loopAnimation = YES;

}

- (void)deleteMultipleItems:(NSNotification *)notify{
    //    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure you want to delete the selected video?"preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction* yesButton = [UIAlertAction
    //                                actionWithTitle:@"Yes"
    //                                style:UIAlertActionStyleDefault
    //                                handler:^(UIAlertAction * action)
    //                                {
    //                                    NSLog(@"Close:%@",MultipleDeleteItemsAry);
    //
    //
    //
    //                                    [self deleteImage];
    //                                }];
    //
    //    UIAlertAction* noButton = [UIAlertAction
    //                               actionWithTitle:@"No"
    //                               style:UIAlertActionStyleDefault
    //                               handler:nil];
    //
    //    [alert addAction:yesButton];
    //    [alert addAction:noButton];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to delete the selected video ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.hidden = YES;
    popUp.accessibilityHint =@"ConfirmToMultipleDelete";
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.inputTextField.hidden = YES;
    [popUp show];
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:self.CollectionView];
        NSIndexPath *indexPath = [self.CollectionView indexPathForItemAtPoint:p];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            if(!isDeleteMode){
                if(!(self.selectedItemIndexPath == nil)){
                    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:self.selectedItemIndexPath];
                    self.selectedItemIndexPath=nil;
                    [self.CollectionView reloadItemsAtIndexPaths:indexPaths];
                }
                UploadVideoCollectionCell* cell =
                [self.CollectionView cellForItemAtIndexPath:indexPath];
                cell.selectedIconForDelete.hidden = NO;
                cell.aboveTopView.hidden = NO;
                NSDictionary *dic = [finalArray objectAtIndex:indexPath.row];
                [dic setValue:@"1" forKey:@"SelectedForDelete"];
                [finalArray replaceObjectAtIndex:indexPath.row withObject:dic];
                //  [cell setSelected:YES];
                
            [self.CollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                [MultipleDeleteItemsAry addObject:dic];
                [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:indexPath.row]];
                isDeleteMode = YES;
                
                TabBarViewController *tabContrl = self.tabBarController;
                NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected( %d )", MultipleDeleteItemsAry.count];
                tabContrl.TttleLable.text = selectedItemString;
                tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"deleteStroke.png"];
                // tabContrl.addAndDeleteBtn.image
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DeleteMode"];
            }
        }
        
        // do stuff with the cell
    }
}


-(void)callFinishedVideo:(NSNotification*)noti
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"saveToUpload"];
    //    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //
    //    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSLog(@"Called callFinishedVideo");
    
    NSString *effectVideo=[[NSUserDefaults standardUserDefaults]stringForKey:@"videoPathValue"];
    
    NSURL *filename = [NSURL URLWithString:effectVideo];
    
    [self FinishedVideo:filename];
    
    //  [hud hideAnimated:YES];
    
}

-(void)dropboxVideoLogin
{
    isImagePick = YES;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DropboxVideoViewController *dropBoxVc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DropboxVideoViews"];
    dropBoxVc.delegate=self;
    
    [self.navigationController pushViewController:dropBoxVc animated:YES];
    
    [[NSNotificationCenter defaultCenter]removeObserver:@"DropboxLogin"];
}


-(void)tapPosition:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^
     {
         self.SocialView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         self.TopSocialView.hidden = true;
         self.SocialView.hidden = true;
     }
     ];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    NSString *restrictionForResolution=[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"];
    
    if([restrictionForResolution isEqualToString:@"Basic"])
    {
        isMembershipPlan=NO;
    }
    else if([restrictionForResolution isEqualToString:@"Standard"])
    {
        isMembershipPlan=YES;
    }
    else {
        isMembershipPlan=YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddVideo:)
                                                 name:@"postVideo" object:nil];
    
    
    
    
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"share_btn"];
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"crop_btn"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"USER_ID"]];
    
    NSLog(@"User ID = %@",user_id);
    
    NSLog(@"VideoOnlyImages %lu",(unsigned long)
          OnlyImages.count);
    
    self.TopSocialView.hidden = true;
    self.SocialView.hidden = true;
    
//    if (finalArray.count == 0)
//    {
//        self.CollectionView.hidden = true;
//        self.EmptyPageView.hidden = false;
//    }
//    else
//    {
//        NSLog(@"VideoOnlyImages %lu",(unsigned long)finalArray.count);
//        
//        self.CollectionView.hidden = false;
//        self.EmptyPageView.hidden = true;
//    }
    if(isImagePick==NO)
    {
        [self getVideos];
    }
    if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        
        [self.ADView removeFromSuperview];
    }
    //    [self getName];
}

-(void)getVideos
{
    @try
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=view_my_image";
        NSDictionary *parameters = @{@"User_ID":user_id,@"lang":@"iOS",@"page_number":@"0",@"media_type":@"video"};
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
                  
                  NSArray *imageArray = [response objectForKey:@"view_my_image"];
                  
                  NSLog(@"Image Response %@",response);
                  
                  finalArray = [[NSMutableArray alloc]init];
                  
                  NSArray *statusArray = [response objectForKey:@"Response_array"];
                  
                  NSDictionary *stsDict = [statusArray objectAtIndex:0];
                  
                  NSString *status = [stsDict objectForKey:@"msg"];
                  Credits = [stsDict objectForKey:@"credit_points"];
                  VideoUploaded = [stsDict objectForKey:@"video_upload"];
                
                  if ([status isEqualToString:@"Found"])
                  {
                      isImagePick = NO;
                      
                      for(NSDictionary *imageDic in imageArray)
                      {
                          NSString *thumbnailPath;
                          
                          NSString *type = [imageDic objectForKey:@"type"];
                          NSString *id;
                          if([type isEqualToString:@"Video"])
                          {
                              thumbnailPath = [imageDic objectForKey:@"thumb_img"];
                              id = [imageDic objectForKey:@"image_id"];
                              
                              [durationVal addObject:[imageDic objectForKey:@"duration"]];
                              
                              NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                              
                              [dic setValue:type forKey:@"DataType"];
                              
                              [dic setValue:id forKey:@"Id"];
                              [dic setObject:thumbnailPath forKey:@"imagePath"];
                              
                              
                              [dic setValue:@"0" forKey:@"SelectedForDelete"];
                              [finalArray addObject:dic];
                          }
                      }
                      
//                      if(finalArray.count==0)
//                      {
//                          self.pageViewImgView.hidden=NO;
//                          
//                          self.pageViewImgView.image=[UIImage imageNamed:@"500-video.png"];
//                      }
                      
                      NSLog(@"Final Array in uploadimg:%@",finalArray);
                      if (finalArray.count == 0)
                      {
                          self.CollectionView.hidden = true;
                          self.EmptyPageView.hidden = false;
                          [hud hideAnimated:YES];
                      }
                      else
                      {
                          self.CollectionView.hidden = false;
                          self.EmptyPageView.hidden = true;
                          
                          [self.CollectionView reloadData];
                          
                          NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                          
                          [self.CollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                          
                          [hud hideAnimated:YES];
                      }
                      
                  }
                  else
                  {
                      
                      NSLog(@"No Image Found");
                      self.CollectionView.hidden=YES;
                      self.pageViewImgView.hidden=NO;
                      self.pageViewImgView.image=[UIImage imageNamed:@"500-image.png"];
                      [hud hideAnimated:YES];
                  }
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  [hud hideAnimated:YES];
              }
              
              //              if(finalArray.count>1){
              //                  NSInteger item = finalArray.count-1;
              //                  NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
              //                  [self.CollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
              //              }
              // [self setRecordVideo];
              
              if (finalArray.count == 0)
                  [self.EmptyPageView addSubview:_RecordVdoRzblView];
              else
                  [self.CollectionView.superview addSubview:_RecordVdoRzblView];
              
          }]resume];
    }
    @catch (NSException *exception)
    {
        [hud hideAnimated:YES];
    }
    @finally
    {
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    //  [_RecordVdoRzblView removeFromSuperview];
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postVideoDelete" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self removeItemsFromDeleteMode];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (finalArray.count == 0)
        [self.EmptyPageView addSubview:_RecordVdoRzblView];
    else
        [self.CollectionView.superview addSubview:_RecordVdoRzblView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteMultipleItems:) name:@"postVideoDelete" object:nil];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
    TabBarViewController *tabContrl = self.tabBarController;
    tabContrl.TttleLable.text = @"My Videos";
    tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"12-PLUS.png"];
    // [self setRecordVideo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)AddVideo:(NSNotification *)note
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
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
        
        if ([spcAvil isEqualToString:@"Space Available"])
        {
            
            self.TopSocialView.hidden = false;
            self.SocialView.hidden = false;
            
            self.SocialView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
            
            [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:
             ^{
                 self.SocialView.center = CGPointMake(self.view.center.x, self.view.center.y * 80/100);// self.view.center;
                 
                 NSLog(@"Center = %f",self.SocialView.center.y);
                 
                 self.SocialView.layer.cornerRadius = 10.0f;
                 self.SocialView.layer.masksToBounds = YES;
             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"Completed");
             }];
   
        }
        else
        {
            //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
            //                                                                      message:@"You do not have space"
            //                                                               preferredStyle:UIAlertControllerStyleAlert];
            //
            //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
            //                                                            style:UIAlertActionStyleDefault handler:nil];
            //
            //        [alert addAction:yesButton];
            //
            //        [self presentViewController:alert animated:YES completion:nil];
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"You do not have space" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor navyBlue];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
        }
    }
}

-(void)viewDidLayoutSubviews
{
    
    //2qself.secondView.frame = CGRectMake(0,  0, self.secondView.frame.size.width, self.secondView.frame.size.height -50);

    // self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);

   // NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"numberOfItemsInSection %lu",(unsigned long)[finalArray count]);
    return [finalArray count];
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"VideoIndex = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    UploadVideoCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //    cell.layer.borderWidth = 0.2f;
    
    cell.alpha = 1.0;
    
    /*  NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *DocDir = [ScreensDir objectAtIndex:0];
     
     DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
     NSMutableDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
     NSLog(@"OnlyVideos %@",OnlyImages);
     NSString *id1 = [dic valueForKey:@"Id"];
     
     DocDir = [DocDir stringByAppendingPathComponent:[id1 stringByAppendingString:@".png"]];*/
    
    /*    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
     
     UIImage *img=[[UIImage alloc] initWithData:pictureData];
     
     cell.ImageView.image = img;*/
    
    //  NSURL *imageURL = [NSURL fileURLWithPath:DocDir];
    
    //[cell.BackGroundImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
    NSURL *url=[[finalArray objectAtIndex:indexPath.row]objectForKey:@"imagePath"];
    if([[[finalArray objectAtIndex:indexPath.row]objectForKey:@"SelectedForDelete"] isEqualToString:@"1"]){
        cell.selectedIconForDelete.hidden = NO;
    }
    [cell.ImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"128-video-holder"]];
    
    
    //SHADOW WITH CORNER RADIUS
    
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
    //SHADOW WITH CORNER RADIUS
    
    [cell.BackGroundImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
    
    /*    NSData *pictureData = UIImagePNGRepresentation(cell.ImageView.image);
     
     CGImageSourceRef BlurImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)pictureData, NULL);
     CFDictionaryRef BlurOptions = (__bridge CFDictionaryRef) @{
     (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
     (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
     (id) kCGImageSourceThumbnailMaxPixelSize : @(50)
     };
     
     // Generate the thumbnail
     CGImageRef Blurthumbnail = CGImageSourceCreateThumbnailAtIndex(BlurImageSource, 0, BlurOptions);
     if (NULL != BlurImageSource)
     CFRelease(BlurImageSource);
     
     UIImage* scaledBlurImage = [UIImage imageWithCGImage:Blurthumbnail];
     CGSize newBlurSize =   CGSizeMake((scaledBlurImage.size.width), (scaledBlurImage.size.height));
     UIGraphicsBeginImageContext(newBlurSize);
     [cell.ImageView.image drawInRect:CGRectMake(0, 0, newBlurSize.width, newBlurSize.height)];
     
     UIImage *BackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     cell.BackGroundImageView.image = BackgroundImage;*/
    
    //    cell.aboveTopView.hidden = true;
    //    cell.topView.hidden = true;
    
    //    cell.ImgView.image = img;
    
    cell.delete.tag = indexPath.row;
    [cell.delete addTarget:self action:@selector(close_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnCrop.tag = indexPath.row;
    [cell.btnCrop addTarget:self action:@selector(crop_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.playVideo.tag = indexPath.row;
    [cell.playVideo addTarget:self action:@selector(play_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.shareBtn.tag = indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(share_btn:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    if (networkStatus == NotReachable)
    {
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
        isImagePick=YES;
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        
       // UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Confirm" message:@"Do you want to play?"preferredStyle:UIAlertControllerStyleAlert];
        
        //    UIAlertAction* yesButton = [UIAlertAction
        //                                actionWithTitle:@"Yes"
        //                                style:UIAlertActionStyleDefault
        //                                handler:^(UIAlertAction * action)
        //                                {
        //                                    [self okButtonPresseds:sendIndex];
        //                                }];
        //
        //    UIAlertAction* noButton = [UIAlertAction
        //                               actionWithTitle:@"No"
        //                               style:UIAlertActionStyleDefault
        //                               handler:^(UIAlertAction * action)
        //                               {
        //                                   [self cancelButtonPressed];
        //                               }];
        //
        //    [alert addAction:yesButton];
        //    [alert addAction:noButton];
        //
        //    [self presentViewController:alert animated:YES completion:nil];
        
        [self okButtonPresseds:sendIndex];
        
//        CustomPopUp *popUp = [CustomPopUp new];
//        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to play?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
//        popUp.okay.hidden = YES;
//        popUp.accessibilityHint =@"ConfirmToPlay";
//        popUp.accessibilityValue = [NSString stringWithFormat:@"%d",sender.tag];
//        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
//        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
//        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
//        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
//        popUp.inputTextField.hidden = YES;
//        [popUp show];
    }
}


- (void)okButtonPresseds:(NSString*)getIndex
{
    NSLog(@"Play Action");
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    NSString *SharedFinalplistPath = [myPath stringByAppendingPathComponent:@"DataList.plist"];
    NSLog(@"SharedFinalplistPath%@",SharedFinalplistPath);
    VideoName = [[NSMutableArray alloc]init];
    
    // VideoName = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    //NSMutableArray *tempOnlyVideos;
    
    for(NSMutableDictionary *dic in finalArray)
    {
        
        if([[dic valueForKey:@"DataType"] isEqualToString:@"Video"])
        {
            [VideoName addObject:dic];
        }
    }
    
    int getPath = [getIndex intValue];
    
    NSDictionary *getArray = [finalArray objectAtIndex:getPath];
    
    NSLog(@"getArray = %@",getArray);
    finalVideoID = [getArray valueForKey:@"Id"];// valueForKey:@"MusicId"];
    
    /*    for (NSDictionary *getDict in getArray)
     {
     finalAudioID = [getDict objectForKey:@"MusicId"];// valueForKey:@"MusicId"];
     }*/
    [self getURLs];
}

-(void)getURLs
{
    @try
    {
        NSLog(@"userid:%@, finalvideoid:%@",user_id,finalVideoID);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_particular_video_path";
        
        NSDictionary *params = @{@"user_id":user_id,@"lang":@"iOS",@"image_id":finalVideoID};
        
        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             
             NSLog(@"Video Particular Response = %@",response);
             
             NSArray *MusicArray = [response objectForKey:@"view_particular_video_path"];
            for(NSDictionary *imageDic in MusicArray)
             {
                 cropVideoURL = [imageDic objectForKey:@"Image_Path"];
             }
             
             NSURL *url = [NSURL URLWithString:cropVideoURL];

             
             UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
             
             PlayVideoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PlayVideoView"];
             
             vc.urlValue = url;
             
             //[self presentViewController:vc animated:YES completion:NULL];
             [self.navigationController pushViewController:vc animated:YES];
             
             /*             AVPlayer *player = [[AVPlayer alloc] initWithURL: url];
              
              //                                    AVPlayer *player = [AVPlayer playerWithURL:url];
              
              AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
              
              
              //             controller.view.backgroundColor = [UIColor blueColor];
              
              //             av.view.backgroundColor = UIColor.whiteColor()
              
              [self presentViewController:controller animated:YES completion:nil];
              controller.player = player;
              [player play];*/
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error : %@", error);
             
             
             //             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Try Again" preferredStyle:UIAlertControllerStyleAlert];
             //
             //             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
             //             [alertController addAction:ok];
             //
             //             [self presentViewController:alertController animated:YES completion:nil];
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
             
             //responseBlock(nil, FALSE, error);
         }];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}



- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeStateFrom:(VKVideoPlayerState)fromState
{
    NSLog(@"didChangeStateFrom");
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeStateTo:(VKVideoPlayerState)toState
{
    NSLog(@"willChangeStateFrom");
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track
{
    NSLog(@"didPlayToEnd");
    
    NSURL *url = [NSURL URLWithString:cropVideoURL];
    [viewController playVideoWithStreamURL:url];
    
    //    [self playSampleClip1];
}

-(void)share_btn:(UIButton*)sender
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
        ShareBtn = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        //    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure, Do you want to Share?"preferredStyle:UIAlertControllerStyleAlert];
        //
        //    UIAlertAction* yesButton = [UIAlertAction
        //                                actionWithTitle:@"Yes"
        //                                style:UIAlertActionStyleDefault
        //                                handler:^(UIAlertAction * action)
        //                                {
        //                                    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"share_btn"];
        //                                    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"crop_btn"];
        //
        //                                    [self okButtonPressed:sendIndex];
        //                                }];
        //
        //    UIAlertAction* noButton = [UIAlertAction
        //                               actionWithTitle:@"No"
        //                               style:UIAlertActionStyleDefault
        //                               handler:^(UIAlertAction * action)
        //                               {
        //                                   [self cancelButtonPressed];
        //                               }];
        //
        //    [alert addAction:yesButton];
        //    [alert addAction:noButton];
        //
        //    [self presentViewController:alert animated:YES completion:nil];
        
        
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"share_btn"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"crop_btn"];
        
        
       
       
        [self shareButtonPressed:sendIndex];
        
       /* CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to share?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToShare";
        popUp.accessibilityValue =[NSString stringWithFormat:@"%d",sender.tag];
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];*/
        
    }
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
        isImagePick=YES;
        NSLog(@"Crop Action");
        
        //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //    NSString *documentsDirectory = [paths objectAtIndex:0];
        //    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
        //
        //    NSString *SharedFinalplistPath = [myPath stringByAppendingPathComponent:@"DataList.plist"];
        // NSLog(@"SharedFinalplistPath%@",SharedFinalplistPath);
        
        VideoName = [[NSMutableArray alloc]init];
        
        for(NSMutableDictionary *dic in finalArray)
        {
            if([[dic valueForKey:@"DataType"] isEqualToString:@"Video"])
            {
                [VideoName addObject:dic];
            }
        }
        
        int getPath =(int)sender.tag ;
        [[NSUserDefaults standardUserDefaults]setObject:[durationVal objectAtIndex:getPath] forKey:@"durationTime"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSDictionary *getArray = [VideoName objectAtIndex:getPath];
        
        NSLog(@"getArray = %@",getArray);
        
        finalVideoID = [getArray valueForKey:@"Id"];
        
        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
        
           VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
        
        vc.finalVideoID=finalVideoID;
        vc.viewHiding=@"first";
        
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"didSelectTap"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//{
//    NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
//
//
//    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure, Do you want to edit?"preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction* yesButton = [UIAlertAction
//                                actionWithTitle:@"Yes"
//                                style:UIAlertActionStyleDefault
//                                handler:^(UIAlertAction * action)
//                                {
//                                    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"share_btn"];
//                                    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"crop_btn"];
//
//                                    [self okButtonPressed:sendIndex];
//
//                                }];
//
//    UIAlertAction* noButton = [UIAlertAction
//                               actionWithTitle:@"No"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction * action)
//                               {
//                                   [self cancelButtonPressed];
//                               }];
//
//    [alert addAction:yesButton];
//    [alert addAction:noButton];
//
//    [self presentViewController:alert animated:YES completion:nil];
//}


- (void)cancelButtonPressed
{
    // write your implementation for cancel button here.
}

- (void)shareButtonPressed:(NSString*)getIndex
{
    NSLog(@"Crop Action");
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    NSString *SharedFinalplistPath = [myPath stringByAppendingPathComponent:@"DataList.plist"];
    NSLog(@"SharedFinalplistPath%@",SharedFinalplistPath);
    
    VideoName = [[NSMutableArray alloc]init];
    
    // VideoName = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    NSMutableArray *tempOnlyVideos;
    for(NSMutableDictionary *dic in finalArray)
    {
        
        if([[dic valueForKey:@"DataType"] isEqualToString:@"Video"])
        {
            [VideoName addObject:dic];
        }
    }
    
    int getPath = [getIndex intValue];
    
    NSDictionary *getArray = [VideoName objectAtIndex:getPath];
    
    NSLog(@"getArray = %@",getArray);
    
    finalVideoID = [getArray valueForKey:@"Id"];// valueForKey:@"MusicId"];
    
    /*    for (NSDictionary *getDict in getArray)
     {
     finalAudioID = [getDict objectForKey:@"MusicId"];// valueForKey:@"MusicId"];
     }*/
    
    [self getURL];
}

-(void)getURL
{
    @try
    {
        NSLog(@"userid:%@, finalvideoid:%@",user_id,finalVideoID);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_particular_video_path";
        
        NSDictionary *params = @{@"user_id":user_id,@"lang":@"iOS",@"image_id":finalVideoID};
        
        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             
             NSLog(@"Video Particular Response = %@",response);
             
             NSArray *MusicArray = [response objectForKey:@"view_particular_video_path"];
             
             //                 musicArray = [[NSMutableArray alloc]init];
             
             
             for(NSDictionary *imageDic in MusicArray)
             {
                 //27APR STARTS
                 
                 cropVideoURL = [imageDic objectForKey:@"Image_Path"];
                 // cropVideoName = [imageDic objectForKey:@"Audio_name"];
                 
                 //                     NSDictionary *sampleDic = @{@"MusicTitle":name,@"MusicId":audid};
                 //
                 //                     [musicArray addObject:sampleDic];
             }
             
             
             //             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             
             //    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             
             
             /*        // Set some text to show the initial status.
              hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
              // Will look best, if we set a minimum size.
              hud.minSize = CGSizeMake(150.f, 100.f);
              
              [self doSomeNetworkWorkWithProgress];*/
             
             
             [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
             
             
             //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             
             //   hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             
             
             //             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             
             
             [self doSomeNetworkWorkWithProgress];
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error : %@", error);
             
             
             [hud hideAnimated:YES];
             
             
             //             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not conenct to server" preferredStyle:UIAlertControllerStyleAlert];
             //
             //             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
             //             [alertController addAction:ok];
             //
             //             [self presentViewController:alertController animated:YES completion:nil];
             //
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
             //responseBlock(nil, FALSE, error);
         }];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
}

- (void)doSomeNetworkWorkWithProgress
{
    
    NSLog(@"doSomeNetworkWorkWithProgress = %@",cropVideoURL);
    
    NSLog(@"cropVideoURL = %@",cropVideoURL);
    
    if (cropVideoURL == nil)
    {
        
        NSLog(@"cropVideoURL NULL");
        
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:true];
        
        //        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.BlurView];
        //        [hud hideAnimated:YES];
        //
        
        
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Video not found" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
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
        NSURL *audioURL = [NSURL URLWithString:cropVideoURL];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:audioURL];
        [task resume];
        
    }
}

- (void)cancelWork:(id)sender
{
    //    self.canceled = YES;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // Do something with the data at location...
    
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
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"crop_btn"])
    {
        
        
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
        
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
        
        
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"share_btn"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"crop_btn"];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
        
        TrimViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TrimVideo"];
        
        NSLog(@"TrimViewController Video ID = %@",finalVideoID);
        
        vc.currentVideoID = finalVideoID;
        
        //        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        //         [self presentViewController:vc animated:YES completion:NULL];
        
        // [self openCrop:appDir];
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"share_btn"])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        
        //getting application's document directory path
        NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [tempArray objectAtIndex:0];
        
        //adding a new folder to the documents directory path
        NSString *appDir = [docsDir stringByAppendingPathComponent:@"/shareVideo/"];
        
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
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
            
        });
        
        
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"share_btn"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"crop_btn"];
        
        [self shareVideoTo];
        
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.progress = progress;
    });
}


-(void)shareVideoTo
{
    
    NSLog(@"shareVideoTo");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [tempArray objectAtIndex:0];
        
        
        NSString *appDir = [docsDir stringByAppendingPathComponent:@"/shareVideo/"];
        
        
        NSString  *filePath =  [appDir stringByAppendingPathComponent:@"samplevideo.mp4"];
        
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSData *dt = [NSData dataWithContentsOfURL:url];
        
        NSLog(@"Dt = %lu",(unsigned long)dt.length);
        
        NSArray * activityItems = @[url];
        
        NSArray * applicationActivities = nil;
        
        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
        
        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
        
        activityController.excludedActivityTypes = excludeActivities;
        
        //        [activityController setCompletionHandler:^(NSString *activityType, BOOL completed)
        //         {
        //             if (completed)
        //             {
        //                 NSLog(@"avc done");
        //             }
        //             else
        //             {
        //                 NSLog(@"avc cancelled"); //<<<<---
        //             }
        //         }];
        
        
        [activityController setCompletionWithItemsHandler:
         ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError)
         {
             if (completed)
             {
                 NSLog(@"avc done");
                 [self deleteLocalValue];
             }
             else
             {
                 NSLog(@"avc cancelled"); //<<<<---
                 [self deleteLocalValue];
             }
         }];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self presentViewController:activityController animated:YES completion:nil];
        }
        else
        {
            
            static NSString *CellIdentifier = @"Cell";
            
            UploadVideoCollectionCell *cell=[self.CollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:ShareBtn];
            
            cell.layer.borderWidth = 0.2f;
            
            UIPopoverPresentationController *presentationController = [activityController popoverPresentationController];
            presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            presentationController.sourceView = cell.topView ;
            presentationController.sourceRect = cell.shareBtn.frame;
            
            [self presentViewController:activityController animated:YES completion:nil];
            
        }
        
        //      [self presentViewController:avc animated:YES completion:nil];
    });
}


-(void)deleteLocalValue
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/shareVideo/"];
    
    if([fileManager fileExistsAtPath:appDir])
    {
        NSLog([fileManager removeItemAtPath:appDir error:&error]?@"deleted":@"not deleted");
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        deleteTag =  (int)sender.tag;
        //    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure you want to delete the selected video?"preferredStyle:UIAlertControllerStyleAlert];
        //
        //    UIAlertAction* yesButton = [UIAlertAction
        //                                actionWithTitle:@"Yes"
        //                                style:UIAlertActionStyleDefault
        //                                handler:^(UIAlertAction * action)
        //                                {
        //                                    NSLog(@"Close:%@",finalArray);
        //
        //                                    NSString *img = [[finalArray objectAtIndex:sender.tag]objectForKey:@"Id"];
        //                                    NSDictionary *dic =   [finalArray objectAtIndex:sender.tag];
        //                                    [MultipleDeleteItemsAry addObject:dic];
        //
        //                                    //DELETE LOCAL ARRAY AND UPDATE COLLECTIOVIEW
        //
        //                                    NSIndexPath *myIP = [NSIndexPath indexPathForRow:deleteTag inSection:0] ;
        //                                    [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:deleteTag]];
        ////                                    [finalArray removeObjectAtIndex:deleteTag];
        ////                                    NSArray *deleteItems = @[myIP];
        ////                                    [self.CollectionView deleteItemsAtIndexPaths:MultipleDeleteIndexPathAry];
        //                                    //[self getName];
        //                                    //DELET LOCAL ARRAY AND UPDATE COLLECTIOVIEw
        //
        //                                    NSLog(@"img:%@",img);
        //                                    deleteName = img;
        //
        //                                    NSLog(@"Img = %@",deleteName);
        //
        //                                    [self deleteImage];
        //                                }];
        //
        //    UIAlertAction* noButton = [UIAlertAction
        //                               actionWithTitle:@"No"
        //                               style:UIAlertActionStyleDefault
        //                               handler:nil];
        //
        //    [alert addAction:yesButton];
        //    [alert addAction:noButton];
        //
        //    [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to delete the selected video ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToDelete";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%d",sender.tag];
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}


-(void)deleteImage
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Deleting...", @"HUD loading title");
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * selectedItemString;
    for(NSDictionary *dic in MultipleDeleteItemsAry){
        NSString *deleteID =  [dic objectForKey:@"Id"];
        if(!(selectedItemString == nil))
            selectedItemString = [NSString stringWithFormat:@"%@'%@',",selectedItemString,deleteID];
        else{
            selectedItemString = [NSString stringWithFormat:@"'%@',",deleteID];
        }
    }
    selectedItemString = [selectedItemString substringToIndex:[selectedItemString length]-1];
    [MultipleDeleteItemsAry removeAllObjects];
    isDeleteMode=NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
    TabBarViewController *tabContrl = self.tabBarController;
    
    tabContrl.TttleLable.text = @"My Video";
    tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"12-PLUS.png"];
    // tabContrl.addAndDeleteBtn.image
    NSDictionary *params = @{@"User_ID":user_id ,@"image_id":selectedItemString,@"lang":@"ios",@"type":@"image"};
    
    [manager POST:@"https://www.hypdra.com/api/api.php?rquest=delete_my_image" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {

         NSLog(@"Image Delete Response = %@",responseObject);
         
         NSMutableDictionary *response=responseObject;
         
         NSDictionary *statusArray = [response objectForKey:@"delete_my_image"];
         
         NSLog(@"Delete Response %@",statusArray);
         
         NSString *cnf = [statusArray objectForKey:@"status"];
         
         NSLog(@"Delete Status %@",cnf);
         
         if ([cnf isEqualToString:@"True"])
         {
             
             [hud hideAnimated:YES];
             
             self.selectedItemIndexPath = nil;
             
             
             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
             
             NSString *minAvil=[statusArray objectForKey:@"Duration Status"];
             
             NSString *spcAvil = [statusArray objectForKey:@"Space Status"];
            
             [defaults setValue:minAvil forKey:@"minAvil"];
             
             [defaults setValue:spcAvil forKey:@"spcAvil"];
             [defaults setObject:[statusArray objectForKey:@"Remaining Space"] forKey:@"Remaining Space"];
             
             [defaults synchronize];
             NSArray *arrayOfIndexPaths = [self.CollectionView indexPathsForSelectedItems];
             for(int i=0;i < [MultipleDeleteIndexPathAry count];i){
                 
                 NSNumber *maxNumber = [MultipleDeleteIndexPathAry valueForKeyPath:@"@max.self"];
                 [MultipleDeleteIndexPathAry removeObject:maxNumber];
                 NSIndexPath *removingIndexPath = [NSIndexPath indexPathForRow:maxNumber.intValue inSection:0];
                 [finalArray removeObjectAtIndex:removingIndexPath.row];
                 NSArray *deleteItems = @[removingIndexPath];
                 [self.CollectionView deleteItemsAtIndexPaths:deleteItems];
                 
             }
             
             if(finalArray.count==0)
             {
                 self.CollectionView.hidden=YES;
                 self.EmptyPageView.hidden=NO;
                 
                 self.pageViewImgView.hidden=NO;
                 self.pageViewImgView.image=[UIImage imageNamed:@"500-video.png"];
             }
             
             //             for(int i=0;i<arrayOfIndexPaths.count;i++){
             //
             //                 NSIndexPath *removingIndexPath = [arrayOfIndexPaths objectAtIndex:i];
             //                 NSInteger deleteInteger = (removingIndexPath.item-1);
             //                 [finalArray removeObjectAtIndex:deleteInteger];
             //                 NSArray *deleteItems = @[removingIndexPath];
             //
             //             }
             
             //             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Success"
             //                                                                           message:@"Image removed"
             //                                                                    preferredStyle:UIAlertControllerStyleAlert];
             //
             //             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
             //                                                                 style:UIAlertActionStyleDefault
             //                                                               handler:nil];
             //
             //             [alert addAction:yesButton];
             //
             //             [self presentViewController:alert animated:YES completion:nil];
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Video Deleted" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             // [self getImages];
             
         }
         else
         {
             
             [hud hideAnimated:YES];
             
             //             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Try Again" preferredStyle:UIAlertControllerStyleAlert];
             //
             //             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
             //             [alertController addAction:ok];
             //
             //             [self presentViewController:alertController animated:YES completion:nil];
             
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
         NSLog(@"Image Delete Error = %@", error);
         
         [hud hideAnimated:YES];
         
         //         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not connect to server" preferredStyle:UIAlertControllerStyleAlert];
         //
         //         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
         //         [alertController addAction:ok];
         //
         //         [self presentViewController:alertController animated:YES completion:nil];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
     }];
    
    /*    NSDictionary *params = @{@"User_ID":user_id ,@"image_id":deleteID,@"lang":@"ios"};
     
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
     
     [manager POST:@"https://www.hypdra.com/api/api.php?rquest=delete_my_image" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     NSLog(@"Image Delete Response:%@",responseObject);
     
     [self localDelete];
     
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
     
     NSLog(@"Image Delete Error: %@", error);
     
     UIAlertController * alert = [UIAlertController
     alertControllerWithTitle:@"Error"
     message:@"Try Again"
     preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* yesButton = [UIAlertAction
     actionWithTitle:@"Ok"
     style:UIAlertActionStyleDefault
     handler:nil];
     
     
     [alert addAction:yesButton];
     
     [self presentViewController:alert animated:YES completion:nil];
     
     }];*/
    
}


-(UIImage *)generateThumbImage : (NSURL *)filepath
{
    @try
    {
        NSURL *url = filepath;//[NSURL fileURLWithPath:filepath];
        
        AVAsset *asset = [AVAsset assetWithURL:url];
        //  Get thumbnail at the very start of the video
        CMTime thumbnailTime = [asset duration];
        thumbnailTime.value = 0;
        
        //  Get image from the video at the given time
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
        
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        return thumbnail;
    }
    @catch(NSException *ex)
    {
        NSLog(@"exception occured");
    }
}

- (IBAction)upload:(id)sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *minAvil=[defaults valueForKey:@"minAvil"];
    
    NSString *spcAvil = [defaults valueForKey:@"spcAvil"];
    
    if ([spcAvil isEqualToString:@"Space Available"])
    {
        
        self.TopSocialView.hidden = false;
        self.SocialView.hidden = false;
        
        self.SocialView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
        
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:
         ^{
             self.SocialView.center = CGPointMake(self.view.center.x, self.view.center.y * 80/100);// self.view.center;
             
             NSLog(@"Center = %f",self.SocialView.center.y);
             
             self.SocialView.layer.cornerRadius = 10.0f;
             self.SocialView.layer.masksToBounds = YES;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
         }];
    }
    
    else
    {
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
        //                                                                      message:@"You do not have space"
        //                                                               preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
        //                                                            style:UIAlertActionStyleDefault handler:nil];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You do not have space" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}
/*{
 UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
 imagePicker.delegate = self;
 imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
 
 [self presentViewController:imagePicker animated:YES completion:nil];
 }*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isImagePick=YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // [self getName];
    
    
    sendImage = [[NSMutableArray alloc]init];
    NSLog(@"Size = %lu",(unsigned long)info.count);
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
   
    
   /* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
    */
    
    [_currentWindow addSubview:_BlurView];
    [_currentWindow addSubview:animationView];
    
    [animationView playWithCompletion:^(BOOL animationFinished) {
        // ...
    }];
    
    
    NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
    //
    UIImage *thumbnail = [self generateThumbImage:videoUrl];
    //
    NSData *thumbnailData = UIImagePNGRepresentation(thumbnail);
    //
    NSData *VideoData = [NSData dataWithContentsOfURL:videoUrl];
    
    [fullImage addObject:VideoData];
    [thumbImage addObject:thumbnailData];
    //
    //
    //        imageID = [NSString stringWithFormat:@"%d",HigestImageCount];
    NSString * type =(NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"];
    if(!([type isEqualToString:@"Basic"] && VideoUploaded.integerValue >= 7)){
        [self completeSendImage];
    }else{
        if(Credits.intValue > 30){
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
        }else{
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Sorry you don't have enough credits" withTitle:@"Upgrade Membership" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.accessibilityHint = @"ConfirmToUpgrade";
            // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            popUp.okay.hidden =YES;
            [popUp.agreeBtn setTitle:@"Upgrade" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
            [popUp show];
        }
    }
}

-(void)completeSendImage
{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        //[hud hideAnimated:YES];
        [animationView removeFromSuperview];
        [_BlurView removeFromSuperview];
    }
    else
    {
        NSData *data = (NSData *)[fullImage objectAtIndex:0];
        float size = ((float)data.length/1024.0f/1024.0f);
        NSLog(@"File size is : %.2f MB",size);
        dispatch_group_t group=dispatch_group_create();
       
        
        NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                         {
                                             for (int i = 0; i<fullImage.count; i++)
                                             {
                                                 [formData appendPartWithFileData:fullImage[i] name:@"upload_files[]" fileName:@"uploads.mp4" mimeType:@"video/mp4"];
                                                 
                                                 [formData appendPartWithFileData:thumbImage[i] name:@"thumb_img[]" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                             }
                                             
                                             // [formData appendPartWithFormData:[imageID dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
                                             
                                             [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                             
                                             [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"size"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"created_date"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"video_duration"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"orientation"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"flip_value"];
                                             
                                             [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"flop_value"];
                                             
                                         } error:nil];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSURLSessionUploadTask *uploadTask;
        
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:requests
                      progress:^(NSProgress * _Nonnull uploadProgress)
                      {
                          
                          // This is not called back on the main queue.
                          // You are responsible for dispatching to the main queue for UI updates
                          dispatch_async(dispatch_get_main_queue(),
                                         ^{
                                             
                                             [MBProgressHUD HUDForView:self.navigationController.view].progress = uploadProgress.fractionCompleted;
                                             
                                         });
                      }
                      
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                      {
                          if (error)
                          {
                              
                              NSLog(@"Error For Image: %@", error);
                              
                              [hud hideAnimated:YES];
                              
                              [animationView removeFromSuperview];
                              [_BlurView removeFromSuperview];

                              
                              CustomPopUp *popUp = [CustomPopUp new];
                              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try again" withTitle:@"Upload failed" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                              popUp.okay.backgroundColor = [UIColor navyBlue];
                              popUp.agreeBtn.hidden = YES;
                              popUp.cancelBtn.hidden = YES;
                              popUp.inputTextField.hidden = YES;
                              [popUp show];
                              
                              
                          }
                          else
                          {
                              
                              NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                              
                              NSLog(@"Response For Image:%@",responsseObject);
                              
                             // [hud hideAnimated:YES];
                              [animationView removeFromSuperview];
                              [_BlurView removeFromSuperview];
                              
                              if (responseObject == NULL)
                              {
                                  // [self rollback];
                              }
                              else
                              {
                                  
                                  NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                  
                                  NSString *minAvil=[responsseObject objectForKey:@"Duration Status"];
                                  
                                  NSString *spcAvil = [responsseObject objectForKey:@"Space Status"];
                                  
                                  [defaults setValue:minAvil forKey:@"minAvil"];
                                  
                                  [defaults setValue:spcAvil forKey:@"spcAvil"];
                                  
                                  [defaults synchronize];
                                  if(!([[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"] && VideoUploaded.integerValue >= 7)){
                                      [self reducePoints];
                                  }
                                                                    
                                  CustomPopUp *popUp = [CustomPopUp new];
                                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Video has been uploaded successfully." withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                                  popUp.okay.backgroundColor = [UIColor lightGreen];
                                  popUp.accessibilityHint =@"VideoUploaded";
                                  
                                  popUp.agreeBtn.hidden =YES;
                                  popUp.cancelBtn.hidden= YES;
                                  popUp.inputTextField.hidden = YES;
                                  [popUp show];
                              }
                              //   dispatch_group_leave(group);
                              
                          }
                      }];
        
        [uploadTask resume];
        // dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
}


-(void)sendServer:(NSData*)data
{
    
    NSString *UR = @"https://www.hypdra.com/api/api.php?rquest=testing_ios";

    //    UIImage *img = [UIImage imageNamed:@"text-xxl.png"];
    //    NSData *dfs = UIImagePNGRepresentation(img);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:UR parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        
                                        [formData appendPartWithFileData:data name:@"upload_files" fileName:@"uploads.mp4" mimeType:@"video/mp4"];
                                        
                                        [formData appendPartWithFormData:[@"10" dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
                                        
                                        [formData appendPartWithFormData:[@"4" dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
                                        
                                        
                                    } error:nil];
    
    
    request.timeoutInterval= 20; // add paramerets to NSMutableURLRequest
    
    //        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
    //        [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //
    //        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         //Update the progress view
                                         //                          [progressView setProgress:uploadProgress.fractionCompleted];
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Change Profile Error: %@", error);
                          
                          
                          
                      }
                      else
                      {
                          //                          NSLog(@"Change Profile Response %@ %@", response, responseObject);
                          
                          
                          
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"response for profile:%@",responsseObject);
                          
                          
                      }
                  }];
    
    [uploadTask resume];
    
}

-(void)sendImage:(NSData*)data nd:(NSData*)th sd:(NSString*)s
{
    
    NSLog(@"data = %d",data.length);
    
    
    /*    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
     
     hud.mode = MBProgressHUDModeAnnularDeterminate;
     hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");*/
    
    NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         
                                         [formData appendPartWithFileData:data name:@"upload_files" fileName:@"uploads.mp4" mimeType:@"video/mp4"];
                                         
                                         [formData appendPartWithFileData:th name:@"thumb_img" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                         
                                         [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
                                         
                                         [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                         
                                         [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"size"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"created_date"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"video_duration"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"orientation"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"flip_value"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"flop_value"];
                                         
                                         
                                     } error:nil];
    
    //    requests.timeoutInterval= 20;
    
    //    [requests setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [requests setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
    //    [requests setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //    [requests setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
    //
    //    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:requests
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         
                                         //                                         [MBProgressHUD HUDForView:self.navigationController.view].progress = uploadProgress.fractionCompleted;
                                         
                                         //Update the progress view
                                         //                          [progressView setProgress:uploadProgress.fractionCompleted];
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Error For Video: %@", error);
                          
                         // [hud hideAnimated:YES];
                          
                          [animationView removeFromSuperview];
                          [_BlurView removeFromSuperview];
                          
                          
                          UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Upload failed"
                                                                                        message:@"Your upload could not be completed.\nTry again ?"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:nil];
                          
                          [alert addAction:yesButton];
                          
                          [self presentViewController:alert animated:YES completion:nil];
                          
                          CustomPopUp *popUp = [CustomPopUp new];
                          [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your upload could not be completed.\nTry again ?" withTitle:@"Upload failed" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                          popUp.okay.backgroundColor = [UIColor navyBlue];
                          
                          popUp.agreeBtn.hidden = YES;
                          popUp.cancelBtn.hidden= YES;
                          popUp.inputTextField.hidden = YES;
                          [popUp show];
                          
                      }
                      else
                      {
                          
                          
                          //                          [hud hideAnimated:YES];
                          
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"Response For Video:%@",responsseObject);
                          
                          //[hud hideAnimated:YES];
                          [animationView removeFromSuperview];
                          [_BlurView removeFromSuperview];
                          
                          NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                          
                          NSString *minAvil=[responsseObject objectForKey:@"Duration Status"];
                          
                          NSString *spcAvil = [responsseObject objectForKey:@"Space Status"];
                          
                          [defaults setValue:minAvil forKey:@"minAvil"];
                          
                          [defaults setValue:spcAvil forKey:@"spcAvil"];
                          
                          [defaults synchronize];
                          
                          UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Video Uploaded"
                                                                                        message:@"Success"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:nil];
                          
                          [alert addAction:yesButton];
                          
                          [self presentViewController:alert animated:YES completion:nil];
                          
                      }
                  }];
    
    [uploadTask resume];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    [self dismissModalViewControllerAnimated:YES];
}


//-(void)updateImagesToServer:(NSData*)sendData
//{
//    NSLog(@"updateImageToServer..");
//
//    //[self loadSavedFile];
//
//    @try
//    {
//
//            if( [self setImageParams:sendData])
//            {
//
//                NSLog(@"Enter block");
//
//                NSOperationQueue *queue = [NSOperationQueue mainQueue];
//
//                [NSURLConnection sendAsynchronousRequest:request
//                                                   queue:queue
//                                       completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
//                 {
//
//                     NSLog(@"Response = %@",urlResponse);
//                 }];
//
//                NSLog(@"Image Sent");
//            }
//            else
//            {
//                NSLog(@"Image Failed...");
//            }
//
// //       }
//    }
//    @catch (NSException *exception)
//    {
//        NSLog(@"Image Exception = %@",exception);
//    }
//    @finally
//    {
//        NSLog(@"Image Exception");
//    }
//}


-(BOOL)setImageParams:(NSData *)imgData imageID:(NSString *)imageId thumbnailData:(NSData *)thumbnailData
{
    @try
    {
        if (imgData!=nil)
        {
            
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
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload_files\"; filename=\"%@.mp4\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //NSLog(@"Image send to  server = %@",imgData);
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[imageId dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"thumb_img\"; filename=\"%@.jpg\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:thumbnailData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[imageId dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"size\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"created_date\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video_duration\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"orientation\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"flip_value\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"flop_value\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            
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


-(void)getName
{
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // HigestImageCount = 0;
    
    imageName = [[NSMutableArray alloc]init];
    
    NSError *error;
    
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:myPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *SharedFinalplistPath = [myPath stringByAppendingPathComponent:@"DataList.plist"];
    
    NSLog(@"SharedFinalplistPath%@",SharedFinalplistPath);
    
    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    
    if (finalArray == nil)
    {
        finalArray = [[NSMutableArray alloc]init];
    }
    
    int temInt;
    
    NSMutableArray *tempOnlyImages = [[NSMutableArray alloc]init];
    
    NSLog(@"FinalArray %@",finalArray);
    
    for(NSMutableDictionary *dic in finalArray)
    {
        
        if([[dic valueForKey:@"DataType"] isEqualToString:@"Video"])
        {
            [tempOnlyImages addObject:dic];
        }
        
        NSString *id = [dic valueForKey:@"Id"];
        
        temInt = id.intValue;
        
        //        if(temInt > HigestImageCount)
        //        {
        //            HigestImageCount =temInt;
        //        }
        
        //        NSLog(@"VideoOnlyImagesgetName %lu",(unsigned long)tempOnlyImages.count);
        
    }
    
    OnlyImages = tempOnlyImages;
    
    if (OnlyImages.count == 0)
    {
        self.CollectionView.hidden = true;
        self.EmptyPageView.hidden = false;
    }
    else
    {
        NSLog(@"VideoOnlyImages %lu",(unsigned long)OnlyImages.count);
        self.CollectionView.hidden = false;
        self.EmptyPageView.hidden = true;
    }
    
    
    [self.CollectionView reloadData];
    
}

/*
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 CGFloat picDimension;
 
 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
 {
 picDimension = self.view.frame.size.width / 3.08f;
 }
 else
 {
 picDimension = self.view.frame.size.width / 2.18f;
 }
 
 return CGSizeMake(picDimension, picDimension);
 
 }*/


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
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did Deselect");
    
    NSDictionary *dic = [finalArray objectAtIndex:indexPath.row];
    [dic setValue:@"0" forKey:@"SelectedForDelete"];
    [finalArray replaceObjectAtIndex:indexPath.row withObject:dic];
    [MultipleDeleteItemsAry removeObject:dic];
    
    [MultipleDeleteIndexPathAry removeObject:[NSNumber numberWithInt:indexPath.row]];
    UploadVideoCollectionCell *cell = (UploadVideoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.aboveTopView.hidden = YES;
    cell.selectedIconForDelete.hidden = YES;
    TabBarViewController *tabContrl = self.tabBarController;
    NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected( %d )", MultipleDeleteItemsAry.count];
    tabContrl.TttleLable.text = selectedItemString;
    if(MultipleDeleteItemsAry.count == 0){
        isDeleteMode = NO;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
        tabContrl.TttleLable.text = @"My Video";
        tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"12-PLUS.png"];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Didselect = %ld",(long)indexPath.row);
    if(isDeleteMode){
        UploadVideoCollectionCell *cell=(UploadVideoCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.aboveTopView.hidden = NO;
        cell.selectedIconForDelete.hidden= NO;
        NSLog(@"Did Select");
        NSDictionary *dic = [finalArray objectAtIndex:indexPath.row];
        [dic setValue:@"1" forKey:@"SelectedForDelete"];
        [finalArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [MultipleDeleteItemsAry addObject:dic];
        int index = indexPath.row;
        [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:indexPath.row]];
        TabBarViewController *tabContrl = self.tabBarController;
        NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected ( %d )", MultipleDeleteItemsAry.count];
        tabContrl.TttleLable.text = selectedItemString;
        
        
    }else{
        
        
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
}


/*
 - (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
 {
 
 NSLog(@"didDeselect = %d",indexPath.row);
 
 UploadVideoCollectionCell* cell = (UploadVideoCollectionCell*)[collectionView  cellForItemAtIndexPath:selectedValue];
 
 cell.aboveTopView.hidden = true;
 
 cell.backgroundColor = [UIColor redColor];
 
 
 cell.topView.hidden = true;
 
 //    cell.alpha = 1;
 }
 */
-(void)removeItemsFromDeleteMode{
    isImagePick=YES;
    NSLog(@"OpenCamera");
    if(isDeleteMode){
        
        for(int i=0; i<finalArray.count; i++){
            NSDictionary *dic = [finalArray objectAtIndex:i];
            [dic setValue:@"0" forKey:@"SelectedForDelete"];
            [finalArray replaceObjectAtIndex:i withObject:dic];
        }
    }
    [_CollectionView reloadData];
    //SET MULTIPLE DELETE MODE NO
    [MultipleDeleteItemsAry removeAllObjects];
    isDeleteMode=NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
    TabBarViewController *tabContrl = self.tabBarController;
    tabContrl.TttleLable.text = @"My Image";
    tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"12-PLUS.png"];
    //SET MULTIPLE DELETE MODE NO
}
- (IBAction)videoRecord:(id)sender
{}

-(void)setRecordVideo
{
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        _RecordVdoRzblView = [[SPUserResizableView alloc] initWithFrame:CGRectMake(10, self.CollectionView.superview.frame.size.height-150, 100, 100)];
    
    else
        _RecordVdoRzblView = [[SPUserResizableView alloc] initWithFrame:CGRectMake(10, self.CollectionView.superview.frame.size.height+150, 100, 100)];
    
    _recordVideoImgVw = [[UIImageView alloc]initWithFrame:_RecordVdoRzblView.bounds];
    _recordVideoImgVw.image = [UIImage imageNamed:@"video_128.png"];
    _recordVideoImgVw.contentMode = UIViewContentModeCenter;
    
    _recordVideoImgVw.contentMode = UIViewContentModeScaleAspectFit;
    
    //_OpenCmraImgViw.alpha=0.3;
    
    _RecordVdoRzblView.contentView = _recordVideoImgVw;
    _RecordVdoRzblView.delegate = self;
    _RecordVdoRzblView.contentView.layer.cornerRadius = 15;
    _RecordVdoRzblView.contentView.backgroundColor = [UIColor whiteColor];
    _RecordVdoRzblView.contentView.alpha = 0.5;
    
    _RecordVdoRzblView.resizableStatus = NO;
    
    [_RecordVdoRzblView hideEditingHandles];
    [_RecordVdoRzblView.cancel removeFromSuperview];
    [_RecordVdoRzblView removeBorder];
    
    
}
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    userResizableView.contentView.alpha = 1.0f;
}
-(void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView{
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        userResizableView.contentView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)openCamera
{
    [self removeItemsFromDeleteMode];
    
                        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                        {
            
                            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
            
                            videoDemo = [mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoDemoIphone"];
            
                            videoDemo.delegate = self;
            
                            [self presentViewController:videoDemo animated:YES completion:NULL];
                        }
    
}

- (void)didCloseVideo
{
    NSLog(@"Video Closed");
    [videoDemo dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFinishedDropBoxVideo:(NSURL *)videoURL
{
    [self FinishedVideo:videoURL];
}

//-(void)didFinishedBoxVideo:(NSData *)videoData thumbnailData:(NSURL *)videoURL
//{
//    [hud hideAnimated:YES];
//    sendImage = [[NSMutableArray alloc]init];
//
//    fullImage = [[NSMutableArray alloc]init];
//    thumbImage = [[NSMutableArray alloc]init];
//
//    //    lastHighestCount = HigestImageCount;
//    //
//    //    HigestImageCount++;
//
//    /*hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");*/
//
//    [_currentWindow addSubview:_BlurView];
//
//    [_currentWindow addSubview:animationView];
//
//    [animationView playWithCompletion:^(BOOL animationFinished) {
//        // ...
//    }];
//
//    NSLog(@"Video Size = %lu",(unsigned long)videoData.length);
//    UIImage *thumbnailImg = [UIImage imageNamed:@"video-icon.png"];
//    NSData *thumbnailData = UIImagePNGRepresentation(thumbnailImg);
//    [fullImage addObject:videoData];
//    [thumbImage addObject:thumbnailData];
//
//    // imageID = [NSString stringWithFormat:@"%d",HigestImageCount];
//
//
////            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
////            {
////
////                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
////
////                videoDemo = [mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoDemoIphone"];
////
////                videoDemo.delegate = self;
////
////                [self presentViewController:videoDemo animated:YES completion:NULL];
////            }
//            if(!([[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"] && VideoUploaded.integerValue >= 7)){
//                [self completeSendImage];
//            }else{
//                if(Credits.integerValue >30 ){
//                CustomPopUp *popUp = [CustomPopUp new];
//                int availablecredits = Credits.intValue;
//                NSString *msg = [NSString stringWithFormat:@"Available credit: %@ | Credit Needed: 30", Credits];
//                [popUp initAlertwithParent:self withDelegate:self withMsg:msg withTitle:@"Pay Using Credit Balance" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
//                popUp.accessibilityHint = @"Redeem";
//                // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//                popUp.okay.hidden =YES;
//                [popUp.agreeBtn setTitle:@"Redeem" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
//                popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
//                [popUp show];
//                }else{
//                    CustomPopUp *popUp = [CustomPopUp new];
//
//                    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Sorry you don't have enough credits" withTitle:@"Upgrade Membership" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
//                    popUp.accessibilityHint = @"ConfirmToUpgrade";
//                    // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//                    popUp.okay.hidden =YES;
//                    [popUp.agreeBtn setTitle:@"Upgrade" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
//                    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
//                    [popUp show];
//                }
//            }
//        }

       
        

    
    


-(void)didFinishedGDriveVideo:(NSURL *)videoURL
{
    [self FinishedVideo:videoURL];
}

- (void) didFinishedVideoEdit:(NSNotification *) notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *videoPath = [userInfo objectForKey:@"videoPathValue"];
    [self FinishedVideo:[NSURL URLWithString:videoPath]];
}

-(void)didFinishedVideo:(NSURL *)videoUrl
{
    [videoDemo dismissViewControllerAnimated:YES completion:nil];
    [self FinishedVideo:videoUrl];
}


-(void)FinishedVideo:(NSURL *)videoURL
{
    isImagePick=YES;
    // [self getName];
    
    sendImage = [[NSMutableArray alloc]init];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    //    lastHighestCount = HigestImageCount;
    //
    //    HigestImageCount++;
    
    /*hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");*/
    
    [_currentWindow addSubview:_BlurView];
    [_currentWindow addSubview:animationView];
    
    [animationView playWithCompletion:^(BOOL animationFinished) {
        // ...
    }];
    
    UIImage *thumbnail = [self generateThumbImage:videoURL];
    
    UIImage *alternateThumbnail=[UIImage imageNamed:@"1.jpg"];
    
    NSData *thumbnailData=UIImagePNGRepresentation(thumbnail);
    
    if(thumbnailData.length<=0)
    {
        thumbnailData=UIImagePNGRepresentation(alternateThumbnail);
    }
    
    NSString *path = [videoURL path];
    //  NSData *VideoData = [[NSFileManager defaultManager] contentsAtPath:path];
    
    NSData *VideoData = [NSData dataWithContentsOfURL:videoURL];
    
    NSLog(@"Video Size = %lu",(unsigned long)VideoData.length);
    NSLog(@"thumbnail Size = %lu",(unsigned long)thumbnailData.length);
    
    //    NSError *error;
    //    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //
    //    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    //    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    //
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    //        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    //NSString  *withString =[NSString stringWithFormat:@"/%d",HigestImageCount];
    
    //    withString = [withString stringByAppendingString:@".png"];
    
    //    NSString *Path = [dataPath stringByAppendingFormat:@"%@",withString];
    
    //    NSLog(@"CommonFilePath:%@",Path);
    //
    //    [thumbnailData writeToFile:Path atomically:YES];
    //
    //    NSString *SharedFinalplistPath = [dataPath stringByAppendingPathComponent:@"DataList.plist"];
    //
    //    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    //
    //    if (finalArray == nil)
    //    {
    //        finalArray = [[NSMutableArray alloc]init];
    //    }
    //
    //    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //    [dic setValue:@"Video" forKey:@"DataType"];
    //    [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"Id"];
    //
    //    [finalArray addObject:dic];
    //    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    //    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    //
    @try
    {
        
        [fullImage addObject:VideoData];
        [thumbImage addObject:thumbnailData];
        
    }
    @catch(NSException *ex)
    {
        //[hud hideAnimated:YES];
        [animationView removeFromSuperview];
        [_BlurView removeFromSuperview];
    }
    //
    //    imageID = [NSString stringWithFormat:@"%d",HigestImageCount];
    
    if((unsigned long)VideoData.length>0 && (unsigned long)thumbnailData.length>0)
        if(!([[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"] && VideoUploaded.integerValue >= 7)){
            [self completeSendImage];
        }else{
            if(Credits.intValue > 30){
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
            }else{
                CustomPopUp *popUp = [CustomPopUp new];
                
                [popUp initAlertwithParent:self withDelegate:self withMsg:@"Sorry you don't have enough credits" withTitle:@"Upgrade Membership" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                popUp.accessibilityHint = @"ConfirmToUpgrade";
                // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                popUp.okay.hidden =YES;
                [popUp.agreeBtn setTitle:@"Upgrade" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
                popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
                [popUp show];
            }
        }
    
    
}

- (IBAction)dropBoxAction:(id)sender
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
        isImagePick = YES;
        
        if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient])
        {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            dropBoxVc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DropboxVideoViews"];
            dropBoxVc.delegate=self;
            //        UINavigationController *navigationController =
            //        [[UINavigationController alloc] initWithRootViewController:dropBoxVc];
            //
            //        navigationController.navigationBar.barTintColor=UIColorFromRGB(0x4186F2);//[UIColor blueColor];
            //
            //        [self presentViewController:navigationController animated:YES completion:nil];
            [self.navigationController pushViewController:dropBoxVc animated:YES];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"dropboxVideo" forKey:@"dropBoxVideo"];
            
            [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                           controller:self
                                              openURL:^(NSURL *url)
             {
                 [[UIApplication sharedApplication] openURL:url];
             }];
        }
    }
}

- (IBAction)galleryPick:(id)sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *minAvil=[defaults valueForKey:@"minAvil"];
    
    NSString *spcAvil = [defaults valueForKey:@"spcAvil"];
    
    if ([spcAvil isEqualToString:@"Space Available"])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
        
        [self presentModalViewController:imagePicker animated:YES];
    }
    else
    {
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
        //                                                                      message:@"You do not have space"
        //                                                               preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
        //                                                            style:UIAlertActionStyleDefault
        //                                                          handler:nil];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have space" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
}
- (IBAction)oneDrive:(id)sender
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
        isImagePick = YES;
        [ODClient authenticatedClientWithCompletion:^(ODClient *client, NSError *error)
         {
             if (!error)
             {
                 self.client = client;
                 //[self loadChildren];
                 
                 dispatch_async(dispatch_get_main_queue(), ^(){
                     //self.navigationItem.rightBarButtonItem = self.actions;
                     UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainUpload"
                                                                          bundle:nil];
                     
                     ODCollectionViewController *vc =
                     [storyboard instantiateViewControllerWithIdentifier:@"ODCollection"];
                     
                     vc.client=client;
                     vc.delegate=self;
                     vc.mime_Type=@"video";
                     
                     [self.navigationController pushViewController:vc animated:YES];
                     
                     //  [self presentViewController:add animated:YES completion:nil];
                     
                 });
             }
             else
             {
                 [self showErrorAlert:error];
             }
         }];
    }
}

- (IBAction)googleDrive:(id)sender
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
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
        GDriveViewController *vc= [mainStoryBoard instantiateViewControllerWithIdentifier:@"googleDrive"];
        vc.delegate=self;
        vc.mimeTypes=@"video";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)Box:(id)sender
{
//    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//
//    if (networkStatus == NotReachable)    {
//        NSLog(@"Not Connected to Internet");
//        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
//        //                                                                      message:@"Internet connection is down"
//        //                                                               preferredStyle:UIAlertControllerStyleAlert];
//        //
//        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//        //                                                            style:UIAlertActionStyleDefault
//        //                                                          handler:^(UIAlertAction * action)
//        //                                    {
//        //                                        NSLog(@"you pressed Yes, please button");
//        //
//        //                                    }];
//        //
//        //        [alert addAction:yesButton];
//        //
//        //        [self presentViewController:alert animated:YES completion:nil];
//        CustomPopUp *popUp = [CustomPopUp new];
//        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check Internet Connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
//        popUp.okay.backgroundColor = [UIColor navyBlue];
//        popUp.agreeBtn.hidden = YES;
//        popUp.cancelBtn.hidden = YES;
//        popUp.inputTextField.hidden = YES;
//        [popUp show];
//
//    }
//
//    else
//    {
//        isImagePick = YES;
//       /* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];*/
//
//        BOXContentClient *client = [BOXContentClient defaultClient];
//
//        [client authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
//            if (error) {
//                if ([error.domain isEqualToString:BOXContentSDKErrorDomain] && error.code == BOXContentSDKAPIUserCancelledError) {
//                    BOXLog(@"Authentication was cancelled, please try again.");
//                } else {
//                    //                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
//                    //                                                                                         message:@"Login failed, please try again"
//                    //                                                                                  preferredStyle:UIAlertControllerStyleAlert];
//                    //                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK"
//                    //                                                                   style:UIAlertActionStyleDefault
//                    //                                                                 handler:^(UIAlertAction * _Nonnull action) {
//                    //                                                                     [self dismissViewControllerAnimated:YES
//                    //                                                                                              completion:nil];
//                    //                                                                 }];
//                    //                [alertController addAction:OKAction];
//                    //                [self presentViewController:alertController
//                    //                                   animated:YES
//                    //                                 completion:nil];
//                    CustomPopUp *popUp = [CustomPopUp new];
//                    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Login failed, please try again" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
//                    popUp.okay.backgroundColor = [UIColor navyBlue];
//                    popUp.accessibilityHint =@"BoxLoginFailed";
//                    popUp.agreeBtn.hidden =YES;
//                    popUp.cancelBtn.hidden = YES;
//                    popUp.inputTextField.hidden = YES;
//                    [popUp show];
//
//
//                }
//            } else {
//
//                BOXSampleFolderViewController *folderListingController = [[BOXSampleFolderViewController alloc] initWithClient:client folderID:BOXAPIFolderIDRoot];
//                folderListingController.fileType = @"Video";
//                folderListingController.delegate=self;
//                [self.navigationController pushViewController:folderListingController animated:YES];
//            }
//        }];
//    }
}

- (void)showErrorAlert:(NSError*)error
{
    NSString *errorMsg;
    if ([error isAuthCanceledError]) {
        errorMsg = @"Sign-in was canceled!";
    }
    else if ([error isAuthenticationError]) {
        errorMsg = @"There was an error in the sign-in flow!";
    }
    else if ([error isClientError]) {
        errorMsg = @"Oops, we sent a bad request!";
    }
    else {
        errorMsg = @"Uh oh, an error occurred!";
    }
    //    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:errorMsg
    //                                                                        message:[NSString stringWithFormat:@"%@", error]
    //                                                                 preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    //
    //    [errorAlert addAction:ok];
    //
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self presentViewController:errorAlert animated:YES completion:nil];
    //    });
    
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:errorMsg withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.backgroundColor = [UIColor navyBlue];
    popUp.agreeBtn.hidden = YES;
    popUp.cancelBtn.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
}

- (void)didFinishedODVideo:(NSData*)videoData thumbnail:(NSData *)thumbnailData
{
    [ODCollectionVc dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"didfinished OD video called");
    
    //[self getName];
    
    sendImage = [[NSMutableArray alloc]init];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    //    lastHighestCount = HigestImageCount;
    //
    //    HigestImageCount++;
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
    
    [_currentWindow addSubview:_BlurView];
    [_currentWindow addSubview:animationView];
    
    [animationView playWithCompletion:^(BOOL animationFinished) {
        // ...
    }];
    
    NSLog(@"Video Size = %lu",(unsigned long)videoData.length);
    
    //
    [fullImage addObject:videoData];
    [thumbImage addObject:thumbnailData];
    
    if(!([[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"] && VideoUploaded.integerValue >= 7)){
        [self completeSendImage];
    }else{
        if(Credits.intValue > 30){
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
        }else{
            CustomPopUp *popUp = [CustomPopUp new];
            
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Sorry you don't have enough credits" withTitle:@"Upgrade Membership" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.accessibilityHint = @"ConfirmToUpgrade";
            // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            popUp.okay.hidden =YES;
            [popUp.agreeBtn setTitle:@"Upgrade" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
            [popUp show];
        }
    }}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"BoxLoginFailed"]){
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
    
    if([alertView.accessibilityHint isEqualToString:@"VideoUploaded"])
    {
        // [self dismissViewControllerAnimated:YES completion:nil];
        
        [self getVideos];
        
    }
    
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToPlay"]){
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToShare"]){
        
    }else if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        //[hud hideAnimated:YES];
        
        [animationView removeFromSuperview];
        [_BlurView removeFromSuperview];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToUpgrade"]){
       // [hud hideAnimated:YES];
        [animationView removeFromSuperview];
        [_BlurView removeFromSuperview];
    }
    else if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        //[hud hideAnimated:YES];
        [animationView removeFromSuperview];
        [_BlurView removeFromSuperview];
    }
    [self cancelButtonPressed];
    [alertView hide];
    alertView = nil;
    NSLog(@"Cancel");
    
}
- (void)agreeCLicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToDelete"]){
        NSLog(@"Close:%@",finalArray);
        
        NSString *img = [[finalArray objectAtIndex:alertView.accessibilityValue.integerValue]objectForKey:@"Id"];
        NSDictionary *dic =   [finalArray objectAtIndex:alertView.accessibilityValue.integerValue];
        [MultipleDeleteItemsAry addObject:dic];

        //DELETE LOCAL ARRAY AND UPDATE COLLECTIOVIEW
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:deleteTag inSection:0] ;
        [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:deleteTag]];
        NSLog(@"img:%@",img);
        deleteName = img;
        NSLog(@"Img = %@",deleteName);
        [self deleteImage];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToMultipleDelete"]){
        [self deleteImage];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToPlay"]){
        
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)alertView.accessibilityValue.integerValue];
        [self okButtonPresseds:sendIndex];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToShare"]){
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"share_btn"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"crop_btn"];
        
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)alertView.accessibilityValue.integerValue];
        [self okButtonPresseds:sendIndex];
        
    }else if([alertView.accessibilityHint isEqualToString:@"VideoUploaded"]){
        
        //[hud hideAnimated:YES];
        [animationView removeFromSuperview];
        [_BlurView removeFromSuperview];
        [self getVideos];
        
    }else if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        [self completeSendImage];
        
        
    }if([alertView.accessibilityHint isEqualToString:@"ConfirmToUpgrade"]){
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];

    }
    [alertView hide];
    alertView = nil;
}

- (IBAction)close_purchaseView:(id)sender
{
    self.purchaseView.hidden=YES;
    self.TopSocialView.hidden=YES;
}

- (IBAction)Pay:(id)sender
{
    
}

- (IBAction)Redeem:(id)sender
{
    
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
@end

