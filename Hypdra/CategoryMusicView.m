//
//  CategoryMusicView.m
//  Montage
//
//  Created by MacBookPro on 5/3/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "CategoryMusicView.h"
#import "AFNetworking.h"
#import "AdminMusicCell.h"
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "DEMORootViewController.h"
#import "WizardAddTitileViewController.h"
#import "AudioPlayerViewController.h"

@interface CategoryMusicView ()
{
    NSString *user_id;
    
    NSMutableArray *contentPath,*musicID,*MainArray;
    
    NSMutableURLRequest *request;
    
    NSString *finalPath,*finalID;
    
    NSIndexPath *selectedValue;
    
    MBProgressHUD *hud;
    
    MPMoviePlayerController *moviePlayer;
    int selected_cell_index;
    
}

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation CategoryMusicView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contentPath = [[NSMutableArray alloc]init];
    musicID = [[NSMutableArray alloc]init];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    [flowLayout setMinimumLineSpacing:5.0f];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.collectionView.bounces = false;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //[flowLayout setSectionInset:UIEdgeInsetsMake(2, 2, 2, 2)];
    
    selected_cell_index = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"SelectedIndex"];
    NSLog(@"selected cell index is %d",selected_cell_index);
    
    _collectionView.contentInset=UIEdgeInsetsMake(5, 5, 5, 5);

    self.done.enabled = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//-(void)viewDidLayoutSubviews
//{
//    self.secondView.frame = CGRectMake(0, self.tabBarController.tabBar.frame.size.height, self.secondView.frame.size.width, self.secondView.frame.size.height - self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
//    //
//    NSLog(@"Height's = %f", self.tabBarController.tabBar.frame.origin.y + self.tabBarController.tabBar.frame.size.height);
//}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //    montageMusic = [[NSMutableArray alloc]init];
    
    [self.done setTintColor:[UIColor clearColor]];
    
    contentPath = [[NSMutableArray alloc]init];
    musicID = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    [self loadCategory];
}


