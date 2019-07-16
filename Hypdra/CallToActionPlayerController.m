//
//  CallToActionPlayerController.m
//  Montage
//
//  Created by MacBookPro on 7/28/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "CallToActionPlayerController.h"
#import "VKVideoPlayerViewController.h"
#import "VKVideoPlayerView.h"
#import "VKVideoPlayerConfig.h"
#import "SPUserResizableView.h"
#import "AFNetworking.h"
#import "SJVideoPlayer.h"
#import "MBProgressHUD.h"
#import "SJVideoPlayerControlView.h"
#import "DEMORootViewController.h"
#import "MyPlayerViewController.h"
#import "MyWizardPlayerViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define URL @"https://www.hypdra.com/api/api.php?rquest=call_to_action_module"

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#pragma mark -

@interface CallToActionPlayerController (SJVideoPlayerControlViewDelegateMethods)<SJVideoPlayerControlViewDelegate>
@end
@interface CallToActionPlayerController ()<VKVideoPlayerDelegate,SPUserResizableViewDelegate,SJVideoPlayerControlDelegate,UITextFieldDelegate,SJVideoPlayerControlViewDelegate>
{
    NSString *user_id,*PlayerUrl,*videoId,*randId,*totalDuration;
    int startMin,endMin,startSec,endSec,CallToActDur,maxDUR,startTime,endTime;
    
    int endMinutes,endSeconds,startMinutes,startSeconds,endTextFieldTotalSecond,startTextFieldTotalSecond,totalSecond,maxMinute,maxSecond;
    
    SJVideoPlayer *SJplayer;
    MBProgressHUD *hud;
    int totalSeconds;
    float xx,yy;
}

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;

@end

