
#import "MyWizardPlayerViewController.h"
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"
#import "WizardWaterAndOrioController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "CallToActionTabViewController.h"
#import "DEMORootViewController.h"
#import "TestKit.h"
#import "SJVideoPlayer.h"
#import <Masonry.h>
#import <SwipeBack/SwipeBack.h>
#import "WebViewControllerCalltoAction.h"
#import "InviteFriendsViewController.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "WaterAndOrioViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <Photos/Photos.h>



@import GoogleMobileAds;

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE 16
#define CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE 8
@interface MyWizardPlayerViewController ()<GADRewardBasedVideoAdDelegate,UIGestureRecognizerDelegate,ClickDelegates>
{
    UIButton *button;

    NSArray *ary,*chgAry;
    
    NSMutableArray *storeArray;
    
    int reChange,arrCount;
    
    NSString *user_id,*isPlanForExport,*operation,*creditsToAddMinus;
    
    int rewardedCount,startTime,endTime;
    
    MBProgressHUD *hud,*hud_1;
    
    NSString *type,*btn_wid,*btn_ht,*xpos,*ypos,*creditPoints,*rewardCount,*toDayDate;
    
    NSString *resolVal;
    BOOL isPlanForCalltoAction;
    SJVideoPlayer *player;
    UITapGestureRecognizer *tapGestureRecognizer;
    
}

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;

@end

@implementation MyWizardPlayerViewController

-(void)loadVideoPlayer
{
    player = [SJVideoPlayer sharedPlayer];
    [player.presentView addSubview:player.control.view];
    player.control.isCircularView=NO;

    [player.presentView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.offset(0);
     }];
    
    [player.control.view mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.offset(0);
     }];
    [self.topView addSubview:player.view];
    
    if (IS_PAD)
    {
        [player.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.offset(0);
             make.leading.trailing.offset(0);
             
             make.height.equalTo(player.view.mas_width).multipliedBy(9.0 / 16);
         }];
    }
    else
    {
        [player.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.offset(0);
             make.leading.trailing.offset(0);
             
             make.height.equalTo(player.view.mas_width).multipliedBy(9.0 / 12.5);
         }];
    }
    
    
#pragma mark - AssetURL
    
    //    player.assetURL = [[NSBundle mainBundle] URLForResource:@"sample.mp4" withExtension:nil];
    
    //    player.assetURL = [NSURL URLWithString:@"http://streaming.youku.com/live2play/gtvyxjj_yk720.m3u8?auth_key=1525831956-0-0-4ec52cd453761e1e7f551decbb3eee6d"];
    
    //    player.assetURL = [NSURL URLWithString:@"http://video.cdn.lanwuzhe.com/1493370091000dfb1"];
    
    //    player.assetURL = [NSURL URLWithString:@"http://vod.lanwuzhe.com/9da7002189d34b60bbf82ac743241a61/d0539e7be21a4f8faa9fef69a67bc1fb-5287d2089db37e62345123a1be272f8b.mp4?video="];
    
    
