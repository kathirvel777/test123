//
//  UserMusicCategory.m
//  Montage
//
//  Created by MacBookPro on 6/3/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "UserMusicCategory.h"
#import "UserMusicCell.h"
#import "DEMORootViewController.h"
#import "WizardAddTitileViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "Reachability.h"

@interface UserMusicCategory ()<ClickDelegates>
{
    NSString *user_id,*deleteName;
    NSMutableArray *MusicName;
    int HigestImageCount;
    NSData *Musicdata;
    NSMutableURLRequest *request;
    
    NSString *songTitle;
    
    NSString *finalAudioID;
    
    NSString *globalDataPath;
    
    NSIndexPath *selectedValue;
    
    int keyIndex;
    
    NSMutableArray *MainArray;
    
    int selected_cell_index;
    
    NSString *cropAudioPath,*cropAudioName;
    MBProgressHUD *hud_1;
    
    
}

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation UserMusicCategory

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    // [flowLayout setSectionInset:UIEdgeInsetsMake(2, 2, 2, 2)];
    
    self.collectionView.bounces = false;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // [flowLayout setSectionInset:UIEdgeInsetsMake(2, 2, 2, 2)];
    
    selected_cell_index = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"SelectedIndex"];
    user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_ID"];
    MainArray= [[NSMutableArray alloc]init];
    _collectionView.contentInset=UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.done.enabled = false;
    
    [self getmusicfromlocal];
    
    
    _currentWindow = [UIApplication sharedApplication].keyWindow;
    
    _BlurView = [[UIView alloc]initWithFrame:CGRectMake(_currentWindow.frame.origin.x, _currentWindow.frame.origin.y, _currentWindow.frame.size.width, _currentWindow.frame.size.height)];
    
    _BlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewDidLayoutSubviews
{
    self.secondView.frame = CGRectMake(0,  self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
    //
    NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    [self.done setTintColor:[UIColor clearColor]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //    [self.done setTintColor:[UIColor clearColor]];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
}


-(void)getmusicfromlocal
{
    HigestImageCount=0;
    
    MusicName = [[NSMutableArray alloc]init];
    
    
    @try
    {
        
        NSLog(@"Enter Music Group");
        
        hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud_1.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud_1.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_particular_user_audio_dtls";
        
        NSDictionary *parameters = @{@"user_id":user_id,@"lang":@"iOS"};
        
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
                  //isAnyMusicAction=NO;
                  NSMutableDictionary *response=responseObject;
                  
                  NSLog(@"Music Response = %@",response);
                  
                  NSArray *MusicArray = [response objectForKey:@"view_particular_user_audio_dtls"];
                  
                  MusicName = [[NSMutableArray alloc]init];
                  
                  NSArray *statusArray = [response objectForKey:@"Response_array"];
                  
                  NSDictionary *stsDict = [statusArray objectAtIndex:0];
                  
                  NSString *status = [stsDict objectForKey:@"msg"];
                  
                  if ([status isEqualToString:@"Found"])
                  {
                      MusicName=[MusicArray mutableCopy];
                      
                      
                      [hud_1 hideAnimated:YES];
                      
                  }
                  else
                  {
                      NSLog(@"Music Not Found..");
                      [hud_1 hideAnimated:YES];
                      
                  }
              }
              else
              {
                  NSLog(@"Error for Music :");
                  [hud_1 hideAnimated:YES];
              };
              
              if (MusicName.count == 0)
              {
                  self.collectionView.hidden = true;
                  // self.pageView.hidden = false;
              }
              else
              {
                  self.collectionView.hidden = false;
                  //self.pageView.hidden = true;
                  [self.collectionView reloadData];
                  
                  
              }
          }]resume];
    }
    @catch(NSException *exc)
    {
        NSLog(@"Music Catch:%@",exc);
        [hud_1 hideAnimated:YES];
    }
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MusicName.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Index = %ld",(long)indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    UserMusicCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.borderWidth = 0.2f;
    
    cell.alpha = 1.0;
    
    // cell.selectedMusic.hidden = true;
    
    NSDictionary *dic = [MusicName objectAtIndex:indexPath.row];
    
    NSString *StringId = [dic valueForKey:@"aud_id"];
    NSString *Title = [dic valueForKey:@"Audio_name"];
    NSLog(@"Music Title song:%@",Title);
    cell.title.text=Title;
    cell.play_btn.tag = indexPath.row;
    [cell.play_btn addTarget:self action:@selector(play_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    //    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-border.png"]];
    
    
    //SHADOW WITH CORNER RADIUS
    
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
    //SHADOW WITH CORNER RADIUS
    
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        cell.selectedMusic.hidden = false;
    }
    else
    {
        cell.selectedMusic.hidden = true;
    }
    
    
    return cell;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    return CGSizeMake(picDimension, picDimension);
    
}



