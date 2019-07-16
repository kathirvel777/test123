//
//  AlbumWizardController.m
//  Montage
//
//  Created by MacBookPro on 4/28/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "AlbumWizardController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MyPlayerViewController.h"
#import "UIImageView+WebCache.h"
#import "WizardCollectionCell.h"
#import "MyWizardPlayerViewController.h"
#import "DEMORootViewController.h"
#import "AlbumTabViewController.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

#define IS_PAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface AlbumWizardController ()<ClickDelegates>
{
    NSMutableArray *thumbImg,*randID,*videoPath,*duration,*videoName,*paymentStatus,*rndID,*video_ID,*embedSrc,*ctaStatus,*idValues,*randomId,*MultipleDeleteItemsAry,*MultipleDeleteIndexPathAry,*finalVideo;
    NSString *user_id;
    BOOL isDeleteMode;
    MBProgressHUD *hud;
    MPMoviePlayerController *moviePlayer;
    
}

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation AlbumWizardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setValue:@"BUSINESS_TEMPLATES" forKey:@"Section"];
    
    embedSrc = [[NSMutableArray alloc]init];
    thumbImg = [[NSMutableArray alloc]init];
    randID = [[NSMutableArray alloc]init];
    videoPath = [[NSMutableArray alloc]init];
    paymentStatus = [[NSMutableArray alloc]init];
    video_ID = [[NSMutableArray alloc]init];
    idValues=[[NSMutableArray alloc]init];
    randomId = [[NSMutableArray alloc]init];
    rndID = [[NSMutableArray alloc]init];
    ctaStatus=[[NSMutableArray alloc]init];
    MultipleDeleteItemsAry = [[NSMutableArray alloc]init];
    MultipleDeleteIndexPathAry = [[NSMutableArray alloc]init];
    finalVideo = [[NSMutableArray alloc]init];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    _collectionView.contentInset=UIEdgeInsetsMake(15, 15, 15, 15);
    
    self.collectionView.bounces = false;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteMultipleItems:) name:@"postWizardAlbumDelete" object:nil];
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.minimumPressDuration = 1.0;   [self.collectionView addGestureRecognizer:lpgr];
    self.collectionView.allowsMultipleSelection = YES;
    //[self UserPlanLimitsTracking];
}

- (void)deleteMultipleItems:(NSNotification *)notify{
    //    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure you want to delete the selected image?"preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction* yesButton = [UIAlertAction
    //                                actionWithTitle:@"Yes"
    //                                style:UIAlertActionStyleDefault
    //                                handler:^(UIAlertAction * action)
    //                                {
    //                                    NSLog(@"Close:%@",MultipleDeleteItemsAry);
    //
    //                                    [self deleteAlbum];
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
    //
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to delete the selected image?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
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
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            if(![[duration objectAtIndex:indexPath.row] isEqualToString:@""]){
                if(!isDeleteMode){
                    if(!(self.selectedItemIndexPath == nil)){
                        NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:self.selectedItemIndexPath];
                        self.selectedItemIndexPath=nil;
                        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
                    }
                    
                    WizardCollectionCell* cell =
                    [self.collectionView cellForItemAtIndexPath:indexPath];
                    cell.SelectedItem.hidden = NO;
                    cell.AboveTopView.hidden = NO;
                    //NSDictionary *selectedRecipe = [randID objectAtIndex:indexPath.row];
                    
                    //[cell setSelected:YES];
                    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                    [MultipleDeleteItemsAry addObject:[randID objectAtIndex:indexPath.row]];
                    [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:indexPath.row]];
                    isDeleteMode = YES;
                    
                    AlbumTabViewController *tabContrl = self.tabBarController;
                    NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected( %d )", MultipleDeleteItemsAry.count];
                    tabContrl.TttleLable.text = selectedItemString;
                    tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"deleteStroke.png"];
                    // tabContrl.addAndDeleteBtn.image
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DeleteMode"];
                }
            }
        }
        
        // do stuff with the cell
    }
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.selectedIndex = 1;
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DeleteMode"];
    AlbumTabViewController *tabContrl = self.tabBarController;
    tabContrl.vc = @"wizard";
    
    tabContrl.TttleLable.text = @"Album";
    tabContrl.addAndDeleteBtn.image = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    thumbImg = [[NSMutableArray alloc]init];
    randID = [[NSMutableArray alloc]init];
    videoPath = [[NSMutableArray alloc]init];
    duration = [[NSMutableArray alloc]init];
    videoName = [[NSMutableArray alloc]init];
    paymentStatus = [[NSMutableArray alloc]init];
    
    embedSrc = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    [self loadAlbum];
    
    //    [self updateImagesToServer];
    
    //    [self loadPlay];
    
}