@implementation CallToActionPlayerController

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    NSData *imgData =  [NSData dataWithContentsOfURL:[NSURL URLWithString:_imgPath]];
    
    _callToActionImage = [UIImage imageWithData:imgData];
    //PlayerUrl =@"https://hypdra.com/api/uploads/599e5c01e48b3.mp4";
    PlayerUrl = [defaults valueForKey:@"VideoUrl"];
    videoId = [defaults valueForKey:@"VideoId"];
    randId =[defaults valueForKey:@"RandId"];
    
    //NSURL *videoURL=[[NSURL alloc] initWithString:PlayerUrl];
    //1
    /*  AVURLAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
     _naturalSize = [[[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
     
     self.player = [[VKVideoPlayer alloc] init];
     self.player.delegate = self;
     self.player.view.frame = self.topView.bounds;
     self.player.view.playerControlsAutoHideTime = @10;
     [self.topView addSubview:self.player.view];*/
    
    //    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    //    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    //    [datePicker setDate:[NSDate date]];
    //    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    //    [datePicker setLocale:locale];
    //    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    //    [self.StartTime_txt setInputView:datePicker];
    
    
    //    CALayer *border = [CALayer layer];
    //    CGFloat borderWidth = 1;
    //    border.borderColor = [UIColor blueColor
    //                          ].CGColor;
    // NSLog(@"Duration");
    
    //    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    //    {
    //
    //        border.frame = CGRectMake(0, self.txtFieldAddress.frame.size.height - borderWidth, self.txtFieldAddress.frame.size.width+220, 1);
    //    }
    //
    //    else if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    //    {
    //        border.frame = CGRectMake(0, self.txtFieldAddress.frame.origin.y-270, self.txtFieldAddress.frame.size.width, 1);
    //    }
    
    //    border.borderWidth = borderWidth;
    //    [self.txtFieldAddress.layer addSublayer:border];
    //    self.txtFieldAddress.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start_min_txtChanged:) name:UITextFieldTextDidChangeNotification object:self.start_min_txt];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start_sec_txtChanged:) name:UITextFieldTextDidChangeNotification object:self.start_sec_txt];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(End_minChanged:) name:UITextFieldTextDidChangeNotification object:self.End_min];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(End_secChanged:) name:UITextFieldTextDidChangeNotification object:self.End_sec];
    NSString *duration = [[NSUserDefaults standardUserDefaults]valueForKey:@"VideoDuration"];
    NSString *code = [duration substringFromIndex: duration. length - 2];
    
    NSLog(@"Duration %@",code);
    
    // [self configureLabelSlider];
    
    //1
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
     
     [defaultCenter addObserver:self selector:@selector(scrubberValueUpdated:) name:kVKVideoPlayerScrubberValueUpdatedNotification object:nil];
     [defaultCenter addObserver:self selector:@selector(durationDidLoad:) name:kVKVideoPlayerDurationDidLoadNotification object:nil];
    
    self.txtFieldAddress.delegate=self;
    //    self.start_min_txt.delegate=self;
    //    self.End_min.delegate=self;
    //    self.start_sec_txt.delegate=self;
    //    self.End_sec.delegate=self;
    
    
    UIImage *image = [UIImage imageNamed:@"slideDefault"];
    
    self.Slide.lowerHandleImageNormal = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 8, 1, 8)];
    
    self.Slide.upperHandleImageNormal = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 8, 1, 8)];
    self.Slide.tintColor=UIColorFromRGB(0x2d2c65);
    self.Slide.lowerHandleImageHighlighted=[UIImage imageNamed:@"slideHighlighted"];
    self.Slide.upperHandleImageHighlighted=[UIImage imageNamed:@"slideHighlighted"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timeUpdate:)
                                                 name:@"currentTime"
                                               object:nil];

    
    //[self setCallToAction];
}
-(void)timeUpdate:(NSNotification *)notify{
    NSTimeInterval time =[SJVideoPlayer sharedPlayer].currentTime;
    NSLog(@"my time %f",time);
    
    int minutes = floor(time/60);
    int seconds = round(time - minutes * 60);
    int currentSec = (minutes*60)+seconds;
    NSLog(@"Time %d",currentSec);
//    if(currentSec>=4 && currentSec<=8){
//        _callToActionBtn.hidden=NO;
//
//    }else {
//        _callToActionBtn.hidden =YES;
//        }
    
    
    NSDictionary* userInfo = notify.userInfo;
   totalDuration =  [userInfo valueForKey:@"DurationTime"];
    NSLog(@"The tot durrr is %@",totalDuration);
   
}
- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (void) configureLabelSlider
{
    
    @try
    {
    NSString *duration = [[NSUserDefaults standardUserDefaults]valueForKey:@"durationvalue"];
    
    NSLog(@"dur val %@",duration);
    
    NSArray *components = [duration componentsSeparatedByString:@":"];
    
    NSString *hour=[components objectAtIndex:0];
    NSString *minute=[components objectAtIndex:1];
    NSString *second=[components objectAtIndex:2];
    
    NSString *h2=@"00";
    NSString *m2=@"00";
    NSString *s2=@"00";
    
    float hours   = [[components objectAtIndex:0] floatValue];
    float minutes = [[components objectAtIndex:1] floatValue];
    NSLog(@"The minutes is %f",minutes);

    int seconds = [[components objectAtIndex:2] intValue];
    
    self.Slide.minimumValue = 0;
    self.Slide.lowerValue = 0;
    self.lowerLabel.text=[NSString stringWithFormat:@"%@:%@:%@",h2,m2,s2];
    startSec = 0;
    totalSeconds=(hours*3600)+(minutes*60)+seconds;
    NSLog(@"the tot is  %d",totalSeconds);
    endSec = totalSeconds;
    self.Slide.maximumValue=totalSeconds;
    self.Slide.upperValue=totalSeconds;
    
    self.upperLabel.text=[NSString stringWithFormat:@"%@:%@:%@",hour,minute,second];
  }@catch(NSException *ex)
    {
        
    }
}
//{
//
//    NSString *duration = @"00:02:05";//[[NSUserDefaults standardUserDefaults]valueForKey:@"durationvalue"];
//
//    NSArray *components = [duration componentsSeparatedByString:@":"];
//
//    int hours   = [[components objectAtIndex:0] intValue];
//    int minutes = [[components objectAtIndex:1] intValue];
//    int seconds = [[components objectAtIndex:2] intValue];
//    NSLog(@"the hour is  %d",hours);
//    NSLog(@"the minute is  %d",minutes);
//    NSLog(@"the seconds is  %d",seconds);
//
//    self.Slide.minimumValue = 0;
//    self.Slide.lowerValue = 0;
//    self.lowerLabel.text=[NSString stringWithFormat:@"%d",(int)self.Slide.lowerValue];
//
//    int totalSeconds=(hours*3600)+(minutes*60)+seconds;
//    NSLog(@"the tot is  %d",totalSeconds);
//
//    self.Slide.maximumValue=totalSeconds;
//    self.Slide.upperValue=totalSeconds;
//
//    self.upperLabel.text=[NSString stringWithFormat:@"%d",(int)self.Slide.upperValue];
//
//}

