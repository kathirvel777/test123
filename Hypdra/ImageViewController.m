//
//  ImageViewController.m
//  Montage
//  Created by MacBookPro on 4/25/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "ImageViewController.h"
#import "UploadImageCollectionCell.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "OLFacebookAlbumRequest.h"
#import "OLFacebookPhotosForAlbumRequest.h"
#import "OLFacebookAlbum.h"
#import "OLFacebookImage.h"
#import "OLFacebookImagePickerController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "OLInstagramImagePickerController.h"
#import "OLInstagramImage.h"
#import "DropboxDownloadFileViewControlller.h"
#import "DropboxIntegrationViewController.h"
#import "SectionViewController.h"
#import "ELCImagePickerController.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AFNetworking.h"
#import "FlickrKit.h"
#import "PhotoViewController.h"
#import "WebViewController.h"
#import "AnnotateViewController.h"
#import "CLImageEditor/CLImageEditor.h"
#import "MBProgressHUD.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "DropboxViewController.h"
#import "UIImageView+WebCache.h"
#import "IGCMenu.h"
#import <ImageIO/ImageIO.h>
#import "CameraDemoViewController.h"
#import "ODCollectionViewController.h"
#import "DEMORootViewController.h"
#import "GDriveViewController.h"
//@import BoxContentSDK;
//#import "BOXSampleFolderViewController.h"
#import "TabBarViewController.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import <Lottie/Lottie.h>



#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ImageViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate, OLFacebookImagePickerControllerDelegate,OLInstagramImagePickerControllerDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,SPUserResizableViewDelegate,CameraDemoViewControllerDelegate,ODVideoImportDelegate,GDriveImportDelegate,FlickrImportDelegate,ClickDelegates>
{
    NSMutableArray *imageName,*sendImage,*finalArray,*OnlyImages,*onlyImagePath,*MultipleDeleteItemsAry,*MultipleDeleteIndexPathAry;
    NSString *user_id,*imageID;
    NSMutableURLRequest *request;
    int lastHighestCount,deleteTag;
    NSIndexPath *SelectedIndexPath;
    NSString *imgName,*deleteName;
    IGCMenu *igcMenu;
    BOOL isMenuActive,isImagePick,isDeleteMode;
    
    CameraDemoViewController *cmraDemo;
    
    UITapGestureRecognizer *tapValue;
    
    MBProgressHUD *hud;
    
#define URL @"https://www.hypdra.com/api/api.php?rquest=image_upload_final"
    //@"https://www.hypdra.com/api/api.php?rquest=image_upload"
    
    //    #define URL @"http://108.175.2.116/montage/api/api.php?rquest=image_upload"
    
    NSArray *localCaptions;
    NSMutableArray *localImages,*fullImage,*thumbImage;
    NSArray *networkCaptions;
    NSArray *networkImages;
    FGalleryViewController *localGallery;
    FGalleryViewController *networkGallery;
    LOTAnimationView *animationView;

}

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@property (nonatomic, strong) OLFacebookAlbumRequest *albumRequest;
@property (nonatomic, strong) NSArray *selected;
@property (nonatomic, strong) NSArray *selectedImages;
@property (nonatomic, retain) FKFlickrNetworkOperation *todaysInterestingOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@property (nonatomic, retain) NSString *userID;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenRect = screen.bounds;
    
    if (!IS_PAD)
    {
        self.wdthCnst.constant = screenRect.size.width * 85/100;
        
        self.hghtCnst.constant = screenRect.size.width * 85/100;
    }
    
    /* NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"HH:mm:ss"];
     NSDate *date = [dateFormatter dateFromString:@"00:49:55"];
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
     NSInteger hour = [components hour];
     NSInteger minute = [components minute];
     NSUInteger sec = [components second];
     
     NSLog(@"hour = %ld",(long)hour);
     
     NSLog(@"min = %ld",(long)minute);
     
     NSLog(@"sec = %ld",(long)sec);*/
    
    isImagePick=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxLogin) name:@"DropboxLogin" object:nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:10.0f];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    self.socialList.layer.cornerRadius = 10;
    self.socialList.clipsToBounds = YES;
    self.socialList.layer.masksToBounds = YES;
    
    imageName = [[NSMutableArray alloc]init];
    finalArray = [[NSMutableArray alloc]init];
    sendImage = [[NSMutableArray alloc]init];
    MultipleDeleteItemsAry = [[NSMutableArray alloc]init];
    MultipleDeleteIndexPathAry = [[NSMutableArray alloc]init];
    
    // OnlyImages = [[NSMutableArray alloc]init];
    
    tapValue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPosition:)];
    [tapValue setNumberOfTapsRequired:1];
    tapValue.delegate=self;
    
    [self.socialView addGestureRecognizer:tapValue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    // Check if there is a stored token
    // You should do this once on app launch
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error)
                        {
                            dispatch_async(dispatch_get_main_queue(),
                                           ^{
                                               if (!error)
                                               {
                                                   [self userLoggedIn:userName userID:userId];
                                               }
                                               else
                                               {
                                                   [self userLoggedOut];
                                               }
                                           });
                        }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addImage:)
                                                 name:@"postImage" object:nil];
    
    
    self.collectionView.bounces = false;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    float hght = self.navigationController.navigationBar.frame.size.height;
    
    [[NSUserDefaults standardUserDefaults]setFloat:hght forKey:@"NavHeight"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (igcMenu == nil)
    {
        igcMenu = [[IGCMenu alloc] init];
    }
    
    igcMenu.delegate=self;
    
    _glcButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame),CGRectGetMidY(self.view.frame), 30, 30)];
    
    igcMenu.menuButton = _glcButton;
    
    igcMenu.menuSuperView = self.view;      //Pass reference of menu button super view
    igcMenu.disableBackground = YES;        //Enable/disable menu background
    igcMenu.numberOfMenuItem = 4;           //Number of menu items to display
    
    igcMenu.menuItemsNameArray = [NSArray arrayWithObjects:@"Delete",@"Annotation",@"Edit",@"View",nil];
    
    UIColor *homeBackgroundColor = [UIColor clearColor];
    UIColor *searchBackgroundColor = [UIColor clearColor];
    UIColor *favoritesBackgroundColor = [UIColor clearColor];
    UIColor *userBackgroundColor = [UIColor clearColor];
    UIColor *buyBackgroundColor = [UIColor clearColor];
    
    igcMenu.menuBackgroundColorsArray = [NSArray arrayWithObjects:homeBackgroundColor,favoritesBackgroundColor,searchBackgroundColor,userBackgroundColor, buyBackgroundColor,nil];
    
    igcMenu.menuImagesNameArray = [NSArray arrayWithObjects:@"126-delete.png",@"128-Annotation.png",@"128-edit.png",@"128-view.png",nil];
    
    isMenuActive = NO;
    
    _currentWindow = [UIApplication sharedApplication].keyWindow;
    
    _BlurView = [[UIView alloc]initWithFrame:CGRectMake(_currentWindow.frame.origin.x, _currentWindow.frame.origin.y, _currentWindow.frame.size.width, _currentWindow.frame.size.height)];
    
    _BlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    //    [self setCameraButton];
    
    if (!self.client)
    {
        self.client = [ODClient loadCurrentClient];
    }
    
    
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.minimumPressDuration = 1.0;   [self.collectionView addGestureRecognizer:lpgr];
    self.collectionView.allowsMultipleSelection = YES;
    [self setCameraButton];
    //[self UserPlanLimitsTracking];
    animationView = [LOTAnimationView animationNamed:@"loading_h"];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    [animationView setCenter:self.view.center];
    animationView.loopAnimation = YES;
}
- (void)deleteMultipleItems:(NSNotification *)notify{
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to delete the selected files ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.accessibilityHint = @"MultipleDelete";
    popUp.okay.hidden = YES;
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor= [UIColor blueBlack];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.inputTextField.hidden = YES;
    [popUp show];
    
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            if(!isDeleteMode){
                if(!(self.selectedItemIndexPath == nil)){
                    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:self.selectedItemIndexPath];
                    self.selectedItemIndexPath=nil;
                    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
                }
                UploadImageCollectionCell* cell =
                [self.collectionView cellForItemAtIndexPath:indexPath];
                cell.SelectedItem.hidden = NO;
                cell.AboveTopView.hidden = NO;
                NSDictionary *dic = [finalArray objectAtIndex:indexPath.row];
                [dic setValue:@"1" forKey:@"SelectedForDelete"];
                [finalArray replaceObjectAtIndex:indexPath.row withObject:dic];
                //            [cell setSelected:YES];
                [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                [MultipleDeleteItemsAry addObject:dic];
                [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:indexPath.row]];
                isDeleteMode = YES;
                
                TabBarViewController *tabContrl = self.tabBarController;
                NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected (%lu)", (unsigned long)MultipleDeleteItemsAry.count];
                tabContrl.TttleLable.text = selectedItemString;
                tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"deleteStroke.png"];
                // tabContrl.addAndDeleteBtn.image
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DeleteMode"];
            }
        }
        
        
        // do stuff with the cell
    }
}



-(void)tapPosition:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.socialView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
    }
                     completion:^(BOOL finished)
     {
         self.topSocialView.hidden = true;
         self.socialView.hidden = true;
     }];
    
}