-(void)viewDidLayoutSubviews
{
    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
}

-(void)deleteAlbum
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Deleting...", @"HUD loading title");
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * selectedItemString;
    for(NSString *deleteID in MultipleDeleteItemsAry){
        // NSString *deleteID =  [dic objectForKey:@"Id"];
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
    AlbumTabViewController *tabContrl = self.tabBarController;
    
    tabContrl.TttleLable.text = @"Upload";
    tabContrl.addAndDeleteBtn.image = nil;
    // tabContrl.addAndDeleteBtn.image
    NSDictionary *params = @{@"user_id":user_id,@"del_id":selectedItemString,@"lang":@"iOS"};
    NSString *URLString;
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
        
        URLString=@"https://www.hypdra.com/api/api.php?rquest=delete_my_business_template_video";
        
    }else{
        
        URLString=@"https://www.hypdra.com/api/api.php?rquest=wizard_delete_my_album_video";
        
    }
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Image Delete Response = %@",responseObject);
         
         NSMutableDictionary *response=responseObject;
         
        NSString *cnf = [responseObject objectForKey:@"status"];
         
         NSLog(@"Delete Status %@",cnf);
         
         if ([cnf isEqualToString:@"Success"])
         {
             
             [hud hideAnimated:YES];
             
             self.selectedItemIndexPath = nil;
             
             
             //             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
             //
             //             NSString *minAvil=[statusArray objectForKey:@"Duration Status"];
             //
             //             NSString *spcAvil = [statusArray objectForKey:@"Space Status"];
             //
             //
             //             [defaults setValue:minAvil forKey:@"minAvil"];
             //
             //             [defaults setValue:spcAvil forKey:@"spcAvil"];
             //             [defaults setObject:[statusArray objectForKey:@"Remaining Space"] forKey:@"Remaining Space"];
             //
             //             [defaults synchronize];
             
             NSArray *arrayOfIndexPaths = [self.collectionView indexPathsForSelectedItems];
             for(int i=0;i < [MultipleDeleteIndexPathAry count];i){
                 
                 NSNumber *maxNumber = [MultipleDeleteIndexPathAry valueForKeyPath:@"@max.self"];
                 [MultipleDeleteIndexPathAry removeObject:maxNumber];
                 NSIndexPath *removingIndexPath = [NSIndexPath indexPathForRow:maxNumber.intValue inSection:0];
                 
                 [thumbImg removeObjectAtIndex:removingIndexPath.row];
                 [randID removeObjectAtIndex:removingIndexPath.row];
                 [videoPath removeObjectAtIndex:removingIndexPath.row];
                 [duration removeObjectAtIndex:removingIndexPath.row];
                 [videoName removeObjectAtIndex:removingIndexPath.row];
                 [randomId removeObjectAtIndex:removingIndexPath.row];
                 [embedSrc removeObjectAtIndex:removingIndexPath.row];
                 [paymentStatus removeObjectAtIndex:removingIndexPath.row];
                 [idValues removeObjectAtIndex:removingIndexPath.row];
                 [ctaStatus removeObjectAtIndex:removingIndexPath.row];
                 
                 NSArray *deleteItems = @[removingIndexPath];
                 [self.collectionView deleteItemsAtIndexPaths:deleteItems];
             }
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
             
             //             CustomPopUp *popUp = [CustomPopUp new];
             //             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Image removed" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             //             popUp.okay.backgroundColor = [UIColor lightGreen];
             //             popUp.agreeBtn.hidden = YES;
             //             popUp.cancelBtn.hidden = YES;
             //             popUp.inputTextField.hidden = YES;
             //             [popUp show];
             
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
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Try Again" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
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
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to server" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor lightGreen];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
     }];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [thumbImg count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    WizardCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.borderWidth = 0.2f;
    
    //    cell.alpha = 1.0;
    
    //
    //    if (cell.ImgView.image != nil)
    //    {
    //        NSLog(@"Have Image...");
    //    }
    //    else
    //    {
    
    
    cell.duration.text = [duration objectAtIndex:indexPath.row];
    //
    cell.fileName.text = [videoName objectAtIndex:indexPath.row];
    
    
    NSURL *imageURL = [NSURL URLWithString:[thumbImg objectAtIndex:indexPath.row]];
    
    [cell.ImgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    
    //SHADOW WITH CORNER RADIUS
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.layer.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(12.0, 12.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cell.layer.bounds;
    maskLayer.path  = maskPath.CGPath;
    cell.layer.mask = maskLayer;
    
    
    //    cell.ImgView.layer.cornerRadius = 12;
    //    cell.ImgView.layer.masksToBounds = YES;
    
    
    cell.layer.shadowRadius = 2;
    // cell.layer.cornerRadius = 12;
    cell.layer.masksToBounds = NO;
    [[cell layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    
    [[cell layer] setShadowOffset:CGSizeMake(0,0)];
    [[cell layer] setShadowOpacity:1];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:12];
    [[cell layer] setShadowPath:[path CGPath]];
    //SHADOW WITH CORNER RADIUS
    
  
    
    
    cell.deleteVideo.tag=indexPath.row;
    [cell.deleteVideo addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.edit.tag = indexPath.row;
    [cell.edit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.playVideo.tag = indexPath.row;
    [cell.playVideo addTarget:self action:@selector(playVideos:) forControlEvents:UIControlEventTouchUpInside];
    
    //    if ((thumbImg.count -1) == indexPath.row)
    //    {
    //        [hud hideAnimated:YES];
    //    }
    
    
    /*if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        cell.deleteVideo.hidden = false;
    }
    else
    {
        cell.deleteVideo.hidden = true;
    }*/
        cell.deleteVideo.hidden = true;
    
    [cell.LoadingIndicator stopAnimating];
    if([[duration objectAtIndex:indexPath.row] isEqualToString:@""]){
        [cell.AboveTopView setHidden:FALSE];
        [cell.LoadingIndicator startAnimating];
    }
    
    return cell;
}


-(void)deleteVideo:(UIButton*)sender
{
    
    //    UIAlertController * alert=[UIAlertController
    //
    //                               alertControllerWithTitle:@"Confirm" message:@"Do you want to edit ?"preferredStyle: UIAlertControllerStyleAlert];
    //
    //    UIAlertAction* yesButton = [UIAlertAction
    //                                actionWithTitle:@"Yes"
    //                                style:UIAlertActionStyleDefault
    //                                handler:^(UIAlertAction * action)
    //                                {
    //                                    NSString *EDit_Id = [rndID objectAtIndex:sender.tag];
    //
    //                                    NSLog(@"Del Id = %@",EDit_Id);
    //                                    NSLog(@"USer_ID = %@",user_id);
    //
    //                                    @try
    //                                    {
    //
    //                                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    //                                        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=wizard_edit_dictionary_dtls";
    //
    //                                        NSDictionary *params = @{@"User_ID":user_id,@"Rand_ID":EDit_Id,@"lang":@"iOS"};
    //
    //                                        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
    //                                         {
    //
    //                                             NSLog(@"Edit Response = %@",responseObject);
    //
    //                                             NSMutableDictionary *Dic = responseObject;
    //                                             NSArray *finalArray = [Dic objectForKey:@"Edit_wizard_final_album_img_dtls"];
    //                                             //
    //                                             NSLog(@"finalArray = %@",finalArray);
    //
    //                                             //
    //                                             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //
    //                                             NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:finalArray];
    //
    //                                             [defaults setObject:dataSave forKey:@"ChoosenImagesandVideos"];
    //
    //                                             [defaults setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
    //
    //
    //                                             [defaults synchronize];
    //
    //
    //                                             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    //
    //                                             DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //                                             [vc awakeFromNib:@"contentController_6" arg:@"menuController"];
    //
    //                                             vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //
    //                                             [self presentViewController:vc animated:YES completion:NULL];
    //
    //
    //
    //                                         }
    //                                              failure:^(NSURLSessionTask *operation, NSError *error)
    //                                         {
    //                                             NSLog(@"Error9: %@", error);
    //                                         }];
    //
    //                                    }
    //                                    @catch (NSException *exception)
    //                                    {
    //                                        NSLog(@"Exception = %@",exception);
    //                                    }
    //                                    @finally
    //                                    {
    //                                        NSLog(@"Finally Exception");
    //                                    }
    //                                }];
    //    UIAlertAction* noButton = [UIAlertAction
    //                               actionWithTitle:@"No"
    //                               style:UIAlertActionStyleDefault
    //                               handler:^(UIAlertAction * action)
    //                               {
    //
    //                               }];
    //
    //    [alert addAction:yesButton];
    //    [alert addAction:noButton];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to edit ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.hidden = YES;
    popUp.accessibilityHint =@"ConfirmToEdit";
    popUp.accessibilityValue =[NSString stringWithFormat:@"%d",sender.tag];
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.inputTextField.hidden = YES;
    [popUp show];
}
/*{
 
 UIAlertController * alert=[UIAlertController
 
 alertControllerWithTitle:@"Confirm" message:@"Are you sure to delete ?"preferredStyle: UIAlertControllerStyleAlert];
 
 UIAlertAction* yesButton = [UIAlertAction
 actionWithTitle:@"Yes"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action)
 {
 NSString *delId = [randID objectAtIndex:sender.tag];
 
 NSLog(@"Del Id = %@",delId);
 
 @try
 {
 
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 manager.responseSerializer = [AFJSONResponseSerializer serializer];
 manager.requestSerializer = [AFJSONRequestSerializer serializer];
 
 manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
 
 [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
 [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
 [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"('Content-type: application/json');"];
 manager.securityPolicy.allowInvalidCertificates = YES;
 
 NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=wizard_delete_my_album_video";
 
 NSDictionary *params = @{@"user_id":user_id,@"del_id":delId,@"lang":@"iOS"};
 
 [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
 {
 NSLog(@"Response = %@",responseObject);
 
 NSString *albumCount = [responseObject objectForKey:@"advance_album_count"];
 
 int numValue = [albumCount intValue];
 
 NSLog(@"Get Album Count = %d",numValue);
 
 [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
 [[NSUserDefaults standardUserDefaults]synchronize];
 
 [self loadAlbum];
 }
 failure:^(NSURLSessionTask *operation, NSError *error)
 {
 NSLog(@"Error9: %@", error);
 }];
 
 }
 @catch (NSException *exception)
 {
 NSLog(@"Exception = %@",exception);
 }
 @finally
 {
 NSLog(@"Finally Exception");
 }
 }];
 UIAlertAction* noButton = [UIAlertAction
 actionWithTitle:@"No"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action)
 {
 
 }];
 
 [alert addAction:yesButton];
 [alert addAction:noButton];
 
 [self presentViewController:alert animated:YES completion:nil];
 }
 */

-(void)playVideos:(UIButton*)sender
{
    [hud hideAnimated:NO];
    [[NSUserDefaults standardUserDefaults]setValue:randID[sender.tag] forKey:@"randomVideoID"];
    
    [[NSUserDefaults standardUserDefaults]setValue:idValues[sender.tag] forKey:@"idVal"];
    
    [[NSUserDefaults standardUserDefaults]setValue:videoName[sender.tag] forKey:@"video_title"];
    
    
    NSString *rID = [videoPath objectAtIndex:sender.tag];
    
    NSString *pID = [paymentStatus objectAtIndex:sender.tag];
    
    NSString *rKID = [rndID objectAtIndex:sender.tag];
    NSString *vID = [video_ID objectAtIndex:sender.tag];
    
    NSString *rand = [randID objectAtIndex:sender.tag];
    
    [[NSUserDefaults standardUserDefaults]setValue:rID forKey:@"randomID"];
    
    [[NSUserDefaults standardUserDefaults]setValue:pID forKey:@"playerID"];
    [[NSUserDefaults standardUserDefaults] setValue:@"BUSINESS_TEMPLATES" forKey:@"Section"];
    [[NSUserDefaults standardUserDefaults]setValue:[finalVideo objectAtIndex:sender.tag] forKey:@"Source_Video"];
    [[NSUserDefaults standardUserDefaults]setValue:[ctaStatus objectAtIndex:sender.tag] forKey:@"callToactstatus"];
    
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
        MyWizardPlayerViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MyWizardPlayer"];
        
        vc.playerURL = rID;
        vc.paymentResult = pID;
        vc.randID = [randomId objectAtIndex:sender.tag];
        vc.video_ID = [randID objectAtIndex:sender.tag];        vc.video_Title = [videoName objectAtIndex:sender.tag];
        vc.deleteID = rand;
        vc.embed_Link = [embedSrc objectAtIndex:sender.tag];
        vc.ctaStatus = [ctaStatus objectAtIndex:sender.tag];
        [hud hideAnimated:YES];

        [self.navigationController pushViewController:vc animated:YES];
        
        NSLog(@"Play Video = %@",rID);
        
   // }
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:rID forKey:@"VideoUrl"];
    [def setObject:[randID objectAtIndex:sender.tag] forKey:@"VideoId"];
    [def setObject:[rndID objectAtIndex:sender.tag] forKey:@"RandId"];
    [def setObject:[duration objectAtIndex:sender.tag] forKey:@"durationvalue"];
    
    [def synchronize];
    
    /* NSURL *url=[[NSURL alloc] initWithString:rID];
     AVPlayer *player = [AVPlayer playerWithURL:url];
     AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
     [self presentViewController:controller animated:YES completion:nil];
     controller.player = player;
     [player play];*/
}
/*{
 NSString *rID = [videoPath objectAtIndex:sender.tag];
 
 NSLog(@"Video Path = %@",rID);
 
 NSURL *url=[[NSURL alloc] initWithString:rID];
 moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDonePressed:) name:MPMoviePlayerDidExitFullscreenNotification object:moviePlayer];
 
 moviePlayer.controlStyle=MPMovieControlStyleDefault;
 //moviePlayer.shouldAutoplay=NO;
 [moviePlayer play];
 [self.view addSubview:moviePlayer.view];
 [moviePlayer setFullscreen:YES animated:YES];
 
 //   [self requestPlayVideo:rID];
 }*/

-(void)loadAlbum
{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");
        
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
        //    dispatch_group_enter(group);
        //    dispatch_group_t sub_group=dispatch_group_create();
        //
        @try
        {
            
            //        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            //        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
           // NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=view_wizard_final_album";
            NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=view_my_business_videos";
            
            //        NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
            
            //        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
            //
            //        [task resume];
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //    hud.mode = MBProgressHUDModeDeterminate;
            //    hud.progress = progress;
            
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
            
            //hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
            
            NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
            
            [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 
                 NSLog(@"10SViewLink = %@",responseObject);

                 thumbImg = [[NSMutableArray alloc]init];
                 randID = [[NSMutableArray alloc]init];
                 videoPath = [[NSMutableArray alloc]init];
                 embedSrc = [[NSMutableArray alloc]init];
                 
                 NSMutableDictionary *response=responseObject;
                 NSArray *imageArray = [response objectForKey:@"View_MyAlbum_image"];
                 
                 NSArray *statusArray = [response objectForKey:@"Response_array"];
                 NSLog(@"Image Response %@",response);
                 NSDictionary *stsDict = [statusArray objectAtIndex:0];
                 NSString *status = [stsDict objectForKey:@"msg"];
                 
                 if ([status isEqualToString:@"Found"])
                 {
                     for(NSDictionary *imageDic in imageArray)
                     {
                         [[NSUserDefaults standardUserDefaults]setValue:@"BUSINESS_TEMPLATES" forKey:@"Section"];
                         if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
                             NSString *rand_id = [imageDic objectForKey:@"id"];
                             
                             NSString *thumb_img_path =@"https://www.hypdra.com/";
                             thumb_img_path = [thumb_img_path stringByAppendingString:(NSString *)[imageDic objectForKey:@"image_path"]]
                             ;
                             
                             NSString *finalVideoPath =@"https://www.hypdra.com/";
                             
                            NSString *vID = [imageDic objectForKey:@"watermark_video_path"];
                             finalVideoPath = [finalVideoPath stringByAppendingString:[imageDic objectForKey:@"final_video_path"]];
                             NSString *dur = @"00:00:10";
                             NSString *vName = [imageDic objectForKey:@"album_name"];
                             NSString *payment = [imageDic objectForKey:@"payment_status"];
                              NSString *rkID = [imageDic objectForKey:@"video_key"];
                             NSString *eLink = [imageDic objectForKey:@"embed_src"];
                              NSString *RandomId = [imageDic objectForKey:@"video_key"];
                             
                             NSString *iD=[imageDic objectForKey:@"id"];
                             
                             NSString *ctaStatusVal=[imageDic objectForKey:@"call_to_action_status"];
                             [thumbImg addObject:thumb_img_path];
                             [randID addObject:rand_id];
                             [videoPath addObject:vID];
                             [duration addObject:dur];
                             [videoName addObject:vName];
                             [paymentStatus addObject:payment];
                             [randomId addObject:RandomId];
                             [rndID addObject:rand_id];
                             [video_ID addObject:rand_id];
                             [embedSrc addObject:eLink];
                             [idValues addObject:iD];
                             [ctaStatus addObject:ctaStatusVal];
                             [finalVideo addObject:finalVideoPath];
                         }else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"WIZARD"]){
                             NSString *rand_id = [imageDic objectForKey:@"id"];
                            NSString *thumb_img_path = [imageDic objectForKey:@"thumb"];
                             
                            NSString *vID = [imageDic objectForKey:@"resize_video"];
                            
                             NSString *dur = [imageDic objectForKey:@"duration"];
                             NSString *vName = [imageDic objectForKey:@"album_name"];
                            NSString *payment = [imageDic objectForKey:@"payment_status"];
                            NSString *rkID = [imageDic objectForKey:@"rand_id"];
                            NSString *eLink = [imageDic objectForKey:@"embed_src"];
                            NSString *RandomId = [imageDic objectForKey:@"rand_id"];
                            NSString *iD=[imageDic objectForKey:@"id"];
                             NSString *finalVideoPath = [imageDic objectForKey:@"final_video_path"];
                            NSString *ctaStatusVal=[imageDic objectForKey:@"call_to_action_status"];
                             
                             [thumbImg addObject:thumb_img_path];
                             [randID addObject:rand_id];
                             [videoPath addObject:vID];
                             [duration addObject:dur];
                             [videoName addObject:vName];
                             [paymentStatus addObject:payment];
                             [randomId addObject:RandomId];
                             [rndID addObject:rand_id];
                             [video_ID addObject:rand_id];
                             [embedSrc addObject:eLink];
                             [idValues addObject:iD];
                             [ctaStatus addObject:ctaStatusVal];
                             [finalVideo addObject:finalVideoPath];
                             
                             NSLog(@"Video Path = %@",videoPath);
                         }
                         
                         
                         
                     }
                     
                 }
                 else
                 {
                     
                     /*               [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"AlbumCount"];
                      [[NSUserDefaults standardUserDefaults]synchronize];*/
                     
                     NSLog(@"Album Videos Not Found..");
                 }
                 
                 [self.collectionView reloadData];
                 
                 [hud hideAnimated:YES];
             }
                  failure:^(NSURLSessionTask *operation, NSError *error)
             {
                 NSLog(@"Error9: %@", error);
                 [hud hideAnimated:YES];
                 
                 CustomPopUp *popUp = [CustomPopUp new];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could not connect to the server" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                 popUp.okay.backgroundColor = [UIColor navyBlue];
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
                 
             }];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception = %@",exception);
            //        [hud hideAnimated:YES];
        }
        @finally
        {
            NSLog(@"Finally Exception");
            //        [hud hideAnimated:YES];
        }
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
    }}

