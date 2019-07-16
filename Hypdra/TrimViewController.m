//
//  TrimViewController.m
//  Montage
//
//  Created by MacBookPro4 on 5/13/17.
//  Copyright © 2017 sssn. All rights reserved.

#import "TrimViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SAVideoRangeSlider.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SJVideoPlayer.h"
#import "SJVideoPlayerControl.h"
#import "DEMORootViewController.h"
#import "DEMOHomeViewController.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "VideoEditorViewController.h"
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"

#define kRotateRight -M_PI/2
#define kRotateLeft  M_PI/2

#define IS_PAD  (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

CGFloat degreesToRadian(CGFloat degrees) {return degrees * M_PI / 180;};


@interface TrimViewController ()<SAVideoRangeSliderDelegate,VKVideoPlayerDelegate,ClickDelegates>
{
    
    BOOL textFlag,logoFlag,OrioFlag,flipFlag,flopFlag;
    
    NSString *appDir,*Pathdir,*user_id,*imageID,*playerURL;
    NSMutableURLRequest *request;
    NSMutableArray *finalArray,*OnlyImages,*fullImage,*thumbImage;
    
    int HigestImageCount,lastHighestCount;
    
    MBProgressHUD *hud;
    
    UIView *tempLayerView;
    CGFloat diagonal,rotationAngle,imageWidth,imageHeight;
    UIImage *videoThumbnail;
    
    int rotation,flip,flop;
    NSString *trimVideoPath;
}

@property (nonatomic, assign, readwrite) NSTimeInterval currentTime;

//@property (strong, nonatomic) SAVideoRangeSlider *mySAVideoRangeSlider;

#define URL @ "https://hypdra.com/api/api.php?rquest=image_upload_final"

@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (strong, nonatomic) NSString *originalVideoPath;
@property (strong, nonatomic) NSString *tmpVideoPath;
@property (nonatomic) CGFloat startTime;
@property (nonatomic) CGFloat stopTime;


@end

@implementation TrimViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSLog(@"viewdidload");
    
    rotation = 0;
    playerURL=[[NSUserDefaults standardUserDefaults]objectForKey:@"videoPathValue"];
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    [self loadVideoPlayer];
    
    flip = 0;
    flop = 0;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    tempLayerView  = self.SJplayer.presentView;

    [self calculateDiagonal];
    //  [self intialLoad:appDir];
    self.navigationController.navigationBar.topItem.title = @"Video Editor";
    [[self.btnTrim imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"URL = %@",self.playerURL);
    
    self.dontBtn.enabled = false;
    
    self.dontBtn.tintColor = [UIColor clearColor];
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    //[self playSampleClip1];
    
    if(!isnan(_currentTime))
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:playerURL] jumpedToTime:self.currentTime];
    else
        [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:playerURL] jumpedToTime:0];
    
    [self loadSlider];
}

-(void)loadSlider
{
    dispatch_async(dispatch_get_main_queue(), ^{
        SAVideoRangeSlider *mySAVideoRangeSlider;
        NSURL *videoFileUrl = [NSURL URLWithString:playerURL];
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoFileUrl options:nil];
        _naturalSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
            mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.trimView.frame.size.width, 80) videoUrl:videoFileUrl];
            
            [mySAVideoRangeSlider setPopoverBubbleSize:200 height:100];
        }
        else
        {
            mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, self.trimView.frame.size.height/4, self.trimView.frame.size.width, 60) videoUrl:videoFileUrl];
            
            mySAVideoRangeSlider.bubleText.font = [UIFont systemFontOfSize:12];
            [mySAVideoRangeSlider setPopoverBubbleSize:120 height:60];
            // self.mySAVideoRangeSlider.maxGap=30;
        }
        
        mySAVideoRangeSlider.topBorder.backgroundColor =     [self colorWithHexString:@"#2d2c65"];
        // 3399FF
        mySAVideoRangeSlider.bottomBorder.backgroundColor =     [self colorWithHexString:@"#2d2c65"];
        
        
        mySAVideoRangeSlider.delegate = self;
        [self.trimView addSubview:mySAVideoRangeSlider];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [hud hideAnimated:YES];
        
    });
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    NSLog(@"viewDidDisappear");
    
    self.currentTime = [SJVideoPlayer sharedPlayer].currentTime;
    
    [[SJVideoPlayer sharedPlayer] stop];
    
}