- (void)addImage:(NSNotification *)note
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        //        NSLog(@"Not Connected to Internet");
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    else
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        NSString *minAvil=[defaults valueForKey:@"minAvil"];
        
        NSString *spcAvil = [defaults valueForKey:@"spcAvil"];
        
        //    self.wdthCnst.constant = 200;
        //
        //    self.hghtCnst.constant = 100;
        
        //    self.widthContraint = [self.widthContraint ch
        
        //     NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.socialList attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.socialView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
        //
        //    [self.socialList addConstraint:constraint];
        
        //    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.socialList
        //                                                             attribute:NSLayoutAttributeWidth
        //                                                             relatedBy:NSLayoutRelationEqual
        //                                                                toItem:self.view
        //                                                             attribute:NSLayoutAttributeWidth
        //                                                            multiplier:1
        //                                                              constant:200];
        //    [self.socialList addConstraint:constraint];
        
        
        if ([spcAvil isEqualToString:@"Space Available"])
        {
            
            self.topSocialView.hidden = false;
            self.socialView.hidden = false;
            
            
            self.socialView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
            
            
            //        self.socialView.frame = CGRectMake(self.socialView.frame.origin.x, self.socialView.frame.origin.y, 200, 200);//CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
            
            
            [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:
             ^{
                 self.socialView.center = CGPointMake(self.view.center.x, self.view.center.y * 80/100);// self.view.center;
                 
                 NSLog(@"Center = %f",self.socialView.center.y);
                 
                 self.socialView.layer.cornerRadius = 10.0f;
                 self.socialView.layer.masksToBounds = YES;
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
            //                                                            style:UIAlertActionStyleDefault
            //                                                          handler:nil];
            //
            //
            //        [alert addAction:yesButton];
            //
            //        [self presentViewController:alert animated:YES completion:nil];
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"You do not have space" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.tag = 2;
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.okay.backgroundColor = [UIColor navyBlue];
            popUp.inputTextField.hidden = YES;
            [popUp show];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    [super viewWillAppear:YES];
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"dropBoxVideo"];
    
    self.topSocialView.hidden = true;
    self.socialView.hidden = true;
    
    //[self getImages];
    //    //SHADOW WITH CORNER RADIUS
    //
    //    _socialView.layer.cornerRadius = 12;
    //    _socialView.layer.masksToBounds = YES;
    //    _socialView.layer.borderWidth = 2;
    //    _socialView.layer.borderColor = [[UIColor clearColor]CGColor];
    //    _socialView.layer.shadowRadius = 2;
    //    _socialView.layer.cornerRadius = 12;
    //    _socialView.layer.masksToBounds = NO;
    //    [[_socialView layer] setShadowColor:[[UIColor whiteColor] CGColor]];
    //
    //    [[_socialView layer] setShadowOffset:CGSizeMake(0,2)];
    //    [[_socialView layer] setShadowOpacity:1];
    //
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_socialView.bounds cornerRadius:12];
    //    [[_socialView layer] setShadowPath:[path CGPath]];
    //    //SHADOW WITH CORNER RADIUS
    
    
    
    //    [self sendImage];
    
    // [self getName];
    
    // [self setGalleryImages];
    
    
    
    //    self.secondView.frame = CGRectMake(0, 149, 10, 10);
    //
    //    self.secondView.backgroundColor = [UIColor yellowColor];
    
    if(isImagePick==NO)
    {
        [self getImages];
    }
    if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        
        [self.ADView removeFromSuperview];
    }
    
}

-(void)getImages
{
    @try
    {
        onlyImagePath=[[NSMutableArray alloc]init];
        
        //isImagePick=NO;
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=view_my_image";
        NSDictionary *parameters = @{@"User_ID":user_id,@"lang":@"iOS",@"page_number":@"0",@"media_type":@"image"};
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
                  
                  if ([status isEqualToString:@"Found"])
                  {
                      for(NSDictionary *imageDic in imageArray)
                      {
                          NSString *thumbnailPath,*originalPath;
                          
                          NSString *type = [imageDic objectForKey:@"type"];
                          NSString *id;
                          if([type isEqualToString:@"Image"])
                          {
                              thumbnailPath = [imageDic objectForKey:@"thumb_img"];
                              id = [imageDic objectForKey:@"image_id"];
                              originalPath=[imageDic objectForKey:@"Image_Path"];
                              
                              NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                              
                              [dic setValue:type forKey:@"DataType"];
                              
                              [dic setValue:id forKey:@"Id"];
                              [dic setObject:thumbnailPath forKey:@"imagePath"];
                              [dic setObject:originalPath forKey:@"originalImagePath"];
                              [dic setValue:@"0" forKey:@"SelectedForDelete"];
                              [finalArray addObject:dic];
                              [onlyImagePath addObject:originalPath];
                              
                              //[onlyImagePath addObject:thumbnailPath
                              //];
                          }
                      }
                      NSLog(@"Final Array in uploadimg:%@",finalArray);
                      
                      NSLog(@"only imagepath Array in uploadimg:%@",onlyImagePath);
                      
                      //                      [[NSUserDefaults standardUserDefaults] setInteger:finalArray.count forKey:@"uploadImgCount"];
                      //
                      //                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                      if (finalArray.count == 0)
                      {
                          self.collectView.hidden = true;
                          self.pageView.hidden = false;
                          
                          [hud hideAnimated:YES];
                      }
                      
                      else
                      {
                          self.collectView.hidden = false;
                          self.pageView.hidden = true;
                          [self.collectionView reloadData];
                          NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                          
                          [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                          
                          [hud hideAnimated:YES];
                      }
                  }
                  else
                  {
                      NSLog(@"No Image Found");
                      self.collectView.hidden=YES;
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
              //[self setCameraButton];
              //              if(finalArray.count>1){
              //                  NSInteger item = finalArray.count-1;
              //                  NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
              //                  [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
              //              }
              
              if (finalArray.count == 0)
                  [self.pageView addSubview:_OpenCameraSPUsrRzbleVw];
              else
                  [self.collectionView.superview addSubview:_OpenCameraSPUsrRzbleVw];
          }]resume];
        //        [[SDImageCache sharedImageCache] clearDisk];
        //        [[SDImageCache sharedImageCache] clearMemory];
        
        
    }
    @catch (NSException *exception)
    {
        [hud hideAnimated:YES];
    }
    @finally
    {
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"imgEditing" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postDelete" object:nil];
    [animationView removeFromSuperview];
    [_BlurView removeFromSuperview];
    
}
//-(void)viewDidLayoutSubviews
//{
//
//    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
//
//    NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"stickers"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteMultipleItems:) name:@"postDelete" object:nil];
    
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    if (finalArray.count == 0)
        [self.pageView addSubview:_OpenCameraSPUsrRzbleVw];
    else
        [self.collectionView.superview addSubview:_OpenCameraSPUsrRzbleVw];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
    TabBarViewController *tabContrl = self.tabBarController;
    tabContrl.TttleLable.text = @"My Images";
    tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"12-PLUS.png"];
}

-(void)imageEditing:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imgEditing" object:nil];
    
    isImagePick=YES;
    //NSLog(@"CLI dta:%@",notification.userInfo);
    NSDictionary *dic=notification.userInfo;
    NSData *imageData=[dic objectForKey:@"total"];
    
    [self finishedImageUploading:imageData];
    
    // [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Cancel any operations when you leave views
    // self.navigationController.navigationBarHidden = NO;
    
    [super viewWillDisappear:YES];
    
    [self.todaysInterestingOp cancel];
    [self.myPhotostreamOp cancel];
    [self.completeAuthOp cancel];
    [self.checkAuthOp cancel];
    [self.uploadOp cancel];
    [self removeItemsFromDeleteMode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) userAuthenticateCallback:(NSNotification *)notification
{
    NSURL *callbackURL = notification.object;
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error)
                           {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   if (!error)
                                   {
                                       [self userLoggedIn:userName userID:userId];
                                   }
                                   else
                                   {
                                       //                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                       //                                       [alert show];
                                       
                                       CustomPopUp *popUp = [CustomPopUp new];
                                       [popUp initAlertwithParent:self withDelegate:self withMsg:@"User authentication failed" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                                       //popUp.accessibilityHint = @"";
                                       popUp.agreeBtn.hidden = YES;
                                       popUp.okay.backgroundColor = [UIColor navyBlue];
                                       popUp.cancelBtn.hidden = YES;
                                       popUp.inputTextField.hidden = YES;
                                       [popUp show];
                                   }
                                   
                                   //          [self.navigationController popToRootViewControllerAnimated:YES];
                                   
                                   //            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                   //
                                   //            SelectSourceViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SelectSource"];
                                   //
                                   //            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                   //
                                   //            [self presentViewController:vc animated:YES completion:NULL];
                                   //
                                   
                               });
                           }];
}



- (void) userLoggedIn:(NSString *)username userID:(NSString *)userID
{
    self.userID = userID;
    NSLog(@"USer Loggin");
    //    if ([FlickrKit sharedFlickrKit].isAuthorized)
    //    {
    //        [self.presentedViewController dismissViewControllerAnimated:YES completion:NO];
    //        [self flickerphotourl];
    //
    //    }
    
    
    //[self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    //self.authLabel.text = [NSString stringWithFormat:@"You are logged in as %@", username];
}

- (void) userLoggedOut
{
    NSLog(@"USer logout");
    
    // [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    // self.authLabel.text = @"Login to flickr";
}

