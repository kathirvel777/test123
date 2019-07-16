//
//  MainMenuViewController.m
//  Montage
//
//  Created by MacBookPro on 11/13/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AFNetworking.h"
#import "CollectionViewCellType.h"
#import "UIImageView+WebCache.h"
#import "OverlayEffectViewController.h"
#import "MBProgressHUD.h"
#import "SwipeBack.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface MainMenuViewController ()<ClickDelegates>
{
    NSMutableArray *thumbImages,*a1,*imageText,*imagePath;
    NSMutableArray *thumbImages1,*imageText1,*imagePath1;
    
    NSString *menuCategory,*imageStatus,*imageId,*myref,*user_id;
    
    MBProgressHUD *hud;
    
}
@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.swipeBackEnabled=NO;
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    menuCategory = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"menuType"];
    
    self.navTitle.text=menuCategory;
    self.navTitle.textColor=[UIColor whiteColor];
    [self.navTitle setFont:[UIFont fontWithName:@"FuturaT-Book" size:20.0]];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"blurimage"];
    
    UIImage* image = [UIImage imageWithData:imageData];
    
    //self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:image];
    
    // self.backgroundImage.image = image;
    //[[UIImageView alloc] initWithImage:image];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sideMenu setTarget: self.revealViewController];
        
        [self.sideMenu setAction: @selector( revealToggle: )];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    thumbImages=[[NSMutableArray alloc]init];
    imageText=[[NSMutableArray alloc]init];
    imagePath=[[NSMutableArray alloc]init];
    
    imageText1=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageText2"]];
    
    imagePath1=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagePath2"]];
    
    thumbImages1=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"thumbImage2"]];
    
    [self specificTypeWebResponse];
    
}

-(void)specificTypeWebResponse
{
    @try
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=view_all_video_overlay_images";
        
        NSDictionary *parameters =@{@"User_ID":user_id,@"lang":@"iOS",@"category":menuCategory};
        
        [manager POST:URLString parameters:parameters success:^(NSURLSessionTask *operation, id responseObject)
         {
             //NSLog(@"The response is %@",responseObject);
             
             a1=[responseObject objectForKey:@"view_all_video_overlay_images"];
             
             for(int i=0;i<a1.count;i++)
             {
                 NSDictionary *d2=[a1 objectAtIndex:i];
                 NSString *thumbimg=[d2 objectForKey:@"thumb_image"];
                 NSString *imgtxt=[d2 objectForKey:@"image_text"];
                 NSString *imgPath=[d2 objectForKey:@"image_path"];
                 
                 [thumbImages addObject:thumbimg];
                 [imageText addObject:imgtxt];
                 [imagePath addObject:imgPath];
             }
             
             [self.collectionView reloadData];
             [hud hideAnimated:YES];
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             //         UIAlertController * alert = [UIAlertController
             //                                      alertControllerWithTitle:@"Error"
             //                                      message:@"Couldn't connect to server!"
             //                                      preferredStyle:UIAlertControllerStyleAlert];
             //
             //         //Add Buttons
             //
             //         UIAlertAction* yesButton = [UIAlertAction
             //                                     actionWithTitle:@"OK"
             //                                     style:UIAlertActionStyleDefault
             //                                     handler:^(UIAlertAction * action)
             //                                     {
             //
             //                                         [alert dismissViewControllerAnimated:YES completion:nil];
             //                                         // [hud hideAnimated:YES];
             //                                     }];
             //
             //
             //         [alert addAction:yesButton];
             //
             //         [self presentViewController:alert animated:YES completion:nil];
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
             [hud hideAnimated:YES];
             
         }];
    }
    @catch(NSException *exception)
    {
        
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return thumbImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CollectionViewCellType";
    
    CollectionViewCellType *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSURL *imageURL = [NSURL URLWithString:[thumbImages objectAtIndex:indexPath.row]];
    
    [cell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"128-video-holder"]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cell.imgView.layer.cornerRadius=20.0f;
        cell.bgView.layer.cornerRadius=10.0f;
    }
    
    else
    {
        cell.imgView.layer.cornerRadius=20.0f;
        cell.bgView.layer.cornerRadius=10.0f;
        
    }
    
    NSDictionary *d2=[a1 objectAtIndex:indexPath.row];
    imageStatus =[d2 objectForKey:@"image_status"];
    
    cell.nameLabel.text=[imageText objectAtIndex:indexPath.row];
    
    if([imageStatus isEqualToString:@"Not_Selected"])
    {
        cell.downloadImgView.image=[UIImage imageNamed:@"75-download"];
    }
    
    else
    {
        cell.downloadImgView.image=[UIImage imageNamed:@"75-download-black"];
    }
    
    cell.nameLabel.text=[imageText objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        picDimension = self.view.frame.size.width / 5.08f;
        
    }
    else
    {
        picDimension = self.view.frame.size.width / 3.3f;
    }
    
    return CGSizeMake(picDimension, picDimension);
}