#pragma mark - Setting Player
    
    [player playerSettings:^(SJVideoPlayerSettings * _Nonnull settings)
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
        [[SJVideoPlayer sharedPlayer] showTitle:self.video_Title];
    }];
    
    
    SJVideoPlayerMoreSetting *model2 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_favorite_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model)
                                        {
                                            NSLog(@"clicked %@", model.title);
                                            [[SJVideoPlayer sharedPlayer] showTitle:model.title];
                                        }];
    
    #pragma mark - 2 Level More Settings
    
    SJVideoPlayerMoreSettingTwoSetting *twoS0 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:nil clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoS1 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:nil clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
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
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting0 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"QQ" image:[UIImage imageNamed:@"db_login_qq"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting1 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_login_weibo"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSettingTwoSetting *twoSetting2 = [[SJVideoPlayerMoreSettingTwoSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_login_weixin"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
        [[SJVideoPlayer sharedPlayer] showTitle:model.title];
    }];
    
    SJVideoPlayerMoreSetting *model3 =
    [[SJVideoPlayerMoreSetting alloc] initWithTitle:@""
                                              image:[UIImage imageNamed:@"db_audio_play_share_n"]
                                     showTowSetting:YES
                                 twoSettingTopTitle:@""
                                    twoSettingItems:@[twoSetting0, twoSetting1, twoSetting2]  // 2级 Settings
                                    clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {}];
    
    [player moreSettings:^(NSMutableArray<SJVideoPlayerMoreSetting *> * _Nonnull moreSettings)
     {
         /*         [moreSettings addObject:model0];
          [moreSettings addObject:model1];
          [moreSettings addObject:model2];
          [moreSettings addObject:model3];*/
     }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"isWaterMarkVc"];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    [defaults synchronize];
    if([self.ctaStatus isEqualToString:@"1"])
    {
        [self calltoButtonAction];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ctaStatusVal) name:@"calltoActStatusVal" object:nil];
    
    [self deleteLocalValue];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    [self.eAfterRemove addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.numberOfTapsRequired = 1;
    self.embedLink.userInteractionEnabled = false;
    
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    
    NSLog(@"MyWizardPlayerViewController didLoad");
    
    
    
    self.embedLink.text = @"";
    
    self.eTopRemove.hidden = true;
    self.eAfterRemove.hidden = true;
    
    self.embedLink.text = self.embed_Link;
    
    ary = @[@"128-red",@"128-blue",@"128-green",@"128-yelow",@"128-black",@"128-lavender",@"128-light-green",@"128-dark-red",@"128-ash"];
    
    chgAry = @[@"128-red-h",@"128-blue-h",@"128-green-h",@"128-yellow-h",@"128-black-h",@"128-lavender-h",@"128-light-green-h",@"128-dark-red-h",@"128-ash-h"];
    
    storeArray = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"rmveWzdWatermrk" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(sendSerevr:)
         name:@"rmveWzdWatermrk" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeUpdate:)
                                                 name:@"currentTime"
                                               object:nil];
    
    [[self.shareVBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    //self.wizradTitle.text = self.video_Title;
    self.navigationItem.title = self.video_Title;

    self.cta_backView.layer.borderWidth=1.0f;
   // self.cta_backView.layer.borderColor=[self colorFromHexString:@"#319BF4"].CGColor;
    
    self.cta_backView.layer.borderColor=[self colorFromHexString:@"#2d2c65"].CGColor;
    
    self.cta_backView.layer.cornerRadius=5.0f;
    
    self.embedLinkView.layer.borderWidth=1.0f;
    
    self.embedLinkView.layer.borderColor=[self colorFromHexString:@"#2d2c65"].CGColor;
    
    creditPoints= [[NSUserDefaults standardUserDefaults]objectForKey:@"credit_points"];
    NSString *rewards=[[NSUserDefaults standardUserDefaults]valueForKey:@"reward_count"];
    rewardedCount = rewards.integerValue;
    rewardedCount = 15 - rewardedCount;
    _CTA_outlet.titleLabel.numberOfLines = 1;
    _CTA_outlet.titleLabel.lineBreakMode = NSLineBreakByClipping;
    _CTA_outlet.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self adjustFontSizeToFillItsContents];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    toDayDate = [formatter stringFromDate:[NSDate date]];
   // [self currentPlan];
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
    
    if(currentSec>=4 && currentSec<=7)
    {
        button.hidden=NO;
        
    }
    else
    {
        button.hidden =YES;
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
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    //    [self playSampleClip1];
    
    
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playerURL] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:self.playerURL] jumpedToTime:0];
    
    [self createScrollViewMenu];
    
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
    
    //    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
    
    int x = 0;
    CGRect frame;
    for (int i = 0; i < [ary count]; i++)
    {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //        [UIButton buttonWithType:UIButtonTypeSystem];
        
        //        [button setTintColor:[UIColor blackColor]];
        
        if (IS_PAD)
        {
            if (i == 0)
            {
                frame = CGRectMake(0, 0, self.secondView.frame.size.width * 10/100 ,self.secondView.frame.size.height);
            }
            else
            {
                frame = CGRectMake((i * self.secondView.frame.size.width * 15/100) , 0, self.secondView.frame.size.width * 10/100, self.secondView.frame.size.height);
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
        
        //        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button setTag:i];
        
        //        [button setBackgroundColor:[UIColor greenColor]];
        
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
    
    
    //    self.aboveView.frame = self.scrlView.frame;
    
    //    self.scrlView.backgroundColor = [UIColor redColor];
    //    [self.secondView addSubview:se];
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
    else if (sender.tag == 1)
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
        
        resolVal = @"2k";
        
        
    }
    else if (sender.tag == 6)
    {
        [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
        
        UIImage *img = [UIImage imageNamed:chgAry[6]];
        
        [sender setImage:img forState:UIControlStateNormal];
        
        [self reChange];
        
        resolVal = @"4k";
        
    }
    else if (sender.tag == 7)
    {
        
        [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
        
        UIImage *img = [UIImage imageNamed:chgAry[7]];
        
        [sender setImage:img forState:UIControlStateNormal];
        
        [self reChange];
        
        resolVal = @"8k";
        
    }
    else if (sender.tag == 8)
    {
        
        [[sender imageView] setContentMode: UIViewContentModeScaleAspectFit];
        
        UIImage *img = [UIImage imageNamed:chgAry[8]];
        
        [sender setImage:img forState:UIControlStateNormal];
        
        [self reChange];
        
        resolVal = @"16k";
    }
    else
    {
        NSLog(@"Restricted, Upgrade ur plan");
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Kindly, Upgrade your Plan to Standard or Premium to access further Resolution!!!" preferredStyle:UIAlertControllerStyleAlert];
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
//                             }];
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
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please, Upgrade your Plan to Standard or Premium to access further Resolution!!!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"UpgradePlan";
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        popUp.inputTextField.hidden = YES;
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
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
       // [self DownloadVideo];
        [self saveVideo:self.playerURL];
        
    }else{
        if (resolVal == nil || resolVal == (id)[NSNull null])
        {
            //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Select any one of Resolution" preferredStyle:UIAlertControllerStyleAlert];
            //
            //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            //
            //        [alertController addAction:ok];
            //
            //        [self presentViewController:alertController animated:YES completion:nil];
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Select any one of Resolution" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor navyBlue];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
            
        }
        else
        {
            [self sendResol];
        }

    }
}
//-(void)SaveVideoTOPhotoAlbum
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    NSString *getImagePath = [basePath stringByAppendingPathComponent:videoName];
//    printf(" \n\n\n-Video file == %s--\n\n\n",[getImagePath UTF8String]);
//    UISaveVideoAtPathToSavedPhotosAlbum ( getImagePath,self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
//}
-(void)saveVideo:(NSString *)videoData{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *yourVideoData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoData]];
        if (yourVideoData) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"video.mp4"];
            
            if([yourVideoData writeToFile:filePath atomically:YES])
            {
                NSURL *capturedVideoURL = [NSURL URLWithString:filePath];
                [self addImageToCameraRoll:capturedVideoURL];

                //Here you can check video is compactible to store in gallary or not
              /*  if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:capturedVideoURL]) {
                    // request to save video in photo roll.
                    [library writeVideoAtPathToSavedPhotosAlbum:capturedVideoURL completionBlock:^(NSURL *assetURL, NSError *error) {
                        if (error) {
                           // callBack(@"error while saving video");
                            NSLog(@"error while saving video");
                        } else{
                            
                            //callBack(@"Video has been saved in to album successfully !!!");
                            
                        }
                    }];
                }*/
            }
            
        }
    });
}

