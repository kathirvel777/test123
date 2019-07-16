//
//  GetEffectsViewController.m
//  Montage
//
//  Created by MacBookPro on 4/5/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "GetEffectsViewController.h"
#import "GetEffectsCollectionCell.h"
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

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

@interface GetEffectsViewController ()
{
    NSMutableArray *finalGif,*finalID,*finalImage,*MainArray,*IsLocked;
    
    NSString *user_id,*creditPoints;
    NSMutableURLRequest *request;
    
    NSString *imgName,*purchase_type;
    
    NSIndexPath *selectedValue;
    
    MBProgressHUD *hud;
    
    NSString *pathValue,*idValue,*pathGif,*menuCategory;
    int selected_cell_index;
    SJVideoPlayer *SJplayer;
    NSArray *imageArray;
    int selectedIndexPath;
    
}
@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation GetEffectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.myHeightConstraints.constant = 0.2f;
    //[self.bannerAdView.heightAnchor constraintEqualToAnchor:self.topView1.heightAnchor
    //multiplier:1.0].active = YES;
    self.navigationController.swipeBackEnabled=NO;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sideMenu setTarget: self.revealViewController];
        
        [self.sideMenu setAction: @selector( revealToggle: )];
        
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"MenuFrontPage"]isEqualToString:@"fromAdvance"])
    {
        [revealViewController revealToggleAnimated:NO];
        
        revealViewController.rearViewRevealOverdraw = 0;
        
    }
    
    [revealViewController panGestureRecognizer];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    menuCategory = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"effectMenuType"];
    
    self.navTitle.text=menuCategory;
    self.navTitle.textColor=[UIColor whiteColor];
    [self.navTitle setFont:[UIFont fontWithName:@"FuturaT-Book" size:20.0]];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:4.0f];
    
    [flowLayout setMinimumLineSpacing:5.0f];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    //[flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    self.collectionView.bounces = false;
    
    NSLog(@"SelectedValue = %@",selectedValue);
    
    self.collectionView.bounces = false;
    
    selected_cell_index = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"SelectedIndex"];
    _collectionView.contentInset=UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.done.enabled = false;
    
    UITapGestureRecognizer *TapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeVideoPlayer:)];
    TapRecognizer.numberOfTapsRequired = 1;
    [self.blurView addGestureRecognizer:TapRecognizer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unlockEffectsOrTransition" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(sendSerevr:)
            name:@"unlockEffectsOrTransition" object:nil];
  
    [self checkMembershipStatus];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(void)checkMembershipStatus
{
    
    NSLog(@"checkmembership:%@",user_id);
    
    /*    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     
     [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
     [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     manager.securityPolicy.allowInvalidCertificates = YES;*/
    
    //    NSError *error;
    
    //    NSString *URLString =[NSString stringWithFormat:@"http://108.175.2.116/montage/api/api.php?rquest=CurrentPlanOfUser"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=NonPaymentBenefits"];
    NSString *URLString =[NSString stringWithFormat:@"https://www.hypdra.com/api/api.php?rquest=UserInformation"];
    
    // NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
    
    NSDictionary *params = @{@"User_ID":user_id,@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"Check Membership Status:%@",responseObject);
         
         creditPoints = [responseObject valueForKey:@"credit_points"];
         self.availableCredits_lbl.text=[NSString stringWithFormat:@"Available Credits - %@", creditPoints];
         
         [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"credit_points"] forKey:@"credit_points"];
         [[NSUserDefaults standardUserDefaults]synchronize];
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error Membership Status: %@", error);
     }];
    
    
    /*   [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
     //        tableDataFromServer=[responseObject objectForKey:@"View_Registration_Details"];
     //        NSLog(@"Json%@",tableDataFromServer);
     
     NSLog(@"Check Membership Status:%@",responseObject);
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
     NSLog(@"Error Membership Status: %@", error);
     //responseBlock(nil, FALSE, error);
     }];*/
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.titlesView.hidden=YES;
    
    //    CGRect newFrame = self.bannerAdView.frame;
    //
    //    newFrame.size.height = 0.0;
    //    [self.bannerAdView setFrame:newFrame];
    //self.myHeightConstraints.constant = 0.0f;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unlockEffectsOrTransition" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
   // self.bannerView.adUnitID =@"ca-app-pub-5459327557802742/3368768794";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
    request.testDevices = nil;

    [self.bannerView loadRequest:request];
    
    [self.done setTintColor:[UIColor clearColor]];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    finalID = [[NSMutableArray alloc]init];
    
    finalGif = [[NSMutableArray alloc]init];
    
    finalImage = [[NSMutableArray alloc]init];
    IsLocked = [[NSMutableArray alloc]init];
    [self loadEffectsData];
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
    return [finalImage count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GetEffectsCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.alpha = 1.0;
    cell.imgView.backgroundColor = [UIColor darkGrayColor];
    
    NSURL *imageURL = [NSURL URLWithString:[finalImage objectAtIndex:indexPath.row]];
    NSDictionary *mainCategory=[imageArray objectAtIndex:indexPath.row];
    /* NSString *paid = (NSString *)[mainCategory objectForKey:@"is_paid"];
     NSString *membership = [[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"];
     if(([membership isEqualToString:@"Basic"] && ([paid isEqualToString:@"1"] || [paid isEqualToString:@"2"])) ||  ([membership isEqualToString:@"Standard"] && ([paid isEqualToString:@"2"]))){
     [cell.lock setHidden:NO];
     //    }else if([membership isEqualToString:@"Standard"] && ([paid isEqualToString:@"2"])){
     //
     }else{
     [cell.lock setHidden:YES];
     }*/
    if([[IsLocked objectAtIndex:indexPath.row
         ]isEqualToString:@"YES"]){
        [cell.lock setHidden:NO];
    [cell.playEffects setHidden:YES];
    }
    else
        [cell.lock setHidden:YES];
    
    [cell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"place_holder_simple.png"]];
    
    
    //    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-border.png"]];
    
    
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
    
    //  cell.layer.borderColor = [UIColor blackColor].CGColor;
    
    //    cell.ImgView.image = img;
    
    //    cell.selectedValue.hidden = true;
    
    //  cell.layer.borderColor = [UIColor blackColor].CGColor;
    
    //    cell.ImgView.image = img;
    
    cell.playEffects.tag = indexPath.row;
    [cell.playEffects addTarget:self action:@selector(playEffect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectedValue.tag = indexPath.row;
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    {
        cell.selectedValue.hidden = false;
    }
    else
    {
        cell.selectedValue.hidden = true;
    }
    
    return cell;
    
}

-(void)playEffect:(UIButton*)sender
{
    self.topView.hidden=NO;
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"])
    {
        self.titlesView.hidden=NO;
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"])
        
        pathGif=[NSString stringWithFormat:@"https://www.hypdra.com/%@",[finalGif objectAtIndex:sender.tag]];
    
    else
        pathGif=[finalGif objectAtIndex:sender.tag];
    
    [self loadVideoPlayer];
    
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:pathGif] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:pathGif] jumpedToTime:0];
    
}

