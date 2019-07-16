//
//  VideoEffectsViewController.m
//  Montage
//
//  Created by MacBookPro on 11/21/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "VideoEffectsViewController.h"
#import "SJVideoPlayer.h"
#import <Masonry.h>
#import "AFNetworking.h"
#import "VideoEditorViewController.h"
#import "CollectionViewCellEffects.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

@interface VideoEffectsViewController ()<ClickDelegates>
{
    NSString *user_id;
    NSMutableArray *effectImages,*effectNames;
    MBProgressHUD *hud;
    int rowIndex1;
    SJVideoPlayer *SJplayer;
    
}

@property (nonatomic,strong) NSString *effectName,*fileExtension;
@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;

@end

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@implementation VideoEffectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.doneOutlet setEnabled:NO];
    [self.doneOutlet setTintColor: [UIColor clearColor]];
    
   /* if([[[NSUserDefaults standardUserDefaults]stringForKey:@"didSelectTap"] isEqualToString:@"tapped"])
        
    {
        [self.doneOutlet setEnabled:YES];
        [self.doneOutlet setTintColor:[UIColor whiteColor]];
    }*/
    
    effectImages=[[NSMutableArray alloc]init];
    effectNames=[[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"blurimage"];
    
    UIImage* image = [UIImage imageWithData:imageData];
    
    _bgImgView.image=image;
    
    if([_isPageFirst isEqualToString:@"first"])
    {
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self getEffects];
    }
    _videoPath=[[NSUserDefaults standardUserDefaults]
                stringForKey:@"videoPathValue"];
}

