//
//  WizardMyImages.m
//  Hypdra
//
//  Created by Mac on 7/10/18.
//  Copyright © 2018 sssn. All rights reserved.

#import "WizardMyImages.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AdvanceMyImagesCell.h"
#import "UIImageView+WebCache.h"
#import "DEMORootViewController.h"
#import "SwipeBack.h"
#import "WizardTabViewController.h"
@import GoogleMobileAds;



@interface WizardMyImages ()<UICollectionViewDelegate,UICollectionViewDataSource,GADBannerViewDelegate>
{
    MBProgressHUD *hud;
    NSString *user_id;
    NSMutableArray *finalArray,*shareArray;
    AdvanceMyImagesCell *cell;
    NSIndexPath *SelectedIndexPath;
}
@property(nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation WizardMyImages

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.swipeBackEnabled=NO;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.imagesCollectionview.bounces = false;
    
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.imagesCollectionview setCollectionViewLayout:flowLayout];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    shareArray=[[NSMutableArray alloc]init];
    
    [self getImages];
    
    WizardTabViewController *tabContrl = self.tabBarController;
    
    tabContrl.btn_Add.image = [UIImage new];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wizardImg:)
                                                 name:@"wizardImg" object:nil];
    
}
- (void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    self.bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
   // self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
    request.testDevices = nil;

    [self.bannerView loadRequest:request]; self.bannerView.center=CGPointMake(_ADView.frame.size.width/2,_ADView.frame.size.height/2);
    [_ADView addSubview:_bannerView];
}
-(void)viewDidLayoutSubviews
{
    
//    self.ViewHoldsCollView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.ViewHoldsCollView.frame.size.width, self.ViewHoldsCollView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    self.ViewHoldsCollView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y-15, self.ViewHoldsCollView.frame.size.width, self.ViewHoldsCollView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
}
- (void)viewWillAppear:(BOOL)animated{
    if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        
        [self.ADView removeFromSuperview];
    }
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
                              
                              
                              [finalArray addObject:dic];
                          }
                      }
                      NSLog(@"Final Array in uploadimg:%@",finalArray);
                      if (finalArray.count == 0)
                      {
                          self.ViewHoldsCollView.hidden = true;
                          self.emptyView.hidden = false;
                          [hud hideAnimated:YES];
                      }
                      else
                      {
                          self.ViewHoldsCollView.hidden = false;
                          self.emptyView.hidden = true;
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
    
    NSURL *imageURL = [[finalArray objectAtIndex:indexPath.row]objectForKey:@"imagePath"];
    
    [cell.img sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
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
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        cell.SelectedImage.hidden=NO;
    }
    
    else
    {
        cell.SelectedImage.hidden=YES;
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedRecipe = [finalArray objectAtIndex:indexPath.row];
    
    [shareArray addObject:selectedRecipe];
    
    WizardTabViewController *tabContrl = self.tabBarController;
    tabContrl.btn_Add.image = [UIImage imageNamed:@"12-tick.png"];
    
    SelectedIndexPath = indexPath;
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            self.selectedItemIndexPath = nil;
//            _doneOutlet.enabled=NO;
//            _doneOutlet.tintColor=[UIColor clearColor];
//
            tabContrl.btn_Add.image = [UIImage new];
        }
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
//            _doneOutlet.enabled=YES;
//            _doneOutlet.tintColor=[UIColor whiteColor];
//
            tabContrl.btn_Add.image = [UIImage imageNamed:@"12-tick.png"];
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        self.selectedItemIndexPath = indexPath;
//        _doneOutlet.enabled=YES;
//        _doneOutlet.tintColor=[UIColor whiteColor];
        tabContrl.btn_Add.image = [UIImage imageNamed:@"12-tick.png"];
    }
    
    // and now only reload only the cells that need updating
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *deSelectedRecipe = [finalArray objectAtIndex:indexPath.row];
    [shareArray removeObject:deSelectedRecipe];
    
    cell = (AdvanceMyImagesCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.SelectedImage.hidden = YES;
    
    if(shareArray.count <1)
    {
//        _doneOutlet.enabled=NO;
//        _doneOutlet.tintColor=[UIColor clearColor];
        WizardTabViewController *tabContrl = self.tabBarController;
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

- (IBAction)backAction:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)menu:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

- (void)wizardImg:(NSNotification *)note
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:shareArray];
    
    //saving array to userdefault to get dict in workspace viewcontroller
    
    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"wizardGalleryImg"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //To get userdefault array value in workspace view controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wizardImage" object:nil];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"wizardImg"
                                                  object:nil];
}

/*
- (IBAction)done:(id)sender
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:shareArray];
    
    //saving array to userdefault to get dict in workspace viewcontroller
    
    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"wizardGalleryImg"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //To get userdefault array value in workspace view controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wizardImage" object:nil];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
} */

@end
