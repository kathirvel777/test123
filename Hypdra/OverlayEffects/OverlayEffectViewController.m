//
//  OverlayEffectViewController.m
//  Montage
//
//  Created by Srinivasan on 23/10/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "OverlayEffectViewController.h"
#import "AFNetworking.h"
#import "OverlayCell.h"
#import "SJVideoPlayer.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "VideoEditorViewController.h"
#import "SwipeBack.h"
#import "UIColor+Utils.h"
#import "CustomPopUp.h"
#import "singletons.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface OverlayEffectViewController ()<ClickDelegates>
{
    MBProgressHUD *hud;
    NSString *user_id;
    int rowIndex;
    SJVideoPlayer *SJplayer;
    
}

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;

@end

@implementation OverlayEffectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.swipeBackEnabled=NO;
    NSLog(@"arr is %@",[self.navigationController viewControllers]);
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        self.overlyViewWidth.constant=50;
        self.overlyX.constant=50;
        
        self.plusWidth.constant=-40;
        self.plusHeight.constant=-5;
        self.plusX.constant=-35;
        
        self.moreX.constant=-35;
        self.moreY.constant=-10;
    }
    
    [self.doneOutlet setEnabled:NO];
    [self.doneOutlet setTintColor: [UIColor clearColor]];
    
    self.moreButtonOutlet.layer.shadowRadius = 2.0f;
    self.moreButtonOutlet.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.moreButtonOutlet.layer.shadowOffset = CGSizeMake(0.1f, 1.0f);
    self.moreButtonOutlet.layer.shadowOpacity = 1.0f;
    self.moreButtonOutlet.layer.masksToBounds = NO;
    
//    self.overlayView.layer.shadowRadius = 2.0f;
//    self.overlayView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.overlayView.layer.shadowOffset = CGSizeMake(0.1f, 1.0f);
//    self.overlayView.layer.shadowOpacity = 1.0f;
//    self.overlayView.layer.masksToBounds = NO;
    
    if([[[NSUserDefaults standardUserDefaults]stringForKey:@"didSelectTap"] isEqualToString:@"tapped"])
    {
        [self.doneOutlet setEnabled:YES];
        [self.doneOutlet setTintColor:[UIColor whiteColor]];
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    _videopath=[[NSUserDefaults standardUserDefaults]
                stringForKey:@"videoPathValue"];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"blurimage"];
    
    UIImage* image = [UIImage imageWithData:imageData];
    
    _bgImgView.image=image;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pagePosition) name:@"pagePosition" object:nil];
    
    
    /*
     if([_isPageFirst isEqualToString:@"first"])
     {
     _thumbImage= [[NSMutableArray alloc]init];
     _imagePath= [[NSMutableArray alloc]init];
     _imageText= [[NSMutableArray alloc]init];
     
     hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
     [self overlayWebResponse];
     }
     else
     {
     self.imageText=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageText2"]];
     
     self.imagePath=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagePath2"]];
     
     self.thumbImage=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"thumbImage2"]];
     
     [self.overlayCollectionView reloadData];
     
     }
     */
}

-(void)pagePosition
{
    self.isPageFirst=@"second";
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.overlayCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.videopath] jumpedToTime:self.currentTime];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"])
    {
        self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
        //self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
        self.bannerView.rootViewController = self;
        GADRequest *request = [GADRequest request];
        //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
        request.testDevices = nil;

    [self.bannerView loadRequest:request];
    }
    else
    {
        [self.bannerView removeFromSuperview];
    }

    [self loadVideoPlayer];
    
    if([_isPageFirst isEqualToString:@"first"])
    {
        //        _thumbImage= [[NSMutableArray alloc]init];
        //        _imagePath= [[NSMutableArray alloc]init];
        //        _imageText= [[NSMutableArray alloc]init];
        
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self overlayWebResponse];
    }
    else
    {
        self.imageText=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageText2"]];
        
        self.imagePath=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagePath2"]];
        
        self.thumbImage=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"thumbImage2"]];
        
        [self overlayWebResponse];
        
        // [self.overlayCollectionView reloadData];
        
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    
    [[SJVideoPlayer sharedPlayer] stop];
    
    NSLog(@"viewDidDisappear");
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"This is an alert view" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    rowIndex=(int)indexPath.row;
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to apply the selected overlay ?" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.hidden = YES;
    
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    popUp.inputTextField.hidden = YES;
    [popUp show];
}

- (void)agreeCLicked:(CustomPopUp *)alertView
{
    [[NSUserDefaults standardUserDefaults]setObject:@"tapped" forKey:@"didSelectTap"];
    
    [[SJVideoPlayer sharedPlayer] pause];
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSLog(@"did select is called");
    self.image_path=[_imagePath objectAtIndex:rowIndex];
    
    NSLog(@"row inddd %d",rowIndex);
    
    NSDictionary *parameters =@{@"lang":@"iOS",@"video_url":_videopath,@"apng_url":_image_path};
    
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=video_overlay_final_video";
    
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
              
              //NSLog(@"The res is %@",responseObject);
              
              self.videopath=[responseObject objectForKey:@"video_overlay_path"];
              
              [[NSUserDefaults standardUserDefaults] setObject:_videopath forKey:@"videoPathValue"];
              [[NSUserDefaults standardUserDefaults] synchronize];
              
              [self loadVideoPlayer];
              
              [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.videopath] jumpedToTime:self.currentTime];
              [self.doneOutlet setEnabled:YES];
              [self.doneOutlet setTintColor:[UIColor whiteColor]];
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
          }
      }]resume];
    
    [alertView hide];
    alertView = nil;
}

