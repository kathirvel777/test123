//
//  ImgEditorCollectionViewController.m
//  Montage
//
//  Created by MacBookPro on 12/30/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "ImgEditorCollectionViewController.h"
#import "AFNetworking.h"
#import "CvCellImgEditor.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CLImageEditor.h"
#import "_CLImageEditorViewController.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ImgEditorCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CLImageEditorDelegate,CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,GADBannerViewDelegate>
{
    NSMutableArray *categoryMain,*previewImg,*idValue;
    
    NSString *mainCategoryValue,*actionID;
    MBProgressHUD *hud;
    int mainCatCount,subCatCount;
    NSString *actionId,*user_id;
    UIImage *img,*finalimg;
    UIImageView *imageViewStick;
}

@end

@implementation ImgEditorCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.applyOutlet.tintColor=[UIColor clearColor];
    self.applyOutlet.enabled=NO;
    
    idValue =[[NSMutableArray alloc]init];
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.collectionViewImg.backgroundColor=UIColorFromRGB(0x262d32);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    
    [self mainCategoryWebResp];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"])
    {
        
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        
        //request.testDevices = @[ kGADSimulatorID , @"a188bfc4e0e0627e387fd3048172fd2d"];//@"a78336ddc8e01915e84e7454e395adf9"];
        request.testDevices = nil;

        // self.bannerView.center=CGPointMake(bview.frame.size.width/2,bview.frame.size.height/2);
        self.bannerView.delegate=self;
        [self.bannerView loadRequest:request];
    }
    else
    {
        [self.bannerView removeFromSuperview];
    }

    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *imgData = [currentDefaults objectForKey:@"imgData"];
    
    img=[[UIImage alloc] initWithData:imgData];
    
   // self.imgView.image=img;
    
    CGRect rect=CGRectFromString([[NSUserDefaults standardUserDefaults]stringForKey:@"imgViewFrame"]);
    
    UIView *childd =[[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width,rect.size.height)];
   
    
    imageViewStick = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width,rect.size.height)];
   
    imageViewStick.image = img;
    
    [childd addSubview:imageViewStick];
    [_imgView addSubview:childd];
    childd.center=_imgView.center;
    
  //  CGRect rect=CGRectFromString([[NSUserDefaults standardUserDefaults]stringForKey:@"imgViewFrame"]);
    
  //  _imgView.frame = CGRectMake(rect.origin.x,rect.origin.y,rect.size.width, rect.size.height);
    
}

-(void)mainCategoryWebResp
{
    @try
    {
        mainCatCount=1;
        self.navTitle.text=@"Action";
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=PS_MainCategory";
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  categoryMain = [[NSMutableArray alloc]init];
                  previewImg = [[NSMutableArray alloc]init];
                  
                  NSArray *mainCategory=[responseObject objectForKey:@"MainCat"];
                  
                  NSString *category,*preview;
                  for(int i=0;i<mainCategory.count;i++)
                  {
                      NSDictionary *dic=[mainCategory objectAtIndex:i];
                      
                      category=[dic objectForKey:@"Category"];
                      preview=[dic objectForKey:@"Preview"];
                      
                      [categoryMain addObject:category];
                      [previewImg addObject:preview];
                  }
                  
                  NSLog(@"Main category %@",categoryMain);
                  NSLog(@"previewImg %@",previewImg);
                  [self.collectionViewImg reloadData];
                  
                  [hud hideAnimated:YES];
              }
              
              else
              {
                  NSLog(@"Error123: %@", error);
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  
                  [hud hideAnimated:YES];
              }
          }
          ]resume];
    }@catch(NSException *exception)
    {
        
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return categoryMain.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"CvCellImgEditor";
    CvCellImgEditor *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSLog(@"indexpath row %ld",(long)indexPath.row);
    
    if(mainCatCount==1)
    {
        cell.frontView.hidden=NO;
        cell.backView.hidden=YES;
    }
    
    else if(mainCatCount==0)
    {
        if(indexPath.row==0)
        {
            cell.frontView.hidden=YES;
            cell.backView.hidden=NO;
        }
        else
        {
            cell.frontView.hidden=NO;
            cell.backView.hidden=YES;
        }
    }
    
    cell.mainCategoryName.text=[categoryMain objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[previewImg objectAtIndex:indexPath.row]];

    [cell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    cell.layer.cornerRadius=10.0f;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(mainCatCount==1)
    {
        mainCategoryValue=[categoryMain objectAtIndex:indexPath.row];
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self subCategoryWebResp];
        
        self.navTitle.text=[categoryMain objectAtIndex:indexPath.row];
        subCatCount=1;
    }
    
    else if(subCatCount==1)
        
    {
        if(indexPath.row==0)
        {
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self mainCategoryWebResp];
        }
        
        else
        {
            actionID =[idValue objectAtIndex:indexPath.row];
            [self finalEffects];
        }
    }
}