- (void)removeVideoPlayer:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    _topView.hidden= YES;
    [[NSNotificationCenter defaultCenter]removeObserver:@"currentTime"];
    
    self.currentTime = SJplayer.currentTime;
    
    [SJplayer stop];
}
/*
 -(void)playTransition:(UIButton*)sender
 {
 NSLog(@"Play Transitions");
 
 pathGif = [finalGif objectAtIndex:sender.tag];
 
 
 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 
 TransitionGIFController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TransitionGIF"];
 
 vc.imgURL = pathGif;
 
 [self.navigationController pushViewController:vc animated:YES];
 
 }*/


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
    idValue  = [finalID objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:idValue forKey:@"idValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if([[IsLocked objectAtIndex:indexPath.row
         ]isEqualToString:@"YES"]){
        
        self.PurchaseView.hidden = NO;
    }
    else
    {
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
        
        if (self.selectedItemIndexPath)
        {
            if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
            {
                [self.done setTintColor:[UIColor clearColor]];
                
                self.done.enabled = false;
                
                self.selectedItemIndexPath = nil;
            }
            else
            {
                
                
                [self.done setTintColor:[UIColor whiteColor]];
                
                self.done.enabled = true;
                
                [indexPaths addObject:self.selectedItemIndexPath];
                self.selectedItemIndexPath = indexPath;
            }
        }
        else
        {
            // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
            
            [self.done setTintColor:[UIColor whiteColor]];
            
            self.done.enabled = true;
            
            self.selectedItemIndexPath = indexPath;
        }
        
        // and now only reload only the cells that need updating
        
        pathValue = [finalImage objectAtIndex:indexPath.row];
        idValue  = [finalID objectAtIndex:indexPath.row];
        pathGif = [finalGif objectAtIndex:indexPath.row];
        
        [collectionView reloadItemsAtIndexPaths:indexPaths];
    }
    
}
/*
 - (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
 {
 GetEffectsCollectionCell* cell = (GetEffectsCollectionCell*)[collectionView  cellForItemAtIndexPath:indexPath];
 
 cell.selectedValue.hidden = true;
 
 //    cell.alpha = 1;
 }*/