/*
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 { NSLog(@"collectionView layout");
 
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
 
 }*/
/*
 - (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
 {
 UserMusicCell *cell = (UserMusicCell*)[collectionView  cellForItemAtIndexPath:indexPath];
 
 cell.alpha = 1;
 
 cell.selectedMusic.hidden = true;
 
 }*/


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    keyIndex = -1;
    
    [self.done setTintColor:[UIColor clearColor]];
    
    self.done.enabled = false;
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    keyIndex = (int)indexPath.row;
    
    /*    [self.done setTintColor:[UIColor whiteColor]];
     
     self.done.enabled = true;*/
    
    
    
    /*    if (!selectedValue)
     {
     UICollectionViewCell* cellValue = [collectionView  cellForItemAtIndexPath:selectedValue];
     
     cellValue.alpha = 1.0;
     
     UserMusicCell *cell = (UserMusicCell*)[collectionView  cellForItemAtIndexPath:indexPath];
     
     //        cell.alpha = 0.1;
     
     cell.selectedMusic.hidden = false;
     }
     else
     {
     selectedValue = indexPath;
     
     UserMusicCell *cell = (UserMusicCell*)[collectionView  cellForItemAtIndexPath:indexPath];
     
     //        cell.alpha = 0.1;
     
     cell.selectedMusic.hidden = false;
     }*/
    //    finalPath = [contentPath objectAtIndex:indexPath.row];
    //    finalID = [musicID objectAtIndex:indexPath.row];
    
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            [self.done setTintColor:[UIColor clearColor]];
            
            self.done.enabled = false;
            
            self.selectedItemIndexPath = nil;
        }
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
            
            [self.done setTintColor:[UIColor whiteColor]];
            
            self.done.enabled = true;
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        
        self.selectedItemIndexPath = indexPath;
        
        [self.done setTintColor:[UIColor whiteColor]];
        
        self.done.enabled = true;
    }
    
    // and now only reload only the cells that need updating
    
    //    keyIndex = (int)indexPath.row;
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
    
    
    
    
    //    NSLog(@"Final Link = %@",finalPath);
    
    
    //    [self tempMove];
    
}

