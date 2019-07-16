//  MyPlayerViewController.m
//  Montage
//  Created by MacBookPro on 5/24/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "MyPlayerViewController.h"
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"
#import "WaterAndOrioViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "CallToActionTabViewController.h"
#import "DEMORootViewController.h"
#import "TestKit.h"
#import "InviteFriendsViewController.h"
#import "SJVideoPlayer.h"
#import <Masonry.h>
#import <SwipeBack/SwipeBack.h>
#import "WebViewControllerCalltoAction.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import <CoreText/CoreText.h>

@import GoogleMobileAds;

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE 16
#define CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE 8
@interface MyPlayerViewController ()<GADRewardBasedVideoAdDelegate,UIGestureRecognizerDelegate,ClickDelegates>
{
    NSArray *ary,*chgAry;
    
    NSString *user_id,*btn_wid,*btn_ht,*xpos,*ypos;
    
    UIButton *button1;
    
    NSMutableArray *storeArray;
    
    int reChange,arrCount,startTime,endTime;
    
    int rewardedCount;
    
    MBProgressHUD *hud,*hud_1;
    
    UITapGestureRecognizer *tapGestureRecognizer;
    
    NSString *resolVal;
    
    NSString *type,*isPlanForExport,*creditPoints,*reduceCreditPoints,*redeemType;
    SJVideoPlayer *SJplayer;
    BOOL isPlanForCalltoAction,isUseCreditsForEmbededSrc;
}

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;

@end

@implementation MyPlayerViewController

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
        [SJplayer showTitle:self.video_Title];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    if([self.ctaStatus isEqualToString:@"1"])
    {
        [self calltoButtonAction];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ctaStatusVal) name:@"calltoActStatusVal" object:nil];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isWaterMarkVc"];
    [self deleteLocalValue];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    tapGestureRecognizer.delegate = self;
    
    [self.eAfterRemove addGestureRecognizer:tapGestureRecognizer];
    
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    //self.paymentResult = @"true";
    
    self.embedLink.userInteractionEnabled = false;
    NSLog(@"MyPlayerViewController didLoad");
    rewardedCount = 5;
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    
    _download_btn.titleLabel.minimumScaleFactor = 0.5;
    _download_btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [[self.download_btn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    self.embedLink.text = @"";
    
    self.eTopRemove.hidden = true;
    self.eAfterRemove.hidden = true;
    
    self.embedLink.text = self.embed_Link;
    
    NSLog(@"self.embed_Link = %@",self.embed_Link);
    
    ary = @[@"128-red",@"128-blue",@"128-green",@"128-yelow",@"128-black",@"128-lavender",@"128-light-green",@"128-dark-red",@"128-ash"];
    
    chgAry = @[@"128-red-h",@"128-blue-h",@"128-green-h",@"128-yellow-h",@"128-black-h",@"128-lavender-h",@"128-light-green-h",@"128-dark-red-h",@"128-ash-h"];
    
    storeArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"rmveWatermrk" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendSerevr:)
                                                 name:@"rmveWatermrk" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeUpdate:)
                                                 name:@"currentTime" object:nil];
    
    [[self.shareVBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    self.advanceTitle.text = self.video_Title;
    self.navigationItem.title = self.video_Title;

    self.cta_backView.layer.borderWidth=1.0f;
    // self.cta_backView.layer.borderColor=[self colorFromHexString:@"#319BF4"].CGColor;
    
    self.cta_backView.layer.borderColor=[self colorFromHexString:@"#2d2c65"].CGColor;
    
    self.cta_backView.layer.cornerRadius=5.0f;
    self.embedLinkView.layer.borderWidth=1.0f;
    self.embedLinkView.layer.borderColor=[self colorFromHexString:@"#2d2c65"].CGColor;
    self.embedLink.layer.borderWidth = 1.0f;
    self.embedLink.layer.borderColor=[UIColor grayColor].CGColor;
    
    creditPoints= [[NSUserDefaults standardUserDefaults]objectForKey:@"credit_points"];
    
    [self checkExportStatus];
    
    _CTA_outlet.titleLabel.numberOfLines = 1;
    _CTA_outlet.titleLabel.lineBreakMode = NSLineBreakByClipping;
    _CTA_outlet.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self adjustFontSizeToFillItsContents];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPlanStatus" object:nil];
}


-(void) adjustFontSizeToFillItsContents
{
    NSString* text = _embedLink.text;
    
    for (int i = CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE; i>CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE; i--) {
        
        UIFont *font = [UIFont fontWithName:_embedLink.font.fontName size:(CGFloat)i];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
        
        CGRect rectSize = [attributedText boundingRectWithSize:CGSizeMake(self.embedLink.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (rectSize.size.height <= self.embedLink.frame.size.height) {
            self.embedLink.font = [UIFont fontWithName:self.embedLink.font.fontName size:(CGFloat)i];
            break;
        }
    }
}

-(void)ctaStatusVal
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"calltoActStatusVal"];
    self.ctaStatus=@"1";
    [self calltoButtonAction];
}

-(void)timeUpdate:(NSNotification *)notify
{
    NSTimeInterval time =[SJVideoPlayer sharedPlayer].currentTime;
    int minutes = floor(time/60);
    int seconds = round(time - minutes * 60);
    int currentSec = (minutes*60)+seconds;
    NSLog(@"Time %d",currentSec);
    
    NSInteger startTime1=[[NSUserDefaults standardUserDefaults]integerForKey:@"startTime"];
    
    NSInteger endTime1=[[NSUserDefaults standardUserDefaults]integerForKey:@"endTime"];
    
    startTime=(int)startTime1;
    endTime=(int)endTime1;
    NSLog(@"CurrentTime %d",currentSec);
    
    if(currentSec>=startTime && currentSec<=endTime)
    {
        button1.hidden=NO;
    }
    else
    {
        button1.hidden =YES;
    }
}

-(void)checkExportStatus
{
    //api/api.php?rquest=CheckVideoExported
    NSDictionary *parameters =@{@"User_ID":user_id};
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=CheckVideoExported";
    
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
              NSLog(@"Export Response:%@",responseObject);
              NSDictionary *exportdic=[responseObject objectForKey:@"CheckVideoExported"];
              
              //  NSMutableArray *exportArray=[exportdic objectForKey:@"CheckVideoExported"];
              
              NSString *exportStatus=[exportdic  valueForKey:@"Status"];
              
              if([exportStatus isEqualToString:@"-1"])
              {
                  isPlanForExport=@"-1";
              }
              else if([exportStatus isEqualToString:@"0"])
              {
                  isPlanForExport=@"0";
              }
              else
              {
                  isPlanForExport=@"1";
              }
              
          }
      }]resume];
}