- (void)addImageToCameraRoll:(NSURL *)filePath {
    NSString *albumName = @"HypdraAlbum";
    
    void (^saveBlock)(PHAssetCollection *assetCollection) = ^void(PHAssetCollection *assetCollection) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:filePath];
            PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error creating asset: %@", error);
            }else{
                [self.navigationController.view makeToast:@"Video is downloaded into the folder Photos/HypdraAlbum"];
            }
        }];
    };
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"localizedTitle = %@", albumName];
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    if (fetchResult.count > 0) {
        saveBlock(fetchResult.firstObject);
    } else {
        __block PHObjectPlaceholder *albumPlaceholder;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            albumPlaceholder = changeRequest.placeholderForCreatedAssetCollection;
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumPlaceholder.localIdentifier] options:nil];
                if (fetchResult.count > 0) {
                    saveBlock(fetchResult.firstObject);
                }
            } else {
                NSLog(@"Error creating album: %@", error);
            }
        }];
    }
}
- (void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSLog(@"Finished saving video with error: %@", error);
    //kapil here ****
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
//                                        NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=wizard_delete_my_album_video";
//
//                                        NSDictionary *params = @{@"user_id":user_id,@"del_id":self.deleteID,@"lang":@"iOS"};
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
//                                             [hud hideAnimated:YES];
//
//
//                                             if (IS_PAD)
//                                             {
//
//
//
//                                                 dispatch_async(dispatch_get_main_queue(),
//                                                                ^{
//
//                                                                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbumiPad" bundle:nil];
//
//                                                                    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//                                                                    [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
//
//                                                                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//                                                                    [self presentViewController:vc animated:YES completion:NULL];
//
//                                                                });
//
//                                             }
//                                             else
//                                             {
//
//
//                                                 dispatch_async(dispatch_get_main_queue(),
//                                                                ^{
//
//                                                                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
//
//                                                                    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//                                                                    [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
//
//                                                                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//                                                                    [self presentViewController:vc animated:YES completion:NULL];
//
//                                                                });
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
//
//                                    }
//                                    @finally
//                                    {
//                                        NSLog(@"Finally Exception");
//
//                                        [hud hideAnimated:YES];
//
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
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Are you sure to delete ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.hidden = YES;
    popUp.accessibilityHint =@"ConfirmToDelete";
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.inputTextField.hidden = YES;
    [popUp show];
}