-(void)loadVideoAsset
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
        
        while (CGSizeEqualToSize(CGSizeZero, self.naturalSize)) {
            @try {
                NSURL *videoURL=[[NSURL alloc] initWithString:self.playerURL];
                AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
                _naturalSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
            } @catch (NSException *exception) {
                
            }
        }
    });
}
//{
//    /*   dispatch_group_t sub_group=dispatch_group_create();
//     dispatch_group_enter(sub_group);
//     NSURL *videoURL=[[NSURL alloc] initWithString:self.playURL];
//
//     AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
//     dispatch_group_leave(sub_group);
//     dispatch_group_notify(sub_group, dispatch_get_main_queue(),
//     ^{
//     NSLog(@"Loaded Video Asset");
//     _naturalSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
//     });*/
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
//        NSURL *videoURL=[[NSURL alloc] initWithString:self.playerURL];
//        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
//        _naturalSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
//    });
//
//}


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
    //[tempLayerView setFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    //[_SJplayer.control.view setFrame:CGRectMake(_SJplayer.control.view.frame.origin.x, _SJplayer.control.view.frame.origin.y, _SJplayer.control.view.frame.size.width, _SJplayer.control.view.frame.size.height)];
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
    CGAffineTransform transform = CGAffineTransformRotate(concate, degreesToRadian(rotationAngle));
    
    //rotationAngle = angle;
    
    [UIView animateWithDuration:0.5 delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         tempLayerView.transform = transform;
     }
                     completion:^(BOOL finished)
     {
         
     }];
    
    [self setFrameToFitImage];
    
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



- (UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - SAVideoRangeSliderDelegate

- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    self.startTime = leftPosition;
    self.stopTime = rightPosition;
    // self.timeLabel.text = [NSString stringWithFormat:@"%f - %f", leftPosition, rightPosition];
    
    NSLog(@"Start and end:%f - %f", leftPosition, rightPosition);
    
}



