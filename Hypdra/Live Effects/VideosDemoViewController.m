//
//  VideosDemoViewController.m
//  Montage
//
//  Created by MacBookPro on 12/7/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "VideosDemoViewController.h"
#import <cge/cge.h>
#import "UIView+Toast.h"
#import "demoUtils.h"
#import "CollectionViewCellCam.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"
#import "AFNetworking.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define SHOW_FULLSCREEN 0
#define RECORD_WIDTH 480
#define RECORD_HEIGHT 640

#define _MYAVCaptureSessionPreset(w, h) AVCaptureSessionPreset ## w ## x ## h
#define MYAVCaptureSessionPreset(w, h) _MYAVCaptureSessionPreset(w, h)

static const char* const s_functionList[] = {
    "mask", //0
    "Pause", //1
    "Beautify", //2
    "PreCalc", //3
    "TakeShot", //4
    "Torch", //5
    "Resolution", //6
    "CropRec", //7
    "MyFilter0", //8
    "MyFilter1", //9
    "MyFilter2", //10
    "MyFilter3", //11
    "MyFilter4", //12
};

static const int s_functionNum = sizeof(s_functionList) / sizeof(*s_functionList);


@interface VideosDemoViewController ()<CGEFrameProcessingDelegate>
{
    BOOL isSapphire,isBister,isOscillate,isMulberry,isMantle,isFlourish,isIdle,isAuric,isOpaque;
    NSString *user_id;

}

@property (weak, nonatomic) IBOutlet UIButton *quitBtns;
@property (weak, nonatomic) IBOutlet UISlider *intensitySliders;
@property CGECameraViewHandler* myCameraViewHandler;
@property (nonatomic) UIScrollView* myScrollView;
@property (nonatomic) GLKView* glkView;
@property (nonatomic) int currentFilterIndex;
@property (nonatomic) NSURL* movieURL;
@property (nonatomic,strong)NSMutableArray *categoryNames;
@property (nonatomic,strong)NSMutableArray *sapphireList,*bisterList,*oscillateList,*mulberryList,*mantleList,*flourishList,*idleList,*auricList,*opaqueList;

@end