-(void)calltoButtonAction
{
    NSDictionary *parameters =@{@"lang":@"iOS",@"User_ID":user_id,@"call_to_dtl_sec":@"advance",@"video_id":_video_ID};
    
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=view_call_to_action_module";
    
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
              NSDictionary *dic=[responseObject objectForKey:@"view_call_to_action_module"];
              
              NSArray *arr=[responseObject objectForKey:@"view_call_to_action_module"];
              NSLog(@"the arrr is %@",arr);
              NSDictionary *di=[arr objectAtIndex:arr.count-2];
              
              //              if([_ctaBtn isEqualToString:@"calltoact"])
              //              {
              
              btn_wid=[di objectForKey:@"button_width"];
              btn_ht=[di objectForKey:@"button_height"];
              xpos=[di objectForKey:@"button_x_position"];
              ypos=[di objectForKey:@"button_y_position"];
              
              button1 = [UIButton buttonWithType:UIButtonTypeCustom];
              button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
              
              
              float btnX=[xpos floatValue];
              float btnY=[ypos floatValue];
              
              float origX=(btnX/100.0);
              float origY=btnY/100.0;
              
              float origX1=(origX)*self.topView.frame.size.width;
              float origY1=(origY)*self.topView.frame.size.height;
              
              //                  float wid=150;//[btn_wid floatValue];
              //                  float ht =75;//[btn_ht floatValue];
              
              float wid=160;//[btn_wid floatValue];
              float ht =80;//[btn_ht floatValue];
              if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                  button1.frame = CGRectMake(origX1,origY1,wid,ht);
              else
                  button1.frame = CGRectMake(origX1,origY1,wid/1.5,ht/1.5);
              
              // button.frame=CGRectMake(5,10,100,200);
              //NSString *imgic=[[NSUserDefaults standardUserDefaults]stringForKey:@"calltoActionImagePath"];
              
              xpos=[di objectForKey:@"button_x_position"];
              NSString *imgic=[NSString stringWithFormat:@"https://www.hypdra.com/api/%@",[di objectForKey:@"icon_path"]];
              
              NSURL *url=[NSURL URLWithString:imgic];
              UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
              
              [button1 setBackgroundImage:img forState:UIControlStateNormal];
              
              [button1 addTarget:self
                          action:@selector(loadWebView)
                forControlEvents:UIControlEventTouchUpInside];
              [SJplayer.view addSubview:button1];
              
              self.callToActionStatus=[di objectForKey:@"url"];
              
              NSString *startTim=[di objectForKey:@"start_time"];
              NSString *endTim=[di objectForKey:@"end_time"];
              
              startTime=[startTim intValue];
              endTime=[endTim intValue];
              
              [[NSUserDefaults standardUserDefaults] setInteger:startTime forKey:@"startTime"];
              [[NSUserDefaults standardUserDefaults] setInteger:endTime forKey:@"endTime"];
          }
      }]resume];
}

