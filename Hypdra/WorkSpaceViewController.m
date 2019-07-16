//
//  WorkSpaceViewController.m
//  Hypdra
//
//  Created by MacBookPro on 7/4/18.
//  Copyright © 2018 sssn. All rights reserved.
//
#import "MBProgressHUD.h"
#import "REFrostedViewController.h"
#import "PageSelectionViewController.h"
#import "DEMORootViewController.h"
#import "ChooseTemplateCollectionViewController.h"
#import "AFNetworking.h"
#import <ImageIO/ImageIO.h>
#import "WorkSpaceViewController.h"
#import "MBProgressHUD.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "WizardMyImages.h"
#import "MuiscTabViewController.h"
#import "WizardIcons.h"
#import "WizardEffects.h"
@import GoogleMobileAds;

@interface WorkSpaceViewController ()<GADBannerViewDelegate>{
    NSMutableArray *titleArray,*OnlyImages;
    NSMutableDictionary *templateDic;
    NSURL *imgUrl;
    int imgCount,musicCount,tempCount,iconCount,effectsCount;
    NSString *imgPath,*templateImgPath,*user_id;
    MBProgressHUD *hud;
    NSString *TenStype;
}
@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation WorkSpaceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    templateDic=[[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"TenSTemplateDic"]]mutableCopy];
    titleArray = [[templateDic objectForKey:@"template_text"] mutableCopy];
    templateImgPath=[templateDic objectForKey:@"preview_image"];
    
    self.subViewFirst.layer.shadowRadius = 10.0f;
    self.subViewFirst.layer.shadowColor = [UIColor blackColor].CGColor;
    self.subViewFirst.layer.shadowOffset = CGSizeMake(0.1f, 1.0f);
    self.subViewFirst.layer.shadowOpacity = 1.0f;
    self.subViewFirst.layer.masksToBounds = NO;
    
    self.subViewSecond.layer.shadowRadius = 10.0f;
    self.subViewSecond.layer.shadowColor = [UIColor blackColor].CGColor;
    self.subViewSecond.layer.shadowOffset = CGSizeMake(0.1f, 1.0f);
    self.subViewSecond.layer.shadowOpacity = 1.0f;
    self.subViewSecond.layer.masksToBounds = NO;
    
    self.subViewThird.layer.shadowRadius = 10.0f;
    self.subViewThird.layer.shadowColor = [UIColor blackColor].CGColor;
    self.subViewThird.layer.shadowOffset = CGSizeMake(0.1f, 1.0f);
    self.subViewThird.layer.shadowOpacity = 1.0f;
    self.subViewThird.layer.masksToBounds = NO;
    
    self.sub_View_Fourth.layer.shadowRadius = 10.0f;
    self.sub_View_Fourth.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sub_View_Fourth.layer.shadowOffset = CGSizeMake(0.1f, 1.0f);
    self.sub_View_Fourth.layer.shadowOpacity = 1.0f;
    self.sub_View_Fourth.layer.masksToBounds = NO;
    
    self.Sub_View_Fifth.layer.shadowRadius = 10.0f;
    self.Sub_View_Fifth.layer.shadowColor = [UIColor blackColor].CGColor;
    self.Sub_View_Fifth.layer.shadowOffset = CGSizeMake(0.1f, 1.0f);
    self.Sub_View_Fifth.layer.shadowOpacity = 1.0f;
    self.Sub_View_Fifth.layer.masksToBounds = NO;
    
    if(templateDic == nil )
    {
        templateDic= [[NSMutableDictionary alloc]init];
    }
    
    if(titleArray == nil){
        titleArray = [[NSMutableArray alloc]init];
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.FirstView.hidden=NO;
    self.subViewFirst.hidden=YES;
    self.subViewSecond.hidden=YES;
    self.subViewThird.hidden=YES;
    self.sub_View_Fourth.hidden=YES;
    self.Sub_View_Fifth.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wizardImage:)
                                                 name:@"wizardImage" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wizardVideo:)
                                                 name:@"wizardVideo" object:nil];

    if([[NSUserDefaults standardUserDefaults]objectForKey:@"wizImgPath"]!=nil)
    {
        
        self.view.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1];
        imgCount=1;
        imgUrl=[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"wizImgPath"]];
        UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
        
        self.imgImgView.image=img;
        self.chooseImage_outlet.hidden=YES;
        self.subViewFirst.hidden=NO;
        
        if(musicCount==1)
        {
            self.chooseMusicTemplate.hidden=YES;
            self.subViewThird.hidden=NO;
        }
        
        if(tempCount==1)
        {
            self.chooseTemplate_outlet.hidden=YES;
            self.subViewSecond.hidden=NO;
        }
        if(iconCount==1)
        {
            self.choose_icon.hidden=YES;
            self.sub_View_Fourth.hidden=NO;
        }
        
        if(effectsCount==1)
        {
            self.choose_efects.hidden=YES;
            self.Sub_View_Fifth.hidden=NO;
        }
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"TenSTemplateDic"]!=nil)
    {
        self.view.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1];
        tempCount=1;
        
        UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:templateImgPath]]];
        self.templateImgView.image=img;
        
            self.chooseTemplate_outlet.hidden=YES;
            self.subViewSecond.hidden=NO;
        
        if(musicCount==1)
        {
            self.chooseMusicTemplate.hidden=YES;
            self.subViewThird.hidden=NO;
        }
        if(imgCount==1)
        {
            self.chooseImage_outlet.hidden=YES;
            self.subViewFirst.hidden=NO;
        }
        if(iconCount==1)
        {
            self.choose_icon.hidden=YES;
            self.sub_View_Fourth.hidden=NO;
        }
        
        if(effectsCount==1)
        {
            self.choose_efects.hidden=YES;
            self.Sub_View_Fifth.hidden=NO;
        }
    }

    if([[NSUserDefaults standardUserDefaults]objectForKey:@"WizardMusicId"]!=nil)
    {
        //imgCount,musicCount used to display image and music in parallel
        self.view.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1];
        musicCount=1;
        
        self.chooseMusicTemplate.hidden=YES;
        self.subViewThird.hidden=NO;
        
        if(imgCount==1)
        {
            self.chooseImage_outlet.hidden=YES;
            self.subViewFirst.hidden=NO;
        }
        if(tempCount==1)
        {
            self.chooseTemplate_outlet.hidden=YES;
            self.subViewSecond.hidden=NO;
        }
        if(iconCount==1)
        {
            self.choose_icon.hidden=YES;
            self.sub_View_Fourth.hidden=NO;
        }
        
        if(effectsCount==1)
        {
            self.choose_efects.hidden=YES;
            self.Sub_View_Fifth.hidden=NO;
        }
        [templateDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"WizardMusicId"] forKey:@"music_id"];
        }else{
        [templateDic setValue:@"" forKey:@"music_id"];
        }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"WizardIconPath"]!=nil)
    {
        //imgCount,musicCount used to display image and music in parallel
        self.view.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1];
        iconCount=1;
        imgUrl=[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"WizardIconPath"]];
        UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
        
        self.iconImgView.image=img;
        self.choose_icon.hidden=YES;
        self.sub_View_Fourth.hidden=NO;
        
        if(imgCount==1)
        {
            self.chooseImage_outlet.hidden=YES;
            self.subViewFirst.hidden=NO;
        }
        if(tempCount==1)
        {
            self.chooseTemplate_outlet.hidden=YES;
            self.subViewSecond.hidden=NO;
        }if(musicCount==1)
        {
            self.chooseMusicTemplate.hidden=YES;
            self.subViewThird.hidden=NO;
        }
        
        if(effectsCount==1)
        {
            self.choose_efects.hidden=YES;
            self.Sub_View_Fifth.hidden=NO;
        }
        [templateDic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"WizardIconId"] forKey:@"icon_id"];
        [templateDic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"WizardIconName"] forKey:@"icon_name"];
        
    }else{
        [templateDic setValue:@"" forKey:@"icon_id"];
        [templateDic setValue:@"" forKey:@"icon_name"];
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"WizardEffectsName"]!=nil)
    {
        //imgCount,musicCount used to display image and music in parallel
        self.view.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1];
        effectsCount=1;
        imgUrl=[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"WizardEffectPath"]];
        UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
        
        self.EffectsImgView.image=img;
        self.choose_efects.hidden=YES;
        self.Sub_View_Fifth.hidden=NO;
        
        if(imgCount==1)
        {
            self.chooseImage_outlet.hidden=YES;
            self.subViewFirst.hidden=NO;
        }
        if(tempCount==1)
        {
            self.chooseTemplate_outlet.hidden=YES;
            self.subViewSecond.hidden=NO;
        }
        if(musicCount==1)
        {
            self.chooseMusicTemplate.hidden=YES;
            self.subViewThird.hidden=NO;
        }
        if(iconCount==1)
        {
            self.choose_icon.hidden=YES;
            self.sub_View_Fourth.hidden=NO;
        }
        [templateDic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"WizardEffectsName"] forKey:@"effect_name"];
        
    }else{

        [templateDic setValue:@"" forKey:@"effect_name"];
    }
    
     if(tempCount  == 0 || imgCount  == 0 || musicCount == 0 || iconCount == 0 || effectsCount == 0){
        self.done_outlet.enabled = NO;
    }
   // [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"WizardMusicId"];
    
    user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_ID"];
}
- (void)viewWillAppear:(BOOL)animated{
    
    if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"MemberShipType"] isEqualToString:@"Basic"]){
        
        [self.AdView removeFromSuperview];
    }
}
- (void)wizardImage:(NSNotification *)note
{
    OnlyImages = [[NSMutableArray alloc]init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"wizardGalleryImg"];
    
    NSLog(@"Data Images = %lu",(unsigned long)data.length);
    
    OnlyImages = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSDictionary *dic=[OnlyImages objectAtIndex:0];
    imgPath=[dic objectForKey:@"imagePath"];
    
    //To get image path to be displayed in imageview
    
    [[NSUserDefaults standardUserDefaults]setObject:imgPath forKey:@"wizImgPath"];
}

