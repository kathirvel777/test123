//
//  AnnotateViewController.m
//  Montage
//
//  Created by MacBookPro on 4/29/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AnnotateViewController.h"
#import "MBProgressHUD.h"
#import "AnnotationCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <ImageIO/ImageIO.h>
#import "AFNetworking.h"

@interface AnnotateViewController ()<UIGestureRecognizerDelegate,MarkerSPUserResizableViewDelegate>
{
    
    BOOL fillCircle,roundMap,fillMap,redMap,pinRed,pinBlue,pinGreen,thickCircle,thinCircle;
    
    UITapGestureRecognizer *tapValue;
    CGPoint textViewTapPoint;
    
    int HigestImageCount,lastHighestCount;
    
    NSMutableArray *imageName,*sendImage,*finalArray,*OnlyImages,*fullImage,*thumbImage;
    
    NSString *user_id,*imageID;
    
    NSMutableURLRequest *request;

    //    int HigestImageCount;
    
    NSString *imgName,*deleteName;
    
    MBProgressHUD *hud;

    NSArray *annoIcon;
    
    int annoValue,resizable_view_tag,lasttag,current_tag,prev_tag;
    
//    UITapGestureRecognizer *tapValue;
        
//  #define URL @"http://108.175.2.116/montage/api/api.php?rquest=image_upload"
    
    #define URL @"https://www.hypdra.com/api/api.php?rquest=image_upload"
    
}

@end

@implementation AnnotateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    resizable_view_tag = 0;
    
    current_tag = prev_tag = -1;
    
    tapValue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPosition:)];
    
    [tapValue setNumberOfTapsRequired:2];
    tapValue.delegate=self;
    
    [self.mainView addGestureRecognizer:tapValue];
    
//    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"Resource" withExtension:@"bundle"];
//    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
//    NSString *imagePath = [bundle pathForResource:@"260-icon-1.png" ofType:nil];
    
//    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:NULL];

    
//    NSLog(@"Files = %@",files);
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"260-icon-1" ofType:@"png"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//
//    NSLog(@"ImagePath Resource = %@",url);
    
    annoIcon = @[@"260-icon-1.png",@"260-icon-2.png",@"260-icon-3.png",@"260-icon-4.png",@"260-icon-5.png",@"260-icon-6.png",@"260-icon-7.png",@"260-icon-8.png",@"260-icon-9.png",@"260-icon-10.png",@"260-icon-11.png",@"260-icon-12.png",@"260-icon-13.png",@"260-icon-14.png",@"260-icon-15.png",@"260-icon-16.png",@"260-icon-17.png",@"260-icon-18.png",@"260-icon-19.png",@"260-icon-20.png",@"260-icon-21.png"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //    self.CollectionView.pagingEnabled = YES;
    
    //    [flowLayout setMinimumInteritemSpacing:.0f];

    [flowLayout setMinimumLineSpacing:0.0f];
    
    [self.CollectionView setCollectionViewLayout:flowLayout];
    
    //    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    // Do any additional setup after loading the view.
    
    //    self.CollectionView.bounces = false;
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AnnotateImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    
    self.imgView.image = image;
    
    [self getName];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
}

- (IBAction)fillCircle:(id)sender
{
    fillCircle = true;
    roundMap = fillMap = redMap = pinRed = pinBlue = pinGreen = thickCircle = thinCircle = false;
}

- (IBAction)roundMap:(id)sender
{
    roundMap = true;
    fillCircle = fillMap = redMap = pinRed = pinBlue = pinGreen = thickCircle = thinCircle = false;
}

- (IBAction)fillMap:(id)sender
{
    fillMap = true;
    fillCircle = roundMap = redMap = pinRed = pinBlue = pinGreen = thickCircle = thinCircle = false;
}


- (IBAction)redMap:(id)sender
{
    redMap = true;
    fillCircle = roundMap = fillMap = pinRed = pinBlue = pinGreen = thickCircle = thinCircle = false;
}

- (IBAction)pinRed:(id)sender
{
    pinRed = true;
    fillCircle = roundMap = fillMap = redMap = pinBlue = pinGreen = thickCircle = thinCircle = false;
}


- (IBAction)pinBlue:(id)sender
{
    pinBlue = true;
    fillCircle = roundMap = fillMap = redMap = pinRed = pinGreen = thickCircle = thinCircle = false;
}


- (IBAction)pinGreen:(id)sender
{
    pinGreen = true;
    fillCircle = roundMap = fillMap = redMap = pinRed = pinBlue = thickCircle = thinCircle = false;
}