-(void)loadVideoPlayer
{
    @try
    {
    SJplayer = [SJVideoPlayer sharedPlayer];
    SJplayer.control.delegate=self;
        
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
                                                blue:arc4random() % 256 / 255.0 alpha:1];
         
         settings.trackColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                               green:arc4random() % 256 / 255.0
                                                blue:arc4random() % 256 / 255.0 alpha:1];
         
         settings.bufferColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                                green:arc4random() % 256 / 255.0
                                                 blue:arc4random() % 256 / 255.0 alpha:1];
         
         settings.replayBtnTitle = @"Replay";
         settings.replayBtnFontSize = 12;
     }];
    
#pragma mark - Loading Placeholder
    
    //    player.placeholder = [UIImage imageNamed:@"sj_video_player_placeholder"];
    
#pragma mark - 1 Level More Settings
    
    SJVideoPlayerMoreSetting.titleFontSize = 12;
    
    SJVideoPlayerMoreSetting *model0 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_like_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model)
                                        {
                                            NSLog(@"clicked %@", model.title);
                                            [SJplayer showTitle:@"SJVideoPlayer"];
                                            
                                            //self.video_Title];
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
    SJplayer.control.delegate = self;
    }@catch(NSException *ex)
    {
        
    }
}
//- (void)timeDelegation{
//
//}
- (void)lowerLabelSlider
{
    if((_start_min_txt.text.length)>=1 && _start_sec_txt.text.length>=1)
    {
        startTextFieldTotalSecond=((startMinutes*60)+startSeconds);
        self.Slide.lowerValue = startTextFieldTotalSecond;
    }
    
}
- (void) upperLabelSlider
{
    if(_End_min.text.length>=1)
    {
        endTextFieldTotalSecond=((endMinutes*60)+endSeconds);
        self.Slide.upperValue =endTextFieldTotalSecond;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    if (textField == self.txtFieldAddress)
    {
        const int movementDistance = -130; // tweak as needed
        const float movementDuration = 0.3f; // tweak as needed
        
        int movement = (up ? movementDistance : -movementDistance);
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        //self.scrollView.frame = CGRectOffset(self.scrollView.frame, 0, movement);
        [UIView commitAnimations];
        
    }
    
}

- (void)durationDidLoad:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    NSNumber* duration = [info objectForKey:@"duration"];
    maxDUR = duration.intValue;
    NSLog(@"maxDUR %@",duration);
    
    maxMinute=[duration intValue]/60;
    maxSecond=[duration intValue]%60;
}

- (void)scrubberValueUpdated:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    int a=(int)[[info objectForKey:@"scrubberValue"] floatValue];
    NSLog(@"scrubberValueUpdatedZZZ %d",a);
    if(a>=startTime && a<=endTime){
        if(!_buttonExist){
            [self setCallToAction];
            _buttonExist = YES;
        }
    }else if(a<startTime ||a>endTime){
        if(_buttonExist){
            [_callToActionBtn removeFromSuperview];
            _buttonExist = NO;
        }
    }
}

