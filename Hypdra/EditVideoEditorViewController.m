//
//  VideoEditorViewController.m
//  Montage
//
//  Created by MacBookPro4 on 11/14/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "EditVideoEditorViewController.h"
#import "EditVideoEditorCollectionViewCell.h"
#import "SJVideoPlayer.h"
#import "AFNetworking.h"
#import "VideoEditorViewController.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "DEMOHomeViewController.h"
#import "DEMORootViewController.h"
#import "VideosViewController.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

@interface EditVideoEditorViewController ()<ClickDelegates,GADBannerViewDelegate>
{
    NSMutableArray *imgArray,*nameArray,*sampleArray;
    NSString *user_id,*videopath;
    NSString *effect_Type, *values;
    BOOL flopFlag,flipFlag,isTick,isOrientationChanged;
    UIView *tempLayerView;
    CGFloat diagonal,rotationAngle,imageWidth,imageHeight;
    int rotation,access;
    MBProgressHUD *hud;
    NSIndexPath *SelectedIndexPath;
    
}

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define kRotateRight -M_PI/2
#define kRotateLeft  M_PI/2

CGFloat degreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation EditVideoEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.doneButton setEnabled:NO];
    [self.doneButton setTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage alloc]]
    ;
    imgArray=[NSMutableArray arrayWithObjects:@"256-Compress",@"256-Fade-in",@"256-Reverse",@"256-Slow",@"256-Fast",@"256-Rotation",@"256-flipflop",nil];
    
    nameArray=[NSMutableArray arrayWithObjects:@"Compress",@"Fade In",@"Reverse",@"Slow",@"Fast",@"Rotation",@"Flip Flop",nil];
    
    [self loadVideoPlayer];
    
    self.flipView.hidden=true;
    self.rotationView.hidden=true;
    self.rotationflipMenuView.hidden=true;
    
    //[self.videoEditCV setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    tempLayerView  = self.SJplayer.presentView;
    [self calculateDiagonal];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"user id %@",user_id);
    
    videopath=[[NSUserDefaults standardUserDefaults]
               stringForKey:@"videoPathValue"];
    NSLog(@"Edit Video Path:%@",videopath);
    // [self blurEffect:videopath];
    NSLog(@"EditV");
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"blurimage"];
    
    UIImage* image = [UIImage imageWithData:imageData];
    
    self.imgView.image=image;
    
    //self.bgView.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

-(void)blurEffect:(NSString *)videoPath
{
    UIImage *thumbnail = [self generateThumbImage:[NSURL URLWithString:videoPath]];
    
    UIImage *blurImage=[self blur:thumbnail];
    
    self.bgView.backgroundColor = [UIColor colorWithPatternImage:blurImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)viewDidAppear:(BOOL)animated
{
    
    //  [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:videopath] jumpedToTime:self.currentTime];
    //
    //    [self.topView addSubview:self.player.view];
    
    if (CGSizeEqualToSize(CGSizeZero, self.naturalSize))
        [self loadVideoAsset];
    
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:videopath] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:videopath] jumpedToTime:0];
    
    NSLog(@"%zd - %s", __LINE__, __func__);
}

-(void)loadVideoAsset
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
        
        while (CGSizeEqualToSize(CGSizeZero, self.naturalSize)) {
            @try {
                NSURL *videoURL=[[NSURL alloc] initWithString:videopath];
                AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
                _naturalSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
            } @catch (NSException *exception) {
                
            }
        }
        
    });
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    [[SJVideoPlayer sharedPlayer] stop];
    NSLog(@"viewDidDisappear");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
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