-(void)wizardVideo:(NSNotification *)note
{
    OnlyImages = [[NSMutableArray alloc]init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"wizardGalleryVid"];
    
    NSLog(@"Data Images = %lu",(unsigned long)data.length);
    
    OnlyImages = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSDictionary *dic=[OnlyImages objectAtIndex:0];
    imgPath=[dic objectForKey:@"imagePath"];
    
    //To get image path to be displayed in imageview
    
    [[NSUserDefaults standardUserDefaults]setObject:imgPath forKey:@"wizImgPath"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseImage_actn:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_22" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
    /* UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
    
    WizardMyImages *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"wizardimages"];
    
    [self.navigationController pushViewController:vc animated:YES]; */
}

- (IBAction)chooseTemplate_actn:(id)sender
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TenStype =@"Template";
    [[NSUserDefaults standardUserDefaults]setValue:@"Template" forKey:@"TenStype"];
    [self loadTemplatesCategory];

}

-(void)loadTemplatesCategory
{
    @try
    {
        NSString *URL;
        if([TenStype isEqualToString:@"Template"]){
            
        URL = @"https://hypdra.com/api/api.php?rquest=business_template_category";
            
        }else{
            
        URL = @"https://hypdra.com/api/api.php?rquest=business_template_effect_category";
        }
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:nil error:nil];

        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              if (!error)
              {
                  NSArray *mainCategoryArray;
                  NSDictionary *mainCategoryEffects=responseObject;
                  
                  [[NSUserDefaults standardUserDefaults]setObject:@"fromWizard" forKey:@"MenuFrontPage"];
                  
                 UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
                  
                  ChooseTemplateCollectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"wizardSideMenu"];
                  NSArray *tempArray;
                  if([TenStype isEqualToString:@"Template"]){
                      
                  tempArray = [mainCategoryEffects objectForKey:@"view_template_category"];
                      
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:tempArray]  forKey:@"TemplateCategory"];
                     
                       [[NSUserDefaults standardUserDefaults]setValue:((NSString *)[[tempArray objectAtIndex:1] valueForKey:@"id"]) forKey:@"TemplateCatrgory"];
                      
                       [[NSUserDefaults standardUserDefaults]synchronize];
                  }else{
                      
                  tempArray = [mainCategoryEffects objectForKey:@"view_template_effect_category"];
                      
                      [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:tempArray]  forKey:@"TemplateCategory"];
                      
                      [[NSUserDefaults standardUserDefaults]setValue:((NSString *)[[tempArray objectAtIndex:1] valueForKey:@"name"]) forKey:@"TemplateCatrgory"];
                      [[NSUserDefaults standardUserDefaults]synchronize];
                  }
                  
                [self presentViewController:vc animated:YES completion:nil];
              }
              else
              {
                  NSLog(@" %@",error);
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor lightGreen];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
              }
              [hud hideAnimated:YES];

          }]resume];
    }@catch(NSException *exception)
    {
        
    }
}

