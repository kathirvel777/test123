//  CallToActionCollectionViewController.m
//  Montage
//  Created by Mac on 7/20/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "CallToActionCollectionViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DEMORootViewController.h"
#import "UIImageView+WebCache.h"
#import "CallToActionCollectionViewController.h"
#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "CreateButtonsViewController.h"
#import "LibraryButtonaViewController.h"
#import "CallToActionPlayerController.h"

@interface CallToActionCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,WYPopoverControllerDelegate>
{
    NSMutableArray *finalGif,*finalID,*finalImage,*MainArray;
    
    NSString *user_id;
    NSMutableURLRequest *request;
    NSMutableArray *imageArray,*imgArray;
    NSString *imgName;
    
    NSIndexPath *selectedValue;
    
    MBProgressHUD *hud;
    NSIndexPath *SelectedIndexPath;
    
    NSString *pathValue,*idValue,*pathGif;
    int selected_cell_index;
    
    WYPopoverController *popoverController;
    PopUpViewController *vc;
}

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property (strong, nonatomic) TWTweetComposeViewController *tweetView;


@end

@implementation CallToActionCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageArray=[[NSMutableArray alloc]init];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"popUpVC"];
    popoverController = [[WYPopoverController alloc ]initWithContentViewController:vc];
    vc.fromLib=@"no";
    popoverController.delegate = self;
    popoverController.popoverContentSize = CGSizeMake(140, 150);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.collection setCollectionViewLayout:flowLayout];
    
    //[flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SelectedIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.collection.bounces = false;
    
    NSLog(@"SelectedValue = %@",selectedValue);
    
    finalID = [[NSMutableArray alloc]init];
    
    finalGif = [[NSMutableArray alloc]init];
    
    MainArray = [[NSMutableArray alloc]init];
    
    self.collection.bounces = false;
    selected_cell_index = [[NSUserDefaults standardUserDefaults]integerForKey:@"SelectedIndex"];
    self.collection.contentInset=UIEdgeInsetsMake(5, 5, 5, 5);
    
    
    //    _tweetView = [[TWTweetComposeViewController alloc] init];
    //
    //    TWTweetComposeViewControllerCompletionHandler
    //    completionHandler =
    //    ^(TWTweetComposeViewControllerResult result) {
    //        switch (result)
    //        {
    //            case TWTweetComposeViewControllerResultCancelled:
    //                NSLog(@"Twitter Result: canceled");
    //                break;
    //            case TWTweetComposeViewControllerResultDone:
    //                NSLog(@"Twitter Result: sent");
    //                break;
    //            default:
    //                NSLog(@"Twitter Result: default");
    //                break;
    //        }
    //        [self dismissModalViewControllerAnimated:YES];
    //    };
    //    [_tweetView setCompletionHandler:completionHandler];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
    [dic setValue:@"arunraj.d@gmail.com" forKey:@"email"];
    [dic1 setValue:@"mobileappdeveloper10@gmail.com" forKey:@"email"];
    
    imgArray = [[NSMutableArray alloc]init];
    
    [MainArray addObject:dic1];
    [MainArray addObject:dic];
    //    _blurView = [[UIView alloc]initWithFrame:self.collection.bounds];
    //    _blurView.backgroundColor = [UIColor colorWithRed:0.0000 green:0.0000 blue:0.0000 alpha:0.5];
    //    [self.collection.superview addSubview:_blurView];
    //    _blurView.hidden = YES;
    
    // [self setParams];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [popoverController dismissPopoverAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    finalImage = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useForVideo) name:@"CallToActionUseforVideo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteButton) name:@"Delete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ButtonEdit) name:@"CallToActionEdit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonDuplicate) name:@"Duplicate" object:nil];
    
    [self loadTransitionData];
    
    //    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    //
    // //[navigationArray removeAllObjects];
    //    if(navigationArray.count > 3){
    //
    //        [navigationArray removeLastObject];  // You can pass your index here
    //        self.navigationController.viewControllers = navigationArray;
    //    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [imageArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    CallToActionCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //  cell.layer.borderColor = [UIColor blackColor].CGColor;
    //    cell.layer.borderWidth = 0.2f;
    
    cell.alpha = 1.0;
    NSURL *imageURL = [NSURL URLWithString:[finalImage objectAtIndex:indexPath.row]];
    //    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    //    UIImage *image = [UIImage imageWithData:imageData];
    NSLog(@"imageURL %@",[finalImage objectAtIndex:indexPath.row]);
    //    cell.imgView.contentMode = UIViewContentModeCenter;
    cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
    // cell.selectedImage.hidden = true;
    
    //cell.layer.borderColor = [UIColor blackColor].CGColor;
    
    // cell.ImgView.image = img;
    
    
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        //cell.selectedImage.hidden = false;
    }
    else
    {
        // cell.selectedImage.hidden = true;
    }
    
    
    return cell;
}
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will selectrowatindexpat");
    return indexPath;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  [self.done setTintColor:[UIColor whiteColor]];
    _selectedItemIndexPath=indexPath;
    /*  pathValue = nil;
     idValue = nil;
     //   pathGif = nil;.
     
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
     
     pathValue = [finalImage objectAtIndex:indexPath.row];
     idValue  = [finalID objectAtIndex:indexPath.row];
     //    pathGif = [finalGif objectAtIndex:indexPath.row];
     
     [collectionView reloadItemsAtIndexPaths:indexPaths];*/
    
    //  [self done];
    
    //  [imageArray removeObjectAtIndex:indexPath.row];
    
    //  NSArray *path=@[indexPath];
    
    //  [self.collection deleteItemsAtIndexPaths:path];
    
    /*    NSLog(@"ImageArray = %@",imageArray);
     
     NSLog(@"ImageArray First = %@",imageArray[0]);
     
     NSLog(@"ImageArray Count = %lu",(unsigned long)imageArray.count);
     
     [imageArray removeObjectAtIndex:indexPath.row];
     
     NSArray *path=@[indexPath];
     [self.collection deleteItemsAtIndexPaths:path];*/
    //[self deleteButton];
    UICollectionViewLayoutAttributes *attributes = [self.collection layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellFrameInSuperview = [collectionView convertRect:attributes.frame toView:[collectionView superview]];
    _HighLightImgVIew = [[UIImageView alloc]initWithFrame:cellFrameInSuperview];
    _blurView.hidden = NO;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         _HighLightImgVIew.transform=CGAffineTransformMakeScale(1.1, 1.1);
                     }
                     completion:^(BOOL finished){
                         //imgView.transform=CGAffineTransformIdentity;
                     }];
    _HighLightImgVIew.contentMode = UIViewContentModeScaleAspectFit;
    
    NSURL *imageURL = [NSURL URLWithString:[finalImage objectAtIndex:indexPath.row]];
    
    [_HighLightImgVIew sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
    [self.collection.superview addSubview:_HighLightImgVIew];
    
    static NSString *CellIdentifier = @"Cell";
    
    CallToActionCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [popoverController presentPopoverFromRect:cell.frame inView:self.collection permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    _blurView.hidden=YES;
    [_HighLightImgVIew removeFromSuperview];
    _HighLightImgVIew = nil;
    return YES;
}


-(void)useForVideo
{
    //
    
    //}
    
    //{
    
    [popoverController dismissPopoverAnimated:YES];
    _blurView.hidden = YES;
    [_HighLightImgVIew removeFromSuperview];
    _HighLightImgVIew = nil;
    NSString *imgPath=[[imageArray objectAtIndex:_selectedItemIndexPath.row]objectForKey:@"image_path"];
    [[NSUserDefaults standardUserDefaults]setObject:imgPath forKey:@"calltoActionImagePath"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainSB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CallToActionPlayerController *vc=[mainSB instantiateViewControllerWithIdentifier:@"CallToActionPlayer"];
    vc.imgPath=imgPath;
    
    [self.navigationController pushViewController:vc animated:YES];
    //    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //    [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
    //
    //    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)deleteButton
{
    NSLog(@"delete123 called");
    [popoverController dismissPopoverAnimated:YES];
    _blurView.hidden = YES;
    [_HighLightImgVIew removeFromSuperview];
    _HighLightImgVIew = nil;
    NSString *imgID=[[imageArray objectAtIndex:_selectedItemIndexPath.row]objectForKey:@"id"];
    NSLog(@"Delete img id:%@",imgID);
    
    @try
    {
        NSString *URLString=@"https://hypdra.com/api/api.php?rquest=delete_user_call_to_action_img";
        
        NSDictionary *params = @{@"user_id":user_id,@"img_id":imgID,@"lang":@"iOS"};
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
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
                  NSLog(@"Delete Response:%@",responseObject);
                  
                  [imageArray removeObjectAtIndex:_selectedItemIndexPath.row];
                  NSLog(@"ImageArray after deleted:%@",imageArray);
                  NSInteger currentRow = _selectedItemIndexPath.row;
                  NSLog(@"currentRow:%d",currentRow);
                  NSIndexPath *path=[NSIndexPath indexPathForRow:_selectedItemIndexPath.row inSection:0];
                  
                  NSArray *deleteItems = @[path];
                  NSLog(@"DeletedItems:%@",deleteItems);
                  [self.collection deleteItemsAtIndexPaths:deleteItems];
                  //[self.collection reloadData];
                  [hud hideAnimated:YES];
                  
              }
          }]resume];
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
    
}