-(void)loadVideoPlayer
{
    _SJplayer = [SJVideoPlayer sharedPlayer];
    
    [_SJplayer.containerView addSubview:_SJplayer.self.control.view];
    _SJplayer.control.isCircularView=NO;
    
    //SJVideoPlayerControlView *cv = _SJplayer.control.view
    [_SJplayer.presentView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.offset(0);
     }];
    
    [_SJplayer.control.view mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.offset(0);
     }];
    [self.topView addSubview:_SJplayer.view];
    
    
    if (IS_PAD)
    {
        [_SJplayer.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.offset(0);
             make.leading.trailing.offset(0);
             
             make.height.equalTo(_SJplayer.view.mas_width).multipliedBy(9.0 / 16);
         }];
    }
    else
    {
        [_SJplayer.view mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.offset(0);
             make.leading.trailing.offset(0);
             
             make.height.equalTo(_SJplayer.view.mas_width).multipliedBy(9.0 / 12.5);
         }];
    }
    
    
    //    self.topView.backgroundColor = [UIColor redColor];
    
    
#pragma mark - AssetURL
    
    //    player.assetURL = [[NSBundle mainBundle] URLForResource:@"sample.mp4" withExtension:nil];
    
    //    player.assetURL = [NSURL URLWithString:@"http://streaming.youku.com/live2play/gtvyxjj_yk720.m3u8?auth_key=1525831956-0-0-4ec52cd453761e1e7f551decbb3eee6d"];
    
    //    player.assetURL = [NSURL URLWithString:@"http://video.cdn.lanwuzhe.com/1493370091000dfb1"];
    
    //    player.assetURL = [NSURL URLWithString:@"http://vod.lanwuzhe.com/9da7002189d34b60bbf82ac743241a61/d0539e7be21a4f8faa9fef69a67bc1fb-5287d2089db37e62345123a1be272f8b.mp4?video="];
    
    