- (IBAction)chooseMusic_actn:(id)sender
{
    NSLog(@"MuiscTabViewController");
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MuiscTabViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MuiscTab"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)back:(id)sender
{
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"Would you like to discard this change ?" withTitle:@"Discard" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.hidden = YES;
    popUp.accessibilityHint =@"Exit";
    popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
    popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
    [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
    [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
    popUp.inputTextField.hidden = YES;
    [popUp show];

}

- (IBAction)done:(id)sender
{
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"wizImgPath"]!=nil)
    {
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"TenSTemplateDic"]!=nil)
            {
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"WizardMusicId"]!=nil)
                {
                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"WizardIconPath"]!=nil)
                    {
                        if([[NSUserDefaults standardUserDefaults] objectForKey:@"WizardEffectsName"]!=nil)
                        {
                
                [templateDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"WizardMusictype"] forKey:@"music_type"];

                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"wizardGalleryImg"];
                NSLog(@"Data Images = %lu",(unsigned long)data.length);
                OnlyImages = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                NSDictionary *dic=[OnlyImages objectAtIndex:0];
                imgPath=[dic objectForKey:@"DataType"];
                [templateDic setValue:[dic objectForKey:@"DataType"] forKey:@"image_type"];
                [templateDic setValue:[dic objectForKey:@"Id"] forKey:@"imageId"];
                [templateDic setValue:user_id forKey:@"userId"];
                CustomPopUp *popUp = [CustomPopUp new];
                [popUp initAlertwithParent:self withDelegate:self withMsg:@"" withTitle:@"Album Name" withImage:[UIImage imageNamed:@"textfield_alert.png"]];
                popUp.accessibilityHint = @"EnteringTitle";
                popUp.okay.backgroundColor = [UIColor navyBlue];
                [popUp.okay setTitle:@"Create" forState:UIControlStateNormal]; popUp.agreeBtn.hidden = YES;

                popUp.inputTextField.delegate=self;
                popUp.inputTextField.placeholder = @"Title";
                popUp.cancelBtn.hidden = YES;
                popUp.msgLabel.hidden = YES;
                popUp.outSideTap = NO;
                [popUp show];
                
                NSLog(@"TEmplate %@",templateDic);
                    }
                }
              }
            }
    }
}

