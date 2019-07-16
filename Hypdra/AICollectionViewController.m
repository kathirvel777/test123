//  AICollectionViewController.m
//  Hypdra
//  Created by Mac on 1/7/19.
//  Copyright © 2019 sssn. All rights reserved.

#import "DEMORootViewController.h"
#import "UIImageView+WebCache.h"
#import <ImageIO/ImageIO.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "AICollectionViewController.h"
#import "AICollectionTableViewCell.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "CLImageEditor/CLImageEditor.h"


@interface AICollectionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ClickDelegates>{
    NSMutableArray *finalArray,*MultipleDeleteItemsAry,*MultipleDeleteIndexPathAry;
    NSIndexPath *SelectedIndexPath;
    NSString *user_id,*newVideoGenerating;
    MBProgressHUD *hud;
    NSMutableURLRequest *request;
    int deleteTag;
    
}
@end

@implementation AICollectionViewController{
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    [self getCollections];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"viewDidAppear");
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(TimerRepeatMethod:) userInfo:nil repeats:YES];
}
- (void) TimerRepeatMethod:(NSTimer *)timer
{
    if(newVideoGenerating == nil){
        //hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        [self getCollections];
    }
    if([newVideoGenerating isEqualToString:@"YES"]){
        
        [self getCollections];
    }
    else
        [timer invalidate];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return finalArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [finalArray objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"AICollection";
    AICollectionTableViewCell *cell = (AICollectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AICollectionTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.delete_btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.download.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.share.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.edit.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    NSURL *imageURL = [NSURL URLWithString:[dict objectForKey:@"User_Image"]];
    NSURL *ActionImageURL = [NSURL URLWithString:[dict objectForKey:@"Action_Image"]];

    NSString *albumImage = [dict objectForKey:@"Album_Image"];
    NSURL *AlbumImageURL;
    
    if (!(albumImage == (id)[NSNull null] || albumImage.length == 0)){
        
       AlbumImageURL = [NSURL URLWithString:albumImage];
        [cell.albumImg sd_setImageWithURL:AlbumImageURL placeholderImage:[UIImage new]];
        cell.albumImg.contentMode = UIViewContentModeScaleAspectFill;
        cell.albumImg.clipsToBounds = true;
        
        [cell.cellActivityIndicator startAnimating];
        
    }
    
    [cell.userImg sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder.png"]];
    [cell.actionImg sd_setImageWithURL:ActionImageURL placeholderImage:[UIImage imageNamed:@"150-image-holder.png"]];
    cell.userImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.userImg.clipsToBounds = true;

    cell.albumImgButton.tag = indexPath.row;
    [cell.albumImgButton addTarget:self action:@selector(albumImageTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.actionImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.actionImg.clipsToBounds = true;

    cell.download.tag = indexPath.row;
    [cell.download addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.share.tag = indexPath.row;
    [cell.share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.edit.tag = indexPath.row;
    [cell.edit addTarget:self action:@selector(imageEdit_btn:) forControlEvents:UIControlEventTouchUpInside];

    cell.delete_btn.tag = indexPath.row;
    [cell.delete_btn addTarget:self action:@selector(deleteAlbum:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)getCollections
{
    @try
    {
        
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=AI_Art_Album";
        NSDictionary *parameters = @{@"User_ID":user_id,@"lang":@"iOS"};
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
                      NSArray *statusArray = [response objectForKey:@"items"];
                      
                      finalArray = statusArray.mutableCopy;
                      
                      NSLog(@"Final Array in uploadimg:%@",finalArray);
                      
                      if(newVideoGenerating == nil){
                          [self.tblVIew reloadData];
                      }else if([newVideoGenerating  isEqual: @"YES"]){
//                          [_tblVIew performBatchUpdates:^{
                              NSIndexPath *path =[NSIndexPath indexPathForRow:0 inSection:0];
                              NSMutableArray *indexPaths =[NSMutableArray arrayWithObject:path];
                              [self.tblVIew beginUpdates];
                              [self.tblVIew reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                              [self.tblVIew endUpdates];

                          //                          } completion:^(BOOL finished) {}];
                      }
                      
                     // [hud hideAnimated:YES];
                      NSDictionary *dict = [finalArray objectAtIndex:0];
                      NSString *albumImage = [dict objectForKey:@"Album_Image"];

                      if([albumImage isEqualToString:@""]){
                          newVideoGenerating = @"YES";
                      }
                      else{
                        newVideoGenerating = @"NO";
                      [hud hideAnimated:YES];
                      }

                  }
//                      else
//                      {
//                          [self.tblVIew reloadData];
//                          [hud hideAnimated:YES];
//                      }
                  //}
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
    NSURL *thumbURL;
    NSString *imgPathVal = [[finalArray objectAtIndex:sender.tag]objectForKey:@"Album_Image"];
    
    if (!(imgPathVal == (id)[NSNull null] || imgPathVal.length == 0)){

        thumbURL=[NSURL URLWithString:[[finalArray objectAtIndex:sender.tag]objectForKey:@"Album_Image"]];
    }
    
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
-(void)imageEditing:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imgEditing" object:nil];
    
    NSLog(@"CLI dta:%@",notification.userInfo);
    NSDictionary *dic=notification.userInfo;
    NSData *imageData=[dic objectForKey:@"total"];
    UIImage *AlbumImage = [UIImage imageWithData:imageData];
   UIImageWriteToSavedPhotosAlbum(AlbumImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    [editor dismissViewControllerAnimated:YES completion:nil];
    UIImage *AlbumImage = image;
}
- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imgEditing" object:nil];
    //    [self refreshImageView];
}

- (void)download:(UIButton*)sender
{
    NSString *imgPathVal = [[finalArray objectAtIndex:sender.tag]objectForKey:@"Album_Image"];
    
    if (!(imgPathVal == (id)[NSNull null] || imgPathVal.length == 0)){
        
       NSURL *thumbURL=[NSURL URLWithString:[[finalArray objectAtIndex:sender.tag]objectForKey:@"Album_Image"]];
        NSData *imgData=[NSData dataWithContentsOfURL:thumbURL];
        UIImage *albumImage=[[UIImage alloc] initWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(albumImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void) image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info;
{
    if (error != NULL)
    {
        NSLog(@"Error:%@",error);
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please go to iOS Setting > Privacy > Photos to allow Hypdra to save photos to your library." withTitle:@"Couldn't Save Photo" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Saved, Please go to album to view" withTitle:@"Saved" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}
- (void)share:(UIButton*)sender
{
    
    NSString *albumImagePath = [[finalArray objectAtIndex:sender.tag]objectForKey:@"Album_Image"];

    NSURL *url=[NSURL URLWithString:albumImagePath];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    NSMutableArray *tempImage = [[NSMutableArray alloc]init];
    [tempImage addObject:image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:tempImage
                                            applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
          [self presentViewController:activityVC animated:YES completion:nil];
    }
    else
    {
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        AICollectionTableViewCell *cell = (AICollectionTableViewCell *)[(UITableView *)self.tblVIew cellForRowAtIndexPath:indexPath];

        // AICollectionTableViewCell *cell = (AICollectionTableViewCell *)[tableView cellForItemAtIndexPath:indexPath];
        
        CGRect rect=CGRectMake(cell.bounds.origin.x+600, cell.bounds.origin.y+10, 50, 30);
        
        
        [hud hideAnimated:YES];
        
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        
       // [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        [popup presentPopoverFromRect:cell.frame inView:self.tblVIew permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

       /* UIPopoverPresentationController *presentationController = [activityVC popoverPresentationController];
        presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        [self presentViewController:activityVC animated:YES completion:nil];
        presentationController.sourceView = self.view;
        presentationController.sourceRect = self.view.frame;*/
       
        
        
//        activityVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    }
    
    //    activityVC.view.backgroundColor=[UIColor whiteColor];
    
    [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed,  NSArray *returnedItems, NSError *activityError)
     {
         NSLog(@"ERROR HERE7");
         if([activityType isEqualToString:UIActivityTypePostToTwitter])
         {
             //twitter selected
         }
     }];
    
    //[self presentViewController:activityVC animated:YES completion:nil];
    
    /* UIPopoverPresentationController *presentationController =
     [activityVC popoverPresentationController];
     presentationController.permittedArrowDirections =
     UIPopoverArrowDirectionUp;
     presentationController.sourceView = self.view ;
     presentationController.sourceRect = self.view.frame;*/
}

-(void)albumImageTapped:(UIButton*)sender{
    _containerView.hidden = false;
    NSDictionary *dict = [finalArray objectAtIndex:sender.tag];
    NSString *albumImage = [dict objectForKey:@"Album_Image"];
    NSURL *AlbumImageURL;
  
        AlbumImageURL = [NSURL URLWithString:albumImage];
        [_albumImageView sd_setImageWithURL:AlbumImageURL placeholderImage:[UIImage new]];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.clipsToBounds = true;
        
    
}


- (IBAction)albumImageCloseTapped:(UIButton *)sender {
    _containerView.hidden = true;
}


-(void)deleteAlbum:(UIButton*)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    deleteTag =  (int)sender.tag;

    if (networkStatus == NotReachable)
    {
        NSLog(@"Not Connected to Internet");

        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check internet connection" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.okay.backgroundColor = [UIColor navyBlue];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
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
   NSDictionary *dict = [finalArray objectAtIndex:deleteTag];
    
    NSDictionary *params = @{@"ID":(NSString *)[dict objectForKey:@"id"]};
    [manager POST:@"https://www.hypdra.com/api/api.php?rquest=AI_Art_Album_delete" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Image Delete Response = %@",responseObject);
         
         NSMutableDictionary *response=responseObject;

         NSString *cnf = [response objectForKey:@"status"];
         
         NSLog(@"Delete Status %@",cnf);
         
         if ([cnf isEqualToString:@"True"])
         {
             
             [hud hideAnimated:YES];
             
             NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];

             [defaults synchronize];
             
             [finalArray removeObjectAtIndex:deleteTag];
             SelectedIndexPath = [NSIndexPath indexPathForItem:deleteTag inSection:0];
             NSArray *deleteItems = @[SelectedIndexPath];
             [self.tblVIew beginUpdates];

             // Perform update
             [self.tblVIew deleteRowsAtIndexPaths:deleteItems
                                 withRowAnimation:UITableViewRowAnimationFade];
             // End update
             [self.tblVIew endUpdates];
             
            if(finalArray.count==0)
             {
                 self.tblVIew.hidden=YES;
                 self.tblVIew.hidden=NO;
             }
          
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Image removed" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
             popUp.okay.backgroundColor = [UIColor lightGreen];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             
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
    
     if([alertView.accessibilityHint isEqualToString:@"SingleDeleteConfirmation"]){
       
        [alertView hide];
        alertView= nil;
        
        [self deleteImage];
        
    }
    [alertView hide];
    alertView= nil;
    
}
@end