#pragma mark - Setting Player
    
    [_SJplayer playerSettings:^(SJVideoPlayerSettings * _Nonnull settings)
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
        [[SJVideoPlayer sharedPlayer] showTitle:@"Sample"];
    }];
    
    SJVideoPlayerMoreSetting *model2 = [[SJVideoPlayerMoreSetting alloc] initWithTitle:@"" image:[UIImage imageNamed:@"db_video_favorite_n"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
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
    
    [_SJplayer moreSettings:^(NSMutableArray<SJVideoPlayerMoreSetting *> * _Nonnull moreSettings)
     {
         /*        [moreSettings addObject:model0];
          [moreSettings addObject:model1];
          [moreSettings addObject:model2];
          [moreSettings addObject:model3];*/
     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    
    [[SJVideoPlayer sharedPlayer] stop];
    if (!CGSizeEqualToSize(CGSizeZero, self.naturalSize))
    {
        rotationAngle = 0;
        [self rotateWithAngle];
    }
}

-(UIImage *)generateThumbImage : (NSURL *)filepath
{
    NSURL *url = filepath;//[NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

- (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}


- (void)setFrameToFitImage
{
    tempLayerView.frame = tempLayerView.superview.bounds;
    NSLog(@"_naturalSize %f",_naturalSize.width);
    float widthRatio  = tempLayerView.bounds.size.width / _naturalSize.width;
    NSLog(@"_naturalSize %f",_naturalSize.height);
    
    float heightRatio = tempLayerView.bounds.size.height / _naturalSize.height;
    float scale = MIN(widthRatio, heightRatio);
    scale= scale+1;
    imageWidth  = scale * tempLayerView.frame.size.width;
    imageHeight = scale * tempLayerView.frame.size.height;
    
    tempLayerView.frame  = CGRectMake(0, 0, imageWidth, imageHeight);
    tempLayerView.center = CGPointMake(CGRectGetWidth(tempLayerView.superview.frame) / 2.0 , CGRectGetHeight(tempLayerView.superview.frame) / 2.0);
    [self calculateDiagonal];
}

- (void)calculateDiagonal

{
    CGRect rect = tempLayerView.frame;
    CGFloat seuareWidth  = CGRectGetWidth(rect) * CGRectGetWidth(rect);
    CGFloat seuareheight = CGRectGetHeight(rect) * CGRectGetHeight(rect);
    diagonal = sqrtf(seuareWidth + seuareheight);
    
}

- (void)rotateWithAngle
{
    CGAffineTransform normal = CGAffineTransformIdentity;
    CGAffineTransform scale     = CGAffineTransformMakeScale([self calculateScaleForAngle:rotationAngle], [self calculateScaleForAngle:rotationAngle]);
    CGAffineTransform concate   = CGAffineTransformConcat(normal, scale);
    CGAffineTransform transform = CGAffineTransformRotate(concate, degreesToRadians(rotationAngle));
    
    //rotationAngle = angle;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         tempLayerView.transform = transform;
     }
                     completion:^(BOOL finished)
     {
         
     }];
    
    [self setFrameToFitImage];
    
    if(rotationAngle==0 || rotationAngle == 360)
        
        [self.SJplayer.presentView sizeToFit];
    tempLayerView.frame = tempLayerView.superview.bounds;
    tempLayerView.center = tempLayerView.superview.center;
    
    NSLog(@"Rotation Angle:%f",rotationAngle);
    
    if(rotationAngle == 90)
    {
        effect_Type=@"orientation";
        values=@"1";
    }
    else if(rotationAngle == 180)
    {
        effect_Type=@"orientation";
        values=@"2";
    }
    else if(rotationAngle == 270)
    {
        effect_Type=@"orientation";
        values=@"3";
    }
    
}

- (CGFloat)calculateScaleForAngle:(CGFloat)angle
{
    CGFloat minSideLength = MIN(tempLayerView.frame.size.width, tempLayerView.frame.size.height);
    
    angle = ABS(angle);
    
    CGFloat width = ((diagonal - minSideLength) / 45) * angle + minSideLength;
    
    CGFloat adjustment = 0;
    
    if(angle <= 22.5)
    {
        adjustment = (angle / 150);
    }
    else
    {
        adjustment = ((45 - angle) / 150);
    }
    
    CGFloat scale = (width / minSideLength) + adjustment;
    
    return scale;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [imgArray count];
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"EditVideoEditorCollectionViewCell";
    
    EditVideoEditorCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.img.image=[UIImage imageNamed:[imgArray objectAtIndex:indexPath.row]];
    
    cell.name.text=[nameArray objectAtIndex:indexPath.row];
    
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        cell.topSelectedBar.hidden=NO;
    }
    else
    {
        cell.topSelectedBar.hidden=YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name=[nameArray objectAtIndex:indexPath.row];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    SelectedIndexPath = indexPath;
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            self.selectedItemIndexPath = nil;
        }
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        
        self.selectedItemIndexPath = indexPath;
        
    }
    
    // and now only reload only the cells that need updating
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
    
    if([name isEqualToString:@"Rotation"] || [name isEqualToString:@"Flip Flop"])
    {
        
        if([name isEqualToString:@"Rotation"])
        {
            effect_Type = @"";
            values = @"";
            
            if(self.selectedItemIndexPath)
            {
                self.flipView.hidden=true;
                self.rotationView.hidden=false;
                self.rotationflipMenuView.hidden=false;
            }
            else
            {
                self.rotationflipMenuView.hidden=true;
            }
            
        }
        else if([name isEqualToString:@"Flip Flop"])
        {
            isTick=YES;
            effect_Type = @"";
            values = @"";
            
            if(self.selectedItemIndexPath)
            {
                self.flipView.hidden=false;
                self.rotationView.hidden=true;
                self.rotationflipMenuView.hidden=false;
            }
            else
            {
                self.rotationflipMenuView.hidden=true;
            }
        }
    }
    else
    {
        
        self.rotationflipMenuView.hidden=true;
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to apply changes ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToApplyChanges";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%d",indexPath.row];
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
}