-(void)ButtonEdit
{
    NSMutableDictionary *finalDic = [imageArray objectAtIndex:self.selectedItemIndexPath.row];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [popoverController dismissPopoverAnimated:YES];
    _blurView.hidden = YES;
    [_HighLightImgVIew removeFromSuperview];
    _HighLightImgVIew = nil;
    
    NSLog(@"finalDic %@",finalDic);
    if( [[finalDic valueForKey:@"type"] isEqualToString:@"create_button"])
    {
        NSLog(@"Created");
        CreateButtonsViewController *vc = [self.tabBarController.viewControllers objectAtIndex:1];
        
        if(![[finalDic valueForKey:@"border_color"] isEqualToString:@"Null"])
        {
            vc.border_color = [self colorWithHexString:[finalDic valueForKey:@"border_color"]];
        }
        if(![[finalDic valueForKey:@"bg_color"] isEqualToString:@"Null"])
        {
            vc.bg_color =[self colorWithHexString:[finalDic valueForKey:@"bg_color"]];
        }
        if(![[finalDic valueForKey:@"text_color"] isEqualToString:@"Null"])
        {
            vc.text_color = [self colorWithHexString:[finalDic valueForKey:@"text_color"]];
        }
        if(![[finalDic valueForKey:@"border_radius"] isEqualToString:@"Null"])
        {
            vc.border_radius = [(NSString *)[finalDic valueForKey:@"border_radius"] floatValue];
        }
        if(![[finalDic valueForKey:@"border_width"] isEqualToString:@"Null"])
        {
            NSString *tem = [finalDic valueForKey:@"border_width"];
            
            vc.border_width = [tem floatValue];
        }
        if(![[finalDic valueForKey:@"clip_layout_height"] isEqualToString:@"Null"])
        {
            vc.clip_layout_height = [(NSString *)[finalDic valueForKey:@"clip_layout_height"] floatValue];
            NSLog(@"clip_layout_height %f",vc.clip_layout_height);
        }
        if(![[finalDic valueForKey:@"clip_layout_width"] isEqualToString:@"Null"])
        {
            vc.clip_layout_width = [(NSString *)[finalDic valueForKey:@"clip_layout_width"] floatValue];
            NSLog(@"clip_layout_width %f",vc.clip_layout_width);
        }
        if(![[finalDic valueForKey:@"clip_text_height"] isEqualToString:@"Null"])
        {
            vc.clip_text_height = [(NSString *)[finalDic valueForKey:@"clip_text_height"] floatValue];
            NSLog(@"clip_text_height %f",vc.clip_text_height);
        }
        if(![[finalDic valueForKey:@"clip_text_left"] isEqualToString:@"Null"])
        {
            vc.clip_text_left = [(NSString *)[finalDic valueForKey:@"clip_text_left"] floatValue];
            NSLog(@"clip_text_left %f",vc.clip_text_left);
        }
        if(![[finalDic valueForKey:@"clip_text_top"] isEqualToString:@"Null"])
        {
            vc.clip_text_top = [(NSString *)[finalDic valueForKey:@"clip_text_top"] floatValue];
            NSLog(@"clip_text_top %f",vc.clip_text_top);
        }
        if(![[finalDic valueForKey:@"clip_text_width"] isEqualToString:@"Null"])
        {
            vc.clip_text_width = [(NSString *)[finalDic valueForKey:@"clip_text_width"] floatValue];
            NSLog(@"clip_text_width %f",vc.clip_text_width);
        }
        if(![[finalDic valueForKey:@"text_size"] isEqualToString:@"Null"])
        {
            vc.text_size = [(NSString *)[finalDic valueForKey:@"text_size"] floatValue];
            NSLog(@"text_size %f",vc.text_size);
        }
        if(![[finalDic valueForKey:@"font_case_upper_lower"] isEqualToString:@"Null"])
        {
            vc.font_case_upper_lower = (NSString *)[finalDic valueForKey:@"font_case_upper_lower"];
            NSLog(@"font_style %@",vc.font_style);
        }
        
        vc.font_style = (NSString *)[finalDic valueForKey:@"font_style"];
        NSLog(@"font_style %@",vc.font_style);
        
        // vc.fromCollection=YES;
        
        vc.text = (NSString *)[finalDic valueForKey:@"text"];
        
        [defaults setBool:YES forKey:@"ReEdit"];
        [defaults synchronize];
        
        self.tabBarController.selectedViewController = vc;
        self.tabBarController.selectedIndex = 1;
    }
    else if([[finalDic valueForKey:@"type"] isEqualToString:@"Library"])
    {
        NSLog(@"Lib");
        
        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LibraryButtonaViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"createButtonPage"];
        vc.buttonArray=[imageArray objectAtIndex:_selectedItemIndexPath.row];
        vc.editFrom=@"reEdit";
        
        //  UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:vc];
        
        // [self presentViewController:navigationController animated:YES completion:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
    [defaults synchronize];
    
}
-(void)buttonDuplicate
{
    
    NSLog(@"duplic called");
    
    [popoverController dismissPopoverAnimated:YES];
    _blurView.hidden = YES;
    [_HighLightImgVIew removeFromSuperview];
    _HighLightImgVIew = nil;
    // NSString *imgID=[[imageArray objectAtIndex:_selectedItemIndexPath.row]objectForKey:@"id"];
    NSString *imgID=[finalID objectAtIndex:_selectedItemIndexPath.row];
    NSLog(@"Duplicate img id:%@",imgID);
    
    @try
    {
        NSDictionary *params =@{@"Image_ID":imgID,@"lang":@"iOS"};
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=duplicate_user_call_to_action_button";
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
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
                  
                  NSLog(@"The resp for cv cta %@",responseObject);
                  
                  NSDictionary *dic=responseObject;
                  NSString *status=[dic objectForKey:@"status"];
                  
                  if([status isEqualToString:@"True"])
                  {
                      [finalID removeAllObjects];
                      [finalImage removeAllObjects];
                      
                      [self loadTransitionData];
                  }
                  
              }
          }]resume];
    }
    
    @catch(NSException *exception)
    {
        
    }
}