@implementation VideosDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timeLabel.hidden=YES;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    [self.intensitySliders setThumbImage:[UIImage imageNamed:@"slidersmall"] forState:UIControlStateNormal];
    self.intensitySliders.tintColor=UIColorFromRGB(0xFFED61);

    isSapphire=NO;
    isBister=NO;
    isOscillate=NO;isMulberry=NO;
    isMantle=NO;isFlourish=NO;isIdle=NO;isAuric=NO;isOpaque=NO;
    
    _categoryNames=[[NSMutableArray alloc]init];
    
    _sapphireList=[[NSMutableArray alloc]init];
    _bisterList=[[NSMutableArray alloc]init];
    _oscillateList=[[NSMutableArray alloc]init];
    _mulberryList=[[NSMutableArray alloc]init];
    _mantleList=[[NSMutableArray alloc]init];
    _flourishList=[[NSMutableArray alloc]init];
    _idleList=[[NSMutableArray alloc]init];
    _auricList=[[NSMutableArray alloc]init];
    _opaqueList=[[NSMutableArray alloc]init];
    
    self.categoryNames = [NSMutableArray arrayWithObjects:@"SAPPHIRE", @"BISTER",@"OSCILLATE",@"MULBERRY",@"MANTLE",@"FLOURISH",@"IDLE",@"AURIC",@"OPAQUE",nil];
    
    self.sapphireList=[NSMutableArray arrayWithObjects:@"filter-106",@"filter-69",@"filter-75",@"filter-70",@"filter-82",@"filter-68",@"filter-43",@"filter-42",@"filter-30",nil];
    
    self.bisterList=[NSMutableArray arrayWithObjects:@"filter-50",@"filter-80",@"filter-22",@"filter-105",@"filter-81",@"filter-79",@"filter-1",@"filter-101",@"filter-39",@"filter-77",nil];
    
    self.oscillateList=[NSMutableArray arrayWithObjects:@"filter-15",@"filter-10",@"filter-108",@"filter-14",@"filter-13",@"filter-11",@"filter-9",@"filter-12",@"filter-64",@"filter-21",nil];
    
    self.mulberryList=[NSMutableArray arrayWithObjects:@"filter-104",@"filter-5",@"filter-47",@"filter-74",@"filter-49",@"filter-66",@"filter-44",@"filter-41",@"filter-53",@"filter-57",nil];
    
    self.mantleList=[NSMutableArray arrayWithObjects:@"filter-18",@"filter-16",@"filter-36",@"filter-20",@"filter-26",@"filter-110",@"filter-24",@"filter-17",@"filter-19",@"filter-107",nil];
    
    self.flourishList=[NSMutableArray arrayWithObjects:@"filter-29",@"filter-38",@"filter-65",@"filter-67",@"filter-76",@"filter-46",@"filter-7",@"filter-71",@"filter-48",nil];
    
    self.idleList=[NSMutableArray arrayWithObjects:@"filter-85",@"filter-3",@"filter-103",@"filter-84",@"filter-28",@"filter-35",@"filter-25",@"filter-23",@"filter-86",nil];
    
    self.auricList=[NSMutableArray arrayWithObjects:@"filter-2",@"filter-34",@"filter-91",@"filter-73",@"filter-40",@"filter-99",@"filter-37",@"filter-45",@"filter-4",@"filter-33",nil];
    
    self.opaqueList=[NSMutableArray arrayWithObjects:@"filter-8",@"filter-95",@"filter-97",@"filter-89",@"filter-58",@"filter-72",@"filter-31",@"filter-27",@"filter-63",@"filter-33",nil];
    
    self.collectionViewVideos.allowsMultipleExpandedSections = NO;
    
    [[self.takeRecord imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    cgeSetLoadImageCallback(loadImageCallback, loadImageOKCallback, nil);
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/liveRecord"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    _movieURL = [NSURL fileURLWithPath:[dataPath stringByAppendingFormat:@"/Movie.mp4"]];
    
    CGRect rt = [[UIScreen mainScreen] bounds];
    
    CGRect sliderRT = [_intensitySliders bounds];
    sliderRT.size.width = rt.size.width - 20;
    [_intensitySliders setBounds:sliderRT];
    
    //#if SHOW_FULLSCREEN
    
    NSLog(@"SHOW_FULLSCREEN");
    
    _glkView = [[GLKView alloc] initWithFrame:rt];
    
    /*#else
     
     NSLog(@"SHOW_FULLSCREEN ELSE");
     
     CGFloat x, y, w = RECORD_WIDTH, h = RECORD_HEIGHT;
     
     CGFloat scaling = MIN(rt.size.width / (float)w, rt.size.height / (float)h);
     
     w *= scaling;
     h *= scaling;
     
     x = (rt.size.width - w) / 2.0;
     y = (rt.size.height - h) / 2.0;
     
     _glkView = [[GLKView alloc] initWithFrame: CGRectMake(x, y, w, h)];
     
     #endif*/
    
    _myCameraViewHandler = [[CGECameraViewHandler alloc] initWithGLKView:_glkView];
    
    if([_myCameraViewHandler setupCamera: MYAVCaptureSessionPreset(RECORD_HEIGHT, RECORD_WIDTH) cameraPosition:AVCaptureDevicePositionFront isFrontCameraMirrored:YES authorizationFailed:^{
        NSLog(@"Not allowed to open camera and microphone, please choose allow in the 'settings' page!!!");
    }])
    {
        [[_myCameraViewHandler cameraDevice] startCameraCapture];
    }
    else
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The Camera Is Not Allowed!"
//                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Image removed" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];

    }
    
    [self.mainView insertSubview:_glkView belowSubview:_quitBtns];
    
    CGRect scrollRT = rt;
    scrollRT.origin.y = scrollRT.size.height - 60;
    scrollRT.size.height = 50;
    _myScrollView = [[UIScrollView alloc] initWithFrame:scrollRT];
    
    CGRect frame = CGRectMake(0, 0, 95, 50);
    
    /*for(int i = 0; i != s_functionNum; ++i)
     {
     NSLog(@"First = %d",s_functionNum);
     
     MyButton* btn = [[MyButton alloc] initWithFrame:frame];
     [btn setTitle:[NSString stringWithUTF8String:s_functionList[i]] forState:UIControlStateNormal];
     [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
     [btn.layer setBorderColor:[UIColor redColor].CGColor];
     [btn.layer setBorderWidth:2.0f];
     [btn.layer setCornerRadius:11.0f];
     [btn setIndex:i];
     [btn addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     [_myScrollView addSubview:btn];
     frame.origin.x += frame.size.width;
     }*/
    
    frame.size.width = 70;
    
    /* for(int i = 0; i != g_configNum; ++i)
     {
     //            NSLog(@"Second = %d",g_configNum);
     MyButton* btn = [[MyButton alloc] initWithFrame:frame];
     
     if(i == 0)
     {
     [btn setTitle:@"Origin" forState:UIControlStateNormal];
     }
     else
     {
     [btn setTitle:[NSString stringWithFormat:@"filter%d", i] forState:UIControlStateNormal];
     }
     
     [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     [btn.layer setBorderColor:[UIColor blueColor].CGColor];
     [btn.layer setBorderWidth:1.5f];
     [btn.layer setCornerRadius:10.0f];
     [btn setIndex:i];
     [btn addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [_myScrollView addSubview:btn];
     
     frame.origin.x = frame.origin.x + frame.size.width + 20;
     }*/
    
    _myScrollView.contentSize = CGSizeMake(frame.origin.x, 50);
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_myScrollView];
    
    [CGESharedGLContext globalSyncProcessingQueue:
     ^{
         [CGESharedGLContext useGlobalGLContext];
         void cgePrintGLInfo();
         cgePrintGLInfo();
     }];
    
    [_myCameraViewHandler fitViewSizeKeepRatio:YES];
    
    [[_myCameraViewHandler cameraRecorder] setPictureHighResolution:YES];
    
    [_myCameraViewHandler switchCamera :YES];
    [self.view addSubview:self.collectionViewVideos];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section==0)       //Sapphire
        return 11;
    
    else if(section==1)  //Bister
        return 12;
    
    else if(section==2)  //oscillate
        return 12;
    
    else if(section==3)  //mulberry
        return 12;
    
    else if(section==4)  //mantle
        return 12;
    
    else if(section==5)  //Flourish
        return 11;
    
    else if(section==6)  //Idle
        return 12;
    
    else if(section==7)  //Auric
        return 12;
    
    else if(section==8)  //opaque
        return 12;
    else
        return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.categoryNames.count;
}