-(void)sendEditType:(NSString *)effect_Type Values:(NSString*)values
{
    NSLog(@"Effect type:%@ \n Values:%@",effect_Type,values);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setTimeoutInterval:120];

    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=video_overlay_video_effect";
    
    NSDictionary *parameters =@{@"lang":@"iOS",@"video_path":videopath,@"effect_type":effect_Type,@"values":values};
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"The response is %@",responseObject);
         NSString * status=[responseObject objectForKey:@"status"];
         
         if([status isEqualToString:@"Success"])
         {
             videopath=[[NSString alloc]init];
             videopath=[responseObject objectForKey:@"video_overlay_effect"];
             
              [self loadVideoPlayer];
             
                          if(!isnan(_currentTime))
                              [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:videopath] jumpedToTime:0];
                          else
             
             tempLayerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
             
             tempLayerView.frame = tempLayerView.superview.bounds;
             tempLayerView.center = tempLayerView.superview.center;
             
             
             [self.doneButton setEnabled:YES];
             [self.doneButton setTintColor:[UIColor whiteColor]];
             
             [hud hideAnimated:YES];
             
         }
     }
     
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [hud hideAnimated:YES];
         
         //         UIAlertController * alert = [UIAlertController
         //              alertControllerWithTitle:@"Error"
         //              message:@"Couldn't connect to server!"
         //          preferredStyle:UIAlertControllerStyleAlert];
         //
         //         //Add Buttons
         //         UIAlertAction* yesButton = [UIAlertAction
         //             actionWithTitle:@"OK"
         //             style:UIAlertActionStyleDefault
         //             handler:^(UIAlertAction * action)
         //             {
         //                  [alert dismissViewControllerAnimated:YES completion:nil];
         //
         //                 //[hud hideAnimated:YES];
         //             }];
         //
         //         [alert addAction:yesButton];
         //
         //         [self presentViewController:alert animated:YES completion:nil];
         
         CustomPopUp *popUp = [CustomPopUp new];
         [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
         popUp.okay.backgroundColor = [UIColor navyBlue];
         popUp.agreeBtn.hidden = YES;
         popUp.cancelBtn.hidden = YES;
         popUp.inputTextField.hidden = YES;
         [popUp show];
     }];
    
}

- (IBAction)backAction:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doneAction:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setObject:videopath forKey:@"videoPathValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
    vc.viewHiding=@"second";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)clockWiseAction:(id)sender
{
    isOrientationChanged = true;
    if (!CGSizeEqualToSize(CGSizeZero, _naturalSize)) {
        // do something
        
        if (rotation == 4)
        {
            rotation = 0;
        }
        else
        {
            rotation = rotation + 1;
        }
        
        if(rotationAngle == 360)
            rotationAngle = 90;
        else rotationAngle = rotationAngle + 90;
        
        NSLog(@"Clockwise");
        
        [self rotateWithAngle];
    }else{
        
    }
    
}

- (IBAction)anticlockWiseAction:(id)sender
{
    access=5;
    if (!CGSizeEqualToSize(CGSizeZero, _naturalSize))
    {
        
        if (rotation == -4)
        {
            rotation = 0;
        }
        else
        {
            rotation = rotation - 1;
        }
        if(rotationAngle == 0)
            rotationAngle = 270;
        else rotationAngle = rotationAngle - 90;
        NSLog(@"Clockwise %f",rotationAngle);
        [self rotateWithAngle];
    }
    else
    {
        
    }
}

- (IBAction)horizontalAction:(id)sender
{
    access=6;
    if(!flipFlag)
    {
        NSLog(@"Hrizontal");
        
        tempLayerView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        [UIView transitionWithView:tempLayerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations: ^{
                            // [self.backView removeFromSuperview];
                            //                            [self addSubview:self.frontView];
                        }
                        completion:NULL];
        
        //_SJplayer.presentView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        
        flipFlag = TRUE;
    }
    else
    {
        NSLog(@"Hrizontal else");
        
        // _SJplayer.presentView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
        
        tempLayerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [UIView transitionWithView:tempLayerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations: ^{
                            //                            [self.backView removeFromSuperview];
                            //                            [self addSubview:self.frontView];
                        }
                        completion:NULL];
        
        flipFlag = FALSE;
        
    }
    
    effect_Type =@"horizontal";
    values=@"1";
    
    tempLayerView.frame = tempLayerView.superview.bounds;
    tempLayerView.center = tempLayerView.superview.center;
}