- (IBAction)thickCircle:(id)sender
{
    thickCircle = true;
    fillCircle = roundMap = fillMap = redMap = pinRed = pinBlue = pinGreen = thinCircle = false;
}


- (IBAction)thinCircle:(id)sender
{
    thinCircle = true;
    fillCircle = roundMap = fillMap = redMap = pinRed = pinBlue = pinGreen = thickCircle = false;
}


-(void)tapPosition:(UITapGestureRecognizer *)recognizer
{
    textViewTapPoint = [recognizer locationInView:self.mainView];
    resizable_view_tag++;

    [self tapPositonFun:&(textViewTapPoint)];
}


- (IBAction)Done:(id)sender
{
    
    [self saveAnnotations];
    
//    CGRect rect = [[UIScreen mainScreen] bounds];
    
    NSLog(@"Begin Snapshot");
    
    CGRect rect = [self.imgView bounds];

//    UIGraphicsBeginImageContext(rect.size);
    
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    CGFloat screenScale = [[UIScreen mainScreen] scale];
//    
//    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
  
//   UIGraphicsBeginImageContext(rect.size);
    
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,2.0);

//    UIGraphicsBeginImageContextWithOptions(self.topView.bounds.size, self.imgView.opaque, 2.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.imgView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  
    UIGraphicsEndImageContext();
    
    [self sendImage:image];
    
//    UIGraphicsBeginImageContextWithOptions(self.imgView.image.size, NO, [UIScreen mainScreen].scale);

/*    UIGraphicsBeginImageContext(self.imgView.frame.size);

    [self.imgView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();*/
    
//    [self sendImage:image];
    
}

- (UIImage*)captureView:(UIView *)yourView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [yourView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)saveAnnotations
{
    NSString *jsonString;
    NSMutableArray *AnnotationArray = [[NSMutableArray alloc]init];
    
    for (int i=1;i<=resizable_view_tag;i++)
    {
        MarkerSPView *resize=(MarkerSPView *)[_mainView viewWithTag:i];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        [dic setValue:resize.accessibilityValue forKey:@"Point"];
        [dic setValue:resize.accessibilityHint forKey:@"AnnoValue"];

        [AnnotationArray addObject:dic];
    }
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:AnnotationArray
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    } else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
           }
    int dicIndex = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"DicIndexInArray"];
    NSDictionary *dic = [finalArray objectAtIndex:dicIndex];
    [dic setValue:jsonString forKey:@"AnnotationJsonString"];
    [finalArray replaceObjectAtIndex:dicIndex withObject:dic];
    
   
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImagesAndVideos"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:myPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *SharedFinalplistPath = [myPath stringByAppendingPathComponent:@"DataList.plist"];
    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    NSLog(@"LastFinalArray %@",finalArray);

    NSLog(@"SharedFinalplistPath%@",SharedFinalplistPath);
}


-(void)getName
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    HigestImageCount = 0;
    imageName = [[NSMutableArray alloc]init];
    
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
    for(NSMutableDictionary *dic in finalArray)
    {
        NSLog(@"FinalArray %@",finalArray);
        if([[dic valueForKey:@"DataType"] isEqualToString:@"Image"])
        {
            [tempOnlyImages addObject:dic];
        }
        NSString *id = [dic valueForKey:@"Id"];
        temInt = id.intValue;
        if(temInt > HigestImageCount)
        {
            HigestImageCount =temInt;
        }
        NSLog(@"HigestCount %d",HigestImageCount);
    }
    OnlyImages = tempOnlyImages;
    
}

-(NSData *)generateThumnail:(UIImage *)image thumbnailData:(NSData *)data
{
    NSData *thumbnailData;
    
    if(image.size.width || image.size.height)
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                               (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                               (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                               (id) kCGImageSourceThumbnailMaxPixelSize : @(400)
                                                               };
        
        CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
        if (NULL != imageSource)
            CFRelease(imageSource);
        
        UIImage* scaledImage = [UIImage imageWithCGImage:thumbnail];
        CGSize newSize =   CGSizeMake((scaledImage.size.width), (scaledImage.size.height));
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        thumbnailData = UIImagePNGRepresentation(image);
        UIGraphicsEndImageContext();
        
    }
    
    return thumbnailData;
    
}



