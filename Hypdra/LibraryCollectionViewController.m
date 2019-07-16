//
//  LibraryCollectionViewController.m
//  Montage
//  Created by MacBookPro on 9/21/17.
//  Copyright © 2017 sssn. All rights reserved.


#import "LibraryCollectionViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "CVCell.h"
#import "LibraryButtonaViewController.h"
#import "DEMORootViewController.h"
#import "MBProgressHUD.h"
#import "WYPopoverController.h"
#import "PopUpViewController.h"
#import "CallToActionPlayerController.h"
#import "Reachability.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

@interface LibraryCollectionViewController ()<ClickDelegates>
{
    UITextView *txtView;
    NSMutableArray *thumbImg,*idArray;
    NSMutableArray *DataFromServer;
    MBProgressHUD *hud;
    WYPopoverController *popoverController;
    NSInteger index;
    PopUpViewController *vc;
}

@end

@implementation LibraryCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useForVideoLibrary) name:@"CallToActionUseforVideoLibrary" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ButtonEditLibrary) name:@"CallToActionEditLibrary" object:nil];
    // Do any additional setup after loading the view.
    // UIColor *clr=[UIColor blueColor];
    thumbImg=[[NSMutableArray alloc]init];
    idArray=[[NSMutableArray alloc]init];
    
    //self.cv.contentInset=UIEdgeInsetsMake(20, 5, 5, 5);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.cv setCollectionViewLayout:flowLayout];
    self.cv.contentInset=UIEdgeInsetsMake(5, 5, 5, 5);

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"popUpVC"];
    vc.fromLib=@"yes";
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:vc];
    popoverController.delegate = self;
    popoverController.popoverContentSize = CGSizeMake(140, 85);

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getAction];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallToActionEditLibrary" object:nil];
    
[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallToActionUseforVideoLibrary" object:nil];
    
    [popoverController dismissPopoverAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    
    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
    NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"thumb count:%lu",(unsigned long)thumbImg.count);
    return [thumbImg count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    NSString *cellId=@"CVCell";
    
    CVCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSURL *imageURL = [NSURL URLWithString:[thumbImg objectAtIndex:indexPath.row]];
    [cell.imgView  sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"buket.png"]];
    
    //    if(indexPath.row == thumbImg.count-1)
    //    {
    //        NSLog(@"hide loading");
    //        [hud hideAnimated:YES];
    //    }
    //    else
    //    {
    //        NSLog(@"not hide loading");
    //    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView layout");
    
    CGFloat picDimension;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        picDimension = self.view.frame.size.width / 3.08f;
    }
    else
    {
        picDimension = self.view.frame.size.width / 3.18f;
        
    }
    
    return CGSizeMake(picDimension, picDimension/2);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    /* int numberOfCellInRow = 3;
//     CGFloat cellWidth =  [[UIScreen mainScreen] bounds].size.width/numberOfCellInRow;
//     
//     return CGSizeMake(cellWidth, cellWidth);*/
//    
//    NSURL *imageURL = [NSURL URLWithString:thumbImg[indexPath.row]];
//    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//    UIImage *img = [UIImage imageWithData:imageData];
//    
//    NSLog(@"width:%f \n height:%f",img.size.width,img.size.height);
//    
//    CGFloat height = img.size.height;
//    CGFloat width  = img.size.width;
//    
//    if(img.size.width<200)
//    {
//        return CGSizeMake(width*0.3,height*0.3);
//    }
//    else
//    {
//        return CGSizeMake(width*0.2, height*0.2);
//    }
//}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[idArray objectAtIndex:indexPath.row] isEqualToString:@"555"])
    {
        NSLog(@"Entered");
    }
    else
    {
        NSLog(@"else begin");
        
        //        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //
        //        LibraryButtonaViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"createButtonPage"];
        //        vc.buttonArray=[DataFromServer objectAtIndex:indexPath.row];
        //        vc.editFrom=@"Lib";
        //        UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:vc];
        //
        //        [self presentViewController:navigationController animated:YES completion:nil];
        
        
        /*UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         //
         //        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
         //
         //        [vc awakeFromNib:@"contentController_13" arg:@"menuController"];
         //
         //        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         
         /*    LibraryButtonaViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"createButtonPage"];
         vc.buttonArray=[DataFromServer objectAtIndex:indexPath.row];
         vc.editFrom=@"Lib";
         
         [self.navigationController pushViewController:vc animated:YES];*/
        
        NSString *cellId=@"CVCell";
        
        CVCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        
        index=indexPath.row;
        
        [popoverController presentPopoverFromRect:cell.frame inView:self.cv permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    }
    
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

-(void)ButtonEditLibrary
{
    [popoverController dismissPopoverAnimated:YES];
    
    if([[idArray objectAtIndex:index] isEqualToString:@"555"])
    {
        NSLog(@"Entered");
    }
    else
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LibraryButtonaViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"createButtonPage"];
        vc.buttonArray=[DataFromServer objectAtIndex:index];
        vc.editFrom=@"Lib";
        
        // [self presentViewController:navigationController animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        //        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //
        //        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        //        LibraryButtonaViewController *vc1=[mainStoryBoard instantiateViewControllerWithIdentifier:@"createButtonPage"];
        //                vc1.buttonArray=[DataFromServer objectAtIndex:index];
        //                vc1.editFrom=@"Lib";
        //
        //        [vc awakeFromNib:@"contentController_13" arg:@"menuController"];
        //
        //        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //        [self presentViewController:vc animated:YES completion:NULL];
    }
}

-(void)useForVideoLibrary
{
    [popoverController dismissPopoverAnimated:YES];
    
    NSString *imgPath=[[DataFromServer objectAtIndex:index]objectForKey:@"img_with_txt"];
    
    [[NSUserDefaults standardUserDefaults]setObject:imgPath forKey:@"calltoActionImagePath"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainSB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CallToActionPlayerController *vc=[mainSB instantiateViewControllerWithIdentifier:@"CallToActionPlayer"];
    vc.imgPath = imgPath;
    [self.navigationController pushViewController:vc animated:YES];
    //    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //    [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
    //
    //    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //    [self presentViewController:vc animated:YES completion:NULL];
}

-(void)getAction
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    NSMutableArray *arr = [[NSMutableArray alloc]init];

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
//            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        //
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=call_to_action_image";
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              
              if (!error)
              {
                  NSLog(@"Response from web: %@", responseObject);
                  
                  DataFromServer=[responseObject valueForKey:@"view_call_to_action_image"];
                  
                  for(NSDictionary *imageDic in DataFromServer)
                  {
                      
                      NSString *thumb_img_path = [imageDic objectForKey:@"img_with_txt"];
                      [thumbImg addObject:thumb_img_path];
                      
                      //NSLog(@"count:%lu",thumbImg.count);
                      
                      NSString *idValue =[imageDic objectForKey:@"icon_compare_id"];
                      
                      [idArray addObject:idValue];

                  }
                  //PERFORM BATCH UPDATES CODING
                 /* NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                  
                  for(int j=0;j<idArray.count;j++){
                      
                      [thumbImg addObject:[arr objectAtIndex:j]] ;
                      [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:j inSection:0]];
                  }
                  [self.cv performBatchUpdates:^{
                      [self.cv insertItemsAtIndexPaths:arrayWithIndexPaths];
                  } completion:nil];*/
                  //PERFORM BATCH UPDATES CODING

                  [self.cv reloadData];
                  [hud hideAnimated:YES];
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response,  responseObject);
                  
                  [hud hideAnimated:YES];
              }
              
          }]resume];
    }
}
-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}
@end