-(void)loadTransitionData
{
    @try
    {
        imageArray=[[NSMutableArray alloc]init];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSDictionary *params =@{@"user_id":user_id,@"lang":@"iOS"};
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=view_user_call_to_action_image";
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
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
                  NSMutableDictionary *response=responseObject;
                  NSMutableArray *aa =  [response objectForKey:@"view_user_call_to_action_image"];
                  NSLog(@"view_user_call_to_action_image %@",aa);
                  for(int i=0;i<aa.count;i++)
                  {
                      NSDictionary *d=[aa objectAtIndex:i];
                      [imageArray addObject:d];
                  }
                  
                  
                  NSString *status = [response objectForKey:@"msg"];
                  
                  
                  
                  for(NSDictionary *imageDic in imageArray)
                  {
                      NSString *imageUrl = [imageDic objectForKey:@"image_path"];
                      NSString *image_id = [imageDic objectForKey:@"id"];
                      // NSString *gifURL = [imageDic objectForKey:@"final_gif"];
                      [finalImage addObject:imageUrl];
                      // [finalGif addObject:gifURL];
                      [finalID addObject:image_id];
                      
                  }
                  //             NSLog(@"Transition = %@",responseObject);
                  //
                  [self.collection reloadData];
                  //
                  [hud hideAnimated:YES];
                  
              }
              else
              {
                  NSLog(@"Error9: %@", error);
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

//-(void)setParams
//{
//
//    NSLog(@"Send Album");
//    NSString *jsonString;
//    NSError *error;
//
//    NSDictionary *fDict = @{@"FinalTemplates":MainArray};
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fDict options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//        error:&error];
//    if (! jsonData)
//    {
//        NSLog(@"Got an error: %@", error);
//    } else
//    {
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
//    }
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
//
//    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
//    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//    //    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//
//    [manager.requestSerializer setTimeoutInterval:150];
//
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    manager.responseSerializer = [AFJSONResponseSerializer
//                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
//
//    //            NSDictionary *params = @{@"User_Name":@"Ragu",@"Email_ID": self.email.text,@"Password":self.password.text,};
//    NSLog(@"User Id %@",user_id);
//
//    NSDictionary *params = @{@"FriendsDetails":jsonString,@"User_Id": user_id,@"lang":@"ios"};
//
//    NSLog(@"NSData %@",jsonString);
//
//    /*    [manager POST:@"http://108.175.2.116/montage/api/api.php?rquest=advance_final_details" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
//     {
//     NSLog(@"FinalVideoResponse %@",responseObject);
//     }
//     failure:^(NSURLSessionTask *operation, NSError *error)
//     {
//     NSLog(@"Error Video Build: %@", error);
//     //responseBlock(nil, FALSE, error);
//     }];*/
//
//
//    [manager POST:@"https://www.hypdra.com/api/api.php?rquest=InviteFriendsThroughEmail" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
//     {
//         NSLog(@"Send Album");
//
//         NSLog(@"InviteEmailResponse: %@", responseObject);
//     }
//          failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//         NSLog(@"Error Video Build: %@", error);
//     }];
//}

- (UIColor *) colorWithHexString: (NSString *) hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    NSLog(@"colorString :%@",colorString);
    CGFloat alpha, red, blue, green;
    
    // #RGB
    alpha = 1.0f;
    red   = [self colorComponentFrom: colorString start: 0 length: 2];
    green = [self colorComponentFrom: colorString start: 2 length: 2];
    blue  = [self colorComponentFrom: colorString start: 4 length: 2];
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