- (NSMutableAttributedString *)labelWithImage:(NSString *)typeName
{
    
    UIImage *newImage = [[UIImage imageNamed:@"back_referral"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, newImage.scale);
    [[UIColor whiteColor] set];
    [newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    newImage = newImage;
    
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = newImage;//[UIImage imageNamed:@"back_referral"];
    ///
    CGFloat imageOffsetY = -5.0;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        imageAttachment.bounds = CGRectMake(0, imageOffsetY, imageAttachment.image.size.width/1.8, imageAttachment.image.size.height/1.8);
    }
    
    else
    {
        imageAttachment.bounds = CGRectMake(0, imageOffsetY, imageAttachment.image.size.width/1.5, imageAttachment.image.size.height/1.5);
    }
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@""];
    [completeText appendAttributedString:attachmentString];
    NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:typeName];
    [completeText appendAttributedString:textAfterIcon];
    return completeText;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId=@"CollectionViewCellCam";
    
    CollectionViewCellCam *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    
    if(indexPath.item==0)
    {
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            cell.layer.cornerRadius=30.0f;
        }
        
        else
        {
            cell.layer.cornerRadius=20.0f;
            
        }
        cell.clipsToBounds=YES;
        
        if (indexPath.section == 0)
        {
            if(isSapphire)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Sapphire"];
                cell.labelType.textAlignment=NSTextAlignmentRight;
                cell.labelType.attributedText=labelValue;
                
            }
            else
            {
                cell.labelType.text=@"Sapphire ";
            }
          cell.bgView.backgroundColor=UIColorFromRGB(0xFCB78D);            cell.bgViewImg.hidden=YES;
        }
        
        else if(indexPath.section==1)
        {
            if(isBister)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Bister"];
                cell.labelType.textAlignment=NSTextAlignmentCenter;
                cell.labelType.attributedText=labelValue;
                
            }
            else
            {
                cell.labelType.text=@"Bister";
            }
            
         cell.bgView.backgroundColor=UIColorFromRGB(0xDDC48C);            cell.bgViewImg.hidden=YES;
            
        }
        
        else if(indexPath.section==2)
        {
            if(isOscillate)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Oscillate"];
                cell.labelType.textAlignment=NSTextAlignmentRight;
                cell.labelType.attributedText=labelValue;
                
            }
            else
            {
                cell.labelType.text=@"Oscillate";
            }
           cell.bgView.backgroundColor=UIColorFromRGB(0xCECA8D);            cell.bgViewImg.hidden=YES;
            
        }
        
        else if(indexPath.section==3)
        {
            if(isMulberry)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Mulberry"];
                cell.labelType.textAlignment=NSTextAlignmentRight;
                cell.labelType.attributedText=labelValue;
                
            }
            else
            {
                cell.labelType.text=@"Mulberry";
                
            }
           cell.bgView.backgroundColor=UIColorFromRGB(0xB9E5E4);            cell.bgViewImg.hidden=YES;
        }
        
        else if(indexPath.section==4)
        {
            if(isMantle)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Mantle"];
                cell.labelType.textAlignment=NSTextAlignmentCenter;
                cell.labelType.attributedText=labelValue;
                
            }
            else
            {
                cell.labelType.text=@"Mantle";
                
            }
            cell.bgView.backgroundColor=UIColorFromRGB(0xBCB7EF);
            cell.bgViewImg.hidden=YES;
        }
        
        else if(indexPath.section==5)
        {
            if(isFlourish)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Flourish"];
                cell.labelType.textAlignment=NSTextAlignmentRight;
                cell.labelType.attributedText=labelValue;
                
            }
            else
            {
                cell.labelType.text=@"Flourish";
            }
            
            cell.bgView.backgroundColor=UIColorFromRGB(0xFCB78D);            cell.bgViewImg.hidden=YES;
        }
        
        else if(indexPath.section==6)
        {
            if(isIdle)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Idle"];
                cell.labelType.textAlignment=NSTextAlignmentCenter;
                cell.labelType.attributedText=labelValue;
                
            }
            else
            {
                cell.labelType.text=@"Idle";
            }
            
            cell.bgView.backgroundColor=UIColorFromRGB(0xDDC48C);            cell.bgViewImg.hidden=YES;
        }
        
        else if(indexPath.section==7)
        {
            if(isAuric)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Auric"];
                cell.labelType.textAlignment=NSTextAlignmentCenter;
                cell.labelType.attributedText=labelValue;
                
            }
            else
            {
                cell.labelType.text=@"Auric";
            }
            cell.bgView.backgroundColor=UIColorFromRGB(0xCECA8D);            cell.bgViewImg.hidden=YES;
        }
        
        else if(indexPath.section==8)
        {
            if(isOpaque)
            {
                NSMutableAttributedString *labelValue = [self labelWithImage:@"Opaque"];
                cell.labelType.textAlignment=NSTextAlignmentRight;
                cell.labelType.attributedText=labelValue;
                
            }
            
            else
            {
                cell.labelType.text=@"Opaque";
            }
            cell.bgView.backgroundColor=UIColorFromRGB(0xB9E5E4);
            cell.bgViewImg.hidden=YES;
        }
    }
    else
    {
        cell.bgViewImg.hidden=NO;
        
        if(indexPath.section==0)  //Sapphire
        {
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
                cell.btn.tag=0;
            }
            
            else if(indexPath.item==2)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=106;
                
            }
            
            else if(indexPath.item==3)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                cell.btn.tag=69;
            }
            
            else if(indexPath.item==4)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                cell.btn.tag=75;
            }
            
            else if(indexPath.item==5)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                cell.btn.tag=70;
            }
            
            else if(indexPath.item==6)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                cell.btn.tag=82;
            }
            else if(indexPath.item==7)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                cell.btn.tag=68;
            }
            
            else if(indexPath.item==8)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                cell.btn.tag=43;
            }
            else if(indexPath.item==9)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                cell.btn.tag=42;
            }
            else if(indexPath.item==10)
            {
                cell.imgView.image=[UIImage imageNamed:[_sapphireList objectAtIndex:indexPath.item-2]];
                cell.btn.tag=30;
            }
            
        }
        else if(indexPath.section==1)  //BIster
        {
            
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
                cell.btn.tag=0;
                
            }
            else if(indexPath.item==2)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=50;
                
            }
            else if(indexPath.item==3)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=80;
                
            }
            else if(indexPath.item==4)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=22;
                
            }else if(indexPath.item==5)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=105;
                
            }else if(indexPath.item==6)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=81;
                
            }else if(indexPath.item==7)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=79;
                
            }else if(indexPath.item==8)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=1;
                
            }else if(indexPath.item==9)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=101;
                
            }else if(indexPath.item==10)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=39;
                
            }
            else if(indexPath.item==11)
            {
                cell.imgView.image=[UIImage imageNamed:[_bisterList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=77;
                
            }
        }
        
        else if(indexPath.section==2)  //oscillate
        {
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
                cell.btn.tag=0;
                
            }
            else if(indexPath.item==2)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=15;
                
            }
            else if(indexPath.item==3)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=10;
                
            }
            else if(indexPath.item==4)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=108;
                
            }else if(indexPath.item==5)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=14;
                
            }else if(indexPath.item==6)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=13;
                
            }else if(indexPath.item==7)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=11;
                
            }else if(indexPath.item==8)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=9;
                
            }else if(indexPath.item==9)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=12;
                
            }else if(indexPath.item==10)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=64;
                
            }
            else if(indexPath.item==11)
            {
                cell.imgView.image=[UIImage imageNamed:[_oscillateList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=21;
                
            }
        }
        else if(indexPath.section==3)  //mulberry
        {
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
                cell.btn.tag=0;
            }
            else if(indexPath.item==2)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=104;
                
            }
            else if(indexPath.item==3)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=5;
                
            }
            else if(indexPath.item==4)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=47;
                
            }else if(indexPath.item==5)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=74;
                
            }else if(indexPath.item==6)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=49;
                
            }else if(indexPath.item==7)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=66;
                
            }else if(indexPath.item==8)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=44;
                
            }else if(indexPath.item==9)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=41;
                
            }else if(indexPath.item==10)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=53;
                
            }
            else if(indexPath.item==11)
            {
                cell.imgView.image=[UIImage imageNamed:[_mulberryList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=57;
                
            }
        }
        
        else if(indexPath.section==4)  //mantle
            
        {
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
                cell.btn.tag=0;
            }
            else if(indexPath.item==2)
            {
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=18;
                
            }
            else if(indexPath.item==3)
            {
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=16;
                
            }
            else if(indexPath.item==4)
            {
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=36;
                
            }else if(indexPath.item==5)
            {
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=20;
                
            }else if(indexPath.item==6)
            {
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=26;
                
            }else if(indexPath.item==7)
            {
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=110;
                
            }else if(indexPath.item==8)
            {
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=24;
                
            }else if(indexPath.item==9)
            {
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=17;
                
            }else if(indexPath.item==10)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=19;
                
            }
            else if(indexPath.item==11)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=107;
                
            }
        }
        else if(indexPath.section==5)  //flourish
            
        {
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.btn.tag=0;
                ;
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
            }
            else if(indexPath.item==2)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=29;
                
            }
            else if(indexPath.item==3)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=38;
                
            }
            else if(indexPath.item==4)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=65;
                
            }else if(indexPath.item==5)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=67;
                
            }else if(indexPath.item==6)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=76;
                
            }else if(indexPath.item==7)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=46;
                
            }else if(indexPath.item==8)
            {
                ;
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=7;
                
            }else if(indexPath.item==9)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=71;
                
            }else if(indexPath.item==10)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=48;
                
            }
        }
        else if(indexPath.section==6)  //idle
            
        {
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.btn.tag=0;
                
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
            }
            else if(indexPath.item==2)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=85;
                
            }
            else if(indexPath.item==3)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=3;
                
            }
            else if(indexPath.item==4)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=103;
                
            }else if(indexPath.item==5)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=109;
                
            }else if(indexPath.item==6)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=84;
                
            }else if(indexPath.item==7)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=28;
                
            }else if(indexPath.item==8)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=35;
                
            }else if(indexPath.item==9)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=25;
                
            }else if(indexPath.item==10)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=23;
                
            }else if(indexPath.item==11)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_mantleList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=86;
                
            }
        }
        else if(indexPath.section==7)  //auric
            
        {
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.btn.tag=0;
                
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
            }
            else if(indexPath.item==2)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=2;
                
            }
            else if(indexPath.item==3)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=34;
                
            }
            else if(indexPath.item==4)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=91;
                
            }else if(indexPath.item==5)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=73;
                
            }else if(indexPath.item==6)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=40;
                
            }else if(indexPath.item==7)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=99;
                
            }else if(indexPath.item==8)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=37;
                
            }else if(indexPath.item==9)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=45;
                
            }else if(indexPath.item==10)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=4;
                
            }else if(indexPath.item==11)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_auricList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=33;
                
            }
        }
        else if(indexPath.section==8)  //opaque
            
        {
            cell.layer.cornerRadius=8.0f;
            cell.clipsToBounds=YES;
            if(indexPath.item==1)
            {
                cell.btn.tag=0;
                
                cell.imgView.image=[UIImage imageNamed:@"liveCapture_noneImg.png"];
            }
            else if(indexPath.item==2)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=8;
                
            }
            else if(indexPath.item==3)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=95;
                
            }
            else if(indexPath.item==4)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=97;
                
            }else if(indexPath.item==5)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=89;
                
            }else if(indexPath.item==6)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=58;
                
            }else if(indexPath.item==7)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=72;
                
            }else if(indexPath.item==8)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=31;
                
            }else if(indexPath.item==9)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=27;
                
            }else if(indexPath.item==10)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=63;
                
            }else if(indexPath.item==11)
            {
                
                cell.imgView.image=[UIImage imageNamed:[_opaqueList objectAtIndex:indexPath.item-2]];
                
                cell.btn.tag=33;
                
            }
        }
    }
    
    [cell.btn addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didCollapseItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did collapsed%@", indexPath);
    if(indexPath.section==0)
    {
        isSapphire=NO;
        
    }
    
    else if(indexPath.section==1)
        isBister=NO;
    
    else if(indexPath.section==2)
        isOscillate=NO;
    
    else if(indexPath.section==3)
        isMulberry=NO;
    
    else if(indexPath.section==4)
        isMantle=NO;
    
    else if(indexPath.section==5)
        isFlourish=NO;
    
    else if(indexPath.section==6)
        isIdle=NO;
    
    else if(indexPath.section==7)
        isAuric=NO;
    
    else if(indexPath.section==8)
        isOpaque=NO;
    
    NSIndexSet *index=[NSIndexSet indexSetWithIndex:indexPath.section];
    [self.collectionViewVideos reloadSections:index];
    
}