-(void)loadWebView
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    WebViewControllerCalltoAction *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"ctaWebView"];
    vc.stringUrl=self.callToActionStatus;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != self.eAfterRemove)
    {
        return NO;
    }
    return YES;
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    self.embedLink.text = @"";
    self.eTopRemove.hidden = true;
    self.eAfterRemove.hidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playerURL] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playerURL] jumpedToTime:0];
    
    NSLog(@"%zd - %s", __LINE__, __func__);
    isUseCreditsForEmbededSrc = false;
    [self createScrollViewMenu];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"Video ID:%@",_video_ID);
    [self loadVideoPlayer];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isWaterMarkVc"];
    self.navigationController.swipeBackEnabled = NO;
    
    NSLog(@"URL = %@",self.playerURL);
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    NSString *restrictionForResolution=[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"];
    
    if([restrictionForResolution isEqualToString:@"Basic"])
    {
        arrCount=3;
        isPlanForCalltoAction=NO;
    }
    else if([restrictionForResolution isEqualToString:@"Standard"])
    {
        arrCount=6;
        isPlanForCalltoAction=YES;
        self.manageWaterBtn.hidden = false;
        self.removeWaterBtn.hidden = true;
    }
    else {
        arrCount=(int)[ary count];
        isPlanForCalltoAction=YES;
        self.manageWaterBtn.hidden = false;
        self.removeWaterBtn.hidden = true;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    NSLog(@"viewWillDisappear");
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    //currentTime
    
    [[NSNotificationCenter defaultCenter]removeObserver:@"currentTime"];
    
    [hud hideAnimated:YES];
    
    self.currentTime = SJplayer.currentTime;
    
    [button1 removeFromSuperview];
    
    [SJplayer stop];
    
    NSLog(@"viewDidDisappear");
        
}

- (void)createScrollViewMenu
{
    for (UIView *subView in self.scrlView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    storeArray = [[NSMutableArray alloc]init];
    
    float w = self.scrlView.frame.size.width;
    float h = self.scrlView.frame.size.height;
    
    NSLog(@"Scroll Y = %f",self.scrlView.frame.origin.y);
    
    NSLog(@"Hght = %f",self.secondView.frame.size.height);
    NSLog(@"W = %f",w);
    NSLog(@"H = %f",h);
    
    // UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
    
    int x = 0;
    CGRect frame;
    
    for (int i = 0; i < [ary count]; i++)
    {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if (IS_PAD)
        {
            if (i == 0)
            {
                frame = CGRectMake(0, 0, self.secondView.frame.size.width * 9/100 ,self.secondView.frame.size.height);
            }
            else
            {
                frame = CGRectMake((i * self.secondView.frame.size.width * 11/100) , 0, self.secondView.frame.size.width * 9/100, self.secondView.frame.size.height);
            }
            
        }
        else
        {
            if (i == 0)
            {
                frame = CGRectMake(0, 0, self.secondView.frame.size.width * 15/100 ,self.secondView.frame.size.height);
            }
            else
            {
                frame = CGRectMake((i * self.secondView.frame.size.width * 18/100) , 0, self.secondView.frame.size.width * 15/100, self.secondView.frame.size.height);
            }
        }
        
        button.frame = frame;
        
        [[button imageView] setContentMode: UIViewContentModeScaleAspectFit];
        
        UIImage *img = [UIImage imageNamed:ary[i]];
        
        [button setImage:img forState:UIControlStateNormal];
        
        if(i<arrCount)
        {
            [button setTag:i];
        }
        else
        {
            [button setTag:555];
        }
        
        [button addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrlView addSubview:button];
        
        [storeArray addObject:button];
        
        if (i == [ary count]-1)
        {
            x = CGRectGetMaxX(button.frame);
        }
        
    }
    
    self.scrlView.contentSize = CGSizeMake(x, self.scrlView.frame.size.height);
    
    self.scrlView.bounces = false;
    
}


-(void)BtnClicked:(UIButton *) sender
{
    
    NSLog(@"Button Clicked = %ld",(long)sender.tag);
    
    reChange = (int)sender.tag;
    
    if (sender.tag == 0)
    {
        [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
        
        UIImage *img = [UIImage imageNamed:chgAry[0]];
        
        [sender setImage:img forState:UIControlStateNormal];
        
        [self reChange];
        
        resolVal = @"240";
    }
    else
        if (sender.tag == 1)
        {
            [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
            
            UIImage *img = [UIImage imageNamed:chgAry[1]];
            
            [sender setImage:img forState:UIControlStateNormal];
            
            [self reChange];
            
            resolVal = @"360";
        }
        else if (sender.tag == 2)
        {
            [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
            
            UIImage *img = [UIImage imageNamed:chgAry[2]];
            
            [sender setImage:img forState:UIControlStateNormal];
            
            [self reChange];
            
            resolVal = @"480";
        }
        else if (sender.tag == 3)
        {
            [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
            
            UIImage *img = [UIImage imageNamed:chgAry[3]];
            
            [sender setImage:img forState:UIControlStateNormal];
            
            [self reChange];
            
            resolVal = @"720";
            
            
        }
        else if (sender.tag == 4)
        {
            [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
            
            UIImage *img = [UIImage imageNamed:chgAry[4]];
            
            [sender setImage:img forState:UIControlStateNormal];
            
            [self reChange];
            
            resolVal = @"1080";
            
        }
        else if (sender.tag == 5)
        {
            [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
            
            UIImage *img = [UIImage imageNamed:chgAry[5]];
            
            [sender setImage:img forState:UIControlStateNormal];
            
            [self reChange];
            
            resolVal = @"2000";
            
            
        }
        else if (sender.tag == 6)
        {
            [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
            
            UIImage *img = [UIImage imageNamed:chgAry[6]];
            
            [sender setImage:img forState:UIControlStateNormal];
            
            [self reChange];
            
            resolVal = @"4000";
            
        }
        else if (sender.tag == 7)
        {
            
            [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
            
            UIImage *img = [UIImage imageNamed:chgAry[7]];
            
            [sender setImage:img forState:UIControlStateNormal];
            
            [self reChange];
            
            resolVal = @"8000";
            
        }
        else if (sender.tag == 8)
        {
            
            [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
            
            UIImage *img = [UIImage imageNamed:chgAry[8]];
            
            [sender setImage:img forState:UIControlStateNormal];
            
            [self reChange];
            
            resolVal = @"16000";
        }
        else
        {
            NSLog(@"Restricted, Upgrade ur plan");
            //  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Kindly, Upgrade your Plan to Standard or Premium to access further Resolution!!!" preferredStyle:UIAlertControllerStyleAlert];
            //
            //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            //        {
            //            if (IS_PAD)
            //            {
            //
            //                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
            //
            //                DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            //
            //                [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
            //
            //                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //
            //                [self presentViewController:vc animated:YES completion:NULL];
            //            }
            //            else
            //            {
            //
            //                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
            //
            //                DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            //
            //                [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
            //
            //                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //
            //                [self presentViewController:vc animated:YES completion:NULL];
            //            }
            //
            //        }];
            //
            //    UIAlertAction * noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            //    }];
            //
            //        [alertController addAction:ok];
            //        [alertController addAction:noButton];
            //
            //        [self presentViewController:alertController animated:YES completion:nil];
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please upgrade your plan to Standard or Premium to access further Resolution!" withTitle:@"Upgrade" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.hidden = YES;
            popUp.accessibilityHint =@"UpgradePlan";
            popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
            popUp.inputTextField.hidden = YES;
            popUp.agreeBtn.titleLabel.text = @"Okay";
            [popUp show];
        }
}


-(void)reChange
{
    for (int i = 0; i < [ary count]; i++)
    {
        
        if (i == reChange)
        {
            continue;
        }
        
        UIButton *button = storeArray[i];
        [[button imageView] setContentMode: UIViewContentModeScaleAspectFit];
        UIImage *img = [UIImage imageNamed:ary[i]];
        [button setImage:img forState:UIControlStateNormal];
    }
}

- (IBAction)downloadAtn:(id)sender
{
    int no_Of_Resolution_Downloads = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"resolution_downloads"]]integerValue];
    NSString *memberShip = [[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"];
    //memberShip = @"Basic";
    
    /*   if (resolVal == nil || resolVal == (id)[NSNull null])
     {
     CustomPopUp *popUp = [CustomPopUp new];
     [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please upgrade your plan to Standard or Premium to access further resolution!" withTitle:@"Upgrade" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
     popUp.okay.backgroundColor =[UIColor lightGreen];
     popUp.agreeBtn.hidden =YES;
     popUp.cancelBtn.hidden = YES;
     popUp.inputTextField.hidden = YES;
     [popUp show];
     }*/
    
    if(((no_Of_Resolution_Downloads>=10 || resolVal.integerValue >= 720) && [memberShip isEqualToString:@"Basic"])  )
    {
        if(creditPoints.intValue > 20){
            
            CustomPopUp *popUp = [CustomPopUp new];
            int availablecredits = creditPoints.intValue;
            NSString *msg = [NSString stringWithFormat:@"Available credit: %@ | Credit Needed: 20", creditPoints];
            [popUp initAlertwithParent:self withDelegate:self withMsg:msg withTitle:@"Pay Using Credit Balance" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.accessibilityHint = @"RedeemResolution";
            // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            popUp.okay.hidden =YES;
            [popUp.agreeBtn setTitle:@"Redeem" forState:UIControlStateNormal];
            popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
            popUp.inputTextField.hidden = YES;
            [popUp show];
            
        }else{
            
            CustomPopUp *popUp = [CustomPopUp new];
            
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Sorry you don't have enough credits" withTitle:@"Upgrade Membership" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            
            popUp.accessibilityHint = @"ConfirmToUpgrade";
            // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            popUp.okay.hidden =YES;
            [popUp.agreeBtn setTitle:@"Upgrade" forState:UIControlStateNormal];
            popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
            popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
            popUp.inputTextField.hidden = YES;
            [popUp show];
        }
    }
    else
    {
        [self sendResol];
        redeemType = @"resolution_downloads";
        [self finish];
    }
}

- (IBAction)toActualShare:(id)sender
{
    if([isPlanForExport isEqualToString:@"-1"])
    {
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Kindly, Upgrade your Plan to Standard or Premium to shar your video!!!" preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        //                             {
        //                                 if (IS_PAD)
        //                                 {
        //
        //                                     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
        //
        //                                     DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        //
        //                                     [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        //
        //                                     vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //                                     [self presentViewController:vc animated:YES completion:NULL];
        //                                 }
        //                                 else
        //                                 {
        //
        //                                     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        //
        //                                     DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        //
        //                                     [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        //
        //                                     vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //                                     [self presentViewController:vc animated:YES completion:NULL];
        //                                 }
        //
        //                             } ];
        //
        //        UIAlertAction * noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        //        }];
        //
        //        [alertController addAction:ok];
        //        [alertController addAction:noButton];
        //
        //        [self presentViewController:alertController animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please upgrade your plan to Standard or Premium to share your video!" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"UpgradePlanToShare";
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else if ([isPlanForExport isEqualToString:@"0"])
    {
        
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Ok" withTitle:@"OK" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        [self deleteLocalValue];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure, Do you want to Share?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToShare";
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
}

- (IBAction)deleteVideo:(id)sender
{
    
    //    UIAlertController * alert=[UIAlertController
    //
    //                               alertControllerWithTitle:@"Confirm" message:@"Are you sure to delete ?"preferredStyle: UIAlertControllerStyleAlert];
    //
    //    UIAlertAction* yesButton = [UIAlertAction
    //                                actionWithTitle:@"Yes"
    //                                style:UIAlertActionStyleDefault
    //                                handler:^(UIAlertAction * action)
    //                                {
    //
    //                                    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //
    //                                    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //                                    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    //
    //                                    @try
    //                                    {
    //
    //                                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    //                                        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=delete_my_album_video";
    //
    //                                        NSDictionary *params = @{@"user_id":user_id,@"del_id":self.video_ID,@"lang":@"iOS"};
    //
    //                                        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
    //                                         {
    //                                             NSLog(@"Response = %@",responseObject);
    //
    //                                             NSString *albumCount = [responseObject objectForKey:@"advance_album_count"];
    //
    //                                             int numValue = [albumCount intValue];
    //
    //                                             NSLog(@"Get Album Count = %d",numValue);
    //
    //                                             [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
    //                                             [[NSUserDefaults standardUserDefaults]synchronize];
    //
    //
    //                                             [hud hideAnimated:YES];
    //
    //
    //                                             if (IS_PAD)
    //                                             {
    ////
    //                                                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbumiPad" bundle:nil];
    //
    //                                                 DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //                                                 [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
    //
    //                                                 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //                                                 [self presentViewController:vc animated:YES completion:NULL];
    //
    //                                             }
    //                                             else
    //                                             {
    //
    //
    //                                                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    //
    //                                                 DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //                                                 [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
    //
    //                                                 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //                                                 [self presentViewController:vc animated:YES completion:NULL];
    //
    //                                             }
    //
    //                                         }
    //                                              failure:^(NSURLSessionTask *operation, NSError *error)
    //                                         {
    //                                             NSLog(@"Error9: %@", error);
    //
    //                                             UIAlertController * alert=[UIAlertController
    //
    //                                                                        alertControllerWithTitle:@"Error" message:@"Could not connect to server"preferredStyle:UIAlertControllerStyleAlert];
    //
    //                                             UIAlertAction* yesButton = [UIAlertAction
    //                                                                         actionWithTitle:@"Ok"
    //                                                                         style:UIAlertActionStyleDefault
    //                                                                         handler:nil];
    //
    //                                             [alert addAction:yesButton];
    //
    //                                             [self presentViewController:alert animated:YES completion:nil];
    //
    //
    //                                             [hud hideAnimated:YES];
    //
    //                                         }];
    //
    //                                    }
    //                                    @catch (NSException *exception)
    //                                    {
    //                                        NSLog(@"Exception = %@",exception);
    //
    //                                        [hud hideAnimated:YES];
    //                                    }
    //                                    @finally
    //                                    {
    //                                        NSLog(@"Finally Exception");
    //
    //
    //                                        [hud hideAnimated:YES];
    //                                    }
    //                                }];
    //    UIAlertAction* noButton = [UIAlertAction
    //                               actionWithTitle:@"No"
    //                               style:UIAlertActionStyleDefault
    //                               handler:^(UIAlertAction * action)
    //                               {
    //
    //                               }];
    //
    //    [alert addAction:yesButton];
    //    [alert addAction:noButton];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure you want to delete the video ?" withTitle:@"Delete" withImage:[UIImage imageNamed:@"delete_alert.png"]];
    popUp.okay.hidden = YES;
    popUp.accessibilityHint =@"ConfirmToDelete";
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.inputTextField.hidden = YES;
    [popUp show];
}


-(void)sendResol
{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSLog(@"User = %@",user_id);
    NSLog(@"rand = %@",self.randID);
    NSLog(@"Resol = %@",resolVal);
    
    NSDictionary *params = @{@"user_id":user_id,@"rand":self.randID,@"resolution":resolVal,@"lang":@"iOS"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"https://www.hypdra.com/api/api.php?rquest=advance_resolution_pay" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Resolution Response: %@", responseObject);
         
         
         [hud hideAnimated:YES];
         
         
         //         UIAlertController * alert=[UIAlertController
         //
         //                                    alertControllerWithTitle:@"Success" message:@"Check your email for video download link. We'll see you soon!"preferredStyle:UIAlertControllerStyleAlert];
         //
         //         UIAlertAction* yesButton = [UIAlertAction
         //                                     actionWithTitle:@"Ok"
         //                                     style:UIAlertActionStyleDefault
         //                                     handler:nil];
         //         [alert addAction:yesButton];
         //
         //         [self presentViewController:alert animated:YES completion:nil];
         
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"We will send video link to your email to download." withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor lightGreen];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         [hud hideAnimated:YES];
         
         NSLog(@"Resolution Error: %@", error);
     }];
    
}

-(void)viewDidLayoutSubviews
{
    
    if (rewardedCount == 0)
    {
        self.topRemove.hidden = true;
        self.afterRemove.hidden = true;
    }
    
    //self.paymentResult = @"true";
    
    if ([self.paymentResult isEqualToString:@"true"])
    {
        self.manageWaterBtn.hidden = false;
        self.removeWaterBtn.hidden = true;
    }
    else
    {
        self.manageWaterBtn.hidden = true;
        self.removeWaterBtn.hidden = false;
    }
    
    NSLog(@"setTintColor");
    
    //    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)playSampleClip1
{
    NSURL *videoURL=[[NSURL alloc] initWithString:self.playerURL];
    
    [self playStream:videoURL];
}

- (void)playStream:(NSURL*)url
{
    
    /*    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
     track.hasNext = YES;
     [self.player loadVideoWithTrack:track];*/
    
    [self.player loadVideoWithStreamURL:url];
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
    
    //    [self.player reloadCurrentVideoTrack];
    
    //    [self playSampleClip1];
    
    [self.player reloadCurrentVideoTrack];
}

- (IBAction)ShareVideo:(id)sender
{
    NSLog(@"sender:%@",sender);
}

- (IBAction)removeWaterMark:(id)sender
{
    int no_Of_remove_watermark = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"remove_watermark"]]integerValue];
    NSString *memberShip = [[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"];
    memberShip = @"Basic";
    
    if((no_Of_remove_watermark >= 5 && [memberShip isEqualToString:@"Basic"]))
    {
        
        self.topRemove.hidden = false;
        
        self.afterRemove.hidden = false;
    }
    else
    {
        [self sendServer];
    }
    
    [self.player pauseContent];
    
    [self.player setAvPlayer:nil];
    
    [self.player setState:VKVideoPlayerStateDismissed];
    
    
    
    
    
}


- (IBAction)manageWaterMark:(id)sender
{
    NSLog(@"MANAGE WATER");
    
    [self.player pauseContent];
    
    [self.player setAvPlayer:nil];
    
    [self.player setState:VKVideoPlayerStateDismissed];
    
    //    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //
    //    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    //
    
    //    dispatch_async(dispatch_get_main_queue(),
    //    ^{
    //
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
    //    ^{ // 1
    
    NSLog(@"DISPATCH_QUEUE_PRIORITY_HIGH");
    
    // if (IS_PAD)
    //    {
    //
    //        dispatch_async(dispatch_get_main_queue(),
    //                       ^{
    //
    //                           self.currentTime = SJplayer.currentTime;
    //
    //                           [SJplayer stop];
    //
    //                           UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbumiPad" bundle:nil];
    //
    //                           WaterAndOrioViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WaterAndOrio"];
    //
    //                           vc.playURL = self.playerURL;
    //
    //                           [self.navigationController pushViewController:vc animated:YES];
    //
    //                       });
    //    }
    //    else
    //    {
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       
                       //            for (UIView *subView in self.scrlView.subviews)
                       //            {
                       //                [subView removeFromSuperview];
                       //            }
                       
                       self.currentTime = SJplayer.currentTime;
                       
                       [SJplayer stop];
                       
                       
                       UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
                       
                       WaterAndOrioViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WaterAndOrio"];
                       
                       //                       vc.playURL = self.playerURL;
                       
                       [self.navigationController pushViewController:vc animated:YES];
                       
                   });
    
    // }
    
    //    });
    
}


- (IBAction)btn240p:(id)sender
{
    // [self.player pauseButtonPressed];
}

- (IBAction)calltoAction:(id)sender
{
    //    if(isPlanForCalltoAction==YES)
    //    {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CallToActionTabViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Call to action"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.calledVC = @"advance";
    
    [[NSUserDefaults standardUserDefaults]setObject:@"advance" forKey:@"call_to_dtl_sec"];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:_playerURL forKey:@"VideoUrl"];
    [def setObject:_video_ID forKey:@"VideoId"];
    [def setObject:_randID forKey:@"RandId"];
    [def synchronize];
    
    [self.navigationController pushViewController:vc animated:YES];
    //   }
    //else
    //    {
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Kindly, Upgrade your Plan to Standard or Premium to Add a Call to Action button in your video!!!" preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    //       {
    //             if (IS_PAD)
    //             {
    //
    //                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
    //
    //                 DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //                 [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
    //
    //                 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //                 [self presentViewController:vc animated:YES completion:NULL];
    //             }
    //             else
    //             {
    //
    //                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
    //
    //                 DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    //
    //                 [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
    //
    //                 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //
    //                 [self presentViewController:vc animated:YES completion:NULL];
    //             }
    //
    //         } ];
    //
    //        UIAlertAction * noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        }];
    //
    //        [alertController addAction:ok];
    //        [alertController addAction:noButton];
    //
    //        [self presentViewController:alertController animated:YES completion:nil];
    //    }
    
}


- (IBAction)share:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"]isEqualToString:@"Basic"])
    {
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"embedded_src"] intValue]==1)
        {
            self.embedLink.text = self.embed_Link;
            self.eTopRemove.hidden = false;
            self.eAfterRemove.hidden = false;
        }
        else
        {
            if(creditPoints.intValue > 20){
                
                CustomPopUp *popUp = [CustomPopUp new];
                int availablecredits = creditPoints.intValue;
                NSString *msg = [NSString stringWithFormat:@"Available credit: %@ | Credit Needed: 20", creditPoints];
                [popUp initAlertwithParent:self withDelegate:self withMsg:msg withTitle:@"Pay Using Credit Balance" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                popUp.accessibilityHint = @"Redeem";
                // popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                popUp.okay.hidden =YES;
                [popUp.agreeBtn setTitle:@"Redeem" forState:UIControlStateNormal];    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
                popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
                popUp.inputTextField.hidden = YES;
                [popUp show];
                
            }else{
                
                CustomPopUp *popUp = [CustomPopUp new];
                [popUp initAlertwithParent:self withDelegate:self withMsg:@"Sorry you don't have enough credits" withTitle:@"Upgrade Membership" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                
                popUp.accessibilityHint = @"ConfirmToUpgrade";
                //popUp.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                popUp.okay.hidden =YES;
                [popUp.agreeBtn setTitle:@"Upgrade" forState:UIControlStateNormal];
                popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
                popUp.cancelBtn.backgroundColor = [UIColor blueBlack];  popUp.inputTextField.hidden = YES;
                [popUp show];
            }
        }
    }
    else
    {
        self.embedLink.text = self.embed_Link;
        self.eTopRemove.hidden = false;
        self.eAfterRemove.hidden = false;
    }
}

- (void)okButtonPressed
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Sharing...", @"HUD loading title");
    [self doSomeNetworkWorkWithProgress];
}

- (void)doSomeNetworkWorkWithProgress
{
    NSLog(@"doSomeNetworkWorkWithProgress = %@",self.playerURL);
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL *audioURL = [NSURL URLWithString:self.playerURL];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:audioURL];
    [task resume];
}


- (void)cancelWork:(id)sender
{
    //    self.canceled = YES;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    // [hud hideAnimated:YES];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    //getting application's document directory path
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    //adding a new folder to the documents directory path
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/tempVideo1/"];
    
    //Checking for directory existence and creating if not already exists
    if(![fileManager fileExistsAtPath:appDir])
    {
        [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    appDir =  [appDir stringByAppendingPathComponent:@"samplevideo.mp4"];

    NSLog(@"AppDir = %@",appDir);
    
    //moving the file from temp location to app's own directory
    BOOL fileCopied = [fileManager moveItemAtPath:[location path] toPath:appDir error:&error];
    
    NSLog(@"FileCopied = ");
    NSLog(fileCopied ? @"Yes" : @"No");
    
    [self shareVideoTo];
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    NSLog(@"Downloading... = %f",progress);
    
    // Update the UI on the main thread
    /*    dispatch_async(dispatch_get_main_queue(), ^{
     
     NSLog(@"Here");
     
     //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
     //
     //        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
     });*/
}


-(void)shareVideoTo
{
    
    NSLog(@"shareVideoTo");
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       
                       NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                       NSString *docsDir = [tempArray objectAtIndex:0];
                       
                       NSString *appDir = [docsDir stringByAppendingPathComponent:@"/tempVideo1/"];
                       
                       NSString  *filePath =  [appDir stringByAppendingPathComponent:@"samplevideo.mp4"];
                       
                       NSURL *url = [NSURL fileURLWithPath:filePath];
                       NSData *dt = [NSData dataWithContentsOfURL:url];
                       
                       NSLog(@"Dt = %lu",(unsigned long)dt.length);
                       
                       NSArray * activityItems = @[url];
                       
                       NSArray * applicationActivities = nil;
                       
                       NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
                       
                       UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
                       
                       activityController.excludedActivityTypes = excludeActivities;
                       
                       //        [activityController setCompletionHandler:^(NSString *activityType, BOOL completed)
                       //         {
                       //             if (completed)
                       //             {
                       //                 NSLog(@"avc done");
                       //             }
                       //             else
                       //             {
                       //                 NSLog(@"avc cancelled"); //<<<<---
                       //             }
                       //         }];
                       
                       
                       [activityController setCompletionWithItemsHandler:
                        ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError)
                        {
                            if (completed)
                            {
                                NSLog(@"avc done");
                                
                                [self deleteLocalValue];
                                [self addExportCount];
                            }
                            else
                            {
                                NSLog(@"avc cancelled"); //<<<<---
                                [self deleteLocalValue];
                            }
                        }];
                       
                       
                       if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                       {
                           
                           [hud hideAnimated:YES];
                           [self presentViewController:activityController animated:YES completion:nil];
                       }
                       else
                       {
                           
                           [hud hideAnimated:YES];
                           
                           UIPopoverPresentationController *presentationController = [activityController popoverPresentationController];
                           presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
                           presentationController.sourceView = self.shrView ;
                           presentationController.sourceRect = self.shareBtn.frame;
                           
                           [self presentViewController:activityController animated:YES completion:nil];
                           
                       }
                       
                       //      [self presentViewController:avc animated:YES completion:nil];
                   });
}


-(void)deleteLocalValue
{
    
    NSLog(@"Deleted");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray * tempArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [tempArray objectAtIndex:0];
    
    NSString *appDir = [docsDir stringByAppendingPathComponent:@"/tempVideo1/"];
    
    if([fileManager fileExistsAtPath:appDir])
    {
        NSLog([fileManager removeItemAtPath:appDir error:&error]?@"deleted":@"not deleted");
    }
    
}

-(void)addExportCount
{
    NSDictionary *parameters =@{@"User_ID":user_id,@"Video_ID":_video_ID,@"ExportedTo":@"ShareFromiOS",@"Section":@"Advance",@"lang":@"iOS"};
    
    NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=AddExportedVideo";
    
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
              NSLog(@"Add Export Response:%@",responseObject);
              
              NSDictionary *addExportDic=[responseObject objectForKey:@"AddExportedVideo"];
              
              NSString *status=[addExportDic objectForKey:@"Status"];
              
              if([status isEqualToString:@"0"])
              {
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Something went wrong, Try Again!" preferredStyle:UIAlertControllerStyleAlert];
                  
                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           
                                       }];
                  
                  [alertController addAction:ok];
                  
                  [self presentViewController:alertController animated:YES completion:nil];
              }
              else
              {
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Successfully exported your Video!" preferredStyle:UIAlertControllerStyleAlert];
                  
                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                       }];
                  [alertController addAction:ok];
                  [self presentViewController:alertController animated:YES completion:nil];
              }
          }
      }]resume];
}