- (IBAction)upload:(id)sender
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *minAvil=[defaults valueForKey:@"minAvil"];
    
    NSString *spcAvil = [defaults valueForKey:@"spcAvil"];
    
    if ([spcAvil isEqualToString:@"Space Available"])
    {
        self.topSocialView.hidden = false;
        self.socialView.hidden = false;
        
        self.socialView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
        
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            //        self.socialView.center = self.view.center;
            
            self.socialView.center = CGPointMake(self.view.center.x, self.view.center.y * 80/100);// self.view.center;
            
            
            self.socialView.layer.cornerRadius = 10.0f;
            self.socialView.layer.masksToBounds = YES;
        }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
         }];
    }
    else
    {
        //        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
        //             message:@"You do not have space"
        //             preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
        //             style:UIAlertActionStyleDefault
        //             handler:nil];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You do not have space" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    
    
    
    /*    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
     
     elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
     elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
     elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
     elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
     //    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
     
     elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];
     
     elcPicker.imagePickerDelegate = self;
     
     [self presentViewController:elcPicker animated:YES completion:nil]; */
    
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
    
    static NSString *CellIdentifier = @"Cell";
    
    UploadImageCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // cell.layer.borderWidth = 0.2f;
    
    cell.alpha = 1.0;
    
    /* NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *DocDir = [ScreensDir objectAtIndex:0];
     
     DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
     NSMutableDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
     NSLog(@"OnlyImages %@",OnlyImages);
     NSString *id1 = [dic valueForKey:@"Id"];
     
     DocDir = [DocDir stringByAppendingPathComponent:[id1 stringByAppendingString:@".png"]];*/
    
    /*    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
     
     UIImage *img=[[UIImage alloc] initWithData:pictureData];
     
     cell.ImgView.image = img;*/
    
    // NSURL *imageURL = [NSURL fileURLWithPath:DocDir];
    
    /*    SDImageCache *imageCache = [SDImageCache sharedImageCache];
     [imageCache clearMemory];
     [imageCache clearDisk];*/
    
    NSString *img=[[finalArray objectAtIndex:indexPath.row]objectForKey:@"imagePath"];
    if([[[finalArray objectAtIndex:indexPath.row]objectForKey:@"SelectedForDelete"] isEqualToString:@"1"]){
        cell.SelectedItem.hidden = NO;
    }
    NSURL *imageURL=[[NSURL alloc]initWithString:img];
    //cell.ImgView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.ImgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    // place_holder_simple.png
    //    [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    //     {
    //         if(error==nil && data!=nil)
    //         {
    ////             dispatch_async(dispatch_get_main_queue(),^{
    ////
    ////                 cell.ImgView.image=[UIImage imageWithData:data];
    ////             });
    //             [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    //                 cell.ImgView.image=[UIImage imageWithData:data];
    //             }];
    //         }
    //     }];
    
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
    
    //  cell.ImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
    // [cell.BackGroundImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
    /* NSData *pictureData = UIImagePNGRepresentation(cell.ImgView.image);
     
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
     CGSize newBlurSize =   CGSizeMake((scaledBlurImage.size.width), (scaledBlurImage.size.height));
     UIGraphicsBeginImageContext(newBlurSize);
     [cell.ImgView.image drawInRect:CGRectMake(0, 0, newBlurSize.width, newBlurSize.height)];
     
     UIImage *BackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     cell.BackGroundImage.image = BackgroundImage;
     //    cell.ImgView.image = img;*/
    
    cell.View.tag = indexPath.row;
    [cell.View addTarget:self action:@selector(View:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.Annotate.tag = indexPath.row;
    [cell.Annotate addTarget:self action:@selector(annotate_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.Edit.tag = indexPath.row;
    [cell.Edit addTarget:self action:@selector(imageEdit_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.Delete.tag = indexPath.row;
    [cell.Delete addTarget:self action:@selector(close_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        cell.AboveTopView.hidden = false;
        cell.TopView.hidden = false;
    }
    else
    {
        cell.AboveTopView.hidden = true;
        cell.TopView.hidden = true;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did Deselect");
    
    NSDictionary *dic = [finalArray objectAtIndex:indexPath.row];
    [dic setValue:@"0" forKey:@"SelectedForDelete"];
    [finalArray replaceObjectAtIndex:indexPath.row withObject:dic];
    [MultipleDeleteItemsAry removeObject:dic];
    
    [MultipleDeleteIndexPathAry removeObject:[NSNumber numberWithInt:indexPath.row]];
    
    
    UploadImageCollectionCell *cell = (UploadImageCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.AboveTopView.hidden = YES;
    cell.SelectedItem.hidden = YES;
    TabBarViewController *tabContrl = self.tabBarController;
    NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected (%lu)", (unsigned long)MultipleDeleteItemsAry.count];
    tabContrl.TttleLable.text = selectedItemString;
    if(MultipleDeleteItemsAry.count == 0){
        isDeleteMode = NO;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
        
        tabContrl.TttleLable.text = @"My Image";
        tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"12-PLUS.png"];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        if(isDeleteMode){
            UploadImageCollectionCell *cell=(UploadImageCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
            cell.AboveTopView.hidden = NO;
            cell.SelectedItem.hidden= NO;
            NSLog(@"Did Select");
            NSDictionary *dic = [finalArray objectAtIndex:indexPath.row];
            [dic setValue:@"1" forKey:@"SelectedForDelete"];
            [finalArray replaceObjectAtIndex:indexPath.row withObject:dic];
            [MultipleDeleteItemsAry addObject:dic];
            int index = indexPath.row;
            [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:indexPath.row]];
            TabBarViewController *tabContrl = self.tabBarController;
            NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected (%lu)", (unsigned long)MultipleDeleteItemsAry.count];
            tabContrl.TttleLable.text = selectedItemString;
            
            
        }else{
            
            SelectedIndexPath = indexPath;
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
    @catch (NSException *exception)
    {
        NSLog(@"Image Select = %@",exception);
    }
    @finally
    {
        NSLog(@"Image Select Finally");
    }
    
    
    /*  NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *DocDir = [ScreensDir objectAtIndex:0];
     
     DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
     
     
     NSMutableDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
     
     NSLog(@"OnlyImages %@",OnlyImages);
     
     NSString *id = [dic valueForKey:@"Id"];
     
     DocDir = [DocDir stringByAppendingPathComponent:[id stringByAppendingString:@".png"]];
     
     NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
     
     UIImage *img=[[UIImage alloc] initWithData:pictureData];
     
     
     CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:img delegate:self];
     
     [self presentViewController:editor animated:YES completion:nil];
     
     NSLog(@"After Editing..");*/
    
    //Showing in gallary
    //    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    //
    //    localGallery.cIndex = (int)indexPath.row;
    //
    //    localGallery.pathArray = [NSArray arrayWithArray:localImages];
    //
    //    [self.navigationController pushViewController:localGallery animated:YES];
    //Showing in gallary
    
}

//- (void)igcMenuSelected:(NSString *)selectedMenuName atIndex:(NSInteger)index
//{
//    @try
//    {
//        [igcMenu hideCircularMenu];
//        isMenuActive = NO;
//
//        NSLog(@"selected menu name = %@ at index = %ld",selectedMenuName,(long)index);
//
//        NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
//        [defaults setInteger:index forKey:@"SelectedMenu"];
//
//        int sendIndex = (int8_t)[defaults integerForKey:@"SelectedIndex"];
//
//
//        if (index == 0)
//        {
//
//
//            UIAlertController * alert=[UIAlertController
//                                       alertControllerWithTitle:@"Confirm" message:@"Are you sure to delete ?"preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction* yesButton = [UIAlertAction
//                                        actionWithTitle:@"Yes"
//                                        style:UIAlertActionStyleDefault
//                                        handler:^(UIAlertAction * action)
//                                        {
//                                            //                                            NSLog(@"Close:%@",OnlyImages);
//
//                                            NSString *img = [[finalArray objectAtIndex:sendIndex]objectForKey:@"Id"];
//                                            NSLog(@"img:%@",img);
//
//                                            deleteName = img;
//
//                                            //    NSRange searchRange = [img rangeOfString:@"." options:NSBackwardsSearch];
//                                            //    NSLog(@"img SearchRange:%@",searchRange);
//                                            //    NSString *tempCon = [img substringToIndex:(searchRange.location)];
//
//                                            NSLog(@"Img = %@",deleteName);
//
//                                            [self deleteImage:deleteName];
//
//                                        }];
//            UIAlertAction* noButton = [UIAlertAction
//                                       actionWithTitle:@"No"
//                                       style:UIAlertActionStyleDefault
//                                       handler:^(UIAlertAction * action)
//                                       {
//
//                                       }];
//
//            [alert addAction:yesButton];
//            [alert addAction:noButton];
//
//            [self presentViewController:alert animated:YES completion:nil];
//
//
//        }
//        else if(index == 1)
//        {
//            NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *DocDir = [ScreensDir objectAtIndex:0];
//
//            DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
//
//            NSMutableDictionary *dic = [OnlyImages objectAtIndex:sendIndex];
//
//            NSLog(@"OnlyImages %@",OnlyImages);
//
//            NSString *id = [dic valueForKey:@"Id"];
//
//            DocDir = [DocDir stringByAppendingPathComponent:[id stringByAppendingString:@".png"]];
//
//            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
//            NSLog(@"PICTURE DATA %@",pictureData);
//            UIImage *img=[[UIImage alloc] initWithData:pictureData];
//
//
//            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(img) forKey:@"AnnotateImage"];
//            [[NSUserDefaults standardUserDefaults] setInteger:sendIndex forKey:@"DicIndexInArray"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//
//            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
//
//            AnnotateViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AnnotateView"];
//
//            //    [self presentViewController:vc animated:YES completion:NULL];
//
//            [self.navigationController pushViewController:vc animated:YES];
//
//
//
//
//        }else if(index == 2)
//        {
//            NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *DocDir = [ScreensDir objectAtIndex:0];
//
//            DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
//
//            NSMutableDictionary *dic = [OnlyImages objectAtIndex:sendIndex];
//
//            NSLog(@"OnlyImages %@",OnlyImages);
//
//            NSString *id = [dic valueForKey:@"Id"];
//
//            DocDir = [DocDir stringByAppendingPathComponent:[id stringByAppendingString:@".png"]];
//
//            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
//
//            UIImage *img=[[UIImage alloc] initWithData:pictureData];
//
//
//            CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:img delegate:self];
//
//
//
//            [self presentViewController:editor animated:YES completion:nil];
//
//            NSLog(@"After Editing..");
//
//
//        }else if(index == 3)
//        {
//            //Showing in gallary
//            localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
//
//            localGallery.cIndex = sendIndex;
//
//            localGallery.pathArray = [NSArray arrayWithArray:onlyImagePath];
//
//            [self.navigationController pushViewController:localGallery animated:YES];
//            // Showing in gallary
//        }
//    }
//    @catch (NSException *exception)
//    {
//        NSLog(@"igcMenu exception = %@",exception);
//    }
//    @finally
//    {
//        NSLog(@"igcMenu Finally");
//    }
//}

-(void)setGalleryImages
{
    
    localImages = [[NSMutableArray alloc]init];
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    for (int i = 0; i < OnlyImages.count; i++)
    {
        NSMutableDictionary *dic = [OnlyImages objectAtIndex:i];
        NSString *pathFile = [dic valueForKey:@"Id"];
        
        NSString *DocDir = [ScreensDir objectAtIndex:0];
        
        DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
        
        DocDir = [DocDir stringByAppendingPathComponent:[pathFile stringByAppendingString:@".png"]];
        
        [localImages addObject:DocDir];
    }
    
    NSLog(@"galleryImages %@",localImages);
}

-(void)View:(UIButton*)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet cponnection" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        [_currentWindow addSubview:_BlurView];
        [_currentWindow addSubview:animationView];
        [animationView playWithCompletion:^(BOOL animationFinished) {

        }];
        
        localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        
        localGallery.cIndex = sender.tag;
        
        localGallery.pathArray = [NSArray arrayWithArray:onlyImagePath];

        [self.navigationController pushViewController:localGallery animated:YES];
        
    }
}

-(void)imageEdit_btn:(UIButton*)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet cponnection" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self performSelector:@selector(imageEdit:) withObject:sender afterDelay:0.0];
        
    }
}

-(void)imageEdit:(UIButton*)sender
{
    [hud hideAnimated:YES];
    
    isImagePick=YES;
    
    NSString *imgPathVal =[[finalArray objectAtIndex:sender.tag]objectForKey:@"originalImagePath"];
    
    NSURL *thumbURL=[NSURL URLWithString:[[finalArray objectAtIndex:sender.tag]objectForKey:@"originalImagePath"]];
    
    NSData *imgData=[NSData dataWithContentsOfURL:thumbURL];
    UIImage *img=[[UIImage alloc] initWithData:imgData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:imgData forKey:@"imgData"];
    
    [[NSUserDefaults standardUserDefaults]setObject:imgPathVal forKey:@"imgPathVal"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageEditing:) name:@"imgEditing" object:nil];
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:img delegate:self];
    
    editor.delegate=self;
    
    [self.navigationController pushViewController:editor animated:YES];
    NSLog(@"After Editing..");
}

-(void)annotate_btn:(UIButton*)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet cponnection" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];          popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    else
    {
        NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *DocDir = [ScreensDir objectAtIndex:0];
        
        DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
        
        NSMutableDictionary *dic = [finalArray objectAtIndex:sender.tag];
        
        NSLog(@"OnlyImages %@",finalArray);
        
        NSString *id = [dic valueForKey:@"Id"];
        
        DocDir = [DocDir stringByAppendingPathComponent:[id stringByAppendingString:@".png"]];
        
        NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
        
        UIImage *img=[[UIImage alloc] initWithData:pictureData];
        
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(img) forKey:@"AnnotateImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
        
        AnnotateViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AnnotateView"];
        
        //    [self presentViewController:vc animated:YES completion:NULL];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
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


/*
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 CGFloat picDimension;
 
 /*    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
 {
 picDimension = self.view.frame.size.width / 3.08f;
 }
 else
 {
 picDimension = self.view.frame.size.width / 2.18f;
 }
 
 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
 {
 return CGSizeMake((collectionView.frame.size.width/3)-20, (collectionView.frame.size.width/3)-20);
 }
 else
 {
 return CGSizeMake((collectionView.frame.size.width/2)-20, (collectionView.frame.size.width/2)-20);
 }}
 
 return CGSizeMake(picDimension, picDimension);
 }
 */


-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    isImagePick=YES;
    NSData *thumbnailData;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self getName];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    //    NSMutableString *ms = [[NSMutableString alloc]init];
    //
    //    lastHighestCount = HigestImageCount;
    
    sendImage = [[NSMutableArray alloc]init];
    NSLog(@"Size = %lu",(unsigned long)info.count);
    // int count =HigestImageCount;
    
    
    
    
    /*    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     //    hud.mode = MBProgressHUDModeDeterminate;
     //    hud.progress = progress;
     
     hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
     hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
     
     [_currentWindow addSubview:_BlurView];*/
    
    
    if(info.count>=1)
    {
       /* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        
        hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
        */
        [_currentWindow addSubview:_BlurView];
        [_currentWindow addSubview:animationView];
        
        [animationView playWithCompletion:^(BOOL animationFinished) {
            // ...
        }];
        for (NSDictionary *dict in info)
        {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
            {
                if ([dict objectForKey:UIImagePickerControllerOriginalImage])
                {
                    // HigestImageCount++;
                    
                    UIImage* chosenImage=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    
                    NSData *data = UIImageJPEGRepresentation(chosenImage, 0.5);
                    //UIImage *img = [[UIImage alloc]initWithData:data];
                    //NSData *data = UIImagePNGRepresentation(chosenImage);
                    
                    thumbnailData = [self generateThumnail:chosenImage thumbnailData:data];
                    
                    [fullImage addObject:data];
                    [thumbImage addObject:thumbnailData];
                    
                    
                }
                else
                {
                    // [hud hideAnimated:YES];
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            }
            else
            {
                NSLog(@"Uknown asset type");
            }
        }
        
        
        // imageID = [ms substringToIndex:[ms length]-1];
        
        
        [self completeSendImage];
    }
    
}

-(void)completeSendImage
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        [hud hideAnimated:YES];
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
        //                                        [hud hideAnimated:YES];
        //
        //                                        [_BlurView removeFromSuperview];
        //
        //                                    }];
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet cponnection" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    else
    {
        
        @try
        {
            NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                             {
                                                 
                                                 for (int i = 0; i<fullImage.count; i++)
                                                 {
                                                     
                                                     [formData appendPartWithFileData:fullImage[i] name:@"upload_files[]" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                                     
                                                     [formData appendPartWithFileData:thumbImage[i] name:@"thumb_img[]" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                                 }
                                                 
                                                 //                                             [formData appendPartWithFormData:[imageID dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
                                                 
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
                            
                              
                          }
                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                          {
                              if (error)
                              {
                                  NSLog(@"Error For Image: %@", error);
                                  
                                  //[hud hideAnimated:YES];
                                  [animationView removeFromSuperview];
                                  [_BlurView removeFromSuperview];
                                  
                                  
                                  CustomPopUp *popUp = [CustomPopUp new];
                                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet cponnection" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                                  popUp.okay.backgroundColor = [UIColor navyBlue];                                popUp.agreeBtn.hidden = YES;
                                  popUp.cancelBtn.hidden = YES;
                                  popUp.inputTextField.hidden = YES;
                                  [popUp show];
                                  // [self rollback];
                              }
                              else
                              {
                                  
                                  NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                  
                                  NSLog(@"Response For Image:%@",responsseObject);
                                  
                                  if (responseObject == NULL)
                                  {
                                      // [self rollback];
                                      //[hud hideAnimated:YES];
                                      
                                      [animationView removeFromSuperview];
                                      
                                      [_BlurView removeFromSuperview];
                                  }
                                  else
                                  {

                                      NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                      
                                      NSString *minAvil=[responsseObject objectForKey:@"Duration Status"];
                                      
                                      NSString *spcAvil = [responsseObject objectForKey:@"Space Status"];
                                      
                                      [defaults setValue:minAvil forKey:@"minAvil"];
                                      
                                      [defaults setValue:spcAvil forKey:@"spcAvil"];
                                      
                                      [defaults synchronize];
                                      
                                      //                                  UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Image Uploaded"
                                      //                                                                                                message:@"Success"
                                      //                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                      //                                  UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                      //                                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                      //                                                                                          [hud hideAnimated:YES];
                                      //
                                      //                                                                                          [_BlurView removeFromSuperview];
                                      //                                                                                          [self getImages];                                                                                    }];
                                      
                                      //
                                      //                                  [alert addAction:yesButton];
                                      
                                      //                                  [self presentViewController:alert animated:YES completion:nil];
                                      
                                      CustomPopUp *popUp = [CustomPopUp new];
                                      if(fullImage.count>1)
                                          [popUp initAlertwithParent:self withDelegate:self withMsg:@"Images has been uploaded successfully" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                                      else
                                          [popUp initAlertwithParent:self withDelegate:self withMsg:@"Image has been uploaded successfully" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                                      popUp.okay.backgroundColor = [UIColor lightGreen];
                                      popUp.accessibilityHint =@"ImageUploadedSuccess";
                                      popUp.agreeBtn.hidden = YES;
                                      popUp.cancelBtn.hidden = YES;
                                      popUp.inputTextField.hidden = YES;
                                      [popUp show];
                                      
                                      [hud hideAnimated:YES];
                                      [animationView removeFromSuperview];
                                      
                                      [_BlurView removeFromSuperview];                                      [self getImages];
                                      
                                  }
                              }
                          }];
            
            [uploadTask resume];
        }
        @catch(NSException *exception)
        {
            NSLog(@"catch:%@",exception);
        }
    }
}


-(void)sendImage:(NSData*)data nd:(NSData*)th sd:(NSString*)s
{
    
    NSLog(@"data = %lu",(unsigned long)data.length);
    
    //    UIImage *img = [UIImage imageNamed:@"text-xxl.png"];
    //
    //    NSData *dfs = UIImagePNGRepresentation(img);
    
    NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         
                                         [formData appendPartWithFileData:data name:@"upload_files" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                         
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
    
    [requests setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:requests
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
                          NSLog(@"Error For Image: %@", error);
                          
                          [hud hideAnimated:YES];
                          
                          [_BlurView removeFromSuperview];
                          
                          UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Upload failed"
                                                                                        message:@"Your upload could not be completed.\nTry again ?"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:nil];
                          
                          [alert addAction:yesButton];
                          
                          [self presentViewController:alert animated:YES completion:nil];
                          
                          //[self rollback];
                          
                      }
                      else
                      {
                          
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"Response For Image:%@",responsseObject);
                          
                          if (responseObject == NULL)
                          {
                              //                              [self rollback];
                          }
                          else
                          {
                              
                              NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                              
                              NSString *minAvil=[responsseObject objectForKey:@"Duration Status"];
                              
                              NSString *spcAvil = [responsseObject objectForKey:@"Space Status"];
                              
                              [defaults setValue:minAvil forKey:@"minAvil"];
                              
                              [defaults setValue:spcAvil forKey:@"spcAvil"];
                              
                              [defaults synchronize];
                              
                              [hud hideAnimated:YES];
                              
                              [_BlurView removeFromSuperview];
                              
                              
                              UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Image Uploaded"
                                                                                            message:@"Success"
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                              
                              UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                                  style:UIAlertActionStyleDefault
                                                                                handler:nil];
                              
                              [alert addAction:yesButton];
                              
                              [self presentViewController:alert animated:YES completion:nil];
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
    
    
    
    /*    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
     
     [manager POST:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
     [formData appendPartWithFileData:data
     name:@"upload_files"
     fileName:@"file.png" mimeType:@"image/jpeg"];
     
     //        [formData appendPartWithFormData:[key1 dataUsingEncoding:NSUTF8StringEncoding]
     //                                    name:@"key1"];
     //
     //        [formData appendPartWithFormData:[key2 dataUsingEncoding:NSUTF8StringEncoding]
     //                                    name:@"key2"];
     
     [formData appendPartWithFileData:th name:@"thumb_img" fileName:@"img.png" mimeType:@"image/jpeg"];
     
     //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application/03D6148D-BF6D-4B92-AC31-578B9971DE19/Documents/MyImagesAndVideos/3.png"] name:@"thumb_img" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
     
     [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
     
     [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
     
     [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
     
     
     // etc.
     }
     progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
     NSLog(@"iResponse: %@", responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
     NSLog(@"iError: %@", error);
     }];*/
    
}


//-(void)updateImagesToServer
//{
//    NSLog(@"updateImageToServer..");
//
//    //[self loadSavedFile];
//
//    @try
//    {
//        for(imgName in sendImage)
//        {
//
//            NSLog(@"Send Image Inside Loop... = %@",imgName);
//
//            NSRange searchRange = [imgName rangeOfString:@"." options:NSBackwardsSearch];
//
//            NSString *tempCon = [imgName substringToIndex:(searchRange.location)];
//
//            NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//
//            NSString *DocDir = [ScreensDir objectAtIndex:0];
//
//            DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos/"];
//
//            DocDir = [DocDir stringByAppendingPathComponent:imgName];
//            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
//
//            UIImage *img=[[UIImage alloc] initWithData:pictureData];
//
//            NSData *imgData = UIImagePNGRepresentation(img);
//
//            //           NSLog(@"Image Data = %@",imgData);
//
//
//            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            //    hud.mode = MBProgressHUDModeDeterminate;
//            //    hud.progress = progress;
//
//
//            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
//
//            [_currentWindow addSubview:_BlurView];
//
//
//            if( [self setImageParams:imgData imageID:tempCon])
//            {
//                NSLog(@"Enter block");
//
//                NSOperationQueue *queue = [NSOperationQueue mainQueue];
//
//                [NSURLConnection sendAsynchronousRequest:request
//                                                   queue:queue
//                                       completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
//                 {
//
//                     [hud hideAnimated:YES];
//
//                     [_BlurView removeFromSuperview];
//
//
//                     NSLog(@"Response = %@",urlResponse);
//
//                 }];
//
//                NSLog(@"Image Sent");
//            }
//            else
//            {
//
//                [hud hideAnimated:YES];
//
//                [_BlurView removeFromSuperview];
//
//
//                NSLog(@"Image Failed...");
//            }
//
//        }
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


-(BOOL)setImageParams:(NSData *)imgData imageID:(NSString *)imageId thumbData:(NSData*)thumbnailData
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
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload_files\"; filename=\"%@.png\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"thumb_img\"; filename=\"%@.png\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:thumbnailData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];
            
            
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

-(void)close_btn:(UIButton*)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        // popUp.accessibilityHint = @"ImageUploadedSuccess";
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        deleteTag =  (int)sender.tag;
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to delete the file ?" withTitle:@"Delete" withImage:[UIImage imageNamed:@"delete_alert.png"]];
        popUp.accessibilityHint = @"SingleDeleteConfirmation";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        //        popUp.agreeBtn.backgroundColor = []
        popUp.okay.hidden = YES;
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
    
    tabContrl.TttleLable.text = @"My Image";
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
             
            
             
             [defaults synchronize];
             NSArray *arrayOfIndexPaths = [self.collectionView indexPathsForSelectedItems];
             for(int i=0;i < [MultipleDeleteIndexPathAry count];i){
                 
                 NSNumber *maxNumber = [MultipleDeleteIndexPathAry valueForKeyPath:@"@max.self"];
                 [MultipleDeleteIndexPathAry removeObject:maxNumber];
                 NSIndexPath *removingIndexPath = [NSIndexPath indexPathForRow:maxNumber.intValue inSection:0];
                 [finalArray removeObjectAtIndex:removingIndexPath.row];
                 
                 if((finalArray.count)==0)
                 {
                     
                     [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"uploadImgCount"];
                 }
                 
                 NSArray *deleteItems = @[removingIndexPath];
                 [self.collectionView deleteItemsAtIndexPaths:deleteItems];
             }
             
             if(finalArray.count==0)
             {
                 self.collectView.hidden=YES;
                 self.pageView.hidden=NO;
                 self.pageViewImgView.hidden=NO;
                 self.pageViewImgView.image=[UIImage imageNamed:@"500-image.png"];
             }
             //                 else
             //                 {
             //                     self.pageViewImgView.hidden=YES;
             //
             //                 }
             
             //self.collectView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"1.jpg"]];
             
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
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Image removed" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
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
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try again" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
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
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
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
-(void)localDelete
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSError *error;
    
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    
    //  NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    NSString *myPath1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    //    myPath = [myPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",deleteName]];
    //
    //    BOOL success = [fileManager removeItemAtPath:myPath error:&error];
    //    NSLog(@"mypath:%@",myPath);
    
    NSString *SharedFinalplistPath = [myPath1 stringByAppendingPathComponent:@"DataList.plist"];
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
        if([[dic valueForKey:@"Id"] isEqualToString:deleteName])
        {
            [plist removeObject:dic];
            break;
        }
    }
    
    [plist writeToFile:SharedFinalplistPath atomically:YES];
    
    //    if (success)
    //    {
    
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:deleteTag inSection:0] ;
    
    [finalArray removeObjectAtIndex:deleteTag];
    
    NSArray *deleteItems = @[myIP];
    
    [self.collectionView deleteItemsAtIndexPaths:deleteItems];
    
    //[self getName];
    
    
    /*        int row = (int)[indexPath row];
     
     
     [OnlyImages removeObjectAtIndex:row];
     
     NSArray *deleteItems = @[indexPath];
     
     
     [self.collectionView deleteItemsAtIndexPaths:deleteItems];*/
    
    
    /*        UIAlertView *removedSuccessFullyAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     [removedSuccessFullyAlert show];*/
    
    //        [self getName];
    
    
    //        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:deleteName]];
    
    
    /*        self.collectView.hidden = false;
     self.pageView.hidden = true;
     [self.collectionView reloadData];*/
    
    
    //        [self getName];
    
    //        [self.collectionView reloadData];
    
    
    //    }
    //    else
    //    {
    //        [self getName];
    //
    //        [self.collectionView reloadData];
    //
    //        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    //    }
    
}

- (IBAction)fromLocal:(id)sender
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.navigationBar.tintColor=[UIColor whiteColor];
    elcPicker.navigationBar.barTintColor=UIColorFromRGB(0x2d2c65);
    
    [elcPicker.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"FuturaT-Book" size:22]}];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    //    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (IBAction)facebook:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");

        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    else
    {
        NSLog(@"Clicked..");
        isImagePick=YES;
        OLFacebookImagePickerController *picker = [[OLFacebookImagePickerController alloc] init];
        
        //   picker.selected = self.selected;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

- (void)showErrorAlert:(NSError*)error
{
    NSString *errorMsg;
    
    if ([error isAuthCanceledError])
    {
        errorMsg = @"Sign-in was canceled!";
    }
    else if ([error isAuthenticationError])
    {
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

- (IBAction)instagram:(id)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    
    else
    {
        isImagePick=YES;
        
        OLInstagramImagePickerController *imagePicker = [[OLInstagramImagePickerController alloc] initWithClientId:@"cc3b41091d97462c8742fc77b60d92eb" secret:@"60b267b0d4714718955f521d4ac6829d" redirectURI:@"http://www.seekitech.com/"];
        
        imagePicker.delegate = self;
        imagePicker.selected = self.selectedImages;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)dropboxLogin
{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DropboxViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DropboxViews"];
    vc.delegate=self;
    
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:@"DropboxLogin"];
}

- (IBAction)dropBox:(id)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    
    else
    {
        isImagePick=YES;
        
        if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient])
        {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            DropboxViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DropboxViews"];
            vc.delegate=self;
            
            //        UINavigationController *navigationController =
            //        [[UINavigationController alloc] initWithRootViewController:vc];
            //
            //        navigationController.navigationBar.barTintColor=UIColorFromRGB(0x4186F2);//[UIColor blueColor];
            //
            //                [self presentViewController:navigationController animated:YES completion:nil];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                           controller:self
                                              openURL:^(NSURL *url)
             {
                 [[UIApplication sharedApplication] openURL:url];
             }];
        }
    }
}
/*{
 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 
 DropboxDownloadFileViewControlller *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DropboxDownloadFileViewControlller"];
 
 UINavigationController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NavigationController"];
 
 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 
 [self presentViewController:vc animated:YES completion:NULL];
 }
 */
