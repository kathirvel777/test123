//
//  ImgEditorStickerViewController.m
//  Montage
//
//  Created by MacBookPro on 2/9/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "ImgEditorStickerViewController.h"
#import "AFNetworking.h"
#import "CvCellImgEditor.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CHTStickerView.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ImgEditorStickerViewController ()<SPUserResizableViewDelegate>
{
    NSMutableArray *categoryMain,*previewMain,*idValue;
    NSString *mainCategoryValue,*actionID;
    int mainCatCount,subCatCount;
    MBProgressHUD *hud;
    UIImage *img;
    UIView *stickView;
    UIView *childd;
    UIImageView *imageViewStick;
}
@end

@implementation ImgEditorStickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.doneOutlet.tintColor=[UIColor clearColor];
    self.doneOutlet.enabled=NO;
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.collectionViewSticker.backgroundColor=UIColorFromRGB(0x262d32);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"stickers"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"HideAnchors"];
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *imgData = [currentDefaults objectForKey:@"imgData"];
    
    img=[[UIImage alloc] initWithData:imgData];
    
    
    CGRect rect=CGRectFromString([[NSUserDefaults standardUserDefaults]stringForKey:@"imgViewFrame"]);
    
    childd =[[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width,rect.size.height)];
    
    [_imgViewSuperView addSubview:childd];
    
    imageViewStick = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width,rect.size.height)];
    imageViewStick.image = img;
    
    [childd addSubview:imageViewStick];
    childd.center=_imgViewSuperView.center;
    
    stickView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width,rect.size.height)];
    
    [childd addSubview:stickView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"stickers"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HideAnchors"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:YES];
    
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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [self loadMainCategory];
    
}

-(void)loadMainCategory
{
    @try
    {
        mainCatCount=1;
        
        self.navTitle.text=@"Stickers";
        
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=Sticker_MainCategory";
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSLog(@"the resp %@",responseObject);
                  
                  categoryMain =[[NSMutableArray alloc]init];
                  previewMain=[[NSMutableArray alloc]init];
                  
                  NSArray *mainCategory=[responseObject objectForKey:@"MainCat"];
                  NSString *category,*preview;
                  
                  for(int i=0;i<mainCategory.count;i++)
                  {
                      NSDictionary *dic=[mainCategory objectAtIndex:i];
                      
                      category=[dic objectForKey:@"Category"];
                      preview=[dic objectForKey:@"Preview"];
                      
                      [categoryMain addObject:category];
                      [previewMain addObject:preview];
                      
                  }
                  
                  [self.collectionViewSticker reloadData];
                  [hud hideAnimated:YES];
              }
              
              else
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
          }]resume];
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
    
    cell.layer.cornerRadius=10.0f;
    
    if(mainCatCount==1)
    {
        NSURL *imageURL = [NSURL URLWithString:[previewMain objectAtIndex:indexPath.row]];
        
        cell.mainCategoryName.text=[categoryMain objectAtIndex:indexPath.row];
        
        [cell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
        
        cell.frontView.hidden=NO;
        cell.backView.hidden=YES;
        cell.subViewSticker.hidden=YES;
    }
    
    else if(mainCatCount==0)
    {
        if(indexPath.row==0)
        {
            cell.frontView.hidden=YES;
            cell.backView.hidden=NO;
            cell.subViewSticker.hidden=YES;
        }
        else
        {
            
            NSURL *subImageURL=[NSURL URLWithString:[categoryMain objectAtIndex:indexPath.row]];
            
            [cell.imgViewSub sd_setImageWithURL:subImageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
            
            cell.frontView.hidden=YES;
            cell.backView.hidden=YES;
            cell.subViewSticker.hidden=NO;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(mainCatCount==1)
    {
        mainCategoryValue=[categoryMain objectAtIndex:indexPath.row];
        [self loadSubCategory];
        self.navTitle.text=[categoryMain objectAtIndex:indexPath.row];
        
        subCatCount=1;
    }
    
    else if(subCatCount==1)
    {
        if(indexPath.row==0)
        {
            [self loadMainCategory];
        }
        
        else
        {
            NSLog(@"sub cat tapped");
            
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [categoryMain objectAtIndex:indexPath.row]]];
            
            UIImage *imag=[UIImage imageWithData:imageData];
            
            @try
            {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HideBorderColour"];
                [[NSUserDefaults standardUserDefaults]synchronize];
               
                if(self.sticView != nil){
                    [_sticView.cancel setHidden:YES];
                    [_sticView removeBorder];
                    self.sticView = nil;
                    
                } if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    self.sticView = [[SPUserResizableView alloc] initWithFrame:CGRectMake(0,0,100,100)];
                }
                
                else
                {
                    self.sticView = [[SPUserResizableView alloc] initWithFrame:CGRectMake(0,0,100,100)];
                }
                
                self.sticView.contentMode=UIViewContentModeScaleAspectFit;
                
                // self.sticView.center = self.imgViewSuperView.center;
                [self.sticView showEditingHandles];
                
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.sticView.bounds];
                imgView.contentMode = UIViewContentModeCenter;
                
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                
                imgView.alpha=1;
                
                imgView.image = imag;
                [self.sticView becomeFirstResponder];
                
                self.sticView.contentView = imgView;
                self.sticView.delegate = self;
                self.sticView.contentView.layer.cornerRadius = 15;
                
                self.sticView.resizableStatus = YES;
                //   [self.sticView.cancel setHidden:NO];
                
                // [self.sticView hideEditingHandles];
                //[self.sticView.cancel setHidden:NO];
                [stickView addSubview:self.sticView];
                self.sticView.center=stickView.center;
                
            }@catch(NSException *ex)
            {
                
            }
            
            [hud hideAnimated:YES];
            
            self.doneOutlet.tintColor=[UIColor whiteColor];
            self.doneOutlet.enabled=YES;
        }
    }
}