- (IBAction)verticalAction:(id)sender
{
    access=6;
    
    if(!flopFlag)
    {
        NSLog(@"vertical");
        
        tempLayerView.transform = CGAffineTransformMakeScale(1.0, -1.0);
        
        [UIView transitionWithView:tempLayerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromTop
                        animations: ^{
                            //                            [self.backView removeFromSuperview];
                            //                            [self addSubview:self.frontView];
                        }
                        completion:NULL];
        
        flopFlag=TRUE;
    }
    else
    {
        NSLog(@"vertical else");
        
        tempLayerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [UIView transitionWithView:tempLayerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromTop
                        animations: ^{
                            //                            [self.backView removeFromSuperview];
                            //                            [self addSubview:self.frontView];
                        }
                        completion:NULL];
        
        flopFlag=FALSE;
        
    }
    
    effect_Type =@"vertical";
    values=@"1";
    
    tempLayerView.frame = tempLayerView.superview.bounds;
    tempLayerView.center = tempLayerView.superview.center;
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
        
    }
    [hud hideAnimated:YES];
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    
    [alertView hide];
    alertView = nil;
    
    self.selectedItemIndexPath = nil;
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:SelectedIndexPath];
    
    [self.videoEditCV reloadItemsAtIndexPaths:indexPaths];
    
    NSLog(@"Cancel");
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    
    self.rotationView.hidden=YES;
    self.flipView.hidden=YES;
    self.rotationflipMenuView.hidden=YES;
    
    NSLog(@"AlertView Accessibility:%ld",alertView.accessibilityValue.integerValue);
    
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToApplyChanges"]){
        [[SJVideoPlayer sharedPlayer] pause];
        
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if([[nameArray objectAtIndex:alertView.accessibilityValue.integerValue] isEqualToString:@"Compress"])
        {
            effect_Type = @"compress";
            values = @"null";
            [self sendEditType:effect_Type Values:values];
        }
        else if([[nameArray objectAtIndex:alertView.accessibilityValue.integerValue] isEqualToString:@"Fade In"])
        {
            effect_Type = @"fadeIn_fadeOut";
            values = @"null";
            [self sendEditType:effect_Type Values:values];
        }
        else if([[nameArray objectAtIndex:alertView.accessibilityValue.integerValue] isEqualToString:@"Fast"])
        {
            effect_Type = @"fast";
            values = @"null";
            [self sendEditType:effect_Type Values:values];
        }
        else if([[nameArray objectAtIndex:alertView.accessibilityValue.integerValue] isEqualToString:@"Slow"])
        {
            effect_Type = @"slow";
            values = @"null";
            [self sendEditType:effect_Type Values:values];
        }
        else if([[nameArray objectAtIndex:alertView.accessibilityValue.integerValue] isEqualToString:@"Reverse"])
        {
            effect_Type = @"reverse";
            values = @"null";
            [self sendEditType:effect_Type Values:values];
        }
        else
        {
            //            [imgArray removeObjectAtIndex:alertView.accessibilityValue.integerValue];
            //            [nameArray removeObjectAtIndex:alertView.accessibilityValue.integerValue];
            //
            //            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.accessibilityValue.integerValue inSection:0];
            //            NSArray *deleteItems = @[indexPath];
            //
            //            [self.videoEditCV deleteItemsAtIndexPaths:deleteItems];
            //
            self.rotationView.hidden=true;
            self.flipView.hidden=true;
            self.rotationflipMenuView.hidden=true;
            
            if(![effect_Type isEqualToString:@""] || ![values isEqualToString:@""])
            {
                [self sendEditType:effect_Type Values:values];
            }
            else
            {
                NSLog(@"you did choose a value");
                
                CustomPopUp *popUp = [CustomPopUp new];
                [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't make any action" withTitle:@"Error" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                popUp.okay.backgroundColor = [UIColor lightGreen];
                popUp.agreeBtn.hidden = YES;
                popUp.cancelBtn.hidden = YES;
                popUp.inputTextField.hidden = YES;
                [popUp show];
                
            }
        }
    }else if([alertView.accessibilityHint isEqualToString:@""]){
        
    }
    [alertView hide];
    alertView = nil;
}

- (IBAction)TickAction:(id)sender
{
    if(access!=nil)
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Do you want to apply changes ?" withTitle:@"Confirm" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToApplyChanges";
        popUp.accessibilityValue = [NSString stringWithFormat:@"%d",access];
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"You don't make any action" withTitle:@"Error" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
}

@end