- (IBAction)flickr:(id)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    
    else
    {
        NSLog(@"Flickr");
        isImagePick=YES;
        
        [self flickerphotourl];
    }
}

- (IBAction)fromCamera:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSData *thumbnailData;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //  [self getName];
    
    sendImage = [[NSMutableArray alloc]init];
    NSLog(@"Size = %lu",(unsigned long)info.count);
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
   /* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
    
    [_currentWindow addSubview:_BlurView];*/
    [_currentWindow addSubview:_BlurView];
    [_currentWindow addSubview:animationView];
    
    [animationView playWithCompletion:^(BOOL animationFinished) {
        // ...
    }];
    
    NSData *JPEGdata = UIImageJPEGRepresentation(chosenImage, 0.5);
    UIImage *img = [[UIImage alloc]initWithData:JPEGdata];
    NSData *data = UIImagePNGRepresentation(chosenImage);    //UIImagePNGRepresentation(chosenImage);// UIImageJPEGRepresentation(chosenImage,0.5);
    
    thumbnailData = [self generateThumnail:chosenImage thumbnailData:data];
    
    [fullImage addObject:data];
    [thumbImage addObject:thumbnailData];
    
    [self completeSendImage];
    
}

-(NSData *)generateThumnail:(UIImage *)image thumbnailData:(NSData *)data
{
    NSData *thumbnailData;
    
    if(image.size.width || image.size.height)
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                               (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                               (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                               (id) kCGImageSourceThumbnailMaxPixelSize : @(400)
                                                               };
        
        CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
        if (NULL != imageSource)
            CFRelease(imageSource);
        
        UIImage* scaledImage = [UIImage imageWithCGImage:thumbnail];
        CGSize newSize =   CGSizeMake((scaledImage.size.width), (scaledImage.size.height));
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        thumbnailData = UIImagePNGRepresentation(image);
        UIGraphicsEndImageContext();
        
    }
    
    return thumbnailData;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(void)flickerphotourl
{
    if ([FlickrKit sharedFlickrKit].isAuthorized)
    {
        
        NSLog(@"Flickr Authorized");
        
        self.myPhotostreamOp = [[FlickrKit sharedFlickrKit] call:@"flickr.photos.search" args:@{@"user_id": self.userID, @"per_page": @"15"} maxCacheAge:FKDUMaxAgeNeverCache completion:^(NSDictionary *response, NSError *error)
                                {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (response) {
                                            NSLog(@"Flickr Response:%@",response);
                                            NSMutableArray *photoURLs = [NSMutableArray array];
                                            
                                            for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"])
                                            {
                                                NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                                                [photoURLs addObject:url];
                                            }
                                            
                                            NSLog(@"Photo URL:%@",photoURLs);
                                            
                                            PhotoViewController *fivePhotos = [[PhotoViewController alloc] initWithURLArray:photoURLs];
                                            fivePhotos.delegate=self;
                                            
                                            [self presentViewController:fivePhotos animated:YES completion:NULL];
                                            
                                            
                                            //[self.navigationController pushViewController:fivePhotos animated:YES];
                                            
                                        }
                                        else
                                        {
                                            
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                            
                                            [alert show];
                                            
                                        }
                                    });
                                }];
    }
    else
    {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        
        if ([FlickrKit sharedFlickrKit].isAuthorized)
        {
            [[FlickrKit sharedFlickrKit] logout];
            [self userLoggedOut];
        }
        else
        {
            
            NSLog(@"WebView");
            
            WebViewController *authView = [[WebViewController alloc] init];
            
            
            //            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //
            //            SectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CSection"];
            //
            //            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentViewController:authView animated:YES completion:NULL];
            
            //[self.navigationController pushViewController:authView animated:YES];
        }
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
                       NSLog(@"ObserveValue");
                       // self.progress.progress = progress;
                       //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
                   });
}


- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^()
     {
         [[[UIAlertView alloc] initWithTitle:@"Oops" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
     }];
}

- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"User cancelled facebook image picking");
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray*)images
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (images.count == 0)
    {
        
    }
    else
    {
        
        self.selected = images;
        
        //[self getImages];
        
        fullImage = [[NSMutableArray alloc]init];
        thumbImage = [[NSMutableArray alloc]init];
        
        NSMutableString *ms = [[NSMutableString alloc]init];
        
        //lastHighestCount = HigestImageCount;
        
        sendImage = [[NSMutableArray alloc]init];
        
       /* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
        
        [_currentWindow addSubview:_BlurView];*/
        
        
        /*    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         //    hud.mode = MBProgressHUDModeDeterminate;
         //    hud.progress = progress;
         
         
         hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
         hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];*/
        
        
        NSURL *url;
        
        //    [self getName];
        
        // int count = HigestImageCount;
        
        int i = 0;
        
        for (OLFacebookImage *image in images)
        {
            i++;
            // HigestImageCount++;
            url = image.fullURL;
            
            NSLog(@"Facebook URL = %@",image.fullURL);
            
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            
            UIImage *img = [UIImage imageWithData:imageData];
            
            NSData *thumbnailData = [self generateThumnail:img thumbnailData:imageData];
            
            [fullImage addObject:imageData];
            [thumbImage addObject:thumbnailData];
            
            // [self saveData:imageData inc:(count+i)];
            
            //            NSString *imgID = [NSString stringWithFormat:@"%d,",HigestImageCount];
            //
            //            [ms appendString:imgID];
            //
        }
        
        // imageID = [ms substringToIndex:[ms length]-1];
        
        [self completeSendImage];
        
        
        
        
        //    [self getName];
        //
        //    [self updateImagesToServer];
        //
        
        /*    [self getName];
         self.collectView.hidden = false;
         self.pageView.hidden = true;
         [self.collectionView reloadData];*/
        
        NSLog(@"User did pick %lu images", (unsigned long) images.count);
    }
}

