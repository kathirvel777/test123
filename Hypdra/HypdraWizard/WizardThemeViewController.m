//
//  WizardThemeViewController.m
//  Montage
//
//  Created by MacBookPro4 on 6/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "WizardThemeViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ThemeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "DEMOHomeViewController.h"
#import "DEMORootViewController.h"
#import "PlayThemeViewController.h"
#import "MuiscTabViewController.h"
#import "SJVideoPlayer.h"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface WizardThemeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,AVAudioPlayerDelegate>
{
    MBProgressHUD *hud;
    NSMutableArray *themeArray;
    NSString *themeTitle;
    SJVideoPlayer *SJplayer;
    
}

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;


@end

@implementation WizardThemeViewController


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
      //  [SJplayer showTitle:self.video_Title];
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
                                     showTowSetting:YES
                                 twoSettingTopTitle:@""
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


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.themeCollectionView setCollectionViewLayout:flowLayout];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    self.themeCollectionView.bounces = false;
    
    themeArray=[[NSMutableArray alloc]init];
    
    self.transparentView.hidden=YES;
    
    self.playThemeView.hidden=YES;
    
 /*   self.player = [[VKVideoPlayer alloc] init];
    
    self.player.delegate = self;
    
    self.player.view.frame = self.topView.bounds;
    
    self.player.view.playerControlsAutoHideTime = @10;
    
    [self.topView addSubview:self.player.view];*/
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    NSLog(@"URL = %@",self.playerURL);
    [self loadVideoPlayer];

    [self getThemes];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    //    [self playSampleClip1];
    
    [super viewDidAppear:YES];
    
//    if(!isnan(_currentTime))
//        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playerURL] jumpedToTime:self.currentTime];
//    else
//        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playerURL] jumpedToTime:0];
    
    NSLog(@"%zd - %s", __LINE__, __func__);
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    NSLog(@"viewWillDisappear");
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
   // [hud hideAnimated:YES];
    
    self.currentTime = SJplayer.currentTime;
    
    [SJplayer stop];
    
    NSLog(@"viewDidDisappear");
    
    //    [self.player pauseButtonPressed];
    
}


-(void)viewWillLayoutSubviews
{
    //self.themeCollectionView.frame=CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getThemes
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)    {
        NSLog(@"Not Connected to Internet");
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                      message:@"Internet connection is down"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        NSLog(@"you pressed Yes, please button");
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
    @try
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=wizard_view_editing_style_videos";
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    hud.mode = MBProgressHUDModeDeterminate;
        //    hud.progress = progress;
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSDictionary *params =@{@"User_ID":[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_ID"]}; //@{@"User_ID":user_id,@"lang":@"iOS"};
        
        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSMutableDictionary *response=responseObject;
             themeArray = [response objectForKey:@"View_Editing_style_values"];
             
             NSLog(@"wizard theme Response %@",response);
             
             [self.themeCollectionView reloadData];
             [hud hideAnimated:YES];
         }
         
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             [hud hideAnimated:YES];
         }];
        
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
  }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return themeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThemeCollectionViewCell" forIndexPath:indexPath];
    
    NSString *urlstring=[[themeArray objectAtIndex:indexPath.row]valueForKey:@"thumbnail"];
    
    [cell.themeBgImg sd_setImageWithURL:[NSURL URLWithString:urlstring] placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    
    [cell.themeImg sd_setImageWithURL:[NSURL URLWithString:urlstring] placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    
    
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
    
    
    return cell;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSString *filepath=[[themeArray objectAtIndex:indexPath.row]valueForKey:@"resize_video"];
     NSURL *videoURL1 = [NSURL URLWithString:filepath];
     //filePath may be from the Bundle or from the Saved file Directory, it is just the path for the video
     AVPlayer *player = [AVPlayer playerWithURL:videoURL1];
     AVPlayerViewController *playerViewController = [AVPlayerViewController new];
     playerViewController.player = player;
     //[playerViewController.player play];//Used to Play On start
     [self presentViewController:playerViewController animated:YES completion:nil];*/
    
    /*  UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
     
     [vc awakeFromNib:@"contentController_8" arg:@"menuController"];
     
     vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     
     [self presentViewController:vc animated:YES completion:NULL];*/
    
    
    NSString *rID = [[themeArray objectAtIndex:indexPath.row]objectForKey:@"resize_video"];
    NSString *EID = [[themeArray objectAtIndex:indexPath.row]objectForKey:@"EID"];
    [[NSUserDefaults standardUserDefaults]setObject:EID forKey:@"EditingStyleID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    themeTitle=[[themeArray objectAtIndex:indexPath.row]objectForKey:@"title"];
    self.themeTitle.text=themeTitle;
    [SJplayer showTitle:themeTitle];
    
    self.playerURL=rID;
    self.transparentView.hidden=NO;
    self.playThemeView.hidden=NO;
   // [self playSampleClip1];
    
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playerURL] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playerURL] jumpedToTime:0];
    
    
    //    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    PlayThemeViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"playTheme"];
    //
    //    vc.playerURL = rID;
    //
    //    [self.navigationController pushViewController:vc animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)backAction:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    [vc awakeFromNib:@"contentController_6" arg:@"menuController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)closePlayView:(id)sender
{
    self.transparentView.hidden=YES;
    self.playThemeView.hidden=YES;
}

