//
//  AdvanceMyImages.m
//  Montage
//
//  Created by MacBookPro4 on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AdvanceMyImages.h"
#import "AdvanceMyImagesCell.h"
#import "DEMORootViewController.h"
#import "UIImageView+WebCache.h"
#import <ImageIO/ImageIO.h>
#import "AdvanceTabViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"


@interface AdvanceMyImages ()<UICollectionViewDelegate,UICollectionViewDataSource,ClickDelegates>
{
    NSMutableArray *finalArray,*OnlyImages,*shareArray;
    NSString *user_id;
    AdvanceMyImagesCell *cell;
    MBProgressHUD *hud;
    NSString *creditPoints;
}

@end

@implementation AdvanceMyImages

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Advanced images called");
    
    //    self.adtabBar.doneDelegate = self;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.imagesCollectionview.bounces = false;
    
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.imagesCollectionview setCollectionViewLayout:flowLayout];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [self.imagesCollectionview setAllowsMultipleSelection:YES];
    
    shareArray = [[NSMutableArray alloc]init];
    
    [self getImages];
    AdvanceTabViewController *tabContrl = self.tabBarController;
    tabContrl.btn_Add.image = [UIImage new];
    //tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"deleteStroke.png"];
    
    // [self getName];
}

-(void)viewDidLayoutSubviews
{
    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
}