- (IBAction)save:(id)sender
{
    
    NSString *theFileName = [[imgName lastPathComponent] stringByDeletingPathExtension];
    
    NSLog(@"imgName = %@",imgName);
    
    if (imgName != NULL )
    {
        NSLog(@"Saved");
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"GetImageRemove"
         object:theFileName];
        
    }
    else
    {
        
    }
}


-(void)loadEffectsData
{
    imageArray = [[NSMutableArray alloc]init];
    
    finalID = [[NSMutableArray alloc]init];
    finalGif=[[NSMutableArray alloc]init];
    finalImage=[[NSMutableArray alloc]init];
    IsLocked=[[NSMutableArray alloc]init];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        
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
            
            NSString *URLString;
            NSDictionary *params;
            
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Effects"]){
                
                URLString =@"https://www.hypdra.com/api/api.php?rquest=SubCategoryEffects";
                params = @{@"Main_Category_Name":menuCategory};
            }
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"]){
                params = @{@"Main_Category_Name":menuCategory,@"User_ID":user_id};
                URLString=@"https://www.hypdra.com/api/api.php?rquest=view_advance_titles";
            }
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"]){
                params = @{@"Main_Category_Name":menuCategory,@"User_ID":user_id};
                URLString=@"https://www.hypdra.com/api/api.php?rquest=view_advance_transition";
            }
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
            
            
            [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 
                 
                 NSMutableDictionary *response=responseObject;
                 
                 if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Effects"])
                     
                     imageArray= [response objectForKey:@"SubCategoryEffects"];
                 
                 else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"])
                     
                     imageArray= [response objectForKey:@"view_title_image"];
                 
                 else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"])
                     
                     imageArray = [response objectForKey:@"view_transition_image"];
                 
                 
                 for(int i=0;i<imageArray.count;i++)
                 {
                     NSDictionary *mainCategory=[imageArray objectAtIndex:i];
                     NSString *imageUrl;
                     
                     NSString *gifURL;
                     if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Effects"]){
                         
                         imageUrl=[mainCategory objectForKey:@"thumb_img_path"];
                         gifURL=[mainCategory objectForKey:@"original_video_path"];
                     }
                     else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"]){
                         imageUrl=[mainCategory objectForKey:@"thumb_img_path"];
                         gifURL=[mainCategory objectForKey:@"title_path"];
                     }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"]){
                         
                         //imageUrl=[mainCategory objectForKey:@"thumb_image"];
                         
                         imageUrl=[NSString stringWithFormat:@"https://www.hypdra.com/%@",[mainCategory objectForKey:@"thumb_image"]];
                         
                         gifURL=[mainCategory objectForKey:@"resize_video"];
                         
                     }
                     NSString *image_id=[mainCategory objectForKey:@"id"];
                     
                     [finalImage addObject:imageUrl];
                     [finalGif addObject:gifURL];
                     [finalID addObject:image_id];
                     
                     NSString *paid = (NSString *)[mainCategory objectForKey:@"is_paid"];
                     NSString *membership = [[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"];
                     if(([membership isEqualToString:@"Basic"] && ([paid isEqualToString:@"1"] || [paid isEqualToString:@"2"])) ||  ([membership isEqualToString:@"Standard"] && ([paid isEqualToString:@"2"]))){
                         [IsLocked addObject:@"YES"];
                         //    }else if([membership isEqualToString:@"Standard"] && ([paid isEqualToString:@"2"])){
                         //
                     }else{
                         [IsLocked addObject:@"NO"];
                     }
                     
                 }
                 [self.collectionView reloadData];
                 
                 [hud hideAnimated:YES];
                 
             }
                  failure:^(NSURLSessionTask *operation, NSError *error)
             {
                 NSLog(@"Error9: %@", error);
                 
                 [hud hideAnimated:YES];
                 
                 CustomPopUp *popUp = [CustomPopUp new];
                 [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                 popUp.okay.backgroundColor = [UIColor lightGreen];
                 popUp.agreeBtn.hidden = YES;
                 popUp.cancelBtn.hidden = YES;
                 popUp.inputTextField.hidden = YES;
                 [popUp show];
                 
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

- (IBAction)done:(id)sender
{
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"])
    {
        self.topView.hidden=NO;
        self.titlesView.hidden=NO;
        self.chooseOutlet.hidden=YES;
    }
    
    else
    {
        NSLog(@"Selected URL = %@",pathValue);
        NSLog(@"Selected ID = %@",idValue);
        NSLog(@"Selected ID = %@",pathGif);
        
        //Chcking MainArray
        MainArray=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainArray"]];
        NSLog(@"MainArray_didLoad_1 %@",MainArray);
        if(MainArray == nil ){
            MainArray= [[NSMutableArray alloc]init];
        }
        //Chcking MainArray
        
        NSMutableDictionary *finalDic = [MainArray objectAtIndex:selected_cell_index];
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Effects"])
            [finalDic setValue:idValue forKey:@"effect"];
        
        else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"])
            
            [finalDic setValue:idValue forKey:@"transition"];
        
        //    [finalDic setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"image_pos"];
        
        [MainArray replaceObjectAtIndex:selected_cell_index withObject:finalDic];
        //Generating Final
        
        //UPDAteMainArrayUserDefaults
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
        [defaults synchronize];
        //UPDAteMainArrayUserDefaults
        
        NSLog(@"MainArray_cellLoad %@",MainArray);
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
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

- (IBAction)closeAction:(id)sender
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *minAvil=[defaults valueForKey:@"minAvil"];
    
    if ([minAvil isEqualToString:@"Duration Available"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"Advance" forKey:@"isWizardOrAdvance"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.revealViewController pushFrontViewController:vc animated:YES];
    }
    
}
//{
//    NSString *dismissValue = [[NSUserDefaults standardUserDefaults]
//                              stringForKey:@"effectDismissValue"];
//
//    if([dismissValue isEqualToString:@"dismissValueList"])
//    {
//
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"effectDismissValue"];
//        [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
//
//    }
//
//    else
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
    [alertView hide];
    alertView = nil;
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    
    [alertView hide];
    alertView = nil;
    
}

- (void)agreeCLicked:(CustomPopUp *)alertView
{
    [alertView hide];
    alertView = nil;
    
}

- (IBAction)chooseAction:(id)sender
{
    NSLog(@"Selected URL = %@",pathValue);
    NSLog(@"Selected ID = %@",idValue);
    NSLog(@"Selected ID = %@",pathGif);
    
    //Chcking MainArray
    MainArray=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainArray"]];
    NSLog(@"MainArray_didLoad_1 %@",MainArray);
    if(MainArray == nil ){
        MainArray= [[NSMutableArray alloc]init];
    }
    //Chcking MainArray
    
    NSMutableDictionary *finalDic = [MainArray objectAtIndex:selected_cell_index];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Effects"])
        [finalDic setValue:idValue forKey:@"effect"];
    
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"])
        
        [finalDic setValue:idValue forKey:@"transition"];
    
    //    [finalDic setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"image_pos"];
    
    [MainArray replaceObjectAtIndex:selected_cell_index withObject:finalDic];
    //Generating Final
    
    //UPDAteMainArrayUserDefaults
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
    [defaults synchronize];
    //UPDAteMainArrayUserDefaults
    
    NSLog(@"MainArray_cellLoad %@",MainArray);
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (IBAction)titlesdoneAction:(id)sender
{
    
    NSLog(@"Selected URL = %@",pathValue);
    NSLog(@"Selected ID = %@",idValue);
    NSLog(@"Selected ID = %@",pathGif);
    
    //Chcking MainArray
    MainArray=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"MainArray"]];
    NSLog(@"MainArray_didLoad_1 %@",MainArray);
    if(MainArray == nil ){
        MainArray= [[NSMutableArray alloc]init];
    }
    //Chcking MainArray
    
    NSMutableDictionary *finalDic = [MainArray objectAtIndex:selected_cell_index];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Effects"])
        [finalDic setValue:idValue forKey:@"effect"];
    
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"])
    {
        [finalDic setValue:idValue forKey:@"title_id"];
        [finalDic setValue:_titles1.text forKey:@"title_one"];
        [finalDic setValue:_titles2.text forKey:@"title_two"];
    }
    
    [MainArray replaceObjectAtIndex:selected_cell_index withObject:finalDic];
    //Generating Final
    
    //UPDAteMainArrayUserDefaults
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:MainArray]  forKey:@"MainArray"];
    [defaults synchronize];
    //UPDAteMainArrayUserDefaults
    
    NSLog(@"MainArray_cellLoad %@",MainArray);
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAdvance" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_3" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
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
    
    [TestKit setcFrom:@"EffectsOrTransition"];
    
    [[TestKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"com.ios.wizard.hypdra.unlockeffects"];
}