- (IBAction)closeAction:(id)sender
{
[[NSNotificationCenter defaultCenter]postNotificationName:@"pagePosition" object:self];

UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
//DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//[vc awakeFromNib:@"content_control" arg:@"menuController"];
//
//vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//[self.revealViewController pushFrontViewController:vc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *d2=[a1 objectAtIndex:indexPath.row];
        imageId=[d2 objectForKey:@"id"];
        imageStatus =[d2 objectForKey:@"image_status"];
        
        NSDictionary *parameters =@{@"User_ID":user_id,@"lang":@"iOS",@"OverlayImageId":imageId};
        
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=save_user_selected_overlay_images";
        
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
                  //NSLog(@"The res is %@",responseObject);
                  
                  if([imageStatus isEqualToString:@"Not_Selected"])
                  {
                      [[NSNotificationCenter defaultCenter]postNotificationName:@"pagePosition" object:self];
                      
                      [thumbImages1 addObject:[thumbImages objectAtIndex:indexPath.row]];
                      [imagePath1 addObject:[imagePath objectAtIndex:indexPath.row]];
                      [imageText1 addObject:[imageText objectAtIndex:indexPath.row]];
                      
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:imageText1]  forKey:@"imageText2"];
                      
                      [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:imagePath1]  forKey:@"imagePath2"];
                      
                      [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:thumbImages1]  forKey:@"thumbImage2"];
                      
                      [[NSUserDefaults standardUserDefaults]synchronize];
                      
                      NSString *dismissValue = [[NSUserDefaults standardUserDefaults]
                                                valueForKey:@"dismissValue"];
                      
                      if([dismissValue isEqualToString:@"dismissValueList"])
                      {
                          
                          [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dismissValue"];
                         [self dismissViewControllerAnimated:YES completion:nil];
                          //[self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
                          
                      }
                      
                      else
                      {
                          [self dismissViewControllerAnimated:YES completion:nil];
                      }
                      
                      
                      /*   UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
                       
                       OverlayEffectViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"overlayController"];
                       vc.isPageFirst=@"second";
                       [vc.doneOutlet setTintColor:[UIColor whiteColor]];
                       
                       [self.navigationController pushViewController:vc animated:YES];
                       */
                      [hud hideAnimated:YES];
                      
                  }
                  else
                  {
                      //                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Already installed" preferredStyle:UIAlertControllerStyleAlert];
                      //
                      //                      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                      //                      [alertController addAction:ok];
                      //
                      //                      [self presentViewController:alertController animated:YES completion:nil];
                      
                      CustomPopUp *popUp = [CustomPopUp new];
                      [popUp initAlertwithParent:self withDelegate:self withMsg:@"Already installed" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                      popUp.okay.backgroundColor = [UIColor lightGreen];
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
    }@catch(NSException *exception)
    {
        
    }
}
-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
        
        
    }
    [alertView hide];
    alertView = nil;
    
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
        
    }
    [alertView hide];
    alertView = nil;
    
}
@end