- (void)collectionView:(UICollectionView *)collectionView didExpandItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did expanded");
    if(indexPath.section==0)
    {
        isSapphire=YES;
        
    }
    
    else if(indexPath.section==1)
        isBister=YES;
    
    else if(indexPath.section==2)
        isOscillate=YES;
    
    else if(indexPath.section==3)
        isMulberry=YES;
    
    
    else if(indexPath.section==4)
        isMantle=YES;
    
    else if(indexPath.section==5)
        isFlourish=YES;
    
    else if(indexPath.section==6)
        isIdle=YES;
    
    else if(indexPath.section==7)
        isAuric=YES;
    
    else if(indexPath.section==8)
        isOpaque=YES;
    
    NSIndexSet *index=[NSIndexSet indexSetWithIndex:indexPath.section];
    [self.collectionViewVideos reloadSections:index];
}

- (void)filterButtonClicked: (MyButton*)sender
{
    // _currentFilterIndex = [sender index];
    // NSLog(@"Filter %d Clicked...\n", _currentFilterIndex);
    
    //    NSIndexPath *indexPath=[NSIndexPath indexPathWithIndex:sender.tag];
    //    CollectionViewCellCam *cell=[self.collectionViewCam dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellCam" forIndexPath:indexPath];
    //    
    
    _currentFilterIndex =(int)sender.tag;
    NSLog(@"Filter %d Clicked...\n", _currentFilterIndex);
    
    //Sapphire
    if(sender.tag==106)
        [self.view makeToast:@"Apricot" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==69)
        [self.view makeToast:@"Bleach" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==75)
        [self.view makeToast:@"Dream" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==70)
        [self.view makeToast:@"HDR" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==82)
        [self.view makeToast:@"Jazz" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==68)
        [self.view makeToast:@"Navy" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==43)
        [self.view makeToast:@"Ocean" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==42)
        [self.view makeToast:@"Pond" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==30)
        [self.view makeToast:@"Snuff" duration:1.0 position:CSToastPositionCenter];
    
    //Bister
    
    else if(sender.tag==50)
        [self.view makeToast:@"Blush" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==80)
        [self.view makeToast:@"Bronze" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==22)
        [self.view makeToast:@"Cipher" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==105)
        [self.view makeToast:@"Choco" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==81)
        [self.view makeToast:@"Chroma" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==79)
        [self.view makeToast:@"Coral" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==1)
        [self.view makeToast:@"Electolyze" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==101)
        [self.view makeToast:@"Grunge" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==39)
        [self.view makeToast:@"Rust" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==77)
        [self.view makeToast:@"Sandal" duration:1.0 position:CSToastPositionCenter];
    
    //Oscilate
    
    else if(sender.tag==15)
        [self.view makeToast:@"Bob" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==10)
        [self.view makeToast:@"Blur" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==108)
        [self.view makeToast:@"Dove" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==14)
        [self.view makeToast:@"Flicker" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==13)
        [self.view makeToast:@"Jelly" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==11)
        [self.view makeToast:@"Jittery" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==9)
        [self.view makeToast:@"Muddy" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==12)
        [self.view makeToast:@"Rattle" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==64)
        [self.view makeToast:@"Scintillate" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==21)
        [self.view makeToast:@"Soften" duration:1.0 position:CSToastPositionCenter];
    
    //Mulberry
    else if(sender.tag==104)
        [self.view makeToast:@"Aqua" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==5)
        [self.view makeToast:@"Bister" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==47)
        [self.view makeToast:@"Cobalt" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==74)
        [self.view makeToast:@"Dwarf" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==49)
        [self.view makeToast:@"Lilac" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==66)
        [self.view makeToast:@"Mauve" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==44)
        [self.view makeToast:@"Orchid" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==41)
        [self.view makeToast:@"Peach" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==53)
        [self.view makeToast:@"Perse" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==57)
        [self.view makeToast:@"Smooth" duration:1.0 position:CSToastPositionCenter];
    
    //mantle
    else if(sender.tag==18)
        [self.view makeToast:@"Comic" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==16)
        [self.view makeToast:@"Crayon" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==36)
        [self.view makeToast:@"Draft" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==20)
        [self.view makeToast:@"Disguise" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==26)
        [self.view makeToast:@"Foil" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==110)
        [self.view makeToast:@"Reflect" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==24)
        [self.view makeToast:@"Sketch" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==17)
        [self.view makeToast:@"Symbolize" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==19)
        [self.view makeToast:@"Trendy" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==107)
        [self.view makeToast:@"Vignette" duration:1.0 position:CSToastPositionCenter];
    
    //flourish
    else if(sender.tag==29)
        [self.view makeToast:@"Bloom" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==38)
        [self.view makeToast:@"Coal" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==65)
        [self.view makeToast:@"Copper" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==67)
        [self.view makeToast:@"Ivory" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==76)
        [self.view makeToast:@"Lush" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==46)
        [self.view makeToast:@"Noble" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==7)
        [self.view makeToast:@"Ruddy" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==71)
        [self.view makeToast:@"Salmon" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==48)
        [self.view makeToast:@"Teal" duration:1.0 position:CSToastPositionCenter];
    
    //Idle
    else if(sender.tag==85)
        [self.view makeToast:@"Ash" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==3)
        [self.view makeToast:@"Blizzard" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==103)
        [self.view makeToast:@"Dreary" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==109)
        [self.view makeToast:@"Ebony" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==84)
        [self.view makeToast:@"Granite" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==28)
        [self.view makeToast:@"Glitch" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==35)
        [self.view makeToast:@"Inert" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==25)
        [self.view makeToast:@"Margin" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==23)
        [self.view makeToast:@"Neon" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==86)
        [self.view makeToast:@"Stony" duration:1.0 position:CSToastPositionCenter];
    
    //Auric
    else if(sender.tag==2)
        [self.view makeToast:@"Craven" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==34)
        [self.view makeToast:@"Deceit" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==91)
        [self.view makeToast:@"Eclipse" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==73)
        [self.view makeToast:@"Hazel" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==40)
        [self.view makeToast:@"Limpid" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==99)
        [self.view makeToast:@"Mellow" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==37)
        [self.view makeToast:@"Pearl" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==45)
        [self.view makeToast:@"Plum" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==4)
        [self.view makeToast:@"Shady" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==33)
        [self.view makeToast:@"Stroke" duration:1.0 position:CSToastPositionCenter];
    
    //Opaque:
    else if(sender.tag==8)
        [self.view makeToast:@"Dazzle" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==95)
        [self.view makeToast:@"Dim" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==97)
        [self.view makeToast:@"Flash" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==89)
        [self.view makeToast:@"Gaze" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==58)
        [self.view makeToast:@"Gleam" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==72)
        [self.view makeToast:@"Glossy" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==31)
        [self.view makeToast:@"Moonlit" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==27)
        [self.view makeToast:@"Null" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==63)
        [self.view makeToast:@"Ripe" duration:1.0 position:CSToastPositionCenter];
    else if(sender.tag==33)
        [self.view makeToast:@"Stroke" duration:1.0 position:CSToastPositionCenter];
    
    const char* config = g_effectConfig[_currentFilterIndex];
    [_myCameraViewHandler setFilterWithConfig:config];
    
}