- (IBAction)close_purchaseView:(id)sender
{
    self.PurchaseView.hidden = YES;
}

- (void)sendSerevr:(NSNotification *)note
{
    purchase_type=@"4";

    [self updateUnlockPayment];
}

-(void)updateUnlockPayment
{
    
    NSLog(@"Unlock effects");
    NSString *order_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"order_id"];
    NSString *effectTransition_idValues = [[NSUserDefaults standardUserDefaults]valueForKey:@"idValue"];
    
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

    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Titles"])
    {
        URLString=@"https://www.hypdra.com/api/api.php?rquest=purchase_titles";
        params = @{@"User_ID":user_id,@"title_id":effectTransition_idValues,@"purchase_type":purchase_type,@"lang":@"iOS",@"Order_id":order_id,@"token":@""};
    }
    
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"menuType"] isEqualToString:@"Transitions"])
    {
        URLString=@"https://www.hypdra.com/api/api.php?rquest=purchase_transitions";
        params = @{@"User_ID":user_id,@"transitions_id":effectTransition_idValues,@"purchase_type":purchase_type,@"lang":@"iOS",@"Order_id":order_id,@"token":@""};
    }
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         if([purchase_type isEqualToString:@"3"])
         {
             [self reduecePoints];
         }
         
         if([[responseObject objectForKey:@"status"] isEqualToString:@"1"])
         {
             [self loadEffectsData];
         }
         self.PurchaseView.hidden=YES;
         
         NSLog(@"Json unlock Transition/Title Response:%@",responseObject);
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"son unlock Transition/Title Error: %@", error);
     }];
}

-(void)reduecePoints
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
    
    //    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=advance_payment_status";
    //    NSString *URLString=@"http://108.175.2.116/montage/api/api.php?rquest=AddTopUps";
    
    NSString *URLString=@"https://www.hypdra.com/api/api.php?rquest=update_points";
    
    NSDictionary *params = @{@"User_ID":user_id,@"operation":@"minus",@"points":@"30",@"lang":@"iOS"};
    
    [manager POST:URLString parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Json minutes Reward Response:%@",responseObject);
         
         creditPoints=[responseObject objectForKey:@"credit_points"];
         
         self.availableCredits_lbl.text=[NSString stringWithFormat:@"Available Credits - %@", creditPoints];
         
         [[NSUserDefaults standardUserDefaults]setObject:creditPoints forKey:@"credit_points"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
}

@end