-(void)getImages
{
    @try
    {
        
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
                          NSString *thumbnailPath;
                          
                          NSString *type = [imageDic objectForKey:@"type"];
                          NSString *id;
                          if([type isEqualToString:@"Image"])
                          {
                              thumbnailPath = [imageDic objectForKey:@"thumb_img"];
                              id = [imageDic objectForKey:@"image_id"];
                              
                              NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                              
                              [dic setValue:type forKey:@"DataType"];
                              
                              [dic setValue:id forKey:@"Id"];
                              [dic setObject:thumbnailPath forKey:@"imagePath"];
                              
                              
                              //                          else
                              //                          {
                              //                              thumbnailPath = [imageDic objectForKey:@"thumb_img"];
                              //                          }
                              //
                              //                          NSString *id = [imageDic objectForKey:@"image_id"];
                              //
                              //                          NSString *videoPath;
                              //
                              //                          NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                              //
                              //                          [dic setValue:type forKey:@"DataType"];
                              //
                              //                          [dic setValue:id forKey:@"Id"];
                              //
                              //                          if(![type isEqualToString:@"Image"])
                              //                          {
                              //                              videoPath = [imageDic objectForKey:@"VideoPath"];
                              //
                              //                              [dic setValue:videoPath forKey:@"videoPath"];
                              //                          }
                              
                              [finalArray addObject:dic];
                          }
                      }
                      NSLog(@"Final Array in uploadimg:%@",finalArray);
                      if (finalArray.count == 0)
                      {
                          self.secondView.hidden = true;
                          self.firstView.hidden = false;
                          [hud hideAnimated:YES];
                      }
                      else
                      {
                          self.secondView.hidden = false;
                          self.firstView.hidden = true;
                          [self.imagesCollectionview reloadData];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    if (shareArray.count == 0)
    {
        AdvanceTabViewController *tabContrl = self.tabBarController;
        tabContrl.btn_Add.image = [UIImage new];
        
    }else{
        AdvanceTabViewController *tabContrl = self.tabBarController;
        tabContrl.btn_Add.image = [UIImage imageNamed:@"12-tick.png"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(galleryImage:)
                                                 name:@"galleryImage" object:nil];
}


//-(void)viewDidLayoutSubviews
//{
//    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    
    
    //  NSLog(@"Music Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    
    //    self.secondView.frame = CGRectMake(0, 149, 10, 10);
    //
    //    self.secondView.backgroundColor = [UIColor yellowColor];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)getName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
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
    
    NSMutableArray *tempOnlyImages = [[NSMutableArray alloc]init];
    for(NSMutableDictionary *dic in finalArray){
        NSLog(@"FinalArray %@",finalArray);
        if( [[dic valueForKey:@"DataType"] isEqualToString:@"Image"]){
            [tempOnlyImages addObject:dic];
        }
    }
    
    OnlyImages = tempOnlyImages;
    [self.imagesCollectionview reloadData];
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
    
    /*  NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *DocDir = [ScreensDir objectAtIndex:0];
     
     DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
     NSMutableDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
     NSLog(@"OnlyImages %@",OnlyImages);
     NSString *id1 = [dic valueForKey:@"Id"];
     
     DocDir = [DocDir stringByAppendingPathComponent:[id1 stringByAppendingString:@".png"]];*/
    
    /*    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
     
     UIImage *img=[[UIImage alloc] initWithData:pictureData];
     
     cell.img.image = img;*/
    
    NSURL *imageURL = [[finalArray objectAtIndex:indexPath.row]objectForKey:@"imagePath"];
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
    
    /*    NSData *pictureData = UIImagePNGRepresentation(cell.img.image);
     
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
     [cell.img.image drawInRect:CGRectMake(0, 0, newBlurSize.width, newBlurSize.height)];
     
     
     
     UIImage *BackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     cell.BackGroundImage.image = BackgroundImage;*/
    
    
    //    [cell.BackGroundImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    if(cell.selected)
        cell.SelectedImage.hidden=NO;
    else
        cell.SelectedImage.hidden=YES;
    //    cell.ImgView.image = img;
    
    //    cell.deleteImg.tag = indexPath.row;
    //    [cell.deleteImg addTarget:self action:@selector(close_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChoosenImagesandVideos"];
    NSMutableArray *imagesandvideos = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"] && imagesandvideos.count >= 10)
    {
        CustomPopUp *popUp = [CustomPopUp new];
        int availablecredits = 320;
        NSString *msg = [NSString stringWithFormat:@"Available credit: %d | Credit Needed: %d", availablecredits,10];
        [popUp initAlertwithParent:self withDelegate:self withMsg:msg withTitle:@"Pay Using Credit Balance" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.accessibilityHint = @"Redeem";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        popUp.okay.hidden =YES;
        [popUp.agreeBtn setTitle:@"Redeem" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }else{
        
        cell=(AdvanceMyImagesCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.SelectedImage.hidden= NO;
        NSLog(@"Did Select");
        NSDictionary *selectedRecipe = [finalArray objectAtIndex:indexPath.row];
        
        [shareArray addObject:selectedRecipe];
        AdvanceTabViewController *tabContrl = self.tabBarController;
        tabContrl.btn_Add.image = [UIImage imageNamed:@"12-tick.png"];
        //tabContrl.addAndDeleteBtn.image = [UIImage imageNamed:@"deleteStroke.png"];
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Did Deselect");
    
    NSDictionary *deSelectedRecipe = [finalArray objectAtIndex:indexPath.row];
    [shareArray removeObject:deSelectedRecipe];
    
    cell = (AdvanceMyImagesCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.SelectedImage.hidden = YES;
    if(shareArray.count <1){
        AdvanceTabViewController *tabContrl = self.tabBarController;
        tabContrl.btn_Add.image = [UIImage new];
    }
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        picDimension = self.view.frame.size.width / 3.08f;
        
    }
    else
    {
        picDimension = self.view.frame.size.width / 3.18f;
    }
    return CGSizeMake(picDimension, picDimension);
}


- (void)galleryImage:(NSNotification *)note
{
    
    //    NSLog(@"ShareArray = %@",shareArray);
    
    NSLog(@"ShareArray = %lu",(unsigned long)shareArray.count);
    
    @try
    {
        if (shareArray.count == 0)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No image selected" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                       }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            AdvanceTabViewController *tabContrl = self.tabBarController;
            tabContrl.btn_Add.image = [UIImage new];
        }
        else
        {
            
            [[NSUserDefaults standardUserDefaults]setInteger:shareArray.count forKey:@"shareArrayCount"];
            
            
            NSString *arraytag=[NSString stringWithFormat:@"ChoosenImagesandVideos"];
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:arraytag];
            NSMutableArray *imagesandvideos = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            if(imagesandvideos == nil)
            {
                imagesandvideos=[[NSMutableArray alloc]init];
            }
            
            for (NSDictionary *dict in shareArray)
            {
                [imagesandvideos addObject:dict];
            }
            
            NSLog(@"Images and Videos = %@",imagesandvideos);
            
            NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:imagesandvideos];
            [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:arraytag];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *iswizardorAdvance=[[NSUserDefaults standardUserDefaults]objectForKey:@"isWizardOrAdvance"];
            
            if([iswizardorAdvance isEqualToString:@"Wizard"])
            {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
                
                DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                
                [vc awakeFromNib:@"contentController_6" arg:@"menuController"];
                
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                [self presentViewController:vc animated:YES completion:NULL];
            }
            else
            {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
                
                DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                
                [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
                
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                [self presentViewController:vc animated:YES completion:NULL];
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CreateNewFinalDic"];
            }
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Finally");
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"galleryImage"
                                                  object:nil];
}


-(void)reducePoints:(NSNumber *)number
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
             creditPoints=[responseObject objectForKey:@"credit_points"];
             
             cell.SelectedImage.hidden = NO;
             NSLog(@"Did Select");
             int position = [number intValue];
             NSDictionary *selectedRecipe = [finalArray objectAtIndex:position];
             [shareArray addObject:selectedRecipe];
             AdvanceTabViewController *tabContrl = self.tabBarController;
             tabContrl.btn_Add.image = [UIImage imageNamed:@"12-tick.png"];
             
             [[NSUserDefaults standardUserDefaults]setObject:creditPoints forKey:@"credit_points"];
             [[NSUserDefaults standardUserDefaults]synchronize];
         }
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
}

-(void) okClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        [self cancelButtonPressed];
    }
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}
- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        [self reducePoints:[NSNumber numberWithInt:alertView.accessibilityValue.intValue]];
        
    }
    [alertView hide];
    alertView = nil;
}
- (void)cancelButtonPressed
{
    // write your implementation for cancel button here.
}
-(void)doneCompleted
{
    NSLog(@"doneCompletion");
}

@end