- (IBAction)trimAction:(id)sender
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    // [self deleteTmpFile];
    NSLog(@"Trim Stat time:%f",_startTime);
    NSLog(@"Trim End time:%f",_stopTime);
    
    int seconds = (int)_startTime % 60;
    int minutes = (int)(_startTime / 60) % 60;
    int hours = (int)_startTime / 3600;
    
    NSLog(@"hours:%02d:%02d:%02d",hours, minutes, seconds);
    
    int endseconds = (int)_stopTime % 60;
    int endminutes = (int)(_stopTime / 60) % 60;
    int endhours = (int)_stopTime / 3600;
    
    NSLog(@"Start hours:%02d:%02d:%02d",hours, minutes, seconds);
    
    NSLog(@"End hours:%02d:%02d:%02d",endhours, endminutes, endseconds);
    
    NSString *startTimeStr=[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
    NSString *endTimeStr=[NSString stringWithFormat:@"%02d:%02d:%02d",endhours, endminutes, endseconds];
    
    NSLog(@"Player URL:%@",playerURL);
    @try
    {
        NSDictionary *parameters =@{@"Video_path":playerURL,@"start_time":startTimeStr,@"end_time":endTimeStr,@"lang":@"iOS"};
        
        NSString *URLString = @"https://www.hypdra.com/api/api.php?rquest=video_overlay_crop";
        
        NSError *error;      // Initialize NSError
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];  // Convert your parameter to NSDATA
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];  // Convert data into string using NSUTF8StringEncoding
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]     initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];  // make NSMutableURL req
        
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue]; // add paramerets to NSMutableURLRequest
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
          {
              
              if (!error)
              {
                  NSLog(@"The res is %@",responseObject);
                  
                  //NSArray *MusicArray = [responseObject objectForKey:@"view_particular_video_path"];
                  
                  if([[responseObject objectForKey:@"status"] isEqualToString:@"Success"])
                  {
                      [[SJVideoPlayer sharedPlayer] stop];
                      
                      trimVideoPath=[responseObject objectForKey:@"video_overlay_crop"];
                      playerURL=trimVideoPath;
                      self.dontBtn.enabled = true;
                      
                      self.dontBtn.tintColor = [UIColor whiteColor];
                      
                      [[SJVideoPlayer sharedPlayer] playWithURL:[NSURL URLWithString:playerURL] jumpedToTime:0];
                      
                      [self loadSlider];
                      
                      [hud hideAnimated:YES];
                  }
                  else
                  {
                      //                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Try Again" message:@"Couldn't crop a video" preferredStyle:UIAlertControllerStyleAlert];
                      //
                      //                      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                      //                    [alertController addAction:ok];
                      //
                      //                    [self presentViewController:alertController animated:YES completion:nil];
                      
                      CustomPopUp *popUp = [CustomPopUp new];
                      [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't crop a video" withTitle:@"Try Again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                      popUp.okay.backgroundColor = [UIColor navyBlue];
                      popUp.agreeBtn.hidden = YES;
                      popUp.cancelBtn.hidden = YES;
                      popUp.inputTextField.hidden = YES;
                      [popUp show];
                      [hud hideAnimated:YES];
                      
                  }
              }
              else
              {
                  //                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Try Again" message:@"Couldn't connect to server " preferredStyle:UIAlertControllerStyleAlert];
                  //
                  //                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                  //                 [alertController addAction:ok];
                  //
                  //                 [self presentViewController:alertController animated:YES completion:nil];
                  //                [hud hideAnimated:YES];
                  
                  CustomPopUp *popUp = [CustomPopUp new];
                  [popUp initAlertwithParent:self withDelegate:self withMsg:@"Couldn't connect to server" withTitle:@"Try again" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                  popUp.okay.backgroundColor = [UIColor navyBlue];
                  popUp.agreeBtn.hidden = YES;
                  popUp.cancelBtn.hidden = YES;
                  popUp.inputTextField.hidden = YES;
                  [popUp show];
                  
              }
              
              
          }]resume];
        
    }
    @catch(NSException *exp)
    {
        NSLog(@"Trim Exp:%@",exp);
        [hud hideAnimated:YES];
    }
    
    
}


- (UIImage*)rotateAtPosition:(CGFloat)radians arg:(UIImage*)imgView
{
    CIImage *imgToRotate = [CIImage imageWithCGImage:imgView.CGImage];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians);
    
    CIImage *rotatedImage = [imgToRotate imageByApplyingTransform:transform];
    
    CGRect extent = [rotatedImage extent];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    UIImage *finalImage = [UIImage imageWithCGImage:[context createCGImage:rotatedImage fromRect:extent]];
    
    //    self.imgView.image = finalImage;
    
    return finalImage;
}