-(void)getEffects
{
    @try
    {
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=view_ffmpeg_video_effects";
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              
              if (!error)
              {
                  
                  NSMutableArray *arrValue=[responseObject objectForKey:@"view_ffmpeg_video_effects"];

                  for(int i=0;i<arrValue.count;i++)
                  {
                      NSDictionary *dictValue =[arrValue objectAtIndex:i];
                      [effectImages addObject:[dictValue objectForKey:@"path"]];
                      [effectNames addObject:[dictValue objectForKey:@"name"]];
                  }
                  rowIndex1=(int)effectNames.count;
                  
                  [self.collectionViewVideo reloadData];
                  [hud hideAnimated:YES];
                  
              }
              else
              {
                  
                  //                  UIAlertController * alert = [UIAlertController
                  //                                               alertControllerWithTitle:@"Error"
                  //                                               message:@"Couldn't connect to server!"
                  //                                               preferredStyle:UIAlertControllerStyleAlert];
                  //
                  //
                  //                  UIAlertAction* yesButton = [UIAlertAction
                  //                                              actionWithTitle:@"OK"
                  //                                              style:UIAlertActionStyleDefault
                  //                                              handler:^(UIAlertAction * action)
                  //                                              {
                  //
                  //                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                  //
                  //                                              }];
                  //
                  //
                  //                  [alert addAction:yesButton];
                  //
                  //                  [self presentViewController:alert animated:YES completion:nil];
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
              }
              
          }]resume];
        
    }@catch(NSException *exception)
    {
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.videoPath] jumpedToTime:self.currentTime];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self loadVideoPlayer];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"])
    {
        self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
       // self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
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
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    
    [[SJVideoPlayer sharedPlayer] stop];
    
    NSLog(@"viewDidDisappear");
    
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
    [self.topView addSubview:SJplayer.view];
    
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return effectNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId=@"CollectionViewCellEffects";
    
    CollectionViewCellEffects *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSURL *imageURL = [NSURL URLWithString:[effectImages objectAtIndex:indexPath.row]];
    
    [cell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    
    cell.effectLabel.text=[effectNames objectAtIndex:indexPath.row];
    
    if (indexPath.row == rowIndex1)
    {
        cell.highLitedView.backgroundColor=UIColorFromRGB(0x2d2c65);
    }
    else
    {
        cell.highLitedView.backgroundColor=[UIColor clearColor];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    rowIndex1=(int)indexPath.row;
    [self.collectionViewVideo reloadData];
    
    _effectName= [effectNames objectAtIndex:indexPath.row];
    
    if([_effectName isEqualToString:@"Aurora"])
    {
        _fileExtension=@"";
    }
    
    else if([_effectName isEqualToString:@"Bsplatter"])
    {
        _fileExtension=@"Bsplatter.acv";
    }
    
    else if([_effectName isEqualToString:@"Cold"])
    {
        _fileExtension=@"coldheart.acv";
    }
    
    else if([_effectName isEqualToString:@"Coldheart"])
    {
        _fileExtension=@"coldheart.acv";
    }
    
    else if([_effectName isEqualToString:@"Coral"])
    {
        _fileExtension=@"aurora.acv";
    }
    
    else if([_effectName isEqualToString:@"Digital"])
    {
        _fileExtension=@"digitalfilm.acv";
    }
    
    else if([_effectName isEqualToString:@"Dove"])
    {
        _fileExtension=@"dove.acv";
    }
    
    else if([_effectName isEqualToString:@"Dream"])
    {
        _fileExtension=@"dream.acv";
    }
    
    else if([_effectName isEqualToString:@"Glow"])
    {
        _fileExtension=@"glow.acv";
    }
    
    else if([_effectName isEqualToString:@"Grayscale"])
    {
        _fileExtension=@"";
    }
    
    else if([_effectName isEqualToString:@"Luminace"])
    {
        _fileExtension=@"";
    }
    
    else if([_effectName isEqualToString:@"Negative"])
    {
        _fileExtension=@"negative.acv";
    }
    
    else if([_effectName isEqualToString:@"Outskirt"])
    {
        _fileExtension=@"";
    }
    
    else if([_effectName isEqualToString:@"Grinch"])
    {
        _fileExtension=@"curve03.acv";
    }
    else if([_effectName isEqualToString:@"Mauve"])
    {
        _fileExtension=@"curve01.acv";
    }
    else if([_effectName isEqualToString:@"Pearl"])
    {
        _fileExtension=@"ch_ratio_curve.acv";
    }
    else if([_effectName isEqualToString:@"Pinkish"])
    {
        _fileExtension=@"pinkish.acv";
    }
    else if([_effectName isEqualToString:@"Pixelate"])
    {
        _fileExtension=@"";
    }
    else if([_effectName isEqualToString:@"Plum"])
    {
        _fileExtension=@"greeny.acv";
    }
    else if([_effectName isEqualToString:@"Sepia"])
    {
        _fileExtension=@"";
    }
    else if([_effectName isEqualToString:@"Shady"])
    {
        _fileExtension=@"shady.acv";
    }
    else if([_effectName isEqualToString:@"Sleek"])
    {
        _fileExtension=@"sleek.acv";
    }
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Could you want to apply changes?" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.hidden = YES;
    
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    popUp.inputTextField.hidden = YES;
    [popUp show];
    
}

/*
 {
 @try
 {
 _effectName= [effectNames objectAtIndex:indexPath.row];
 
 if([_effectName isEqualToString:@"Aurora"])
 {
 _fileExtension=@"";
 }
 
 else if([_effectName isEqualToString:@"Bsplatter"])
 {
 _fileExtension=@"Bsplatter.acv";
 }
 
 else if([_effectName isEqualToString:@"Cold"])
 {
 _fileExtension=@"coldheart.acv";
 }
 
 else if([_effectName isEqualToString:@"Coldheart"])
 {
 _fileExtension=@"coldheart.acv";
 }
 
 else if([_effectName isEqualToString:@"Coral"])
 {
 _fileExtension=@"aurora.acv";
 }
 
 else if([_effectName isEqualToString:@"Digital"])
 {
 _fileExtension=@"digitalfilm.acv";
 }
 
 else if([_effectName isEqualToString:@"Dove"])
 {
 _fileExtension=@"dove.acv";
 }
 
 else if([_effectName isEqualToString:@"Dream"])
 {
 _fileExtension=@"dream.acv";
 }
 
 else if([_effectName isEqualToString:@"Glow"])
 {
 _fileExtension=@"glow.acv";
 }
 
 else if([_effectName isEqualToString:@"Grayscale"])
 {
 _fileExtension=@"";
 }
 
 else if([_effectName isEqualToString:@"Luminace"])
 {
 _fileExtension=@"";
 }
 
 else if([_effectName isEqualToString:@"Negative"])
 {
 _fileExtension=@"negative.acv";
 }
 
 else if([_effectName isEqualToString:@"Outskirt"])
 {
 _fileExtension=@"";
 }
 
 else if([_effectName isEqualToString:@"Grinch"])
 {
 _fileExtension=@"curve03.acv";
 }
 else if([_effectName isEqualToString:@"Mauve"])
 {
 _fileExtension=@"curve01.acv";
 }
 else if([_effectName isEqualToString:@"Pearl"])
 {
 _fileExtension=@"ch_ratio_curve.acv";
 }
 else if([_effectName isEqualToString:@"Pinkish"])
 {
 _fileExtension=@"pinkish.acv";
 }
 else if([_effectName isEqualToString:@"Pixelate"])
 {
 _fileExtension=@"";
 }
 else if([_effectName isEqualToString:@"Plum"])
 {
 _fileExtension=@"greeny.acv";
 }
 else if([_effectName isEqualToString:@"Sepia"])
 {
 _fileExtension=@"";
 }
 else if([_effectName isEqualToString:@"Shady"])
 {
 _fileExtension=@"shady.acv";
 }
 else if([_effectName isEqualToString:@"Sleek"])
 {
 _fileExtension=@"sleek.acv";
 }
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
 
 NSDictionary *parameters =@{@"lang":@"iOS",@"video_url":self.videoPath,@"acv_file_extn":_fileExtension,@"effect_name":_effectName};
 
 NSLog(@"the param %@",parameters);
 
 NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=video_effect_final_video";
 
 NSError *error;      // Initialize NSError
 
 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
 
 NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
 
 AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
 
 NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
 
 req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
 [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
 [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
 
 [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
 {
 
 if (!error)
 {
 NSLog(@"the response is %@",responseObject);
 NSDictionary *dict=responseObject;
 NSString *status=[dict objectForKey:@"status"];
 
 if([status isEqualToString:@"Success"])
 {
 self.videoPath=[responseObject objectForKey:@"video_overlay_effect_path"];
 
 [[NSUserDefaults standardUserDefaults] setObject:self.videoPath forKey:@"videoPathValue"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 
 [self loadVideoPlayer];
 
 [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.videoPath] jumpedToTime:self.currentTime];
 
 [self.doneOutlet setEnabled:YES];
 [self.doneOutlet setTintColor:[UIColor whiteColor]];
 [hud hideAnimated:YES];
 }
 }
 else
 {
 NSLog(@"the error %@",error);
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
 [self dismissViewControllerAnimated:YES completion:nil];
 }];
 
 [alert addAction:yesButton];
 [alert addAction:noButton];
 
 [self presentViewController:alert animated:YES completion:nil];
 }@catch(NSException *exception)
 {
 
 }
 }*/

- (void)agreeCLicked:(CustomPopUp *)alertView
{
    [[NSUserDefaults standardUserDefaults]setObject:@"tapped" forKey:@"didSelectTap"];
    
    [[SJVideoPlayer sharedPlayer] pause];
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *parameters =@{@"lang":@"iOS",@"video_url":self.videoPath,@"acv_file_extn":_fileExtension,@"effect_name":_effectName};
    
    NSLog(@"the param %@",parameters);
    
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=video_effect_final_video";
    
    NSError *error;      // Initialize NSError
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];  // make NSMutableURL req
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
      {
          
          if (!error)
          {
              NSLog(@"the response is %@",responseObject);
              NSDictionary *dict=responseObject;
              NSString *status=[dict objectForKey:@"status"];
              
              if([status isEqualToString:@"Success"])
              {
                  self.videoPath=[responseObject objectForKey:@"video_overlay_effect_path"];
                  
                  [[NSUserDefaults standardUserDefaults] setObject:self.videoPath forKey:@"videoPathValue"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  
                  [self loadVideoPlayer];
                  
                  [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.videoPath] jumpedToTime:self.currentTime];
                  
                  [self.doneOutlet setEnabled:YES];
                  [self.doneOutlet setTintColor:[UIColor whiteColor]];
                  [hud hideAnimated:YES];
              }
          }
          else
          {
              CustomPopUp *popUp = [CustomPopUp new];
              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
              popUp.okay.backgroundColor = [UIColor navyBlue];
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

- (IBAction)backAction:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doneAction:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
    
    vc.viewHiding=@"second";
    [self.navigationController pushViewController:vc animated:YES];
    [self.doneOutlet setEnabled:NO];
    [self.doneOutlet setTintColor: [UIColor clearColor]];
}

@end

