//
//  WizardIcons.m
//  Hypdra
//
//  Created by Mac on 12/4/18.
//  Copyright © 2018 sssn. All rights reserved.
//
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "Reachability.h"
#import "SJVideoPlayer.h"
#import "SwipeBack.h"
#import "CustomPopUp.h"
#import "UIColor+Utils.h"
#import "TestKit.h"
#import "ChooseTemplateCollectionViewCell.h"
@import GoogleMobileAds;
#import "WizardIcons.h"
#import "WizardIconCollectionViewCell.h"
#import "DEMORootViewController.h"


#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
@interface WizardIcons ()<GADBannerViewDelegate>{
    NSMutableArray *finalArray;
    
    NSString *user_id;
    NSMutableURLRequest *request;
    
    NSString *imgName,*purchase_type;
    
    NSIndexPath *selectedValue;
    
    MBProgressHUD *hud;
    
    NSString *pathValue,*idValue,*pathGif;
    int selected_cell_index;
    SJVideoPlayer *SJplayer;
    NSArray *imageArray;
    int selectedIndexPath;

}
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property(nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;
@end

@implementation WizardIcons

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled=NO;

    UITapGestureRecognizer *TapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeVideoPlayer:)];
    TapRecognizer.numberOfTapsRequired = 1;
    [self.blurView addGestureRecognizer:TapRecognizer];
    

    user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_ID"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:12.0f];
    
    [self.CollectionView setCollectionViewLayout:flowLayout];
    
    //[flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    self.CollectionView.bounces = false;
    
    NSLog(@"SelectedValue = %@",selectedValue);
    
    self.CollectionView.bounces = false;
    _CollectionView.contentInset=UIEdgeInsetsMake(5, 5, 5, 5);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [finalArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"WizardIcon";
    
    WizardIconCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.alpha = 1.0;
    cell.ImgView.backgroundColor = [UIColor darkGrayColor];
    
    NSDictionary *mainCategory=[finalArray objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[mainCategory objectForKey:@"preview_image"]];
    
    [cell.ImgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
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
        picDimension = self.view.frame.size.width / 5.18f;
    }
    return CGSizeMake(picDimension, picDimension);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    
    self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
    //self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
    request.testDevices = nil;

    [self.bannerView loadRequest:request];
 self.bannerView.center=CGPointMake(_ADView.frame.size.width/2,_ADView.frame.size.height/2);
    
    [_ADView addSubview:_bannerView];
    
     self.done.enabled = false;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        
        [self.ADView removeFromSuperview];
}
    
    [self.done setTintColor:[UIColor clearColor]];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    NSLog(@"User ID = %@",user_id);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self getTemplates];
}
-(void)getTemplates
{
    @try
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSString *URLString = @"https://hypdra.com/api/api.php?rquest=business_template_icon";
        
       // NSDictionary *parameters = @{@"Category_Id":templateCategeory,@"User_ID":user_id,@"lang":@"iOS"};
        NSError *error;
       // NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
       // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8",@"application/json", nil];
        manager.responseSerializer = responseSerializer;
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSLog(@"Template_icon_Response == %@",responseObject);
                  
                  NSMutableDictionary *response=responseObject;
                  finalArray = [[NSMutableArray alloc]init];
                  finalArray = [response objectForKey:@"view_business_icon"];
                  
                  [self.CollectionView reloadData];
                  [hud hideAnimated:YES];
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  [hud hideAnimated:YES];
              }
              
          }]resume];
        
        
        [hud hideAnimated:YES];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"img Catch:%@",exception);
    }
    @finally
    {
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedValue = indexPath;
    NSDictionary *templateDic = [finalArray objectAtIndex:indexPath.row];

    NSDictionary *mainCategory=[finalArray objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults]setValue:[mainCategory objectForKey:@"preview_image"] forKey:@"WizardIconPath"];
    
    NSString *iconName = [templateDic objectForKey:@"icon_name"];
    NSString *iconID = [templateDic objectForKey:@"icon_id"];
    [[NSUserDefaults standardUserDefaults]setValue:iconName forKey:@"WizardIconName"];
    [[NSUserDefaults standardUserDefaults]setValue:iconID forKey:@"WizardIconId"];
    NSString *playerURL =[templateDic objectForKey:@"preview_resize_video"];
        [self playEffect:playerURL];
        
   /*
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:templateDic]  forKey:@"TenSTemplateDic"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        CreateTemplateViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"createTemplate"];
        [self.navigationController pushViewController:vc animated:YES];
        
    */
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
    [self.videoView addSubview:SJplayer.view];
    
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
        [SJplayer showTitle:@""];
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
         
     }];
}
-(void)playEffect:(NSString *)Url
{
    self.blurView.hidden=NO;
    self.topView.hidden=NO;
    
    pathGif=Url;
    
    [self loadVideoPlayer];
    
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:pathGif] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:pathGif] jumpedToTime:0];
    
}
- (void)removeVideoPlayer:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    _blurView.hidden= YES;
    self.topView.hidden=YES;
    [[NSNotificationCenter defaultCenter]removeObserver:@"currentTime"];
    
    self.currentTime = SJplayer.currentTime;
    
    [SJplayer stop];
}
- (IBAction)done:(id)sender {
    
}
- (IBAction)Choose_btn:(id)sender {
    NSDictionary *templateDic = [finalArray objectAtIndex:selectedValue.row];
    
    [[NSUserDefaults standardUserDefaults]setValue:[templateDic objectForKey:@"preview_image"] forKey:@"WizardIconPath"];
    
    NSString *iconName = [templateDic objectForKey:@"icon_name"];
    NSString *iconID = [templateDic objectForKey:@"icon_id"];
    [[NSUserDefaults standardUserDefaults]setValue:iconName forKey:@"WizardIconName"];
    [[NSUserDefaults standardUserDefaults]setValue:iconID forKey:@"WizardIconId"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];

}
@end