- (IBAction)toActualShare:(id)sender
{
    if([isPlanForExport isEqualToString:@"-1"])
    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Kindly, Upgrade your Plan to Standard or Premium to Add a Call to Action button in your video!!!" preferredStyle:UIAlertControllerStyleAlert];
        /*
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {
             
                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainSettings" bundle:nil];
                                     
                 DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                                     
                 [vc awakeFromNib:@"contentController_12" arg:@"menuController"];
                                     
                 vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                     
                 [self presentViewController:vc animated:YES completion:NULL];
         }];*/
        
//        UIAlertAction * noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        
//        [alertController addAction:ok];
//        [alertController addAction:noButton];
        
        //[self presentViewController:alertController animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Please, Upgrade your Plan to Standard or Premium to Add a Call to Action button in your video!!!" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"UpgradePlanToCallToAction";
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else if ([isPlanForExport isEqualToString:@"0"])
    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Your Reached your export count of this month!!!" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                             {
//
//                             }];
//
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your Reached your export count of this month!!!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
    else
    {
        [self deleteLocalValue];
    
//        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure, Do you want to Share?"preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* yesButton = [UIAlertAction
//            actionWithTitle:@"Yes"
//            style:UIAlertActionStyleDefault
//            handler:^(UIAlertAction * action)
//            {
//                [self okButtonPressed];
//            }];
//
//        UIAlertAction* noButton = [UIAlertAction
//           actionWithTitle:@"No"
//           style:UIAlertActionStyleDefault
//           handler:^(UIAlertAction * action)
//           {
//
//           }];
//
//        [alert addAction:yesButton];
//        [alert addAction:noButton];
//
//
//        [self presentViewController:alert animated:YES completion:nil];
        
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

- (IBAction)copy:(id)sender
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[self.embedLink text]];
    
    self.eTopRemove.hidden = true;
    self.eAfterRemove.hidden = true;
    
    
    [self.navigationController.view makeToast:@"Link Copied"];
}