-(void)loadCategory
{
    //    dispatch_group_enter(group);
    //    dispatch_group_t sub_group=dispatch_group_create();
    //
    @try
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=view_admin_music_category_content";
        
        NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"music_category":self.categoryName};
        
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    hud.mode = MBProgressHUDModeDeterminate;
        //    hud.progress = progress;
        
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        
        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"Response = %@",responseObject);
             
             //             thumbImg = [[NSMutableArray alloc]init];
             //             randID = [[NSMutableArray alloc]init];
             //             videoPath = [[NSMutableArray alloc]init];
             //
             NSMutableDictionary *response=responseObject;
             NSArray *imageArray = [response objectForKey:@"view_admin_music_category_content"];
             //             //             NSLog(@"Image Response %@",response);
             for(NSDictionary *imageDic in imageArray)
             {
                 NSString *path = [imageDic objectForKey:@"content"];
                 NSString *mID = [imageDic objectForKey:@"id"];
                 
                 [contentPath addObject:path];
                 [musicID addObject:mID];
             }
             
             [self.collectionView reloadData];
             
             [hud hideAnimated:YES];
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             
             [hud hideAnimated:YES];
             
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Could not connect to server"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];
             
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             
         }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Finally Exception");
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [contentPath count];
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    AdminMusicCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    //    cell.selectedMusic.hidden = true;
    
    //  cell.layer.borderColor = [UIColor blackColor].CGColor;
    
    //    cell.ImgView.image = img;
    
    cell.playMusic.tag = indexPath.row;
    [cell.playMusic addTarget:self action:@selector(playMusics:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectedMusic.tag = indexPath.row;
    
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

-(void)playMusics:(UIButton*)sender
{
    
    NSLog(@"Play Music");
    
    NSString *musicURL = [contentPath objectAtIndex:sender.tag];
    //
    //    //NSString *soundFilePath = [NSString stringWithFormat:@"%@/test.m4a",[[NSBundle mainBundle] resourcePath]];
    //    NSURL *soundFileURL = [NSURL URLWithString:musicURL];
    //
    //    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    //    player.numberOfLoops = -1;
    //
    //    [player play];
    
    
    NSURL *url=[[NSURL alloc] initWithString:musicURL];
    
    //    NSURL *url=[[NSURL alloc] initWithString:@"http://108.175.2.116/montage/api/edit_image/1870121790No_title.mp4"];
    
    /*    moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDonePressed:) name:MPMoviePlayerDidExitFullscreenNotification object:moviePlayer];
     
     
     moviePlayer.controlStyle=MPMovieControlStyleDefault;
     //moviePlayer.shouldAutoplay=NO;
     
     [moviePlayer play];
     
     [self.view addSubview:moviePlayer.view];
     
     [moviePlayer setFullscreen:YES animated:YES];*/
    
    /*    AVPlayer *player = [AVPlayer playerWithURL:url];
     
     // create a player view controller
     AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
     [self presentViewController:controller animated:YES completion:nil];
     controller.player = player;
     [player play];*/
    
    
    /*    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     AudioPlayerViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AudioPlayer"];
     
     vc.playPath = musicURL;
     
     vc.sourceView = @"admin";
     
     [self.navigationController pushViewController:vc animated:YES];*/
    
    
    
    NSURL *urls=[[NSURL alloc] initWithString:musicURL];
    
    AVPlayer *player = [AVPlayer playerWithURL:urls];
    
    
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    
    [controller.contentOverlayView setBackgroundColor:[UIColor greenColor]];
    
    controller.allowsPictureInPicturePlayback = YES;
    
    [self presentViewController:controller animated:YES completion:nil];
    controller.player = player;
    [player play];
    
    
}

/*
 - (void) moviePlayBackDonePressed:(NSNotification*)notification
 {
 [moviePlayer stop];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:moviePlayer];
 
 
 if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)])
 {
 [moviePlayer.view removeFromSuperview];
 }
 moviePlayer=nil;
 }
 
 - (void) moviePlayBackDidFinish:(NSNotification*)notification
 {
 [moviePlayer stop];
 [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
 
 if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)])
 {
 [moviePlayer.view removeFromSuperview];
 }
 }*/



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


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    finalPath = @"";
    finalID = @"";
    
    [self.done setTintColor:[UIColor clearColor]];
    
    self.done.enabled = false;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*    [self.done setTintColor:[UIColor whiteColor]];
     
     self.done.enabled = true;*/
    
    
    finalPath = [contentPath objectAtIndex:indexPath.row];
    finalID = [musicID objectAtIndex:indexPath.row];
    
    
    
    //    finalID = nil;
    //    finalPath = nil;
    
    /*    if (!selectedValue)
     {
     UICollectionViewCell* cellValue = [collectionView  cellForItemAtIndexPath:selectedValue];
     
     cellValue.alpha = 1.0;
     
     AdminMusicCell* cell = (AdminMusicCell*)[collectionView  cellForItemAtIndexPath:indexPath];
     
     //        cell.alpha = 0.1;
     
     cell.selectedMusic.hidden = false;
     }
     else
     {
     selectedValue = indexPath;
     
     AdminMusicCell* cell = (AdminMusicCell*)[collectionView  cellForItemAtIndexPath:indexPath];
     
     //        cell.alpha = 0.1;
     
     cell.selectedMusic.hidden = false;
     
     
     }*/
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            self.selectedItemIndexPath = nil;
            
            [self.done setTintColor:[UIColor clearColor]];
            
            self.done.enabled = false;
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
    
    
    finalPath = [contentPath objectAtIndex:indexPath.row];
    finalID = [musicID objectAtIndex:indexPath.row];
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
    
    //    [self tempMove];
    
    NSLog(@"Final Link = %@",finalPath);
    
}

/*
 - (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
 {
 AdminMusicCell* cell = (AdminMusicCell*)[collectionView  cellForItemAtIndexPath:indexPath];
 cell.alpha = 1;
 
 cell.selectedMusic.hidden = true;
 
 }
 */

-(void)tempMove
{
    NSLog(@"Selected URL = %@",finalPath);
    NSLog(@"Selected ID = %@",finalID);
    
    //Chcking MainArray
    MainArray=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainArray"]];
    NSLog(@"MainArray_didLoad_1 %@",MainArray);
    if(MainArray == nil ){
        MainArray= [[NSMutableArray alloc]init];
    }
    //Chcking MainArray
    
    NSMutableDictionary *finalDic = [MainArray objectAtIndex:selected_cell_index];
    [finalDic setValue:@"admin" forKey:@"music_type"];
    [finalDic setValue:finalID forKey:@"music"];
    //    [finalDic setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"image_pos"];
    
    [MainArray replaceObjectAtIndex:selected_cell_index withObject:finalDic];
    //Generating Final
    
    //UPDAteMainArrayUserDefaults
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
    [defaults synchronize];
    //UPDAteMainArrayUserDefaults
    
    NSLog(@"MainArray_cellLoad %@",MainArray);
    
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
    
}


- (IBAction)done:(id)sender
{
    NSLog(@"Selected URL = %@",finalPath);
    NSLog(@"Selected ID = %@",finalID);
    
    NSString *option=[[NSUserDefaults standardUserDefaults]objectForKey:@"isWizardOrAdvance"];
    NSLog(@"Wizard Option:%@",option);
    
    if([option isEqualToString:@"Wizard"])
    {
        
        
        [[NSUserDefaults standardUserDefaults]setObject:finalID forKey:@"WizardMusicId"];
        [[NSUserDefaults standardUserDefaults]setObject:@"admin" forKey:@"WizardMusictype"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        WizardAddTitileViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddTitle"];
        
        //vc.playerURL = rID;
        
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
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
        [finalDic setValue:@"admin" forKey:@"music_type"];
        [finalDic setValue:finalID forKey:@"music"];
        [finalDic setValue:@"1" forKey:@"music_color_identification"];
        [finalDic setValue:colorString forKey:@"music_color"];
        
        
        for(int i=selected_cell_index+1;i<MainArray.count;i++){
            
            NSMutableDictionary *finalDic = [MainArray objectAtIndex:i];
            if([[finalDic valueForKey:@"music_color_identification"] isEqualToString:@"0"]){
                [finalDic setValue:@"admin" forKey:@"music_type"];
                [finalDic setValue:finalID forKey:@"music"];
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
        
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
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

@end