-(void)sendImage:(UIImage*)getData
{
    
    [self getName];

    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    lastHighestCount = HigestImageCount;
    
    HigestImageCount++;
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading...", @"HUD loading title");
    
    
    NSData *data = UIImagePNGRepresentation(getData);
    
    UIImage *chosenImage = [UIImage imageWithData:data];

    NSData *thumbnailData = [self generateThumnail:chosenImage thumbnailData:data];

    
    [fullImage addObject:data];
    [thumbImage addObject:thumbnailData];

    
    
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
    
    [data writeToFile:Path atomically:YES];
    
    NSString *SharedFinalplistPath = [dataPath stringByAppendingPathComponent:@"DataList.plist"];
    
    
    finalArray = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    if (finalArray == nil)
    {
        finalArray = [[NSMutableArray alloc]init];
    }
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:@"Image" forKey:@"DataType"];
    [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"Id"];
    
    [finalArray addObject:dic];
    NSLog(@"PlistPath:%@",SharedFinalplistPath);
    [finalArray writeToFile:SharedFinalplistPath atomically:YES];
    
    NSString *tempString = [NSString stringWithFormat:@"%d",HigestImageCount];
    
    tempString = [tempString stringByAppendingString:@".png"];
    
    
    [sendImage addObject:tempString];
    
    
    imageID = [NSString stringWithFormat:@"%d",HigestImageCount];
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading...", @"HUD loading title");
    
    
    [self completeSendImage];

    
/*    if( [self setImageParams:data imageID:[NSString stringWithFormat:@"%d",HigestImageCount]])
    {
        NSLog(@"Enter block");
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
         {
             NSLog(@"Response = %@",urlResponse);
             
             [hud hideAnimated:YES];
             
             [self.navigationController popViewControllerAnimated:YES];


         }];
        
        NSLog(@"Image Sent");
    }
    else
    {
        NSLog(@"Image Failed...");
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [hud hideAnimated:YES];
    }*/
    
}




-(void)completeSendImage
{
    
    
    NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         
                                         for (int i = 0; i<fullImage.count; i++)
                                         {
                                             
                                             [formData appendPartWithFileData:fullImage[i] name:@"upload_files[]" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                             
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
                                         
                                         
                                         [MBProgressHUD HUDForView:self.navigationController.view].progress = uploadProgress.fractionCompleted;
                                         
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Error For Image: %@", error);
                          
                          [hud hideAnimated:YES];
                          
                          
                          UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Upload failed"
                                                                                        message:@"Your upload could not be completed.\nTry again ?"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                              style:UIAlertActionStyleDefault
                                                                            handler:nil];
                          
                          [alert addAction:yesButton];
                          
                          [self presentViewController:alert animated:YES completion:nil];
                          
                          [self rollback];
                          
                      }
                      else
                      {
                          
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"Response For Image:%@",responsseObject);
                          
                          [hud hideAnimated:YES];
                          
                          
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
                              
                              
                              UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Image Uploaded"
                                                                                            message:@"Success"
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                              
                              UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                                  style:UIAlertActionStyleDefault
                                                                                handler:^(UIAlertAction * action)
                                                                                {
                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                }];
                                                      
                              
                              [alert addAction:yesButton];
                              
                              [self presentViewController:alert animated:YES completion:nil];
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
  
    [self.navigationController popViewControllerAnimated:YES];

//    [self getName];
    
}



