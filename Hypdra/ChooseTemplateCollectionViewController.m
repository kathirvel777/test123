//
//  ChooseTemplateCollectionViewController.m
//  Hypdra
//
//  Created by MacBookPro on 7/4/18.
//  Copyright © 2018 sssn. All rights reserved.

#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DEMORootViewController.h"
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
#import "ChooseTemplateCollectionViewController.h"
#import "CreateTemplateViewController.h"
#import "SWRevealViewController.h"
@import GoogleMobileAds;

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface ChooseTemplateCollectionViewController ()<GADBannerViewDelegate>{
    NSMutableArray *finalArray;
    
    NSString *user_id,*creditPoints,*templateCategeory;
    NSMutableURLRequest *request;
    
    NSString *imgName,*purchase_type;
    
    NSIndexPath *selectedValue;
    
    MBProgressHUD *hud;
    
    NSString *pathValue,*idValue,*pathGif,*menuCategory,*TenStype;
    int selected_cell_index;
    SJVideoPlayer *SJplayer;
    NSArray *imageArray;
    int selectedIndexPath;
}
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property(nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;
@end

@implementation ChooseTemplateCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.swipeBackEnabled=NO;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sideMenu setTarget: self.revealViewController];
        
        [self.sideMenu setAction: @selector( revealToggle: )];
        
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"MenuFrontPage"]isEqualToString:@"fromWizard"])
    {
        
    [revealViewController revealToggleAnimated:NO];
    revealViewController.rearViewRevealOverdraw = 0;
  
    }
    
    [revealViewController panGestureRecognizer];
    
    user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_ID"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.bounces = false;
    
    NSLog(@"SelectedValue = %@",selectedValue);
    
    self.collectionView.bounces = false;
    _collectionView.contentInset=UIEdgeInsetsMake(5, 5, 5, 5);
    creditPoints =(NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:@"credit_points"];
    
    self.availableCredits_lbl.text =[NSString stringWithFormat:@"Available Credits: %@", creditPoints];
    templateCategeory = [[NSUserDefaults standardUserDefaults]valueForKey:@"TemplateCatrgory"];
   self.navigationItem.title =[[NSUserDefaults standardUserDefaults]valueForKey:@"TemplateTitle"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unlockTenzTemplate" object:nil];
    UITapGestureRecognizer *TapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeVideoPlayer:)];
    TapRecognizer.numberOfTapsRequired = 1;
    [self.blurView addGestureRecognizer:TapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(sendServerTemplate:)
        name:@"unlockTenzTemplate" object:nil];
    
     TenStype = [[NSUserDefaults standardUserDefaults]valueForKey:@"TenStype"];
    if([TenStype isEqualToString:@"Template"]){
        self.Choose_Btn.hidden = YES;
    }
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


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unlockTenzTemplate" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
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
    
    static NSString *CellIdentifier = @"templateCell";
    
    ChooseTemplateCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
   
    cell.alpha = 1.0;
    cell.imgView.backgroundColor = [UIColor darkGrayColor];
    
    NSDictionary *mainCategory=[finalArray objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[mainCategory objectForKey:@"preview_image"]];
    
    [cell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
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
    
    NSString *membership = [[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"];
    
    if([TenStype isEqualToString:@"Template"]){
       NSString *paid = (NSString *)[mainCategory objectForKey:@"is_paid"];
        if(([membership isEqualToString:@"Basic"] && ([paid isEqualToString:@"1"] || [paid isEqualToString:@"2"] || [paid isEqualToString:@"3"])) ||  ([membership isEqualToString:@"Standard"] && ([paid isEqualToString:@"2"] || [paid isEqualToString:@"3"])) || ([membership isEqualToString:@"Premium"] && [paid isEqualToString:@"3"])){
            
            cell.lock_btn.hidden = NO;
            cell.lock_btn.tag = indexPath.row;
            [cell.lock_btn addTarget:self action:@selector(lock:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            cell.lock_btn.hidden = YES;
        }
    }else{
        cell.lock_btn.hidden = YES;
    }
    return cell;
    
}
-(void)lock:(UIButton*)sender
{
            self.topView.hidden = NO;
            self.blurView.hidden = NO;
            self.PurchaseView.hidden = NO;
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

-(void)collectionView:(UICollectionView*)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    idValue  = @"";
    [self.done setTintColor:[UIColor clearColor]];
    self.done.enabled = false;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *membership = [[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"];
    NSDictionary *templateDic = [finalArray objectAtIndex:indexPath.row];
    if([TenStype isEqualToString:@"Template"]){
        NSString *paid = (NSString *)[templateDic objectForKey:@"is_paid"];
        [[NSUserDefaults standardUserDefaults]setValue:(NSString *)[templateDic objectForKey:@"template_id"] forKey:@"TemplateID"];
        
        if(([membership isEqualToString:@"Basic"] && ([paid isEqualToString:@"1"] || [paid isEqualToString:@"2"] || [paid isEqualToString:@"3"])) ||  ([membership isEqualToString:@"Standard"] && ([paid isEqualToString:@"2"] || [paid isEqualToString:@"3"])) || ([membership isEqualToString:@"Premium"] && [paid isEqualToString:@"3"])){
            
            NSMutableArray *titleArray = [[templateDic objectForKey:@"template_text"] mutableCopy];
            NSString *playerURL =[templateDic objectForKey:@"preview_video_path"];
            [self playEffect:playerURL];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:templateDic]  forKey:@"TenSTemplateDic"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
            
            CreateTemplateViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"createTemplate"];
        
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else{
        
        NSString *playerURL =[templateDic objectForKey:@"preview_video_path"];
        
        [[NSUserDefaults standardUserDefaults]setValue:(NSString *)[templateDic objectForKey:@"preview_image"] forKey:@"WizardEffectPath"];
        
        
        [self playEffect:playerURL];
        [[NSUserDefaults standardUserDefaults]setValue:(NSString *)[templateDic objectForKey:@"effect_name"] forKey:@"WizardEffectsName"];
    }
}

-(void)getTemplates
{
    @try
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSString *URLString,*TagValue;
        NSDictionary *parameters;
        
    if([TenStype isEqualToString:@"Template"]){
        TagValue = @"view_business_template";
        URLString = @"https://www.hypdra.com/api/api.php?rquest=business_template";
        parameters = @{@"Category_Id":templateCategeory,@"User_ID":user_id,@"lang":@"iOS"};
        
    }else{
        TagValue = @"view_business_effect";
        URLString = @"https://www.hypdra.com/api/api.php?rquest=business_template_effect";
        parameters = @{@"Category_Name":templateCategeory,@"User_ID":user_id,@"lang":@"iOS"};
    }
       
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8",@"application/json", nil];
        manager.responseSerializer = responseSerializer;
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSLog(@"ImageViewResponse == %@",responseObject);
                  
                  NSMutableDictionary *response=responseObject;
                  finalArray = [[NSMutableArray alloc]init];
                  finalArray = [response objectForKey:TagValue];
                  
                  [self.collectionView reloadData];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)closeAction:(id)sender
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *minAvil=[defaults valueForKey:@"minAvil"];
    
    if ([minAvil isEqualToString:@"Duration Available"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.revealViewController pushFrontViewController:vc animated:YES];
    }
    
}
- (IBAction)Redeem:(id)sender
{
    if([creditPoints intValue] >= 30)
    {
        purchase_type=@"3";
        [self updateUnlockPayment];
        
    }
    else
    {
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't have enough Credit Points to unlock ! kindly watch videos to get more points" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
}

- (IBAction)Pay:(id)sender
{
    purchase_type=@"4";
    
    [TestKit setcFrom:@"TenzTemplate"];
    
    [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.businesstemplate"];
}

- (IBAction)close_purchaseView:(id)sender
{
    _blurView.hidden= YES;
    self.topView.hidden=YES;
    
}

- (void)sendServerTemplate:(NSNotification *)note
{
    purchase_type = @"4";
    
    _TemplateID = [[NSUserDefaults standardUserDefaults]valueForKey:@"TemplateID"];
    
    [self updateUnlockPayment];
}

-(void)updateUnlockPayment
{
    
    NSLog(@"Unlock effects");
    
    NSString *order_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"order_id"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary *params;
    NSString *URLString;
    
    URLString=@"https://www.hypdra.com/api/api.php?rquest=purchase_template";
    params = @{@"User_ID":user_id,@"template_id":_TemplateID,@"purchase_type":purchase_type,@"Order_id":order_id,@"token":@"",@"lang":@"iOS"};

    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         
         
         if([[responseObject objectForKey:@"status"] isEqualToString:@"1"])
         {
             if([purchase_type isEqualToString:@"3"])
             {
                 [self reduecePoints];
             }
             [self getTemplates];
         }
         self.blurView.hidden = YES;
         self.PurchaseView.hidden=YES;
         
         NSLog(@"Json unlock Templates Response:%@",responseObject);
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"son unlock Templates Error: %@", error);
     }];
}

-(void)reduecePoints
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer = responseSerializer;
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=update_points";
    
    NSDictionary *params = @{@"User_ID":user_id,@"operation":@"minus",@"points":@"30",@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json minutes Reward Response:%@",responseObject);
         
         creditPoints=[responseObject objectForKey:@"credit_points"];
         
         self.availableCredits_lbl.text=[NSString stringWithFormat:@"Available Credits: %@", creditPoints];
         
         [[NSUserDefaults standardUserDefaults]setObject:creditPoints forKey:@"credit_points"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
}
- (IBAction)Done_actn:(id)sender
{
    
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
    [self.VideoPlayerView addSubview:SJplayer.view];
    
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
    self.PurchaseView.hidden=YES;
    //_Choose_Btn.hidden = NO;

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
- (IBAction)Choose_actn:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *minAvil=[defaults valueForKey:@"minAvil"];
    
    if ([minAvil isEqualToString:@"Duration Available"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_20" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.revealViewController pushFrontViewController:vc animated:YES];
    }
}
@end