-(void)tempMove
{
    
    NSDictionary *dic = [MusicName objectAtIndex:keyIndex];
    NSString *StringId = [dic valueForKey:@"MusicId"];
    
    //Chcking MainArray
    MainArray=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainArray"]];
    
    NSLog(@"MainArray_didLoad_1 %@",MainArray);
    
    if(MainArray == nil )
    {
        MainArray= [[NSMutableArray alloc]init];
    }
    //Chcking MainArray
    
    NSMutableDictionary *finalDic = [MainArray objectAtIndex:selected_cell_index];
    
    [finalDic setValue:@"user" forKey:@"music_type"];
    [finalDic setValue:StringId forKey:@"music"];
    
    [MainArray replaceObjectAtIndex:selected_cell_index withObject:finalDic];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
    [defaults synchronize];
    
    NSLog(@"MainArray_cellLoad %@",MainArray);
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)done:(id)sender
{
    NSString *option=[[NSUserDefaults standardUserDefaults]objectForKey:@"isWizardOrAdvance"];
    NSLog(@"Wizard Option:%@",option);
    
    NSDictionary *dic = [MusicName objectAtIndex:keyIndex];
    NSString *StringId = [dic valueForKey:@"aud_id"];
    
    if([option isEqualToString:@"Wizard"])
    {
        hud_1=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSLog(@"Wizard music id:%@",StringId);
        [[NSUserDefaults standardUserDefaults]setObject:StringId forKey:@"WizardMusicId"];
        [[NSUserDefaults standardUserDefaults]setObject:@"user" forKey:@"WizardMusictype"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
//
//        WizardAddTitileViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddTitle"];
//
//        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    }
    
    else
    {
        
        //Chcking MainArray
        
        MainArray=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainArray"]];
        NSLog(@"MainArray_didLoad_1 %@",MainArray);
        if(MainArray == nil ){
            MainArray= [[NSMutableArray alloc]init];
        }
        
        //Generating Random Color
        CGFloat hue = ( arc4random() % 256 / 256.0 ); // 0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        NSString *colorString = [self hexStringFromColor:color];
        
        //Chcking MainArray
        
        NSMutableDictionary *finalDic = [MainArray objectAtIndex:selected_cell_index];
        [finalDic setValue:@"user" forKey:@"music_type"];
        [finalDic setValue:StringId forKey:@"music"];
        [finalDic setValue:@"1" forKey:@"music_color_identification"];
        [finalDic setValue:colorString forKey:@"music_color"];
        
        for(int i=selected_cell_index+1;i<MainArray.count;i++){
            
            NSMutableDictionary *finalDic = [MainArray objectAtIndex:i];
            if([[finalDic valueForKey:@"music_color_identification"] isEqualToString:@"0"]){
                [finalDic setValue:@"user" forKey:@"music_type"];
                [finalDic setValue:StringId forKey:@"music"];
                [finalDic setValue:colorString forKey:@"music_color"];
                
                [MainArray replaceObjectAtIndex:i withObject:finalDic];
            }else{
                break;
            }
        }
        [MainArray replaceObjectAtIndex:selected_cell_index withObject:finalDic];
        //Generating Final
        
        //UPDAteMainArrayUserDefaults
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
        [defaults synchronize];
        //UPDAteMainArrayUserDefaults
        
        NSLog(@"MainArray_cellLoad %@",MainArray);
        
        NSLog(@"user music MainArray_cellLoad %@",MainArray);
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
}



- (IBAction)back:(id)sender
{
    NSString *option=[[NSUserDefaults standardUserDefaults]objectForKey:@"isWizardOrAdvance"];
    if([option isEqualToString:@"Wizard"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardMusicId"];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];
        
        /* UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
         
         DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
         
         [vc awakeFromNib:@"contentController_7" arg:@"menuController"];
         
         vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         
         [self presentViewController:vc animated:YES completion:NULL];*/
        
    }
    else
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CreateNewFinalDic"];
    }
}
-(NSString*)hexStringFromColor:(UIColor*)color
{
    NSString *webColor = nil;
    
    // This method only works for RGB colors
    if (color &&
        CGColorGetNumberOfComponents(color.CGColor) == 4)
    {
        // Get the red, green and blue components
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        // These components range from 0.0 till 1.0 and need to be converted to 0 till 255
        CGFloat red, green, blue;
        red = roundf(components[0] * 255.0);
        green = roundf(components[1] * 255.0);
        blue = roundf(components[2] * 255.0);
        
        // Convert with %02x (use 02 to always get two chars)
        webColor = [[NSString alloc]initWithFormat:@"#%02x%02x%02x", (int)red, (int)green, (int)blue];
    }
    return webColor;
}
-(void)play_btn:(UIButton*)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
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
        
      //  isAnyMusicAction=YES;
        
        
        
        NSString *sendIndex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
         [self okButtonsPressed:sendIndex];
        
    }
    
}

- (void)okButtonsPressed:(NSString*)getIndex
{
    NSLog(@"Play Action");
    
    int i=[getIndex intValue];
    
    NSString *urlString=[[MusicName objectAtIndex:i]valueForKey:@"Audio_Path"];
    
    NSURL *url=[[NSURL alloc] initWithString:urlString];
    
    AVPlayer *player = [AVPlayer playerWithURL:url];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    
    [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
    
    controller.allowsPictureInPicturePlayback = YES;
    
    [self presentViewController:controller animated:YES completion:nil];
    
    controller.player = player;
    [player play];
}

@end