-(void)FinalTemplates
{
    NSString *finalJsonString;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:templateDic
                                                       options:NSJSONWritingPrettyPrinted
                        // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    } else
    {
        finalJsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
    }
    @try
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=business_template_final";
        
        NSDictionary *parameters = @{@"final":finalJsonString,@"lang":@"iOS"};

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
                  NSLog(@"FinalTempplateResponse == %@",responseObject);
                  NSMutableDictionary *dic = responseObject;
                  if([[dic valueForKey:@"status"] isEqualToString:@"True"]){
                      
                      CustomPopUp *popUp = [CustomPopUp new];
                      [popUp initAlertwithParent:self withDelegate:self withMsg:@"Making your Movie... it may take a few moments. You will be notified when your video is ready" withTitle:@"Thanks" withImage:[UIImage imageNamed:@"Alert_Success.png"]];
                      popUp.accessibilityHint = @"VideoGenerated";
                      popUp.okay.backgroundColor = [UIColor lightGreen];
                      popUp.agreeBtn.hidden = YES;
                      popUp.cancelBtn.hidden = YES;
                      popUp.inputTextField.hidden = YES;
                      [popUp show];
                  }
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
- (IBAction)menu:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    
    // Present the view controller
    
    [self.frostedViewController presentMenuViewController];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    
    self.bannerView.adUnitID =@"ca-app-pub-4411584255946382/4912857702";
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = @[ kGADSimulatorID , @"edbfb999c3435fc4de3c45e321ec02e6"];
    request.testDevices = nil;
    [self.bannerView loadRequest:request];

    self.bannerView.center=CGPointMake(_AdView.frame.size.width/2,_AdView.frame.size.height/2);
    
    [_AdView addSubview:_bannerView];
}
- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"Exit"])
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc1 animated:YES completion:nil];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"wizardGalleryImg"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"wizImgPath"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardMusicId"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TenSTemplateDic"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardIconPath"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardIconName"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardIconId"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WizardEffectsName"];
        
        }
}
-(void) okClicked:(CustomPopUp *)alertView{
    
    if([alertView.accessibilityHint isEqualToString:@"EnteringTitle"]){        
        if (alertView.inputTextField.text.length == 0)
        {
            [alertView hide];
            alertView = nil;
            [self checkAlert];
        }
        else
        {
           [templateDic setValue:alertView.inputTextField.text forKey:@"title"];
    
            [self FinalTemplates];
        }
    }else if([alertView.accessibilityHint isEqualToString:@"VideoGenerated"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NavigationFromWizardToAlbum"];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainAlbum" bundle:nil];
        
        DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        [vc awakeFromNib:@"contentController_4" arg:@"menuController"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];
    }
    [alertView hide];
    alertView = nil;
}
-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"Exit"])
    {
    }
    [alertView hide];
    alertView = nil;
}

-(void)checkAlert
{
    CustomPopUp *popUp = [CustomPopUp new];
    [popUp initAlertwithParent:self withDelegate:self withMsg:@"You forget to enter album title" withTitle:@"Alert" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
    popUp.okay.backgroundColor = [UIColor lightGreen];
    popUp.agreeBtn.hidden = YES;
    popUp.cancelBtn.hidden = YES;
    popUp.inputTextField.hidden = YES;
    [popUp show];
}
- (IBAction)choose_icon_action:(id)sender {
    
     UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
     
     WizardIcons *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WizardIcons"];
     
     [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)choose_effects_actin:(id)sender {
    
//    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TenStype =@"Effects";
[[NSUserDefaults standardUserDefaults]setValue:@"Effects" forKey:@"TenStype"];
    [self loadTemplatesCategory];
    
}
@end