//            if(subCatCount==2)
//            {
//                if(indexPath.row==0)
//                {
//                    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    [self mainCategoryWebResp];
//                    [hud hideAnimated:YES];
//                }
//                else
//                {
//                    actionID =[idValue objectAtIndex:indexPath.row];
//                    [self finalEffects];
//                }
//            }

-(void)finalEffects
{
    @try
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *beforeImgEffect=[[NSUserDefaults standardUserDefaults]objectForKey:@"imgPathVal"];
        
        NSDictionary *parameters =@{@"User_ID":user_id,@"ActionID":actionID,@"PhotoFilePath":beforeImgEffect};
        
        NSLog(@"the paeam %@",parameters);
        
        NSString *URL = @"https://www.hypdra.com/PhotoShopActionEffects/IOS_File_Upload.php";
        
        NSError *error;      // Initialize NSError
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add parameters to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  
                  NSLog(@"the response %@",responseObject);
                  NSDictionary *dic=responseObject;
                  
                  if([[dic objectForKey:@"message"] isEqualToString:@"NOT OK"])
                  {
                      CustomPopUp *popUp = [CustomPopUp new];
                      [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                      popUp.okay.backgroundColor = [UIColor lightGreen];
                      popUp.agreeBtn.hidden = YES;
                      popUp.cancelBtn.hidden = YES;
                      popUp.inputTextField.hidden = YES;
                      [popUp show];
                      [hud hideAnimated:YES];
                  }
                  else
                  {
                      NSString *imgPath=[dic objectForKey:@"img_path"];
                      NSURL *baseUrl=[[NSURL alloc]initWithString:imgPath];
                      NSData *pictureData=[[NSData alloc]initWithContentsOfURL:baseUrl];
                      
                      finalimg=[[UIImage alloc] initWithData:pictureData];
                      imageViewStick.image = finalimg;
                    // self.imgView.image=finalimg;
                      
                      self.applyOutlet.tintColor=[UIColor whiteColor];
                      self.applyOutlet.enabled=YES;
                      [hud hideAnimated:YES];
                  }
              }
              else
              {
                  NSLog(@"Error123: %@", error);
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  [hud hideAnimated:YES];
              }
          }
          ]resume];
    }@catch(NSException *exception)
    {
        
    }
}

-(void)subCategoryWebResp
{
    @try
    {
        mainCatCount=0;
        
        NSDictionary *parameters =@{@"lang":@"iOS",@"cat":mainCategoryValue};
        
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=PS_SubCategory";
        
        NSError *error;      // Initialize NSError
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add parameters to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              
              if (!error)
              {
                  [categoryMain removeAllObjects];
                  [previewImg removeAllObjects];
                  
                  categoryMain = [[NSMutableArray alloc]init];
                  previewImg = [[NSMutableArray alloc]init];
                  
                  NSDictionary *dicValue=responseObject;
                  NSArray *arrValue=[dicValue objectForKey:@"SubCat"];
                  
                  for (int i=0; i<arrValue.count; i++)
                  {
                      NSDictionary *dic=[arrValue objectAtIndex:i];
                      NSString *prev=[dic objectForKey:@"Preview"];
                      NSString *subCat=[dic objectForKey:@"SubCategory"];
                      NSString *idVal=[dic objectForKey:@"id"];
                      
                      if(i==0)
                      {
                          [categoryMain insertObject:@"example" atIndex:i];
                          [previewImg insertObject:@"example" atIndex:i];
                          [idValue insertObject:@"00" atIndex:i];
                      }
                      
                      [categoryMain insertObject:subCat atIndex:i+1];
                      [previewImg insertObject:prev atIndex:i+1];
                      [idValue insertObject:idVal atIndex:i+1];
                      
                  }
                  
                  [self.collectionViewImg reloadData];
                  
                  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                  
                  
                  [self.collectionViewImg scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                  
                  
                  [hud hideAnimated:YES];
                  
              }
              
              else
              {
                  NSLog(@"Error123: %@", error);
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
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

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)applyAction:(id)sender
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *userinfo=@{@"finalEffect":finalimg};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FinalEffect" object:self userInfo:userinfo];
    
    [hud hideAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    
    [alertView hide];
    alertView = nil;
    
}

- (void)agreeCLicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView = nil;
}

@end