-(BOOL)setImageParams:(NSData *)imgData imageID:(NSString *)imageId
{
    @try
    {
        if (imgData!=nil)
        {
            
            NSLog(@"Enter Image send");
            
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
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload_files\"; filename=\"%@.jpg\"\r\n", @"uploads"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[user_id dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[imageId dataUsingEncoding:NSUTF8StringEncoding]];
            
            
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //   CGFloat picDimension = self.view.frame.size.width / 3.4f;
    
    CGFloat picDimension;// = self.iconView.frame.size.width / 6.0f;

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        picDimension = self.iconView.frame.size.width / 8.0f;
    }
    else
    {
        picDimension = self.iconView.frame.size.width / 6.0f;
    }
    return CGSizeMake(picDimension,self.iconView.frame.size.width);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    NSLog(@"didselect = %ld",(long)indexPath.row);
//    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 21;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"VideoIndex = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    AnnotationCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //    cell.labelText.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    //        [button setTitle:[NSString stringWithFormat:@"Button %d", i] forState:UIControlStateNormal];


    
//    [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", [[NSBundle mainBundle] resourcePath], imgName]];
    
    cell.selectedLine.hidden=YES;

    NSString *str = [NSString stringWithFormat:@"%@",annoIcon[indexPath.row]];

//    NSURL *imageURL = [NSURL fileURLWithPath:str];
//    
//    [cell.annotateBtn sd_setBackgroundImageWithURL:imageURL forState:UIControlStateNormal];
    
    // sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"IMAGE_URL_HERE"]]] forState:UIControlStateNormal];

    
    
    cell.annotateBtn.tag = indexPath.row;
    [cell.annotateBtn addTarget:self action:@selector(anno_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img = [UIImage imageNamed:str];
    
    [[cell.annotateBtn imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [cell.annotateBtn setImage:img forState:UIControlStateNormal];
    
    
    
    // [cell.annotateBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    return cell;
    
}

-(void)anno_btn:(UIButton*)sender
{
    annoValue = sender.tag;
    
    
    if (current_tag == -1 && prev_tag == -1)
    {
        current_tag = prev_tag = annoValue;
        
        NSIndexPath *myIP=[NSIndexPath indexPathForRow:current_tag inSection:0];
        
        AnnotationCollectionViewCell *cell=(AnnotationCollectionViewCell*)[self.CollectionView cellForItemAtIndexPath:myIP];
        cell.selectedLine.hidden=false;
    }
    else
    {
        
        current_tag = annoValue;
        
        NSIndexPath *myIP=[NSIndexPath indexPathForRow:current_tag inSection:0];
        
        AnnotationCollectionViewCell *cell=(AnnotationCollectionViewCell*)[self.CollectionView cellForItemAtIndexPath:myIP];
        cell.selectedLine.hidden=false;

        
        myIP=[NSIndexPath indexPathForRow:prev_tag inSection:0];
        
        cell=(AnnotationCollectionViewCell*)[self.CollectionView cellForItemAtIndexPath:myIP];
        cell.selectedLine.hidden=true;
        
        prev_tag = current_tag;
        
    }
    
    
    
/*    int a;
    
    if(a != 0)
    {
        NSLog(@"myIP!=nil");
        
        NSIndexPath *myIP=[NSIndexPath indexPathForRow:lasttag inSection:0];
        
        AnnotationCollectionViewCell *cell=(AnnotationCollectionViewCell*)[self.CollectionView cellForItemAtIndexPath:myIP];
        cell.selectedLine.hidden=YES;
        
        NSIndexPath *myIP1=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        AnnotationCollectionViewCell *cell1=(AnnotationCollectionViewCell*)[self.CollectionView cellForItemAtIndexPath:myIP1];
        cell1.selectedLine.hidden=NO;
        
       NSString *lasttag= annoValue ;
        
        // [self.CollectionView deselectItemAtIndexPath:myIP animated:YES];
    }
    else
    {
        
        NSIndexPath *myIP1=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        AnnotationCollectionViewCell *cell1=(AnnotationCollectionViewCell*)[self.CollectionView cellForItemAtIndexPath:myIP1];
        cell1.selectedLine.hidden=NO;
        lasttag=sender.tag;
        
    }*/
    
    
    
    
    //    NSLog(@"Selected = %d",annoValue);
}


-(void)tapPositonFun:(CGPoint *)point
{
    
    NSString *getAnnoValue = annoIcon[annoValue];
    
        @try
        {
            CGRect imageFrame = CGRectMake(textViewTapPoint.x,textViewTapPoint.y , 100, 100);
            
            MarkerSPView *imageResizableView = [[MarkerSPView alloc] initWithFrame:imageFrame];
            
            imageResizableView.accessibilityHint = [NSString stringWithFormat:@"%d",annoValue];
            imageResizableView.accessibilityValue =NSStringFromCGPoint(*point);
            
            
            UIImageView *imageView;
            
            NSLog(@"CGPoint %@",imageResizableView.accessibilityValue);
            NSLog(@"AnnoValue %@",imageResizableView.accessibilityHint);
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:getAnnoValue]];
            
//            imageResizableView.textView.text = @" Reject";
//            
//            [imageResizableView.textView sizeToFit];
            
            imageResizableView.contentView = imageView;
            imageResizableView.delegate = self;
            imageResizableView.tag = resizable_view_tag;
            [imageResizableView showEditingHandles];
            
            _lastEditedView = _currentlyEditingView;
            _currentlyEditingView = imageResizableView;
            [_currentlyEditingView showEditingHandles];
            [_currentlyEditingView.closeButton setHidden:NO];
            [_lastEditedView hideEditingHandles];
            [_lastEditedView.closeButton setHidden:YES];
            
            [self.mainView addSubview:imageResizableView];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"Reject Exception = %@",exception);
        }
        @finally
        {
            NSLog(@"Finally Reject..");
        }
}

@end