-(void)saveData:(NSData*)iData inc:(int)count
{
    
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    //    NSString  *withString =[NSString stringWithFormat:@"/%d",HigestImageCount];
    //
    //
    //    withString = [withString stringByAppendingString:@".png"];
    //
    //
    //    NSString *Path = [dataPath stringByAppendingFormat:@"%@",withString];
    //
    //    NSLog(@"CommonFilePath:%@",Path);
    //
    //    [iData writeToFile:Path atomically:YES];
    //
    //    NSString *SharedFinalplistPath = [dataPath stringByAppendingPathComponent:@"DataList.plist"];
    //
    //
    //    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    //    if (finalArray == nil)
    //    {
    //        finalArray = [[NSMutableArray alloc]init];
    //    }
    //
    //
    //    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    //    [dic setValue:@"Image" forKey:@"DataType"];
    //    [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"Id"];
    
    //    [finalArray addObject:dic];
    //    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    //    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    //
    //    NSString *tempString = [NSString stringWithFormat:@"%d",HigestImageCount];
    //
    //    tempString = [tempString stringByAppendingString:@".png"];
    //
    //
    //    [sendImage addObject:tempString];
    
    
    
    [self sendImage:iData nd:iData sd:[NSString stringWithFormat:@"%d",20]];
    
    
    /*    if( [self setImageParams:iData imageID:[NSString stringWithFormat:@"%d",HigestImageCount]thumbData:iData])
     {
     NSLog(@"Enter block");
     
     NSOperationQueue *queue = [NSOperationQueue mainQueue];
     
     [NSURLConnection sendAsynchronousRequest:request
     queue:queue
     completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
     {
     [hud hideAnimated:YES];
     
     [_BlurView removeFromSuperview];
     
     NSLog(@"Response = %@",urlResponse);
     }];
     
     NSLog(@"Image Sent");
     }
     else
     {
     [hud hideAnimated:YES];
     
     [_BlurView removeFromSuperview];
     
     NSLog(@"Image Failed...");
     }*/
    
}



- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFinishPickingImages:(NSArray*)images
{
    self.selectedImages = images;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // [self getName];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    NSMutableString *ms = [[NSMutableString alloc]init];
    
    //    lastHighestCount = HigestImageCount;
    
    sendImage = [[NSMutableArray alloc]init];
    
    //    int count = HigestImageCount;
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
    
    [_currentWindow addSubview:_BlurView];
    
    int i = 0;
    
    NSURL *url;
    
    for (OLInstagramImage *image in images)
    {
        i++;
        
        //HigestImageCount++;
        
        NSLog(@"User selected instagram image with full URL: %@", image.fullURL);
        
        url = image.fullURL;
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        UIImage *img = [UIImage imageWithData:imageData];
        
        NSData *thumbnailData = [self generateThumnail:img thumbnailData:imageData];
        
        [fullImage addObject:imageData];
        [thumbImage addObject:thumbnailData];
        
        //[self saveData:imageData inc:(count+i)];
        
        //        NSString *imgID = [NSString stringWithFormat:@"%d,",HigestImageCount];
        //
        //        [ms appendString:imgID];
    }
    
    // imageID = [ms substringToIndex:[ms length]-1];
    
    [self completeSendImage];
    
    
    //    NSString *ImageURL = [url absoluteString];
    //    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    /*    [self getName];
     self.collectView.hidden = false;
     self.pageView.hidden = true;
     [self.collectionView reloadData];*/
}

- (void)instagramImagePickerDidCancelPickingImages:(OLInstagramImagePickerController *)imagePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imageEditorDidCancel:(CLImageEditor*)editor
{
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    NSData *thumbnailData;
    [editor dismissViewControllerAnimated:YES completion:nil];
    
    // [self getName];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    
    //    NSMutableString *ms = [[NSMutableString alloc]init];
    //
    //    lastHighestCount = HigestImageCount;
    //
    //    HigestImageCount++;
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
    
    [_currentWindow addSubview:_BlurView];
    
    
    NSData *JPEGdata = UIImageJPEGRepresentation(image, 0.5);
    UIImage *img = [[UIImage alloc]initWithData:JPEGdata];
    NSData *data = UIImagePNGRepresentation(img);
    //UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 0.5);
    
    
    thumbnailData = [self generateThumnail:image thumbnailData:data];
    
    [fullImage addObject:data];
    [thumbImage addObject:thumbnailData];
    
    
    //    NSString *imgID = [NSString stringWithFormat:@"%d",HigestImageCount];
    //
    //    [ms appendString:imgID];
    
    //
    //    NSError *error;
    //    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //
    //    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    //    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    //
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    //        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    //
    //    NSString  *withString =[NSString stringWithFormat:@"/%d",HigestImageCount];
    //
    //
    //    withString = [withString stringByAppendingString:@".png"];
    //
    //
    //    NSString *Path = [dataPath stringByAppendingFormat:@"%@",withString];
    //
    //    NSLog(@"CommonFilePath:%@",Path);
    //
    //    [data writeToFile:Path atomically:YES];
    //
    //    NSString *SharedFinalplistPath = [dataPath stringByAppendingPathComponent:@"DataList.plist"];
    //
    //
    //    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    //    if (finalArray == nil)
    //    {
    //        finalArray = [[NSMutableArray alloc]init];
    //    }
    //
    //
    //    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    //    [dic setValue:@"Image" forKey:@"DataType"];
    //    [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"Id"];
    //
    //    [finalArray addObject:dic];
    //    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    //    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    //
    //NSString *tempString = [NSString stringWithFormat:@"%d",HigestImageCount];
    
    //    tempString = [tempString stringByAppendingString:@".png"];
    
    
    //  [sendImage addObject:tempString];
    
    //imageID = ms;
    
    //[hud hideAnimated:YES];
    [self completeSendImage];
    
    /*    thumbnailData = [self generateThumnail:image thumbnailData:data];
     
     [self sendImage:data nd:thumbnailData sd:[NSString stringWithFormat:@"%d",HigestImageCount]];*/
    
    /*    if( [self setImageParams:data imageID:[NSString stringWithFormat:@"%d",HigestImageCount]thumbData:thumbnailData])
     {
     NSLog(@"Enter block");
     
     NSOperationQueue *queue = [NSOperationQueue mainQueue];
     
     [NSURLConnection sendAsynchronousRequest:request
     queue:queue
     completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
     {
     NSLog(@"Response = %@",urlResponse);
     
     [hud hideAnimated:YES];
     
     [_BlurView removeFromSuperview];
     
     [self.collectionView reloadData];
     
     }];
     
     NSLog(@"Image Sent");
     }
     else
     {
     [hud hideAnimated:YES];
     
     [_BlurView removeFromSuperview];
     
     NSLog(@"Image Failed...");
     }*/
    
}


- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imgEditing" object:nil];
}

-(void)didFinishedGDriveImage:(NSURL *)imageURL second:(NSString*)thumbnailLinkImg
{
    [self FinishedImage:imageURL second:thumbnailLinkImg];
    
}

-(void)FinishedImage:(NSURL*)imageURL second:(NSString*)thumbnailLinkImg
{
    
    NSURL *url=[NSURL URLWithString:thumbnailLinkImg];
    UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    NSData *thumbnailData;
    
    // [self getName];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    
    //    NSMutableString *ms = [[NSMutableString alloc]init];
    //
    //    lastHighestCount = HigestImageCount;
    //
    //    HigestImageCount++;
    //
  /*  hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");*/
    [_currentWindow addSubview:_BlurView];
    [_currentWindow addSubview:animationView];
    
    [animationView playWithCompletion:^(BOOL animationFinished) {
        // ...
    }];
    
    
    
    NSData *JPEGdata = UIImageJPEGRepresentation(imag, 0.5);
    UIImage *img = [[UIImage alloc]initWithData:JPEGdata];
    NSData *data = UIImagePNGRepresentation(img);
    //UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 0.5);
    
    
    thumbnailData = [self generateThumnail:imag thumbnailData:data];
    
    [fullImage addObject:data];
    [thumbImage addObject:thumbnailData];
    
    
    //    NSString *imgID = [NSString stringWithFormat:@"%d",HigestImageCount];
    //
    //    [ms appendString:imgID];
    //
    //
    //    NSError *error;
    //    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //
    //    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    //    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    //
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    //        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    //
    //    NSString  *withString =[NSString stringWithFormat:@"/%d",HigestImageCount];
    //
    //
    //    withString = [withString stringByAppendingString:@".png"];
    //
    //
    //    NSString *Path = [dataPath stringByAppendingFormat:@"%@",withString];
    //
    //    NSLog(@"CommonFilePath:%@",Path);
    //
    //    [data writeToFile:Path atomically:YES];
    //
    //    NSString *SharedFinalplistPath = [dataPath stringByAppendingPathComponent:@"DataList.plist"];
    //
    //
    //    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    //    if (finalArray == nil)
    //    {
    //        finalArray = [[NSMutableArray alloc]init];
    //    }
    //
    //
    //    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    //    [dic setValue:@"Image" forKey:@"DataType"];
    //    [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"Id"];
    //
    //    [finalArray addObject:dic];
    //    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    //    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    //
    //    NSString *tempString = [NSString stringWithFormat:@"%d",HigestImageCount];
    //
    //    tempString = [tempString stringByAppendingString:@".png"];
    //
    //
    //    [sendImage addObject:tempString];
    //
    //    imageID = ms;
    
    
    [self completeSendImage];
}



#pragma mark - FGalleryViewControllerDelegate Methods

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num = (int)[onlyImagePath count];
    return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption = [localCaptions objectAtIndex:index];
    return caption;
}

//- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
//{
//    return [onlyImagePath objectAtIndex:index];
//}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return [onlyImagePath objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender
{
    
}

- (void)handleEditCaptionButtonTouch:(id)sender
{
    // here we could implement some code to change the caption for a stored image
}

