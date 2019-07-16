
#import "SJVideoPlayer.h"
#import <Masonry.h>
#import <SwipeBack/SwipeBack.h>
#import "CreateTemplateViewController.h"
#import "CreateTemplateTableViewCell.h"
#import "UIColor+Utils.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "DEMORootViewController.h"
#import "MBProgressHUD.h"
@import GoogleMobileAds;


#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface CreateTemplateViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ClickDelegates,GADBannerViewDelegate>{
    
    NSMutableArray *titleArray;
    NSMutableDictionary *templateDic;
    NSInteger error_count;
    SJVideoPlayer *SJplayer;
    NSString *playerURL;
    MBProgressHUD *hud;

}
@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;
@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation CreateTemplateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    templateDic = [[NSMutableDictionary alloc]init];
    titleArray = [[NSMutableArray alloc]init];
    templateDic=[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"TenSTemplateDic"]]mutableCopy];
    [self.navigationItem setTitle:(NSString*)[templateDic objectForKey:@"template_name"]];
    titleArray = [[templateDic objectForKey:@"template_text"] mutableCopy];
    playerURL =[templateDic objectForKey:@"preview_video_path"];
    error_count = 0;
    [self.tableView reloadData];
    
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"createTemplate";
    CreateTemplateTableViewCell *cell = (CreateTemplateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CreateTemplateTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titles.tag =indexPath.row;
    NSDictionary *textDic = [titleArray objectAtIndex:indexPath.row
                             ];
    cell.titles.delegate = self;
    cell.titles.text = (NSString *)[textDic valueForKey:@"text_value"];
    [cell.titles addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    NSString *maximum = [textDic valueForKey:@"maximum_count"];
    cell.CharLimitIndicator.text = [NSString stringWithFormat:@"%u / %@",cell.titles.text.length,maximum];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)viewWillAppear:(BOOL)animated{
    if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        
        [self.ADView removeFromSuperview];
    }
     [self loadVideoPlayer];
}

-(void)viewDidAppear:(BOOL)animated{
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:playerURL] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:playerURL] jumpedToTime:0];
}

- (void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    self.bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
   // self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
    request.testDevices = nil;

    [self.bannerView loadRequest:request]; self.bannerView.center=CGPointMake(_ADView.frame.size.width/2,_ADView.frame.size.height/2);
    [_ADView addSubview:_bannerView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [[NSNotificationCenter defaultCenter]removeObserver:@"currentTime"];

    [SJplayer stop];
    
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
    [self.VideoView addSubview:SJplayer.view];
    
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
        [SJplayer showTitle:(NSString *)[templateDic valueForKey:@"Funsies"]];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    CreateTemplateTableViewCell *cell = (CreateTemplateTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *textDic = [titleArray objectAtIndex:textField.tag
                             ];
    
    NSString *maximum = [textDic valueForKey:@"maximum_count"];
    NSString *minimum = [textDic valueForKey:@"minimum_count"];
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength <= maximum.integerValue){
        if(newLength < minimum.integerValue){
            [cell.CharLimitIndicator setTextColor:[UIColor redColor]];
        }else{
            [cell.CharLimitIndicator setTextColor:[UIColor darkTextColor]];
            cell.CharLimitIndicator.text = [NSString stringWithFormat:@"%d / %@",newLength,maximum];
        }
        
        
        return YES;
    }else{
        return NO;
    }
}
-(void)textFieldDidChange :(UITextField *) textField{
    
    NSMutableDictionary *textDic = [[titleArray objectAtIndex:textField.tag
                                     ] mutableCopy];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    CreateTemplateTableViewCell *cell = (CreateTemplateTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *minimum = [textDic valueForKey:@"minimum_count"];
    if(textField.text.length < minimum.integerValue){
        
        if(cell.errorIndicator.hidden){
        error_count++;
        cell.errorIndicator.hidden = NO;
    }
    }else{
        
        if(!cell.errorIndicator.hidden){
            
            error_count--;
            cell.errorIndicator.hidden=YES;

        }
        [textDic setValue:(NSString *)textField.text forKey:@"text_value"];
        [titleArray replaceObjectAtIndex:textField.tag withObject:textDic];

    }
}
- (IBAction)Submit:(id)sender {
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(error_count > 0){
        
    }else{
    [templateDic setObject:titleArray forKey:@"template_text"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:templateDic]  forKey:@"TenSTemplateDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:nil];

    }
}

- (IBAction)back:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TenSTemplateDic"];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