-(void)setCallToAction
{
    @try
    {
    _callToActionBtn = nil;
    
   // _callToActionBtn = [[SPUserResizableView alloc] initWithFrame:CGRectMake(250, 250, 200, 200)];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HideAnchors"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HideBorderColour"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
    _callToActionBtn = [[SPUserResizableView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    }
    
    else
    {
        _callToActionBtn = [[SPUserResizableView alloc] initWithFrame:CGRectMake(0,0,150,150)];
    }
    
    _callToActionBtn.center = self.topView.center;
    
    NSLog(@"before Btn width and ht is %f and %f",_callToActionBtn.frame.size.width,_callToActionBtn.frame.size.height);
    
    xx=(_callToActionBtn.frame.origin.x/self.topView.frame.size.width)*100;
    NSLog(@"befor xx %f",xx);
    yy=(_callToActionBtn.frame.origin.y/self.topView.frame.size.height)*100;
    NSLog(@"befor yy %f",yy);

    _action_btn_img = [[UIImageView alloc]initWithFrame:_callToActionBtn.bounds];
    _action_btn_img.contentMode = UIViewContentModeCenter;
    
    _action_btn_img.contentMode = UIViewContentModeScaleAspectFit;
    
    _action_btn_img.alpha=1.0;
    
    _action_btn_img.image = _callToActionImage;
    _callToActionBtn.contentView = _action_btn_img;
    _callToActionBtn.delegate = self;
    _callToActionBtn.contentView.layer.cornerRadius = 15;
//    _callToActionBtn.layer.shadowColor = [UIColor blackColor].CGColor;
//    _callToActionBtn.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    _callToActionBtn.layer.shadowOpacity = 0.8f;
    _callToActionBtn.resizableStatus = NO;

    [_callToActionBtn showEditingHandles];
    [_callToActionBtn.cancel setHidden:YES];
    [SJplayer.view addSubview:_callToActionBtn];
 }@catch(NSException *ex)
    {
        
    }
    [self configureLabelSlider];
}

- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView
{
   // userResizableView.contentView.alpha = 1.0f;
}

-(void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView{
//    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
//        // Animate the alpha value of your imageView from 1.0 to 0.0 here
//        userResizableView.contentView.alpha = 0.4;
//    } completion:^(BOOL finished) {
//        
//    }];
}
-(void)updateTextField:(id)sender
{
    //    UIDatePicker *picker = (UIDatePicker*)self.self.StartTime_txt.inputView;
    //    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    //    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    //    dateString = [@"Start:" stringByAppendingString:dateString];
    //    self.self.StartTime_txt.text = [NSString stringWithFormat:@"%@",dateString];
}

- (void)start_min_txtChanged:(NSNotification *)notification
{
   /* startMin = [self.start_min_txt.text intValue];

    if(startMin > maxMinute)
    {
        startMin=00;
        self.start_min_txt.text =[NSString stringWithFormat:@"%d",startMin];
        startTime = (startMin*60) + startSec;
        NSLog(@"startTime %d",startTime);

        startMinutes=startMin;

    }
    else
    {
        startMinutes=startMin;

    }
    [self lowerLabelSlider];*/
}

- (void)start_sec_txtChanged:(NSNotification *)notification
{
    /*startSec = [self.start_sec_txt.text intValue];
    
    if(startSec > 60 && startSec>totalSecond)
    {
        startSec=00;
        
        self.start_sec_txt.text =[NSString stringWithFormat:@"%d",startSec];
        
        startTime = (startMin*60) + startSec;
        NSLog(@"startTime %d",startTime);
        startSeconds=startSec;
        
    }
    else
    {
        startSeconds=startSec;
    }
    [self lowerLabelSlider];*/
}

- (void)End_minChanged:(NSNotification *)notification
{
   /* endMin = [self.End_min.text intValue];
    
    if(endMin > maxMinute)
    {
        endMin=00;
        self.End_min.text =[NSString stringWithFormat:@"%d",endMin];
        
        endTime  = (endMin*60)+endSec;
        NSLog(@"endTime %d",endTime);
        endMinutes=endMin;
    }
    else
    {
        endMinutes=endMin;
    }
    [self upperLabelSlider];*/
    
}

- (void)End_secChanged:(NSNotification *)notification {
    
  /*  endSec = [self.End_sec.text intValue];

    if((endSec > 60) || (endMin==maxMinute && endSec>maxSecond))
    {
        endSec=00;
        self.End_sec.text =[NSString stringWithFormat:@"%d",endSec];
        endTime  = (endMin*60)+endSec;
        NSLog(@"endTime %d",endTime);
        endSeconds=endSec;
    }
    else
    {
        endSeconds=endSec;
    }
    [self upperLabelSlider];*/
}

-(void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    NSLog(@"User ID = %@",user_id);

    [self loadVideoPlayer];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    NSLog(@"viewWillDisappear");
    
}
#pragma mark - keyboard movements
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect f = self.view.frame;
//        f.origin.y = -keyboardSize.height;
//        self.view.frame = f;
//    }];
//}
//
//-(void)keyboardWillHide:(NSNotification *)notification
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect f = self.view.frame;
//        f.origin.y = 0.0f;
//        self.view.frame = f;
//    }];
//}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [[NSNotificationCenter defaultCenter]removeObserver:@"currentTime"];
    //    [self.player pauseButtonPressed];
    
    [hud hideAnimated:YES];
    
    self.currentTime = SJplayer.currentTime;
    
    [SJplayer stop];
    
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self playSampleClip1];
//
//}

- (void)viewDidAppear:(BOOL)animated
{
    
    //    [self playSampleClip1];
    
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VideoUrl"]] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"VideoUrl"]] jumpedToTime:0];
    
    NSLog(@"%zd - %s", __LINE__, __func__);
    [self setCallToAction];

    // [self createScrollViewMenu];
    
}


/*
 - (void)playSampleClip1
 {
 NSURL *videoURL=[[NSURL alloc] initWithString:PlayerUrl];
 
 [self playStream:videoURL];
 }/*
 
 //1
 /*
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
- (IBAction)slideChanges:(NMRangeSlider *)sender
{
    @try
    {
    UIImage *image=[UIImage imageNamed:@"slideImg"];
    self.Slide.lowerHandleImageNormal = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 8, 1, 8)];
    self.Slide.upperHandleImageNormal = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 8, 1, 8)];
    

    if(self.Slide.lowerValue==0 && self.Slide.upperValue==totalSeconds)
    {
        UIImage *image=[UIImage imageNamed:@"slideDefault"];
        self.Slide.lowerHandleImageNormal = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 8, 1, 8)];
        self.Slide.upperHandleImageNormal = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 8, 1, 8)];
        
    }
    
    [self updateSliderLabels];
    }@catch(NSException *ex)
    {
        
    }
}

- (void) updateSliderLabels
{
    @try
    {
    // You get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
    lowerCenter.x = (self.Slide.lowerCenter.x+55.0f+ self.Slide.frame.origin.x);
    lowerCenter.y = (self.Slide.center.y+58.0f);

    }
    
    else
    {
        lowerCenter.x = (self.Slide.lowerCenter.x+13.0f+ self.Slide.frame.origin.x);
        lowerCenter.y = (self.Slide.center.y+30.0f);

    }

    self.lowerLabel.center = lowerCenter;
    
    int lowerSecond = (int)self.Slide.lowerValue % 60;
    int lowerMinute = (int)(self.Slide.lowerValue / 60) % 60;
    int lowerHour = (int)self.Slide.lowerValue / 3600;
    
        self.lowerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",lowerHour,lowerMinute,lowerSecond];
    startSec = (lowerMinute*60)+lowerSecond;
    CGPoint upperCenter;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        upperCenter.x = (self.Slide.upperCenter.x-55.0f+ self.Slide.frame.origin.x);
        upperCenter.y = (self.Slide.center.y+57.0f);
    }
    
    else
    {
        upperCenter.x = (self.Slide.upperCenter.x-13.0f+ self.Slide.frame.origin.x);
        upperCenter.y = (self.Slide.center.y+30.0f);
    }
    
    self.upperLabel.center = upperCenter;
    
    int upperSecond = (int)self.Slide.upperValue % 60;
    int upperMinute = (int)(self.Slide.upperValue / 60) % 60;
    int upperHour = (int)self.Slide.upperValue / 3600;
    endSec = (upperMinute*60)+upperSecond;
    self.upperLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",upperHour,upperMinute,upperSecond];
    
//    self.start_min_txt.text=[NSString stringWithFormat:@"%d",((int)self.Slide.lowerValue)/60];
//    self.start_sec_txt.text=[NSString stringWithFormat:@"%d",((int)self.Slide.lowerValue)%60];
//
//    self.End_min.text=[NSString stringWithFormat:@"%d",((int)self.Slide.upperValue)/60];
//    self.End_sec.text=[NSString stringWithFormat:@"%d",((int)self.Slide.upperValue)%60];
 }@catch(NSException *exception)
    {
        
    }
}
//{
//    // You get get the center point of the slider handles and use this to arrange other subviews
//
//    CGPoint lowerCenter;
//    lowerCenter.x = (self.Slide.lowerCenter.x + self.Slide.frame.origin.x);
//    lowerCenter.y = (self.Slide.center.y - 30.0f);
//    self.lowerLabel.center = lowerCenter;
//    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.Slide.lowerValue];
//
//    CGPoint upperCenter;
//    upperCenter.x = (self.Slide.upperCenter.x + self.Slide.frame.origin.x);
//    upperCenter.y = (self.Slide.center.y - 30.0f);
//    self.upperLabel.center = upperCenter;
//    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.Slide.upperValue];
//
//    self.start_min_txt.text=[NSString stringWithFormat:@"%d",((int)self.Slide.lowerValue)/60];
//    self.start_sec_txt.text=[NSString stringWithFormat:@"%d",((int)self.Slide.lowerValue)%60];
//
//    self.End_min.text=[NSString stringWithFormat:@"%d",((int)self.Slide.upperValue)/60];
//    self.End_sec.text=[NSString stringWithFormat:@"%d",((int)self.Slide.upperValue)%60];
//
//}

-(void)setParams
{
    @try
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
        
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [manager.requestSerializer setTimeoutInterval:150];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        //  NSDictionary *params = @{@"User_Name":@"Ragu",@"Email_ID": self.email.text,@"Password":self.password.text,};
        NSLog(@"startTime %@",[NSString stringWithFormat:@"%d",startTime]);
        NSLog(@"endTime %@",[NSString stringWithFormat:@"%d",endTime]);
        
        
        
        NSLog(@"xx and yy %f,%f",xx,yy);
        NSLog(@"my img path %@",_imgPath);
        
        //video_id ,
        NSDictionary *params = @{@"lang":@"iOS",@"User_ID":user_id,@"video_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"VideoId"],@"id":[[NSUserDefaults standardUserDefaults] stringForKey:@"idVal"],@"url":self.txtFieldAddress.text,@"start_time":[NSString stringWithFormat:@"%d",startSec],@"end_time":[NSString stringWithFormat:@"%d",endSec],@"screen_width":@"30",@"screen_height":@"30",@"button_width":[NSString stringWithFormat:@"%f",_callToActionBtn.frame.size.width],@"button_height":[NSString stringWithFormat:@"%f",_callToActionBtn.frame.size.height],@"button_color":@"0 ",@"button_x_position":[NSString stringWithFormat:@"%f", xx],@"button_y_position":[NSString stringWithFormat:@"%f",yy],@"text":@"hello",@"text_color":@"0",@"text_size":@"0",@"font_style":@"0 ",@"button_width_val":@"0",@"font_case":@"0 ",@"compressed_id":@"0",@"icon_path":_imgPath,
                                 @"call_to_dtl_sec":    [[NSUserDefaults standardUserDefaults]stringForKey:@"call_to_dtl_sec"]};
        
        NSLog(@"The pparam %@",params);
        
        [manager POST:@"https://www.hypdra.com/api/api.php?rquest=call_to_action_module" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             
             NSLog(@"call_to_action_module: %@", responseObject);
             
             NSDictionary *dict=responseObject;
             NSString *status=[dict objectForKey:@"status"];
             
             if([status isEqualToString:@"Success"])
             {
//                 NSString *rID=[[NSUserDefaults standardUserDefaults]stringForKey:@"randomID"];
//                 NSString *pID=[[NSUserDefaults standardUserDefaults]stringForKey:@"playerID"];
//                 NSString *videoTitle=[[NSUserDefaults standardUserDefaults]stringForKey:@"video_title"];
                 
                 
                 if([[[NSUserDefaults standardUserDefaults]stringForKey:@"call_to_dtl_sec"] isEqualToString:@"advance"])
                 {
                     
                     
                     //             UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
                     //             MyPlayerViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MyPlayer"];
                     //             vc.playerURL = rID;
                     //             vc.paymentResult = pID;
                     //             vc.video_ID = [[NSUserDefaults standardUserDefaults]valueForKey:@"VideoId"];
                     //             vc.randID = [[NSUserDefaults standardUserDefaults]valueForKey:@"RandId"];
                     //             vc.video_Title = videoTitle;
                     //             vc.ctaBtn=@"calltoact";
                     //             vc.ctaStatus=@"1";
                     
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"calltoActStatusVal" object:self];
                     
                     NSArray *aa=[self.navigationController viewControllers];
                     
                     NSLog(@"aa controll %@",aa);
                     
                     [self.navigationController popToViewController:[aa objectAtIndex:1] animated:YES];
                     // [self.navigationController pushViewController:vc animated:YES];
                 }
                 
                 else
                 {
                     
                     //                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
                     //                 MyWizardPlayerViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MyWizardPlayer"];
                     //                 vc.playerURL = rID;
                     //                 vc.paymentResult = pID;
                     //                 vc.video_ID = [[NSUserDefaults standardUserDefaults]valueForKey:@"VideoId"];
                     //                 vc.randID = [[NSUserDefaults standardUserDefaults]valueForKey:@"RandId"];
                     //                 vc.video_Title = videoTitle;
                     //                 vc.ctaBtn=@"calltoact";
                     //                 vc.ctaStatus=@"1";
                     
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"calltoActStatusVal" object:self];
                     
                     NSArray *aa=[self.navigationController viewControllers];
                     
                     NSLog(@"aa controll %@",aa);
                     
                     [self.navigationController popToViewController:[aa objectAtIndex:1] animated:YES];
                     // [self.navigationController pushViewController:vc animated:YES];
                 }
                 
             }
         }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"Error Video Build: %@", error);
         }];
    }@catch(NSException *ex)
    {
        
    }
}

- (IBAction)backAction:(id)sender
{
    NSString *valueToSave = @"collectionPage";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"collectionPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray *array = [self.navigationController viewControllers];
    
    [self.navigationController popToViewController:[array objectAtIndex:2] animated:YES];
    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
//
//    [vc awakeFromNib:@"contentController_11" arg:@"menuController"];
//
//    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//
//    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)useForVideoAction:(id)sender
{
    @try
    {
    xx=(_callToActionBtn.frame.origin.x/self.topView.frame.size.width)*100;
    yy=(_callToActionBtn.frame.origin.y/self.topView.frame.size.height)*100;

    NSLog(@"after Btn width and ht is %f and %f",_callToActionBtn.frame.size.width,_callToActionBtn.frame.size.height);
    
    NSLog(@"after xx %f",xx);
    NSLog(@"after yy %f",yy);
    
    [self setParams];
    }@catch(NSException *ex)
    {
        
    }
}

@end