-(void)sendResol
{
    [hud hideAnimated:NO];
    
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
//                                    alertControllerWithTitle:@"Success" message:@"Check your email for video download link. We'll see you soon!"preferredStyle:UIAlertControllerStyleAlert];
//
//         UIAlertAction* yesButton = [UIAlertAction
//                                     actionWithTitle:@"Ok"
//                                     style:UIAlertActionStyleDefault
//                                     handler:nil];
//
//         [alert addAction:yesButton];
//
//         [self presentViewController:alert animated:YES completion:nil];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Check your email for video download link. We'll see you soon!" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"URL = %@",self.playerURL);
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [hud hideAnimated:YES];
    [self loadVideoPlayer];
    
    
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isWaterMarkVc"];
    
    self.navigationController.swipeBackEnabled = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSLog(@"User ID = %@",user_id);
    //restrictionForResolution and WATERMARK
    NSString *MemberShip=[[NSUserDefaults standardUserDefaults]objectForKey:@"MemberShipType"];
    
    if([MemberShip isEqualToString:@"Basic"])
    {
        arrCount=3;
        isPlanForCalltoAction=NO;
    }
    else if([MemberShip isEqualToString:@"Standard"])
    {
        arrCount=6;
        isPlanForCalltoAction=YES;
    }
    else {
        arrCount=(int)[ary count];
        isPlanForCalltoAction=YES;
        
        //Restriction For WATERMARK Base on Membership Type
        
        self.paymentResult = @"True";
        self.manageWaterBtn.hidden = false;
        self.removeWaterBtn.hidden = true;
        
    }
    
    self.callToActionStatus = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"callToactstatus"];
    
//    if([self.ctaStatus isEqualToString:@"1"])
//    {
//        [self calltoButtonAction];
//    }
    
    [self checkExportStatus];

}

-(void)calltoButtonAction
{
    NSDictionary *parameters;
    NSString *URL;
    NSError *error;      // Initialize NSError

    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
        parameters = @{@"lang":@"iOS",@"User_ID":user_id,@"call_to_dtl_sec":@"business_template",@"video_id":_video_ID};
        URL = @"https://www.hypdra.com/api/api.php?rquest=view_call_to_action_module";
    
    }else{

        parameters =@{@"lang":@"iOS",@"User_ID":user_id,@"call_to_dtl_sec":@"wizard",@"video_id":_video_ID};
        URL = @"https://www.hypdra.com/api/api.php?rquest=view_call_to_action_module";
    
    }
    
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
              
              NSArray *arr=[responseObject objectForKey:@"view_call_to_action_module"];
              NSLog(@"the arrr is %@",arr);
              NSDictionary *di=[arr objectAtIndex:arr.count-2];
              
              
                  btn_wid=[di objectForKey:@"button_width"];
                  btn_ht=[di objectForKey:@"button_height"];
                  xpos=[di objectForKey:@"button_x_position"];
                  ypos=[di objectForKey:@"button_y_position"];
                  
                  button = [UIButton buttonWithType:UIButtonTypeCustom];
                  
                  //                  String.valueOf((Integer.parseInt(button_x_position)/100.0)*video_container_width));
                  //                  Log.d("picasso_height_process", String.valueOf((Integer.parseInt(button_y_position)/100.0)*video_container_height));
                  //
                  float btnX=[xpos floatValue];
                  float btnY=[ypos floatValue];
                  
                  float origX=(btnX/100.0);
                  float origY=btnY/100.0;
                  
                  float origX1=(origX)*self.topView.frame.size.width;
                  float origY1=(origY)*self.topView.frame.size.height;
                  
                  float wid=150;//[btn_wid floatValue];
                  float ht =75;//[btn_ht floatValue];
                  
                  if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                      button.frame = CGRectMake(origX1,origY1,wid,ht);
                  
                  else
                      button.frame = CGRectMake(origX1,origY1,wid/1.5,ht/1.5);
                  
                  // button.frame=CGRectMake(5,10,100,200);
                  NSString *imgic=[[NSUserDefaults standardUserDefaults]stringForKey:@"calltoActionImagePath"];
                  
                  NSURL *url=[NSURL URLWithString:imgic];
                  UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                  [button setBackgroundImage:img forState:UIControlStateNormal];
                  
                  [button addTarget:self
                             action:@selector(loadWebView)
                   forControlEvents:UIControlEventTouchUpInside];
                  [player.view addSubview:button];
              
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSLog(@"viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [hud hideAnimated:YES];
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    
    [button removeFromSuperview];

    [[SJVideoPlayer sharedPlayer] stop];
    
    NSLog(@"viewDidDisappear");

    // [self.player pauseButtonPressed];
}