- (IBAction)chooseTheme:(id)sender
{
    self.transparentView.hidden=YES;
    self.playThemeView.hidden=YES;
    
    self.currentTime = SJplayer.currentTime;
    
    [SJplayer stop];
    
    //    [self.player pauseButtonPressed];
    
    //    self.player.playerItem = nil;
    
  /*  [self.player pauseContent];
    
    [self.player setAvPlayer:nil];
    
    [self.player setState:VKVideoPlayerStateDismissed];*/
    
    //    self.playerURL = @"";
    
    //    [self playSampleClip1];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MuiscTabViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MuiscTab"];
    
    //  UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:vc];
    
    //  vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    //  [self.navigationController pushViewController:vc animated:YES];
    
    
}
/*
- (void)playSampleClip1
{
    NSURL *videoURL=[[NSURL alloc] initWithString:self.playerURL];
    
    [self playStream:videoURL];
}

- (void)playStream:(NSURL*)url
{
    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
    track.hasNext = YES;
    [self.player loadVideoWithTrack:track];
}


- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event
{
    NSLog(@"%s event:%d", __FUNCTION__, event);
    __weak __typeof(self) weakSelf = self;
    
    if (event == VKVideoPlayerControlEventTapDone)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (event == VKVideoPlayerControlEventTapCaption)
    {
        RUN_ON_UI_THREAD(^{
            VKPickerButton *button = self.player.view.captionButton;
            NSArray *subtitleList = @[@"JP", @"EN"];
            
            if (button.isPresented)
            {
                [button dismiss];
            }
            else
            {
                weakSelf.player.view.controlHideCountdown = -1;
                [button presentFromViewController:weakSelf title:NSLocalizedString(@"settings.captionSection.subtitleLanguageCell.text", nil) items:subtitleList formatCellBlock:^(UITableViewCell *cell, id item)
                 {
                     
                     NSString* code = (NSString*)item;
                     cell.textLabel.text = code;
                     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", @"50"];
                 }
                                  isSelectedBlock:^BOOL(id item)
                 {
                     return [item isEqualToString:weakSelf.currentLanguageCode];
                 }
                               didSelectItemBlock:^(id item)
                 {
                     //                [weakSelf setLanguageCode:item];
                     [button dismiss];
                 } didDismissBlock:^{
                     weakSelf.player.view.controlHideCountdown = [weakSelf.player.view.playerControlsAutoHideTime integerValue];
                 }];
            }
        });
    }
}


- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeStateFrom:(VKVideoPlayerState)fromState
{
    NSLog(@"didChangeStateFrom");
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeStateTo:(VKVideoPlayerState)toState
{
    NSLog(@"willChangeStateFrom");
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track
{
    NSLog(@"didPlayToEnd");
    
    [self playSampleClip1];
}
*/

@end