- (IBAction)paymentBtn:(id)sender
{
    type = @"InApp";
    
    [TestKit setcFrom:@"Advance"];
    
    [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.removewatermark"];
}

- (IBAction)inviteFrndBtn:(id)sender
{
    NSLog(@"Invite Frnds");
    
    [[NSUserDefaults standardUserDefaults]setObject:@"WaterMark" forKey:@"InviteFor"];
    [[NSUserDefaults standardUserDefaults]setObject:@"Advance" forKey:@"InviteThrough"];
    [[NSUserDefaults standardUserDefaults]setObject:_video_ID forKey:@"InviteVideoID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    
    InviteFriendsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InviteFriends"];
    
    [self.navigationController pushViewController:vc animated:YES];
    // }
    
}


- (IBAction)rewardVideoBtn:(id)sender
{
    type = @"RewardedVideo";
    //
    //    [self.player pauseContent];
    //
    //    [self.player setAvPlayer:nil];
    //
    //    [self.player setState:VKVideoPlayerStateDismissed];
    //
    //    [self startNewGame];
    
    hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if([creditPoints intValue]>=50)
    {
        reduceCreditPoints = @"50";
        
        [self useCreditsToRemoveWaterMark];
    }
    else
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have enough Credit Points to Remove WaterMark. Watch videos to get more points" withTitle:@"Oops" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.accessibilityHint =@"GiftPoints";
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

-(void)useCreditsToRemoveWaterMark
{
    
    NSLog(@"Minutes / Space");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    // NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";

    // NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=update_points";
    
    NSDictionary *params = @{@"User_ID":user_id,@"operation":@"minus",@"points":reduceCreditPoints,@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json minutes Reward Response:%@",responseObject);
         
         creditPoints=[responseObject objectForKey:@"credit_points"];
         
         [[NSUserDefaults standardUserDefaults]setObject:creditPoints forKey:@"credit_points"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         if([reduceCreditPoints intValue] == 50)
         {
             [self sendServer];
         }
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

- (IBAction)waterCloseBtn:(id)sender
{
    self.topRemove.hidden = true;
    self.afterRemove.hidden = true;
}

- (void)startNewGame
{
    
    //[activityIndicatorView startAnimating];
    
    NSString *rCount;
    
    if (rewardedCount > 0)
    {
        rCount = [NSString stringWithFormat:@"You have to watch %d video to unlock Remove Watermark",rewardedCount];
    }
    else
    {
        rCount = [NSString stringWithFormat:@"You are eligible for Remove Watermark for this video"];
    }
    
    [self.navigationController.view makeToast:rCount];
    
    hud_1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    hud.label.text = NSLocalizedString(@"Sharing...", @"HUD loading title");
    
    
    if (![[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [self requestRewardedVideo];
    }
    
    //    self.counter = 10;
    
    //    self.gameState = kGameStatePlaying;
    //    self.playAgainButton.hidden = YES;
    //    self.showVideoButton.hidden = YES;
    //    self.counter = GameLength;
    //    self.gameLabel.text = [NSString stringWithFormat:@"%ld", (long)self.counter];
    /*    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
     target:self
     selector:@selector(decrementCounter:)
     userInfo:nil
     repeats:YES];*/
    //    self.timer.tolerance = GameLength * 0.1;
}


- (void)requestRewardedVideo
{
    GADRequest *request = [GADRequest request];
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                           withAdUnitID:@"ca-app-pub-3940256099942544/1712485313"];
}

/*
 - (void)pauseGame
 {
 if (self.gameState != kGameStatePlaying)
 {
 return;
 }
 
 self.gameState = kGameStatePaused;
 
 // Record the relevant pause times.
 self.pauseDate = [NSDate date];
 self.previousFireDate = [self.timer fireDate];
 
 // Prevent the timer from firing while app is in background.
 [self.timer setFireDate:[NSDate distantFuture]];
 }
 
 - (void)resumeGame
 {
 if (self.gameState != kGameStatePaused)
 {
 return;
 }
 self.gameState = kGameStatePlaying;
 
 // Calculate amount of time the app was paused.
 NSTimeInterval pauseDuration = [self.pauseDate timeIntervalSinceNow];
 
 // Set the timer to start firing again.
 [self.timer setFireDate:[self.previousFireDate dateByAddingTimeInterval:-pauseDuration]];
 }
 
 - (void)setTimer:(NSTimer *)timer
 {
 [_timer invalidate];
 _timer = timer;
 }
 
 - (void)decrementCounter:(NSTimer *)timer
 {
 
 //    [self endGame];
 
 /*    self.counter--;
 if (self.counter > 0)
 {
 //        self.gameLabel.text = [NSString stringWithFormat:@"%ld", (long)self.counter];
 }
 else
 {
 [self endGame];
 }
 }*/
/*
 - (void)earnCoins:(NSInteger)coins
 {
 self.coinCount += coins;
 [self.coinCountLabel setText:[NSString stringWithFormat:@"Coins: %ld", (long)self.coinCount]];
 }
 */


- (void)endGame
{
    
    //    [activityIndicatorView stopAnimating];
    
    //    self.timer = nil;
    
    //    self.gameState = kGameStateEnded;
    //    self.gameLabel.text = @"Game over!";
    /*    if ([[GADRewardBasedVideoAd sharedInstance] isReady])
     {
     self.showVideoButton.hidden = NO;
     }*/
    //    self.playAgainButton.hidden = NO;
    // Reward user with coins for finishing the game.
    //    [self earnCoins:GameOverReward];
    
    if ([[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
    else
    {
        [[[UIAlertView alloc]
          initWithTitle:@"Interstitial not ready"
          message:@"The interstitial didn't finish " @"loading or failed to load"
          delegate:self
          cancelButtonTitle:@"Drat"
          otherButtonTitles:nil] show];
    }
}

#pragma Interstitial button actions

/*
 - (IBAction)playAgain:(id)sender
 {
 [self startNewGame];
 }
 
 - (IBAction)showVideo:(id)sender
 {
 [self startNewGame];
 
 }*/

#pragma mark UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //    [self startNewGame];
}

#pragma mark GADRewardBasedVideoAdDelegate implementation

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    
    //    [activityIndicatorView stopAnimating];
    
    [hud_1 hideAnimated:YES];
    
    if ([[GADRewardBasedVideoAd sharedInstance] isReady])
    {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }
    else
    {
        [[[UIAlertView alloc]
          initWithTitle:@"Interstitial not ready"
          message:@"The interstitial didn't finish " @"loading or failed to load"
          delegate:self
          cancelButtonTitle:@"Drat"
          otherButtonTitles:nil] show];
    }
    
    NSLog(@"Reward based video ad is received.");
    
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Opened reward based video ad.");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad started playing.");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad is closed.");
    
    [self.player pauseContent];
    
    [self.player setAvPlayer:nil];
    
    [self.player setState:VKVideoPlayerStateDismissed];
    
    //    self.showVideoButton.hidden = YES;
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward
{
    
    [self.player pauseContent];
    
    [self.player setAvPlayer:nil];
    
    [self.player setState:VKVideoPlayerStateDismissed];
    
    NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf", reward.type,[reward.amount doubleValue]];
    
    NSLog(@"%@", rewardMessage);
    
    
    rewardedCount -= 1;
    
    if (rewardedCount == 0)
    {
        [self sendServer];
        
        //        [self afterStripeServer];
    }
    
}


-(void)sendServer
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=NonPaymentBenefits"];
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS",@"Video_ID":self.video_ID,@"Section":@"advance",@"Product":@"watermark",@"Value":@"true",@"BuyType":@"reward"};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Rewarded Response:%@",responseObject);
         
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"Success"])
         {
             self.manageWaterBtn.hidden = false;
             self.removeWaterBtn.hidden = true;
             
             self.paymentResult = @"true";
             
             self.topRemove.hidden = true;
             self.afterRemove.hidden = true;
             [hud hideAnimated:YES];
             [hud_1 hideAnimated:YES];
             
         }
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Rewarded Error: %@", error);
         
         rewardedCount = 1;
         [hud hideAnimated:YES];
         
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Try Again" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
         
         [alert addAction:okAction];
         
         [self presentViewController:alert animated:YES completion:nil];
         
         [hud hideAnimated:YES];
         [hud_1 hideAnimated:YES];
         
     }];
}


- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"Reward based video ad will leave application.");
    
    [hud_1 hideAnimated:YES];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error
{
    NSLog(@"Reward based video ad failed to load.");
    
    NSString *rCount = [NSString stringWithFormat:@"Try Again..."];
    
    [hud_1 hideAnimated:YES];
    
    [self.navigationController.view makeToast:rCount];
    
}



/*
 -(void)afterStripeServer
 {
 
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 manager.responseSerializer = [AFJSONResponseSerializer serializer];
 manager.requestSerializer = [AFJSONRequestSerializer serializer];
 
 [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
 [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
 [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 manager.securityPolicy.allowInvalidCertificates = YES;
 
 //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
 
 NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=payment_status";
 
 NSString *vID = [[NSUserDefaults standardUserDefaults]objectForKey:@"randomVideoID"];
 
 NSLog(@"Video ID = %@",vID);
 
 NSDictionary *params = @{@"User_ID":user_id,@"video_id":vID,@"payment_type":@"RewardedVideo",@"payment_status":@"true",@"payment_section":@"advance",@"lang":@"iOS"};
 
 
 [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
 {
 NSLog(@"Json Payment Response:%@",responseObject);
 
 self.paymentResult = @"true";
 
 /*         self.manageWaterBtn.hidden = false;
 self.removeWaterBtn.hidden = true;
 
 self.topRemove.hidden = true;
 
 self.afterRemove.hidden = true;
 }
 
 failure:^(NSURLSessionTask *operation, NSError *error)
 {
 NSLog(@"Error: %@", error);
 }];
 
 }
 */

- (void)sendSerevr:(NSNotification *)note
{
    NSLog(@"Advance WaterMark");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=payment_status";
    
    NSString *vID = [[NSUserDefaults standardUserDefaults]objectForKey:@"randomVideoID"];
    
    NSLog(@"Video ID = %@",vID);
    
    NSString *jsonString;
    
    NSDictionary *getDict =  [[NSUserDefaults standardUserDefaults]objectForKey:@"ConsumeReceipt"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:getDict options:NSJSONWritingPrettyPrinted error:nil];
    
    if (! jsonData)
    {
        //        NSLog(@"Got an error: %@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
        NSLog(@"Got an string: %@", jsonString);
    }
    
    //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=payment_status";
    
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=payment_status";
    
    NSDictionary *params = @{@"User_ID":user_id,@"video_id":vID,@"payment_type":type,@"payment_status":@"true",@"payment_section":@"advance",@"lang":@"iOS",@"TransactionInfo":jsonString,@"ProductID":[note object],@"Amount":@"2",@"Status":@"1"};
    
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Json Payment Response:%@",responseObject);
         
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"Success"])
         {
             self.manageWaterBtn.hidden = false;
             self.removeWaterBtn.hidden = true;
             
             self.paymentResult = @"true";
             
             self.topRemove.hidden = true;
             self.afterRemove.hidden = true;
             [hud hideAnimated:YES];
             [hud_1 hideAnimated:YES];
             
         }
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}