-(void)loadSubCategory
{
    @try
    {
        mainCatCount=0;
        
        NSDictionary *parameters =@{@"lang":@"iOS",@"cat":mainCategoryValue};
        NSLog(@"sub param %@",parameters);
        
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=Sticker_SubCategory";
        
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
                  NSLog(@"the resp %@",responseObject);
                  
                  [categoryMain removeAllObjects];
                  
                  categoryMain = [[NSMutableArray alloc]init];
                  idValue=[[NSMutableArray alloc]init];
                  
                  NSDictionary *dicValue=responseObject;
                  NSArray *arrValue=[dicValue objectForKey:@"SubCat"];
                  
                  for (int i=0; i<arrValue.count; i++)
                  {
                      NSDictionary *dic=[arrValue objectAtIndex:i];
                      NSString *prev=[dic objectForKey:@"Preview"];
                      NSString *idVal=[dic objectForKey:@"id"];
                      
                      if(i==0)
                      {
                          [categoryMain insertObject:@"example" atIndex:i];
                          [idValue insertObject:@"00" atIndex:i];
                      }
                      
                      [categoryMain insertObject:prev atIndex:i+1];
                      [idValue insertObject:idVal atIndex:i+1];
                  }
                  
                  [self.collectionViewSticker reloadData];
                  
                  
                  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                  
                  [self.collectionViewSticker scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                  
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

- (IBAction)doneAction:(id)sender
{
    //    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //UIGraphicsBeginImageContextWithOptions(self.imgView.frame.size, YES, 4);
    //
    //    [_imgViewSuperView drawViewHierarchyInRect:self.imgView.frame afterScreenUpdates:YES];
    //
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    UIImageView *img = [[UIImageView alloc] initWithImage:image];
    //
    //    self.imgView.image=img.image;
    //
    //    NSDictionary *userinfo=@{@"finalEffect":self.imgView.image};
    //
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"FinalEffect" object:self userInfo:userinfo];
    //
    //    [hud hideAnimated:YES];
    //
    //    [self.navigationController popViewControllerAnimated:YES];
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CGSize size = [childd frame].size;
    [_sticView.cancel setHidden:YES];
    [_sticView removeBorder];
    UIGraphicsBeginImageContextWithOptions(size,NO,2.0);
    [[childd layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *drawingViewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //[_DrawingBoard addSubview:img];
    UIGraphicsEndImageContext();
    
    imageViewStick.image=drawingViewImage;
    
    NSDictionary *userinfo=@{@"finalEffect":imageViewStick.image};
    
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