- (IBAction)DoneAction:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setObject:trimVideoPath forKey:@"videoPathValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
    vc.viewHiding=@"second";
    // vc.isFromTrimVC=@"yes";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)commentfun:(id)sender
{
    [self getName];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    lastHighestCount = HigestImageCount;
    
    HigestImageCount++;
    
    NSLog(@"tmpVideoPath2:%@",self.tmpVideoPath);
    
    NSURL *videoURL=[NSURL fileURLWithPath:self.tmpVideoPath];
    NSLog(@"done videourl:%@",videoURL);
    
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    
    if (rotation == 1)
    {
        thumbnail = [self rotateAtPosition:-1.5708 arg:thumbnail];
    }
    if (rotation == 2)
    {
        thumbnail = [self rotateAtPosition:-3.14159 arg:thumbnail];
    }
    if (rotation == 3)
    {
        thumbnail = [self rotateAtPosition:-4.71239 arg:thumbnail];
    }
    if (rotation == -1)
    {
        thumbnail = [self rotateAtPosition:1.5708 arg:thumbnail];
    }
    if (rotation == -2)
    {
        thumbnail = [self rotateAtPosition:3.14159 arg:thumbnail];
    }
    if (rotation == -3)
    {
        thumbnail = [self rotateAtPosition:4.71239 arg:thumbnail];
    }
    
    if (flip == 1)
    {
        UIImage *sourceImage = thumbnail;
        
        CIImage *coreImage = [CIImage imageWithCGImage:sourceImage.CGImage];
        
        UIImage *imgMirror = [UIImage imageWithCIImage:coreImage scale:sourceImage.scale orientation:UIImageOrientationUpMirrored];
        
        CGRect rect = CGRectMake(0, 0, thumbnail.size.width, thumbnail.size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        [imgMirror drawInRect:rect];
        
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    if (flop == 1)
    {
        UIImage *sourceImage = thumbnail;
        
        CGRect rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
        
        UIGraphicsBeginImageContext(sourceImage.size);
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, sourceImage.CGImage);
        
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    
    
    CGSize newSize=CGSizeMake(400,400); // I am giving resolution 50*50 , you can change your need
    UIGraphicsBeginImageContext(newSize);
    [thumbnail drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    thumbnail = newImage;
    
    NSData *thumbnailData = UIImagePNGRepresentation(thumbnail);
    NSLog(@"thumbnaildata:%lu",(unsigned long)thumbnailData.length);
    
    NSData *VideoData = [NSData dataWithContentsOfURL:videoURL];
    NSLog(@"videoData:%lu",(unsigned long)VideoData.length);
    NSError *error;
    
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString  *withString =[NSString stringWithFormat:@"/%d",HigestImageCount];
    
    withString = [withString stringByAppendingString:@".png"];
    
    NSString *Path = [dataPath stringByAppendingFormat:@"%@",withString];
    
    NSLog(@"CommonFilePath:%@",Path);
    
    [thumbnailData writeToFile:Path atomically:YES];
    
    NSString *SharedFinalplistPath = [dataPath stringByAppendingPathComponent:@"DataList.plist"];
    
    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    
    if (finalArray == nil)
    {
        finalArray = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"Video" forKey:@"DataType"];
    [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"Id"];
    
    [finalArray addObject:dic];
    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    //    NSLog(@"VideoData:%@",VideoData);
    
    NSLog(@"Current Video ID = %@",self.currentVideoID);
    
    NSLog(@"Current Rotation = %d",rotation);
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading...", @"HUD loading title");
    
    [fullImage addObject:VideoData];
    [thumbImage addObject:thumbnailData];
    
    imageID = [NSString stringWithFormat:@"%d",HigestImageCount];
    
    [self completeSendImage];
    
    
}

-(void)completeSendImage
{
    
    NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         
                                         for (int i = 0; i<fullImage.count; i++)
                                         {
                                             
                                             [formData appendPartWithFileData:fullImage[i] name:@"upload_files[]" fileName:@"uploads.mp4" mimeType:@"video/mp4"];
                                             
                                             [formData appendPartWithFileData:thumbImage[i] name:@"thumb_img[]" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                         }
                                         
                                         [formData appendPartWithFormData:[imageID dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
                                         
                                         [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
                                         
                                         [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"size"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"created_date"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"video_duration"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"orientation"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"flip_value"];
                                         
                                         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"flop_value"];
                                         
                                     } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:requests
                  progress:^(NSProgress * _Nonnull uploadProgress)
                  {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(),
                                     ^{
                                         //Update the progress view
                                         //                          [progressView setProgress:uploadProgress.fractionCompleted];
                                         
                                         [MBProgressHUD HUDForView:self.navigationController.view].progress = uploadProgress.fractionCompleted;
                                         
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          
                          NSLog(@"Error For Image: %@", error);
                          
                          [hud hideAnimated:YES];
                          
                          //  [_BlurView removeFromSuperview];
                          
                          //                          UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Upload failed"
                          //                                                                                        message:@"Your upload could not be completed.\nTry again ?"
                          //                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                          //
                          //                          UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                          //                                                                              style:UIAlertActionStyleDefault
                          //                                                                            handler:nil];
                          //
                          //                          [alert addAction:yesButton];
                          //
                          //                          [self presentViewController:alert animated:YES completion:nil];
                          
                          CustomPopUp *popUp = [CustomPopUp new];
                          [popUp initAlertwithParent:self withDelegate:self withMsg:@"Your upload could not be completed.\nTry again ?" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                          popUp.okay.backgroundColor = [UIColor navyBlue];
                          popUp.agreeBtn.hidden = YES;
                          popUp.cancelBtn.hidden = YES;
                          popUp.inputTextField.hidden = YES;
                          [popUp show];
                          
                          [self rollback];
                          
                      }
                      else
                      {
                          
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"Response For Image:%@",responsseObject);
                          
                          [hud hideAnimated:YES];
                          
                          // [_BlurView removeFromSuperview];
                          
                          if (responseObject == NULL)
                          {
                              [self rollback];
                          }
                          else
                          {
                              
                              NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                              
                              NSString *minAvil=[responsseObject objectForKey:@"Duration Status"];
                              
                              NSString *spcAvil = [responsseObject objectForKey:@"Space Status"];
                              
                              [defaults setValue:minAvil forKey:@"minAvil"];
                              
                              [defaults setValue:spcAvil forKey:@"spcAvil"];
                              
                              [defaults synchronize];
                              
                              //                              UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Video Uploaded"
                              //                                                                                            message:@"Success"
                              //                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                              //
                              //                              UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                              //                                                                                  style:UIAlertActionStyleDefault
                              //                                                                                handler:nil];
                              //                              {
                              //                                  [self EditedLocalValue];
                              //
                              //                                  UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
                              //
                              //                                  VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
                              //
                              //                                  [self.navigationController pushViewController:vc animated:YES];
                              //                              }
                              //
                              //                              [alert addAction:yesButton];
                              //
                              //                              [self presentViewController:alert animated:YES completion:nil];
                              
                              CustomPopUp *popUp = [CustomPopUp new];
                              [popUp initAlertwithParent:self withDelegate:self withMsg:@"Video Uploaded" withTitle:@"Success" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
                              popUp.okay.backgroundColor = [UIColor lightGreen];
                              popUp.accessibilityHint =@"VideoUploaded";
                              
                              popUp.agreeBtn.hidden = YES;
                              popUp.cancelBtn.hidden = YES;
                              popUp.inputTextField.hidden = YES;
                              [popUp show];
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
    
    
}



-(void)rollback
{
    
    NSLog(@"Enter rollback = %d",(HigestImageCount - lastHighestCount));
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    NSString *myPath1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    for (int i = 1; i<=(HigestImageCount - lastHighestCount); i++)
    {
        myPath = [myPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",(lastHighestCount+i)]];
        
        [fileManager removeItemAtPath:myPath error:&error];
    }
    
    NSLog(@"mypath:%@",myPath);
    
    NSString *SharedFinalplistPath = [myPath1 stringByAppendingPathComponent:@"DataList.plist"];
    
    NSLog(@"SharedFinalplistPath%@",SharedFinalplistPath);
    
    NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    
    NSMutableArray *samePlist = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    
    if (plist == nil)
    {
        plist = [[NSMutableArray alloc]init];
    }
    
    if (samePlist == nil)
    {
        samePlist = [[NSMutableArray alloc]init];
    }
    
    NSLog(@"plist:%@",plist);
    
    int i = 1;
    
    for(NSDictionary *dic in plist)
    {
        NSString *str = [NSString stringWithFormat:@"%d",(lastHighestCount+i)];
        
        if( [[dic valueForKey:@"Id"] isEqualToString:str])
        {
            [samePlist removeObject:dic];
            NSLog(@"Rollback Succeed");
            i++;
        }
    }
    
    [samePlist writeToFile:SharedFinalplistPath atomically:YES];
    
    //    [self getName];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



- (IBAction)backAction:(id)sender
{
    [self EditedLocalValue];
    
    
    
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    // [self.navigationController popViewControllerAnimated:YES];
}


-(void)getName
{
    NSLog(@"tmpVideoPath1:%@",self.tmpVideoPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    HigestImageCount = 0;
    
    // imageName = [[NSMutableArray alloc]init];
    
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:myPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *SharedFinalplistPath = [myPath stringByAppendingPathComponent:@"DataList.plist"];
    NSLog(@"SharedFinalplistPath%@",SharedFinalplistPath);
    
    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    
    if (finalArray == nil)
    {
        finalArray = [[NSMutableArray alloc]init];
    }
    
    int temInt;
    NSMutableArray *tempOnlyImages = [[NSMutableArray alloc]init];
    NSLog(@"FinalArray %@",finalArray);
    
    for(NSMutableDictionary *dic in finalArray)
    {
        if([[dic valueForKey:@"DataType"] isEqualToString:@"Video"])
        {
            [tempOnlyImages addObject:dic];
        }
        NSString *id = [dic valueForKey:@"Id"];
        temInt = id.intValue;
        if(temInt > HigestImageCount)
        {
            HigestImageCount =temInt;
        }
        NSLog(@"VideoOnlyImagesgetName %d",tempOnlyImages.count);
    }
    OnlyImages = tempOnlyImages;
}

-(BOOL)setImageParams:(NSData *)imgData imageID:(NSString *)imageId thumbnailData:(NSData *)thumbnailData
{
    @try
    {
        if (imgData!=nil)
        {
            NSLog(@"image not equal to nil");
            
            request = [NSMutableURLRequest new];
            request.timeoutInterval = 20.0;
            [request setURL:[NSURL URLWithString:URL]];
            [request setHTTPMethod:@"POST"];
            //[request setCachePolicy:NSURLCacheStorageNotAllowed];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            
            
            [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload_files\"; filename=\"%@.mp4\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //           NSLog(@"Image send to  server = %@",imgData);
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[imageId dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"thumb_img\"; filename=\"%@.jpg\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:thumbnailData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"orientation\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%d",rotation] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"flip_value\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%d",flip] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"flop_value\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%d",flop] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"After Values");
            [request setHTTPBody:body];
            NSLog(@"From Body");
            [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
            NSLog(@"After Content length");
            
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Send Image Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Send Image Finally...");
    }
}

-(void)EditedLocalValue
{
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

- (IBAction)clockWise:(id)sender
{
    if (rotation == 4)
    {
        rotation = 0;
    }
    else
    {
        rotation = rotation + 1;
        if(rotationAngle == 360)
            rotationAngle = 90;
        else rotationAngle = rotationAngle + 90;
        
        NSLog(@"Clockwise");
        
        [self rotateWithAngle];
        //        [self rotateAtPosition:kRotateRight];
        
    }
}

- (IBAction)anticlockWise:(id)sender
{
    if (rotation == 1)
    {
        rotation = 5;
    }
    else
    {
        rotation = rotation - 1;
        if(rotationAngle == 90)
        {
            rotationAngle = 450;
        }
        else
        {
            rotationAngle = rotationAngle - 90;
        }
        NSLog(@"Clockwise %f",rotationAngle);
        
        [self rotateWithAngle];
        
        //     [self rotateAtPosition:kRotateLeft];
        
    }
}

- (IBAction)horizontalAction:(id)sender
{
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
        
        tempLayerView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        
        flipFlag = TRUE;
        flip = 1;
        
    }
    else
    {
        NSLog(@"Hrizontal else");
        
        
        tempLayerView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
        
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
        flip = 2;
        
    }
    
    tempLayerView.frame = tempLayerView.superview.bounds;
    
}

- (IBAction)verticalAction:(id)sender
{
    
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
        flop = 1;
        
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
        flop = 2;
        
    }
    tempLayerView.frame = tempLayerView.superview.bounds;
}

-(void)loadVideoPlayer
{
    _SJplayer = [SJVideoPlayer sharedPlayer];
    [_SJplayer.presentView addSubview:_SJplayer.control.view];
    _SJplayer.control.isCircularView=NO;

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
         
     }];
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"VideoUploaded"]){
        
        [self EditedLocalValue];
        
        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
        
        VideoEditorViewController *vc=[mainStoryBoard instantiateViewControllerWithIdentifier:@"VideoEditor"];
        
        [self.navigationController pushViewController:vc animated:YES];
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