//-(void)sampleTest
//{
//    NSLog(@"User Id = %@",user_id);
//}

- (IBAction)copy:(id)sender
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[self.embedLink text]];
    
    self.eTopRemove.hidden = true;
    self.eAfterRemove.hidden = true;
    
    [self.navigationController.view makeToast:@"Link Copied"];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"embedded_src"] intValue] == 1)
    {
        redeemType = @"embedded_src";
        [self finish];
    }
    if(isUseCreditsForEmbededSrc)
    {
        [self useCreditsToRemoveWaterMark];
        isUseCreditsForEmbededSrc=false;
    }
}

- (void)VideoDelete{
    
    @try
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=delete_my_album_video";
        
        NSDictionary *params = @{@"user_id":user_id,@"del_id":self.video_ID,@"lang":@"iOS"};
        
        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"Response = %@",responseObject);
             
             NSString *albumCount = [responseObject objectForKey:@"advance_album_count"];
             
             int numValue = [albumCount intValue];
             
             NSLog(@"Get Album Count = %d",numValue);
             
             [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             
             [hud hideAnimated:YES];
             if(numValue>0)
             {
                 
                 //if (IS_PAD)
                 //             {
                 //
                 //
                 //                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbumiPad" bundle:nil];
                 //
                 //                 DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                 //
                 //                 [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
                 //
                 //                 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                 //
                 //                 [self presentViewController:vc animated:YES completion:NULL];
                 //
                 //             }
                 //             else
                 //             {
                 
                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
                 
                 DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                 
                 [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
                 
                 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                 
                 [self presentViewController:vc animated:YES completion:NULL];
                 
                 // }
             }
             else
             {
                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 
                 DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                 
                 [vc awakeFromNib:@"demo_pageselection" arg:@"menuController"];
                 
                 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                 [self presentViewController:vc animated:YES completion:nil];
                 
                 
             }
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error9: %@", error);
             
             UIAlertController * alert=[UIAlertController
                                        alertControllerWithTitle:@"Error" message:@"Could not connect to server"preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"Ok"
                                         style:UIAlertActionStyleDefault
                                         handler:nil];
             
             [alert addAction:yesButton];
             [self presentViewController:alert animated:YES completion:nil];
             [hud hideAnimated:YES];
             
         }];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception = %@",exception);
        [hud hideAnimated:YES];
    }
    @finally
    {
        NSLog(@"Finally Exception");
        [hud hideAnimated:YES];
    }
    
}
-(void) okClicked:(CustomPopUp *)alertView{
    if ([alertView.accessibilityHint isEqualToString:@"GiftPoints"])
    {
        [hud_1 hideAnimated:YES];
        [hud hideAnimated:YES];
        
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        
    }
    
    [alertView hide];
    alertView = nil;
    NSLog(@"Cancel");
    
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"UpgradePlan"]){
        //if (IS_PAD)
        //        {
        //
        //            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettingsiPad" bundle:nil];
        //
        //            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        //
        //            [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        //
        //            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //            [self presentViewController:vc animated:YES completion:NULL];
        //        }
        //        else
        //        {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        // }
        
    }else if([alertView.accessibilityHint isEqualToString:@"UpgradePlanToShare"]){
        
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
        //  }
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToShare"]){
        [self okButtonPressed];
        
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToDelete"]){
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        [self VideoDelete];
        
    }
    else if ([alertView.accessibilityHint isEqualToString:@"GiftPoints"])
    {
        [hud_1 hideAnimated:YES];
        [hud hideAnimated:YES];
        
    }
    else if([alertView.accessibilityHint isEqualToString:@"Redeem"]){
        reduceCreditPoints = @"20";
        
        self.embedLink.text = self.embed_Link;
        self.eTopRemove.hidden = false;
        self.eAfterRemove.hidden = false;
        isUseCreditsForEmbededSrc = true;
    }
    else if([alertView.accessibilityHint isEqualToString:@"RedeemResolution"]){
        
        reduceCreditPoints = @"20";
        redeemType = @"resolution_downloads";
        [self useCreditsToRemoveWaterMark];
        [self sendResol];
    }
    
    else if([alertView.accessibilityHint isEqualToString:@"ConfirmToUpgrade"]){
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
    [alertView hide];
    alertView = nil;
}

-(void)finish
{
    @try
    {
        
        NSDictionary *parameters =@{@"lang":@"iOS",@"User_ID":user_id,@"type":redeemType};
        
        NSString *URL = @"https://www.hypdra.com/api/api.php?rquest=update_plan_status";
        
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
                  NSDictionary *resp=responseObject;
                  
                  if([[resp objectForKey:@"status"] isEqualToString:@"1"])
                  {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"getPlanStatus" object:nil];
                  }
                  
              }
              
          }]resume];
        
    }@catch(NSException *ex)
    {
        
    }
    
}
@end