- (void)setMask
{
    CGRect rt = [[UIScreen mainScreen] bounds];
    
    CGFloat x, y, w = RECORD_WIDTH, h = RECORD_HEIGHT;
    
    if([_myCameraViewHandler isUsingMask])
    {
        [_myCameraViewHandler setMaskUIImage:nil];
    }
    else
    {
        UIImage* img = [UIImage imageNamed:@"mask1.png"];
        w = img.size.width;
        h = img.size.height;
        [_myCameraViewHandler setMaskUIImage:img];
    }
    
    float scaling = MIN(rt.size.width / (float)w, rt.size.height / (float)h);
    
    w *= scaling;
    h *= scaling;
    
    x = (rt.size.width - w) / 2.0;
    y = (rt.size.height - h) / 2.0;
    
    [_myCameraViewHandler fitViewSizeKeepRatio:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
#if SHOW_FULLSCREEN
    
    [_glkView setFrame:rt];
    
#else
    
    [_glkView setFrame:CGRectMake(x, y, w, h)];
    
#endif
    
    [UIView commitAnimations];
}

- (BOOL)bufferRequestRGBA
{
    return NO;
}

// Draw your own content!
// The content would be shown in realtime, and can be recorded to the video.
- (void)drawProcResults:(void *)handler
{
    // unmark below, if you can use cpp. (remember #include "cgeImageHandler.h")
    //    using namespace CGE;
    //    CGEImageHandler* cppHandler = (CGEImageHandler*)handler;
    //    cppHandler->setAsTarget();
    
    static float x = 0;
    static float dx = 10.0f;
    glEnable(GL_SCISSOR_TEST);
    x += dx;
    if(x < 0 || x > 500)
        dx = -dx;
    glScissor(x, 100, 200, 200);
    glClearColor(1, 0.5, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glDisable(GL_SCISSOR_TEST);
}

//The realtime buffer for processing. Default format is YUV, and you can change the return value of "bufferRequestRGBA" to recieve buffer of format-RGBA.
- (BOOL)processingHandleBuffer:(CVImageBufferRef)imageBuffer
{
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(UITouch* touch, BOOL* stop)
     {
         CGPoint touchPoint = [touch locationInView:_glkView];
         CGSize sz = [_glkView frame].size;
         CGPoint transPoint = CGPointMake(touchPoint.x / sz.width, touchPoint.y / sz.height);
         
         [_myCameraViewHandler focusPoint:transPoint];
         NSLog(@"touch position: %g, %g, transPoint: %g, %g", touchPoint.x, touchPoint.y, transPoint.x, transPoint.y);
     }];
}

- (void)switchTorchMode
{
    AVCaptureTorchMode mode[3] =
    {
        AVCaptureTorchModeOff,
        AVCaptureTorchModeOn,
        AVCaptureTorchModeAuto
    };
    
    static int torchModeIndex = 0;
    
    ++torchModeIndex;
    torchModeIndex %= 3;
    
    [_myCameraViewHandler setTorchMode:mode[torchModeIndex]];
}

- (void)switchResolution
{
    NSString* resolutionList[] =
    {
        AVCaptureSessionPresetPhoto,
        AVCaptureSessionPresetHigh,
        AVCaptureSessionPresetMedium,
        AVCaptureSessionPresetLow,
        AVCaptureSessionPreset352x288,
        AVCaptureSessionPreset640x480,
        AVCaptureSessionPreset1280x720,
        AVCaptureSessionPreset1920x1080,
        AVCaptureSessionPreset3840x2160,
        AVCaptureSessionPresetiFrame960x540,
        AVCaptureSessionPresetiFrame1280x720,
        AVCaptureSessionPresetInputPriority
    };
    
    static const int listNum = sizeof(resolutionList) / sizeof(*resolutionList);
    static int index = 0;
    
    if([[_myCameraViewHandler cameraDevice] captureSessionPreset] != resolutionList[index])
    {
        [_myCameraViewHandler setCameraSessionPreset:resolutionList[index]];
    }
    
    CMVideoDimensions dim = [[[_myCameraViewHandler cameraDevice] inputCamera] activeFormat].highResolutionStillImageDimensions;
    NSLog(@"Preset: %@, max resolution: %d, %d\n", [[_myCameraViewHandler cameraDevice] captureSessionPreset], dim.width, dim.height);
    
    [[_myCameraViewHandler cameraRecorder] setPictureHighResolution:YES];
    
    ++index;
    index %= listNum;
}

//This example shows how to record the specified area of your camera view.

- (void)cropRecording: (MyButton*)sender
{
    @try
    {
    if([_myCameraViewHandler isRecording])
    {
        void (^finishBlock)(void) = ^{
            NSLog(@"End recording...\n");
            
            [CGESharedGLContext mainASyncProcessingQueue:^{
                [sender setTitle:@"录制完成" forState:UIControlStateNormal];
                [sender setEnabled:YES];
            }];
            
            [DemoUtils saveVideo:_movieURL];
            
        };
        [_myCameraViewHandler endRecording:finishBlock withCompressionLevel:2];
    }
    else
    {
        unlink([_movieURL.path UTF8String]);
        
        CGRect rts[] =
        {
            CGRectMake(0.25, 0.25, 0.5, 0.5), //Record a quarter of the camera view in the center.
            CGRectMake(0.5, 0.0, 0.5, 1.0), //Record the right (half) side of the camera view.
            CGRectMake(0.0, 0.0, 1.0, 0.5), //Record the up (half) side of the camera view.
        };
        
        CGRect rt = rts[rand() % sizeof(rts) / sizeof(*rts)];
        
        CGSize videoSize = CGSizeMake(RECORD_WIDTH * rt.size.width, RECORD_HEIGHT * rt.size.height);
        
        NSLog(@"Crop area: %g, %g, %g, %g, record resolution: %g, %g", rt.origin.x, rt.origin.y, rt.size.width, rt.size.height, videoSize.width, videoSize.height);
        
        [_myCameraViewHandler startRecording:_movieURL size:videoSize cropArea:rt];
        
        [sender setTitle:@"Rec stopped" forState:UIControlStateNormal];
        
        [sender setEnabled:YES];
    }
  }@catch(NSException *exception)
    {
        
    }
}

/*
 - (void)setCustomFilter:(CustomFilterType)type
 {
 void* customFilter = cgeCreateCustomFilter(type, 1.0f, _myCameraViewHandler.cameraRecorder.sharedContext);
 [_myCameraViewHandler.cameraRecorder setFilterWithAddress:customFilter];
 }
 */

- (void)functionButtonClick: (MyButton*)sender
{
    NSLog(@"Function Button %d Clicked...\n", [sender index]);
    
   
}

//Actions :-

- (IBAction)quitBtnClicked:(id)sender
{
    @try
    {
    NSLog(@"Camera Demo Quit...");
    [[[_myCameraViewHandler cameraRecorder] cameraDevice] stopCameraCapture];
    //    [self dismissViewControllerAnimated:true completion:nil];
    //safe clear to avoid memLeaks.
    [_myCameraViewHandler clear];
    _myCameraViewHandler = nil;
    [CGESharedGLContext clearGlobalGLContext];
    
    if ([self.delegate respondsToSelector:@selector(didCloseVideo)])
    {
        [self.delegate didCloseVideo];
    }
    }@catch(NSException *ex)
    {
        
    }
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)intensityChanged:(UISlider*)sender
{
    float currentIntensity = [sender value] * 3.0f - 1.0f; //[-1, 2]
    
    [_myCameraViewHandler setFilterIntensity: currentIntensity];
}

- (IBAction)switchCameraClicked:(id)sender
{
    [_myCameraViewHandler switchCamera :YES]; //Pass YES to mirror the front camera.
    
    CMVideoDimensions dim = [[[_myCameraViewHandler cameraDevice] inputCamera] activeFormat].highResolutionStillImageDimensions;
    
    NSLog(@"Max Photo Resolution: %d, %d\n", dim.width, dim.height);
}


- (IBAction)recordingBtnClicked:(UIButton*)sender
{
    @try
    {
    [self.takeRecord setImage:[UIImage imageNamed:@"stopvideo.png"] forState:UIControlStateNormal];
    
    [sender setEnabled:NO];
    
    if([_myCameraViewHandler isRecording])
    {
        NSLog(@"before dispatch async");
        
        void (^finishBlock)(void) =
        ^{
            NSLog(@"End recording...\n");
            
            [CGESharedGLContext mainASyncProcessingQueue:
             ^{
                 [sender setTitle:@"Rec OK" forState:UIControlStateNormal];
                 [sender setEnabled:YES];
                 NSLog(@"Before First");
                 [self finish];
                 
             }];
            
            //               [DemoUtils saveVideo:_movieURL];
            
            NSLog(@"First");
            
        };
        
        NSLog(@"Second");
        
        [_myCameraViewHandler endRecording:finishBlock withCompressionLevel:0];
        
        NSLog(@"after dispatch async");
    }
    else
    {
        unlink([_movieURL.path UTF8String]);
        [_myCameraViewHandler startRecording:_movieURL size:CGSizeMake(RECORD_WIDTH, RECORD_HEIGHT)];
        
        [sender setTitle:@"Recording" forState:UIControlStateNormal];
        [sender setEnabled:YES];
        
        self.timeLabel.hidden=NO;
 
        NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", self.timeMin, self.timeSec];
        
        self.timeLabel.text= timeNow;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
 }@catch(NSException *exception)
    {
        
    }
}

//Event called every time the NSTimer ticks.
- (void)timerTick:(NSTimer *)timer
{
    self.timeSec++;
    if (self.timeSec == 60)
    {
        self.timeSec = 0;
        self.timeMin++;
    }
    //String format 00:00
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", self.timeMin, self.timeSec];
    //Display on your label
    self.timeLabel.text= timeNow;
}

-(void)finish
{
    @try
    {
    [[[_myCameraViewHandler cameraRecorder] cameraDevice] stopCameraCapture];
    [_myCameraViewHandler clear];
    _myCameraViewHandler = nil;
    [CGESharedGLContext clearGlobalGLContext];
    
        NSDictionary *parameters =@{@"lang":@"iOS",@"User_ID":user_id,@"type":@"video_recording"};
        
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
        
    if ([self.delegate respondsToSelector:@selector(didFinishedVideo:)])
    {
        [self.delegate didFinishedVideo:_movieURL];
    }
    }@catch(NSException *ex)
    {
        
    }
    
}

- (IBAction)switchFlashLight:(id)sender
{
    static AVCaptureFlashMode flashLightList[] =
    {
        AVCaptureFlashModeOff,
        AVCaptureFlashModeOn,
        AVCaptureFlashModeAuto
    };
    
    static int flashLightIndex = 0;
    
    ++flashLightIndex;
    
    flashLightIndex %= sizeof(flashLightList) / sizeof(*flashLightList);
    
    [_myCameraViewHandler setCameraFlashMode:flashLightList[flashLightIndex]];
}
-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
        
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
    if([alertView.accessibilityHint isEqualToString:@""]){
        
    }else if([alertView.accessibilityHint isEqualToString:@""]){
        
    }
    [alertView hide];
    alertView = nil;
}
@end