-(void)edit:(UIButton*)sender
{
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:@"Confirm" message:@"Do you want to edit ?"preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    NSString *EDit_Id = [rndID objectAtIndex:sender.tag];
                                    
                                    NSLog(@"Del Id = %@",EDit_Id);
                                    NSLog(@"USer_ID = %@",user_id);
                                    
                                    @try
                                    {
                                        
                                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                        
                                        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=wizard_edit_dictionary_dtls";
                                        
                                        NSDictionary *params = @{@"User_ID":user_id,@"Rand_ID":EDit_Id,@"lang":@"iOS"};
                                        
                                        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
                                         {
                                             //NSLog(@"Edit Response = %@",responseObject);
                                             
                                             NSMutableDictionary *Dic = [responseObject objectAtIndex:0];
                                             NSArray *finalArray = [Dic objectForKey:@"FinalTemplates"];
                                             //
                                             NSLog(@"Edit Response = %@",Dic);
                                             //
                                             //                                             NSString *arraytag=[NSString stringWithFormat:@"ChoosenImagesandVideos"];
                                             //
                                             //                                             NSMutableArray *imagesandvideos = [[NSMutableArray alloc]init];
                                             //
                                             //                                             NSMutableArray *mnArray = [[NSMutableArray alloc]init];
                                             //
                                             //                                             for (NSDictionary *dict in aryDic)
                                             //                                             {
                                             //
                                             //                                                 NSString *im = [dict objectForKey:@"Image_Path"];
                                             //                                                 NSString *imType = [dict objectForKey:@"image_type"];
                                             //
                                             //                                                 NSDictionary *dct = @{@"Id": im , @"DataType": imType};
                                             //
                                             //                                                 [imagesandvideos addObject:dct];
                                             //
                                             //                                                 NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]init];
                                             //
                                             //                                                 [finalDic setValue:im forKey:@"image_path"];
                                             //
                                             //                                                 [finalDic setValue:imType forKey:@"image_type"];
                                             //
                                             //                                                 [finalDic setValue:[dct objectForKey:@
                                             //                                                                     "Effect"] forKey:@"effect"];
                                             //
                                             //                                                 [finalDic setValue:[dict objectForKey:@"Transition"] forKey:@"transition"];
                                             //
                                             //                                                 [finalDic setValue:[dct objectForKey:@"music_type"] forKey:@"music_type"];
                                             //
                                             //                                                 [finalDic setValue:[dct objectForKey:@"Music"] forKey:@"music"];
                                             //                                                 [finalDic setValue:[dct objectForKey:@"image_pos"] forKey:@"image_pos"];
                                             //
                                             //                                                 [mnArray addObject:finalDic];
                                             //
                                             //                                             }
                                             //
                                             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                             
                                             NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:finalArray];
                                             
                                             [defaults setObject:dataSave forKey:@"ChoosenImagesandVideos"];
                                             
                                             [defaults setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
                                             
                                             
                                             [defaults synchronize];
                                             
                                             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
                                             
                                             DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                                             
                                             [vc awakeFromNib:@"contentController_6" arg:@"menuController"];
                                             
                                             vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                             
                                             [self presentViewController:vc animated:YES completion:NULL];
                                             
                                             
                                             //                                             NSString *albumCount = [responseObject objectForKey:@"advance_album_count"];
                                             //
                                             //                                             int numValue = [albumCount intValue];
                                             //
                                             //                                             NSLog(@"Get Album Count = %d",numValue);
                                             //
                                             //                                             [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
                                             //                                             [[NSUserDefaults standardUserDefaults]synchronize];
                                             //
                                             //                                             [self loadAlbum];
                                         }
                                              failure:^(NSURLSessionTask *operation, NSError *error)
                                         {
                                             NSLog(@"Error9: %@", error);
                                         }];
                                        
                                    }
                                    @catch (NSException *exception)
                                    {
                                        NSLog(@"Exception = %@",exception);
                                    }
                                    @finally
                                    {
                                        NSLog(@"Finally Exception");
                                    }
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(![[duration objectAtIndex:indexPath.row] isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"SelectedIndex"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //[igcMenu showCircularMenu];
        
        if(isDeleteMode){
            WizardCollectionCell *cell=(WizardCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
            cell.AboveTopView.hidden = NO;
            cell.SelectedItem.hidden= NO;
            NSLog(@"Did Select");
            //NSDictionary *selectedRecipe = [finalArray objectAtIndex:indexPath.row];
            [MultipleDeleteItemsAry addObject:[randID objectAtIndex:indexPath.row]];
            int index = indexPath.row;
            [MultipleDeleteIndexPathAry addObject:[NSNumber numberWithInt:indexPath.row]];
            AlbumTabViewController *tabContrl = self.tabBarController;
            NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected ( %lu )", (unsigned long)MultipleDeleteItemsAry.count];
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
            //    [self EditVideo];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did Deselect");
    if(![[duration objectAtIndex:indexPath.row] isEqualToString:@""]){
        //NSDictionary *deSelectedRecipe = [finalArray objectAtIndex:indexPath.row];
        [MultipleDeleteItemsAry removeObject:[randID objectAtIndex:indexPath.row]];
        
        [MultipleDeleteIndexPathAry removeObject:[NSNumber numberWithInt:indexPath.row]];
        
        
        WizardCollectionCell *cell = (WizardCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.AboveTopView.hidden = YES;
        cell.SelectedItem.hidden = YES;
        
        AlbumTabViewController *tabContrl = self.tabBarController;
        NSMutableString* selectedItemString = [NSMutableString stringWithFormat:@"Selected( %d )", MultipleDeleteItemsAry.count];
        tabContrl.TttleLable.text = selectedItemString;
        if(MultipleDeleteItemsAry.count == 0){
            isDeleteMode = NO;
            
            tabContrl.TttleLable.text = @"Album";
            tabContrl.addAndDeleteBtn.image = nil;
        }
    }
}
-(void) okClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
}
- (void) VideoEdit: (NSInteger)VideoId{
    NSString *EDit_Id = [rndID objectAtIndex:VideoId];
    
    NSLog(@"Del Id = %@",EDit_Id);
    NSLog(@"USer_ID = %@",user_id);
    
    @try
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=wizard_edit_dictionary_dtls";
        
        NSDictionary *params = @{@"User_ID":user_id,@"Rand_ID":EDit_Id,@"lang":@"iOS"};
        
        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             
             NSLog(@"Edit Response = %@",responseObject);
             
             NSMutableDictionary *Dic = responseObject;
             NSArray *finalArray = [Dic objectForKey:@"Edit_wizard_final_album_img_dtls"];
             //
             NSLog(@"finalArray = %@",finalArray);
             
             //
             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
             
             NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:finalArray];
             
             [defaults setObject:dataSave forKey:@"ChoosenImagesandVideos"];
             
             [defaults setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
             
             
             [defaults synchronize];
             
             
             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
             
             DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
             
             [vc awakeFromNib:@"contentController_6" arg:@"menuController"];
             
             vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
             
             
             [self presentViewController:vc animated:YES completion:NULL];
             
             
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
         }];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Finally Exception");
    }
}
-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}
- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToMultipleDelete"]){
        [self deleteAlbum];
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToEdit"]){
        
        [self VideoEdit:alertView.accessibilityValue.integerValue];
        
    }
    [alertView hide];
    alertView = nil;
}

@end

