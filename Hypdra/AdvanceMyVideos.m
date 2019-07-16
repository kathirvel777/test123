//
//  AdvanceMyVideos.m
//  Montage
//
//  Created by MacBookPro4 on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AdvanceMyVideos.h"
#import "AdvanceMyVideosCell.h"
#import "DEMORootViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AdvanceTabViewController.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"

@interface AdvanceMyVideos ()<UICollectionViewDelegate,UICollectionViewDataSource,ClickDelegates>
{
    NSMutableArray *OnlyImages,*finalArray,*shareArray;
    NSString *user_id;
    MBProgressHUD *hud;
    NSString *creditPoints;
    AdvanceMyVideosCell *cell;
    
    
}

@end

@implementation AdvanceMyVideos

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    Do any additional setup after loading the view.
    //    [flowLayout setMinimumInteritemSpacing:2.0f];
    //    [flowLayout setMinimumLineSpacing:30.0f];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    self.VideosCollectionView.bounces = false;
    
    [self.VideosCollectionView setCollectionViewLayout:flowLayout];
    
    shareArray = [[NSMutableArray alloc]init];
    
    [self.VideosCollectionView setAllowsMultipleSelection:YES];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    /*    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(galleryVideo:)
     name:@"galleryVideo" object:nil];*/
    
    // [self getName];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    
    [self getVideos];
    AdvanceTabViewController *tabContrl = self.tabBarController;
    tabContrl.btn_Add.image = [UIImage new];
    
}

-(void)viewDidLayoutSubviews
{
    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
}

-(void)getVideos
{
    @try
    {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=view_my_image";
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
                          if([type isEqualToString:@"Video"])
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
                          [self.VideosCollectionView reloadData];
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
        [hud hideAnimated:YES];
    }
    @finally
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
                                             selector:@selector(galleryVideo:)
                                                 name:@"galleryVideo" object:nil];
    
    
    //    if (OnlyImages.count == 0)
    //    {
    //        self.secondView.hidden = true;
    //        self.firstView.hidden = false;
    //    }
    //    else
    //    {
    //        self.secondView.hidden = false;
    //        self.firstView.hidden = true;
    //    }
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    // NSLog(@"Music Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
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
        if( [[dic valueForKey:@"DataType"] isEqualToString:@"Video"]){
            [tempOnlyImages addObject:dic];
        }
    }
    
    OnlyImages = tempOnlyImages;
    [self.VideosCollectionView reloadData];
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
    
    static NSString *CellIdentifier = @"AdvanceMyVideosCell";
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.borderWidth = 0.2f;
    
    cell.alpha = 1.0;
    
    /* NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *DocDir = [ScreensDir objectAtIndex:0];
     
     DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
     NSMutableDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
     NSLog(@"OnlyImages %@",OnlyImages);
     NSString *id = [dic valueForKey:@"Id"];
     
     DocDir = [DocDir stringByAppendingPathComponent:[id stringByAppendingString:@".png"]];
     NSLog(@"Video Collecitonview Docdir:%@",DocDir);*/
    
    /*    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
     
     UIImage *img=[[UIImage alloc] initWithData:pictureData];*/
    
    
    NSURL *imageURL = [[finalArray objectAtIndex:indexPath.row]objectForKey:@"imagePath"];
    //fileURLWithPath:DocDir];
    
    [cell.video sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
    //    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-border.png"]];
    
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
    if(cell.selected)
        cell.SelectedVideo.hidden=NO;
    else
        cell.SelectedVideo.hidden=YES;
    
    //    NSLog(@"Video Collectionview:%@",img);
    //    cell.video.image = img;
    
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
        NSString *msg = [NSString stringWithFormat:@"Available credit: %d | Credit Needed: %d", availablecredits,availablecredits];
        [popUp initAlertwithParent:self withDelegate:self withMsg:msg withTitle:@"Pay Using Credit Balance" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.accessibilityHint = @"Redeem";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        popUp.okay.hidden =YES;
        [popUp.agreeBtn setTitle:@"Redeem" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    else
    {
        
        AdvanceMyVideosCell *cell=(AdvanceMyVideosCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.SelectedVideo.hidden= NO;
        
        NSLog(@"Did Select");
        
        NSDictionary *selectedRecipe = [finalArray objectAtIndex:indexPath.row];
        
        [shareArray addObject:selectedRecipe];
        AdvanceTabViewController *tabContrl = self.tabBarController;
        tabContrl.btn_Add.image = [UIImage imageNamed:@"12-tick.png"];
        
//        if(shareArray.count<1)
//        {
//        AdvanceTabViewController *tabContrl = self.tabBarController;
//        tabContrl.btn_Add.image =  [UIImage imageNamed:@"12-tick.png"];
//        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Did Deselect");
    AdvanceMyVideosCell *cell=(AdvanceMyVideosCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.SelectedVideo.hidden= YES;
    
    
    NSDictionary *deSelectedRecipe = [finalArray objectAtIndex:indexPath.row];
    [shareArray removeObject:deSelectedRecipe];
    AdvanceTabViewController *tabContrl = self.tabBarController;
    tabContrl.btn_Add.image = [UIImage new];
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


- (void)galleryVideo:(NSNotification *)note
{
    // NSLog(@"ShareArray = %@",shareArray);
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
                                                    name:@"galleryVideo"
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
             
             cell.SelectedVideo.hidden = NO;
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
@end