-(void)viewDidLayoutSubviews
{
    NSLog(@"self.paymentResult = %@",self.paymentResult);
    
    if (rewardedCount == 0)
    {
        self.topRemove.hidden = true;
        self.afterRemove.hidden = true;
    }
    
    //self.paymentResult = @"True";
    if ([self.paymentResult isEqualToString:@"True"])
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
    
    // [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
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
                 }
                                  didDismissBlock:
                 ^{
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

- (IBAction)ShareVideo:(id)sender
{
    NSLog(@"sender:%@",sender);
}

- (IBAction)removeWaterMark:(id)sender
{
    //    [self.player pauseButtonPressed];
    
    
    [self.player pauseContent];
    
    [self.player setAvPlayer:nil];
    
    [self.player setState:VKVideoPlayerStateDismissed];
    
    /*    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     PaymentViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PaymentPage"];
     
     vc.typeOfSection = @"wizard";
     
     [self.navigationController pushViewController:vc animated:YES];*/
    
    self.topRemove.hidden = false;
    
    self.afterRemove.hidden = false;
    
}

- (IBAction)manageWaterMark:(id)sender
{
    NSLog(@"MANAGE WATER");
    
    //    [self.player pauseButtonPressed];
    
    [self.player pauseContent];
    
    [self.player setAvPlayer:nil];
    
    [self.player setState:VKVideoPlayerStateDismissed];
self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;

        [[SJVideoPlayer sharedPlayer] stop];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
    
    WaterAndOrioViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WaterAndOrio"];
    
    vc.playURL = self.playerURL;
    
    [self.navigationController pushViewController:vc animated:YES];
 //WizardWaterAndOrioController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WizardWaterAndOrio"];

//        vc.playURL = self.playerURL;
//        vc.finalRndID = self.randID;
//
//        [self.navigationController pushViewController:vc animated:YES];
  //  }
    //    });
    
}

- (IBAction)btn240p:(id)sender
{
    //    [self.player pauseButtonPressed];
}


- (IBAction)share:(id)sender
{
    self.embedLink.text = self.embed_Link;
    
    self.eTopRemove.hidden = false;
    self.eAfterRemove.hidden = false;
}


- (void)okButtonPressed
{
    [hud hideAnimated:NO];
    
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
    
    //retrieving the filename from the response and appending it again to the path
    //this path "appDir" will be used as the target path
    //        appDir =  [appDir stringByAppendingFormat:@"/%@",[[downloadTask response] suggestedFilename]];
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
                 NSLog(@"avc cancelled");
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

-(void)addExportCount
{
    NSDictionary *parameters;
    NSString *URL;
    NSError *error;      // Initialize NSError
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
        parameters = @{@"User_ID":user_id,@"Video_ID":_video_ID,@"ExportedTo":@"ShareFromiOS",@"Section":@"business_template",@"lang":@"iOS"};;
        URL = @"https://www.hypdra.com/api/api.php?rquest=AddExportedVideo";
        
    }else{
        
        parameters =@{@"User_ID":user_id,@"Video_ID":_video_ID,@"ExportedTo":@"ShareFromiOS",@"Section":@"Wizard",@"lang":@"iOS"};
        URL = @"https://www.hypdra.com/api/api.php?rquest=AddExportedVideo";
    }
    
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
//                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Something went wrong, Try Again!!!" preferredStyle:UIAlertControllerStyleAlert];
//
//                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                                       {
//
//                                       }];
//
//                  [alertController addAction:ok];
//
//                  [self presentViewController:alertController animated:YES completion:nil];
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Server not connected  Try Again!!!" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor navyBlue];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
              }
              else
              {
//                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Successfully exported your Video!!!" preferredStyle:UIAlertControllerStyleAlert];
//
//                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                   {
//
//                   }];
//
//                  [alertController addAction:ok];
//
//                  [self presentViewController:alertController animated:YES completion:nil];
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Successfully exported your Video!!!" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
              }
          }
      }]resume];
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

- (IBAction)paymentBtn:(id)sender
{
    type = @"InApp";
    
    [TestKit setcFrom:@"Wizard"];
    
    [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.removewatermark"];
}


- (IBAction)inviteFrndBtn:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"WaterMark" forKey:@"InviteFor"];
    [[NSUserDefaults standardUserDefaults]setObject:@"Wizard" forKey:@"InviteThrough"];
    [[NSUserDefaults standardUserDefaults]setObject:_video_ID forKey:@"InviteVideoID"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //if (IS_PAD)
//    {
//
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbumiPad" bundle:nil];
//
//        InviteFriendsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InviteFriends"];
//
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else
//    {
    
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
        
        InviteFriendsViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InviteFriends"];
        
        [self.navigationController pushViewController:vc animated:YES];
   // }
    
}