-(void)setCameraButton
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        
        _OpenCameraSPUsrRzbleVw = [[SPUserResizableView alloc] initWithFrame:CGRectMake(10, self.collectView.frame.size.height-150, 100, 100)];
    
    else
        
        _OpenCameraSPUsrRzbleVw = [[SPUserResizableView alloc] initWithFrame:CGRectMake(10, self.collectView.frame.size.height+150, 100, 100)];
    
    _OpenCmraImgViw = [[UIImageView alloc]initWithFrame:_OpenCameraSPUsrRzbleVw.bounds];
    _OpenCmraImgViw.image = [UIImage imageNamed:@"camera_img_cap_128.png"];
    
    _OpenCmraImgViw.contentMode = UIViewContentModeCenter;
    
    _OpenCmraImgViw.contentMode = UIViewContentModeScaleAspectFit;
    
    //_OpenCmraImgViw.alpha=0.3;
    
    _OpenCameraSPUsrRzbleVw.contentView = _OpenCmraImgViw;
    _OpenCameraSPUsrRzbleVw.delegate = self;
    _OpenCameraSPUsrRzbleVw.contentView.layer.cornerRadius = 15;
    _OpenCameraSPUsrRzbleVw.contentView.backgroundColor = [UIColor whiteColor];
    _OpenCameraSPUsrRzbleVw.contentView.alpha = 0.5;
    _OpenCameraSPUsrRzbleVw.resizableStatus = NO;
    
    [_OpenCameraSPUsrRzbleVw hideEditingHandles];
    [_OpenCameraSPUsrRzbleVw.cancel removeFromSuperview];
    [_OpenCameraSPUsrRzbleVw removeBorder];
    
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
    [_collectionView reloadData];
    //SET MULTIPLE DELETE MODE NO
    [MultipleDeleteItemsAry removeAllObjects];
    isDeleteMode=NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
    TabBarViewController *tabContrl = self.tabBarController;
    tabContrl.TttleLable.text = @"My Image";
    tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"12-PLUS.png"];
    //SET MULTIPLE DELETE MODE NO
}
-(void)openCamera
{
    [self removeItemsFromDeleteMode];
    /*  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
     [self presentViewController:picker animated:YES completion:NULL]; */
    
    //    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    //    {
    //        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
    //        cmraDemo = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CameraDemo"];
    //        cmraDemo.delegate = self;
    //    }
    
    //    else
    //    {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LiveEffects" bundle:nil];
    cmraDemo = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CameraDemoIphone"];
    cmraDemo.delegate = self;
    // }
    
    [self presentViewController:cmraDemo animated:YES completion:NULL];
}

-(void)didCloseCamera
{
    NSLog(@"Closeddd");
    [cmraDemo dismissViewControllerAnimated:YES completion:nil];
    [_collectionView reloadData];
    
}

- (void)didFinishedCamera:(UIImage*)chosenImages
{
    NSData *thumbnailData;
    UIImage *chosenImage = chosenImages;
    
    [cmraDemo dismissViewControllerAnimated:YES completion:NULL];
    
    //[self getName];
    
    sendImage = [[NSMutableArray alloc]init];
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    //
    //    NSMutableString *ms = [[NSMutableString alloc]init];
    //
    //    lastHighestCount = HigestImageCount;
    //
    //    HigestImageCount++;
    
    /*    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     //    hud.mode = MBProgressHUDModeDeterminate;
     //    hud.progress = progress;
     
     hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
     hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
     
     [_currentWindow addSubview:_BlurView];*/
    
    /*hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
    
    [_currentWindow addSubview:_BlurView];*/
    [_currentWindow addSubview:_BlurView];
    [_currentWindow addSubview:animationView];
    
    [animationView playWithCompletion:^(BOOL animationFinished) {
        // ...
    }];
    
    NSData *JPEGdata = UIImageJPEGRepresentation(chosenImage, 0.5);
    UIImage *img = [[UIImage alloc]initWithData:JPEGdata];
    NSData *data = UIImagePNGRepresentation(chosenImage);    //UIImagePNGRepresentation(chosenImage);// UIImageJPEGRepresentation(chosenImage,0.5);
    
    thumbnailData = [self generateThumnail:chosenImage thumbnailData:data];
    
    [fullImage addObject:data];
    [thumbImage addObject:thumbnailData];
    //[hud hideAnimated:YES];
    //    NSString *imgID = [NSString stringWithFormat:@"%d",HigestImageCount];
    //
    //    [ms appendString:imgID];
    //
    //    NSError *error;
    //    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //
    //    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    //    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    //
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    //        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    //
    //    NSString  *withString =[NSString stringWithFormat:@"/%d",HigestImageCount];
    //
    //    withString = [withString stringByAppendingString:@".png"];
    //
    //    NSString *Path = [dataPath stringByAppendingFormat:@"%@",withString];
    //
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
    //
    //    [dic setValue:@"Image" forKey:@"DataType"];
    //    [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"Id"];
    //
    //    [finalArray addObject:dic];
    //    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    //    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    //
    //    NSString *tempString = [NSString stringWithFormat:@"%d",HigestImageCount];
    //
    //    tempString = [tempString stringByAppendingString:@".png"];
    //
    //    [sendImage addObject:tempString];
    
    /*    if( [self setImageParams:data imageID:[NSString stringWithFormat:@"%d",HigestImageCount] thumbData:thumbnailData])
     {
     NSLog(@"Enter block");
     
     NSOperationQueue *queue = [NSOperationQueue mainQueue];
     
     [NSURLConnection sendAsynchronousRequest:request
     queue:queue
     completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
     {
     [hud hideAnimated:YES];
     
     [_BlurView removeFromSuperview];
     
     NSLog(@"Response = %@",urlResponse);
     }];
     
     NSLog(@"Image Sent");
     }
     else
     {
     NSLog(@"Image Failed...");
     
     [_BlurView removeFromSuperview];
     
     }*/
    
    //    [self sendImage:data nd:thumbnailData sd:[NSString stringWithFormat:@"%d",HigestImageCount]];
    
    /*    [self getName];
     self.collectView.hidden = false;
     self.pageView.hidden = true;
     [self.collectionView reloadData];*/
    
    
    //  imageID = ms;
    [self completeSendImage];
}

- (IBAction)OneDrive:(id)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    
    else
    {
        isImagePick=YES;
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
                     vc.delegate=self;
                     vc.client=client;
                     vc.mime_Type=@"image";
                     
                     [self.navigationController pushViewController:vc animated:YES];
                     
                     //  [self presentViewController:add animated:YES completion:nil];
                     
                     /*  UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
                      
                      DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                      
                      [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
                      
                      vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                      
                      [self presentViewController:vc animated:YES completion:NULL];*/
                 });
             }
             else
             {
                 [self showErrorAlert:error];
             }
         }];
    }
}

- (IBAction)Box:(id)sender
{
//    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//
//    if (networkStatus == NotReachable)
//    {
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
//
//        CustomPopUp *popUp = [CustomPopUp new];
//        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
//        popUp.okay.backgroundColor = [UIColor lightGreen];
//        popUp.agreeBtn.hidden = YES;
//        popUp.cancelBtn.hidden = YES;
//        popUp.inputTextField.hidden = YES;
//        [popUp show];
//
//    }
//
//    else
//    {
//        isImagePick=YES;
//
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
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
//
//                    CustomPopUp *popUp = [CustomPopUp new];
//                    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Login failed, please try again" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
//                    popUp.accessibilityHint = @"BoxLoginFailed";
//                    popUp.agreeBtn.hidden = YES;
//                    popUp.cancelBtn.hidden = YES;
//                    popUp.okay.backgroundColor = [UIColor navyBlue];
//                    popUp.inputTextField.hidden = YES;
//                    [popUp show];
//
//                }
//            } else {
//
//                BOXSampleFolderViewController *folderListingController = [[BOXSampleFolderViewController alloc] initWithClient:client folderID:BOXAPIFolderIDRoot];
//                folderListingController.fileType = @"Image";
//                folderListingController.delegate= self;
//                [self.navigationController pushViewController:folderListingController animated:YES];
//            }
//        }];
//    }
}

- (IBAction)GoogleDrive:(id)sender
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Login failed, please try again" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    
    else
    {
        isImagePick=YES;
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
        
        GDriveViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"googleDrive"];
        
        vc.mimeTypes=@"image";
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

/*-(void)didFinishedBoxImage:(NSData *)imageData
{
    [hud hideAnimated:YES];
    [self finishedImageUploading:imageData];
}
*/
- (void)didFinishedODImage:(NSData*)imageData
{
    [self finishedImageUploading:imageData];
}

-(void)didFinishedFlickrImage:(NSData *)imageData
{
    [self finishedImageUploading:imageData];
}

-(void)didFinishedDropBoxImage:(NSData *)imageData
{
    [self finishedImageUploading:imageData];
}

-(void)
finishedImageUploading:(NSData*)imageData
{
    //[self getName];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    //    lastHighestCount = HigestImageCount;
    //
    //    HigestImageCount++;
    //
   /* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading", @"HUD loading title");
    
    [_currentWindow addSubview:_BlurView];*/
    [_currentWindow addSubview:_BlurView];
    [_currentWindow addSubview:animationView];
    
    [animationView playWithCompletion:^(BOOL animationFinished) {
        // ...
    }];
    
    UIImage *chosenImage = [UIImage imageWithData:imageData];
    
    NSData *thumbnailData = [self generateThumnail:chosenImage thumbnailData:imageData];
    
    thumbnailData = [self generateThumnail:chosenImage thumbnailData:imageData];
    
    [fullImage addObject:imageData];
    [thumbImage addObject:thumbnailData];
    
    [self completeSendImage];
    
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
    
    if([alertView.accessibilityHint isEqualToString:@"MultipleDelete"]){
        NSLog(@"Close:%@",MultipleDeleteItemsAry);
        [alertView hide];
        alertView = nil;
        [self deleteImage];
        
    }else if([alertView.accessibilityHint isEqualToString:@"SingleDeleteConfirmation"]){
        // NSString *img = [[finalArray objectAtIndex:sender.tag]objectForKey:@"Id"];
        NSDictionary *dic =   [finalArray objectAtIndex:alertView.accessibilityValue.integerValue];
        
        [MultipleDeleteItemsAry addObject:dic];
        
        //DELETE LOCAL ARRAY AND UPDATE COLLECTIOVIEW
        
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:deleteTag inSection:0] ;
        [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:deleteTag]];
        
        //DELET LOCAL ARRAY AND UPDATE COLLECTIOVIEW
        [alertView hide];
        alertView= nil;
        
        [self deleteImage];
        
    }
    [alertView hide];
    alertView= nil;
    
}
@end