-(void) okClicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView=nil;
    
}

-(void) cancelClicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}
/*{
 
 @try
 {
 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Info"
 message:@"Could you want to apply changes?"
 preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action)
 {
 
 [[NSUserDefaults standardUserDefaults]setObject:@"tapped" forKey:@"didSelectTap"];
 
 [[SJVideoPlayer sharedPlayer] pause];
 
 hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
 NSLog(@"did select is called");
 self.image_path=[_imagePath objectAtIndex:indexPath.row];
 
 NSDictionary *parameters =@{@"lang":@"iOS",@"video_url":_videopath,@"apng_url":_image_path};
 
 NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=video_overlay_final_video";
 
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
 
 //NSLog(@"The res is %@",responseObject);
 
 self.videopath=[responseObject objectForKey:@"video_overlay_path"];
 
 [[NSUserDefaults standardUserDefaults] setObject:_videopath forKey:@"videoPathValue"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 
 [self loadVideoPlayer];
 
 [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.videopath] jumpedToTime:self.currentTime];
 [self.doneOutlet setEnabled:YES];
 [self.doneOutlet setTintColor:[UIColor whiteColor]];
 [hud hideAnimated:YES];
 
 }
 
 else
 {
 NSLog(@"Error123: %@, %@, %@", error, response,  responseObject);
 
 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Try Again" message:@"Couldn't connect to server " preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
 [alertController addAction:ok];
 
 [self presentViewController:alertController animated:YES completion:nil];
 [hud hideAnimated:YES];
 }
 }]resume];
 
 }];
 
 UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action)
 {
 // [self dismissViewControllerAnimated:YES completion:nil];
 }];
 
 [alert addAction:yesButton];
 [alert addAction:noButton];
 
 [self presentViewController:alert animated:YES completion:nil];
 }
 @catch(NSException *exception)
 {
 }
 }*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageText.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"OverlayCell";
    OverlayCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.cellLabel.text=[_imageText objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[_thumbImage objectAtIndex:indexPath.row]];
    
    [cell.cellImgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"128-video-holder"]];
    
    return cell;
}

-(void)overlayWebResponse
{
    @try
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=video_overlay_image";
        
        NSDictionary *parameters =@{@"User_ID":user_id,@"lang":@"iOS"};
        
        [manager POST:URLString parameters:parameters success:^(NSURLSessionTask *operation, id responseObject)
         {
             _thumbImage= [[NSMutableArray alloc]init];
             _imagePath= [[NSMutableArray alloc]init];
             _imageText= [[NSMutableArray alloc]init];
             NSDictionary *d1=responseObject;
             
             NSMutableArray *a1=[d1 objectForKey:@"view_video_overlay_image"];
             
             NSLog(@"The a1 is %@",a1);
             
             for(int i=0;i<a1.count;i++)
             {
                 NSDictionary *d2=[a1 objectAtIndex:i];
                 
                 [_imageText addObject:[d2 objectForKey:@"image_text"]];
                 [_thumbImage addObject:[d2 objectForKey:@"thumb_image"]];
                 [_imagePath addObject:[d2 objectForKey:@"image_path"]];
                 
             }
             
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_imageText]  forKey:@"imageText2"];
             
             [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_imagePath]  forKey:@"imagePath2"];
             
             [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_thumbImage]  forKey:@"thumbImage2"];
             
             
             [self.overlayCollectionView reloadData];
             
             [hud hideAnimated:YES];
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             
             CustomPopUp *popUp = [CustomPopUp new];
             [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
             popUp.okay.backgroundColor = [UIColor navyBlue];
             popUp.agreeBtn.hidden = YES;
             popUp.cancelBtn.hidden = YES;
             popUp.inputTextField.hidden = YES;
             [popUp show];
             [hud hideAnimated:YES];
         }];
    }
    @catch(NSException *excep)
    {
        
    }
}

-(void)loadVideoPlayer
{
    SJplayer = [SJVideoPlayer sharedPlayer];
    [SJplayer.presentView addSubview:SJplayer.control.view];
    SJplayer.control.isCircularView=NO;
    
    [SJplayer.presentView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.offset(0);
     }];
    
    [SJplayer.control.view mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.offset(0);
     }];
    [self.TopView addSubview:SJplayer.view];
    
    if (IS_PAD)
    {
        [SJplayer.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.offset(0);
             make.leading.trailing.offset(0);
             
             make.height.equalTo(SJplayer.view.mas_width).multipliedBy(9.0 / 16);
         }];
    }
    else
    {
        [SJplayer.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.offset(0);
             make.leading.trailing.offset(0);
             
             make.height.equalTo(SJplayer.view.mas_width).multipliedBy(9.0 / 12.5);
         }];
    }
    
    //    self.topView.backgroundColor = [UIColor redColor];
    
#pragma mark - AssetURL
    
    //    player.assetURL = [[NSBundle mainBundle] URLForResource:@"sample.mp4" withExtension:nil];
    
    //    player.assetURL = [NSURL URLWithString:@"http://streaming.youku.com/live2play/gtvyxjj_yk720.m3u8?auth_key=1525831956-0-0-4ec52cd453761e1e7f551decbb3eee6d"];
    
    //    player.assetURL = [NSURL URLWithString:@"http://video.cdn.lanwuzhe.com/1493370091000dfb1"];
    
    //    player.assetURL = [NSURL URLWithString:@"http://vod.lanwuzhe.com/9da7002189d34b60bbf82ac743241a61/d0539e7be21a4f8faa9fef69a67bc1fb-5287d2089db37e62345123a1be272f8b.mp4?video="];
    
    
#pragma mark - Setting Player
    
    [SJplayer playerSettings:^(SJVideoPlayerSettings * _Nonnull settings)
     {
         settings.traceColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                               green:arc4random() % 256 / 255.0
                                                blue:arc4random() % 256 / 255.0
                                               alpha:1];
         settings.trackColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                               green:arc4random() % 256 / 255.0
                                                blue:arc4random() % 256 / 255.0
                                               alpha:1];
         settings.bufferColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                green:arc4random() % 256 / 255.0
                                                 blue:arc4random() % 256 / 255.0
                                                alpha:1];
         settings.replayBtnTitle = @"Replay";
         settings.replayBtnFontSize = 12;
     }];
    
#pragma mark - Loading Placeholder
    
    //    player.placeholder = [UIImage imageNamed:@"sj_video_player_placeholder"];
    
    
    
#pragma mark - 1 Level More Settings
    
    SJVideoPlayerMoreSetting.titleFontSize = 12;
    
    SJVideoPlayerMoreSetting *model0 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_like_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        NSLog(@"clicked %@", model.title);
        [SJplayer showTitle:self.title];
    }];
    
    
    SJVideoPlayerMoreSetting *model2 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_favorite_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        NSLog(@"clicked %@", model.title);
        [SJplayer showTitle:model.title];
    }];
    
    
#pragma mark - 2 Level More Settings
    
    SJVideoPlayerMoreSettingTwoSetting *twoS0 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:nil clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [SJplayer showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoS1 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:nil clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [SJplayer showTitle:model.title];
    }];
    
#pragma mark - 1 Level More Settings
    
    SJVideoPlayerMoreSetting *model1 =
    [[SJVideoPlayerMoreSetting alloc] initWithTitle:@""
                                              image:[UIImage imageNamed:@"db_audio_play_download_n"]
                                     showTowSetting:YES
                                 twoSettingTopTitle:@""
                                    twoSettingItems:@[twoS0, twoS1]
                                    clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {}];
    
    
#pragma mark - 2 Level More Settings
    
    SJVideoPlayerMoreSettingTwoSetting.topTitleFontSize = 14;
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting0 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"QQ" image:[UIImage imageNamed:@"db_login_qq"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model)
                                                       {
                                                           [SJplayer showTitle:model.title];
                                                       }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting1 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_login_weibo"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [SJplayer showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting2 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_login_weixin"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [SJplayer showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSetting *model3 =
    [[SJVideoPlayerMoreSetting alloc] initWithTitle:@""
                                              image:[UIImage imageNamed:@"db_audio_play_share_n"]
                                     showTowSetting:YES twoSettingTopTitle:@""
                                    twoSettingItems:@[twoSetting0, twoSetting1, twoSetting2]  // 2级 Settings
                                    clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {}];
    
    [SJplayer moreSettings:^(NSMutableArray<SJVideoPlayerMoreSetting *> * _Nonnull moreSettings)
     {
         /*      [moreSettings addObject:model0];
          [moreSettings addObject:model1];
          [moreSettings addObject:model2];
          [moreSettings addObject:model3];*/
     }];
    
}

- (IBAction)menuSelection:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Dispersion" forKey:@"menuType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    UIViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"menuOverlayController"];
    
    
    // [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)backAction:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
    
   // [self.navigationController pushViewController:vc animated:YES];
    NSArray *array=[self.navigationController viewControllers];
    if(array.count==1){
        [self.navigationController popToViewController:vc animated:YES];
    }else
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

- (IBAction)doneAction:(id)sender
{
    //    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    //
    //    VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
    //
    //    vc.viewHiding=@"second";
    //   // [self.navigationController pushViewController:vc animated:YES];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"viewhide" object:nil];
    
    NSArray *array=[self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

- (IBAction)moreTap:(id)sender
{
    NSLog(@"last tapped");
    [[NSUserDefaults standardUserDefaults] setObject:@"Dispersion" forKey:@"menuType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    UIViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"menuOverlayController"];
    
    // [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

@end