- (IBAction)rewardVideoBtn:(id)sender
{
    type = @"RewardedVideo";

//    [self.player pauseContent];
//
//    [self.player setAvPlayer:nil];
//
//    [self.player setState:VKVideoPlayerStateDismissed];
//    [self startNewGame];

    if([creditPoints intValue]>=50)
    {
        creditsToAddMinus = @"50";
        operation = @"minus";
        rewardCount = @"0";
        [self updatePoints];
    }
    else
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have enough Credit Points to Remove WaterMark!      Kindly watch videos and get 10 points for each" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.accessibilityHint =@"GiftPoints";
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

-(void)updatePoints
{
    NSLog(@"Minutes / Space");
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [hud hideAnimated:NO];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=update_points";
    
    NSDictionary *params = @{@"User_ID":user_id,@"operation":operation,@"points":creditsToAddMinus,@"lang":@"iOS",@"Date":toDayDate,@"reward_count":rewardCount};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json minutes Reward Response:%@",responseObject);
         
         //         product = @"minutes";
         //         value = buyRewardMin;
         //         amount = @"0";
         
         creditPoints=[responseObject objectForKey:@"credit_points"];
         
         NSString *rewards = [responseObject objectForKey:@"reward_count"];
         [[NSUserDefaults standardUserDefaults]setValue:rewards forKey:@"reward_count"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         rewardedCount = rewards.integerValue;
         rewardedCount = 15 - rewardedCount;
         [[NSUserDefaults standardUserDefaults]setObject:creditPoints forKey:@"credit_points"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         [self sendServer];
         
         
         
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

- (IBAction)CallToAction:(id)sender {
    
//    if(isPlanForCalltoAction==YES)
//    {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CallToActionTabViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Call to action"];

vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    vc.calledVC = @"wizard";
//    vc.calledVC = @"business_template";
if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
    
[[NSUserDefaults standardUserDefaults]setObject:@"business_template" forKey:@"call_to_dtl_sec"];
    
}else{
    
 [[NSUserDefaults standardUserDefaults]setObject:@"wizard" forKey:@"call_to_dtl_sec"];
}
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:_playerURL forKey:@"VideoUrl"];
    [def setObject:_video_ID forKey:@"VideoId"];
    [def setObject:_randID forKey:@"RandId"];
    [def synchronize];
    
    [self.navigationController pushViewController:vc animated:YES];
    //}
  //  else
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Kindly, Upgrade your Plan to Standard or Premium to Add a Call to Action button in your video!!!" preferredStyle:UIAlertControllerStyleAlert];
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
//    }
}


- (void)startNewGame
{
    
    //    [activityIndicatorView startAnimating];
    
    NSString *rCount;
    
    if (rewardedCount > 0)
    {
        rCount = [NSString stringWithFormat:@"You can watch %d video to unlock Remove Watermark",rewardedCount];
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
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:@"ca-app-pub-3940256099942544/1712485313"];
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
        [[[UIAlertView alloc] initWithTitle:@"Interstitial not ready" message:@"The interstitial didn't finish " @"loading or failed to load" delegate:self cancelButtonTitle:@"Drat" otherButtonTitles:nil] show];
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
    
    rewardCount = @"1";
    operation = @"add";
    creditsToAddMinus = @"10";
    if (rewardedCount == 0)
    {
       // [self sendServer];
        
    }
    [self updatePoints];
    
}

-(void)sendServer
{
    NSDictionary *params;
    NSString *URLString;
    NSError *error;     // Initialize NSError
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
        params = @{@"User_ID":user_id,@"lang":@"iOS",@"Video_ID":self.video_ID,@"Section":@"business_template",@"Product":@"watermark",@"Value":@"true",@"BuyType":@"reward"};
        URLString = [NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=NonPaymentBenefits"];
        
    }else{
        params =@{@"User_ID":user_id,@"lang":@"iOS",@"Video_ID":self.video_ID,@"Section":@"wizard",@"Product":@"watermark",@"Value":@"true",@"BuyType":@"reward"};
        URLString = [NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=NonPaymentBenefits"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Rewarded Response:%@",responseObject);
         
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"Success"])
         {
             self.paymentResult = @"True";
             self.manageWaterBtn.hidden = false;
             self.removeWaterBtn.hidden = true;

             self.topRemove.hidden = true;
             self.afterRemove.hidden = true;
             [hud hideAnimated:YES];
             [hud_1 hideAnimated:YES];

         }
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Rewarded Error: %@", error);
         
        // rewardedCount = 1;
         
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
 
 NSDictionary *params = @{@"User_ID":user_id,@"video_id":self.video_id,@"payment_type":@"RewardedVideo",@"payment_status":@"true",@"payment_section":@"wizard",@"lang":@"iOS"};
 
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
 }*/


- (void)sendSerevr:(NSNotification *)note
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=payment_status";
    
    
    
    NSString *jsonString;
    
    NSDictionary *getDict =  [[NSUserDefaults standardUserDefaults]objectForKey:@"ConsumeReceipt"];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:getDict options:NSJSONWritingPrettyPrinted error:nil];
    
    if (! jsonData)
    {
        //        NSLog(@"Got an error: %@", error);
    } else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
        NSLog(@"Got an string: %@", jsonString);
    }
    
    
    
    //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=payment_status";
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=payment_status";
    
    NSDictionary *params = @{@"User_ID":user_id,@"video_id":self.video_ID,@"payment_type":type,@"payment_status":@"true",@"payment_section":@"wizard",@"lang":@"iOS",@"TransactionInfo":jsonString,@"ProductID":[note object],@"Amount":@"2",@"Status":@"1"};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Json Payment Response:%@",responseObject);
         
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"Success"])
         {
             self.paymentResult = @"True";

             self.manageWaterBtn.hidden = false;
             self.removeWaterBtn.hidden = true;
             
             
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
- (void)VideoDelete{
    @try
    {
        NSString *URLString;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Section"] isEqualToString:@"BUSINESS_TEMPLATES"]){
            
         URLString=@"https://www.hypdra.com/api/api.php?rquest=delete_my_business_template_video";
            
        }else{
            
        URLString=@"https://www.hypdra.com/api/api.php?rquest=wizard_delete_my_album_video";
            
        }
        NSDictionary *params = @{@"user_id":user_id,@"del_id":self.deleteID,@"lang":@"iOS"};
        
        [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"Response = %@",responseObject);
             
             NSString *albumCount = [responseObject objectForKey:@"advance_album_count"];
             
             int numValue = [albumCount intValue];
             
             NSLog(@"Get Album Count = %d",numValue);
             
             [[NSUserDefaults standardUserDefaults]setInteger:numValue forKey:@"AlbumCount"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             [hud hideAnimated:YES];
             
             
            // if (IS_PAD)
//             {
//
//
//
//                 dispatch_async(dispatch_get_main_queue(),
//                                ^{
//
//                                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbumiPad" bundle:nil];
//
//                                    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//                                    [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
//
//                                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//                                    [self presentViewController:vc animated:YES completion:NULL];
//
//                                });
//
//             }
//             else
//             {
             
                 
                 dispatch_async(dispatch_get_main_queue(),
                                ^{
                                    
                                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
                                    
                                    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
                                    
                                    [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
                                    
                                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                    
                                    [self presentViewController:vc animated:YES completion:NULL];
                                    
                                });
                 
            // }
             
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
    if([alertView.accessibilityHint isEqualToString:@"GiftPoints"]){
        
        [self.player pauseContent];
        [self.player setAvPlayer:nil];
        [self.player setState:VKVideoPlayerStateDismissed];
        [self startNewGame];

    }
    
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    [alertView hide];
    alertView = nil;
    
    NSLog(@"Cancel");
}
- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"UpgradePlan"]){
       // if (IS_PAD)
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
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToDelete"]){
        
        [hud hideAnimated:NO];
        
        [self VideoDelete];
       
    }else if([alertView.accessibilityHint isEqualToString:@"ConfirmToShare"]){
        [self okButtonPressed];
    }

    [alertView hide];
    alertView = nil;
}

@end

