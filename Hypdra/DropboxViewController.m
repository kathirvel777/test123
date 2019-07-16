//
//  DropboxViewController.m
//  DBRoulette
//
//  Created by MacBookPro on 6/8/17.
//  Copyright © 2017 Dropbox. All rights reserved.
//

#import "DropboxViewController.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "DropboxTableViewCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import <ImageIO/ImageIO.h>
#import "UIImageView+WebCache.h"
#import "SwipeBack.h"


@interface DropboxViewController ()
{
    NSMutableArray *dArray;
    
    NSMutableArray *imageName,*sendImage,*finalArray,*OnlyImages,*fullImage,*thumbImage;
    
    MBProgressHUD *hud;
    
    
    NSString *user_id,*imageID;
    NSMutableURLRequest *request;
    
    #define URL @"https://www.hypdra.com/api/api.php?rquest=image_upload"
    
    int HigestImageCount,lastHighestCount;
    
}

@end

@implementation DropboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled=NO;
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];

    dArray = [[NSMutableArray alloc]init];
    
    self.tableView.bounces = false;
    
    [self temp];
    
   // [self getName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    //[self temp];
}


-(void)temp
{
    DBUserClient *client = [DBClientsManager authorizedClient];
    
    NSString *searchPath = @"";
    
    // list folder metadata contents (folder will be root "/" Dropbox folder if app has permission
    // "Full Dropbox" or "/Apps/<APP_NAME>/" if app has permission "App Folder").
    
    [[client.filesRoutes listFolder:searchPath]
     setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error)
     {
         
         NSLog(@"Folders = %@",result);
         
         if (result)
         {
             hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
             [self displayPhotos:result.entries];
         }
         else
         {
             NSString *title = @"";
             NSString *message = @"";
             if (routeError)
             {
                 // Route-specific request error
                 title = @"Route-specific error";
                 if ([routeError isPath])
                 {
                     message = [NSString stringWithFormat:@"Invalid path: %@", routeError.path];
                 }
             }
             else
             {
                 title = @"Generic request error";
                 if ([error isInternalServerError])
                 {
                     DBRequestInternalServerError *internalServerError = [error asInternalServerError];
                     message = [NSString stringWithFormat:@"%@", internalServerError];
                 }
                 else if ([error isBadInputError])
                 {
                     DBRequestBadInputError *badInputError = [error asBadInputError];
                     message = [NSString stringWithFormat:@"%@", badInputError];
                 } else if ([error isAuthError]) {
                     DBRequestAuthError *authError = [error asAuthError];
                     message = [NSString stringWithFormat:@"%@", authError];
                 } else if ([error isRateLimitError]) {
                     DBRequestRateLimitError *rateLimitError = [error asRateLimitError];
                     message = [NSString stringWithFormat:@"%@", rateLimitError];
                 } else if ([error isHttpError]) {
                     DBRequestHttpError *genericHttpError = [error asHttpError];
                     message = [NSString stringWithFormat:@"%@", genericHttpError];
                 } else if ([error isClientError]) {
                     DBRequestClientError *genericLocalError = [error asClientError];
                     message = [NSString stringWithFormat:@"%@", genericLocalError];
                 }
             }
             
             UIAlertController *alertController =
             [UIAlertController alertControllerWithTitle:title
                                                 message:message
                                          preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
             [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                 style:(UIAlertActionStyle)UIAlertActionStyleCancel
                                                               handler:nil]];
             [self presentViewController:alertController animated:YES completion:nil];
             
         }
     }];
}

- (void)displayPhotos:(NSArray<DBFILESMetadata *> *)folderEntries
{
    NSMutableArray<NSString *> *imagePaths = [NSMutableArray new];
    for (DBFILESMetadata *entry in folderEntries)
    {
        NSString *itemName = entry.name;
        
        //.jpeg|\\.jpg|\\.JPEG|\\.JPG|\\.png"
        if([itemName containsString:@".jpeg"] || [itemName containsString:@".jpg"] || [itemName containsString:@".JPEG"] || [itemName containsString:@".JPG"] || [itemName containsString:@".png"])
        {
            if ([self isImageType:itemName])
            {
                [imagePaths addObject:entry.pathDisplay];
                
                [dArray addObject:entry.pathDisplay];
            }
        }
    }
    
   // [self.tableView reloadData];
    
    for (NSString *entry in imagePaths)
    {
        DBUserClient *client = [DBClientsManager authorizedClient];
        
        [[client.filesRoutes getThumbnailData:entry]
         setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSData *
                            fileData)
         {
             
             NSLog(@"Data = %@",result.pathDisplay);
             
             NSLog(@"Data = %lu",(unsigned long)fileData.length);
             
             NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
             
             NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
             NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:@"/dropBoxTemp"];
             
             NSError *errors;
             
             if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
                 [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&errors];
             
             NSString *dataPath = [documentsPathlist stringByAppendingFormat:@"%@",result.pathDisplay];
             
             NSLog(@"DataPath = %@",dataPath);
             
             BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
             if(success)
             {
                 NSLog(@"Already Present");
             }
             else
             {
                 [fileData writeToFile:dataPath atomically:YES];
//                 [self.tableView reloadData];

             }
             [self.tableView reloadData];
             [hud hideAnimated:YES];

         }];
    }
}

- (BOOL)isImageType:(NSString *)itemName
{
    NSRange range = [itemName rangeOfString:@"\\.jpeg|\\.jpg|\\.JPEG|\\.JPG|\\.png" options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

- (void)downloadImage:(NSString *)imagePath
{
    DBUserClient *client = [DBClientsManager authorizedClient];
    [[client.filesRoutes downloadData:imagePath]
     setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSData *fileData)
     {
         if (result)
         {
             if(fileData!=nil)
             {
                 if ([self.delegate respondsToSelector:@selector(didFinishedDropBoxImage:)])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [self.delegate didFinishedDropBoxImage:fileData];
                         [hud hideAnimated:YES];

                         [self.navigationController popViewControllerAnimated:YES];
                     });
                     
                 }
             }
             //[self downloadFileFromDropBox:fileData];
             
             /*             NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
              
              NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
              NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:@"/dropBoxTemp1"];
              
              NSError *errors;
              
              if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
              [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&errors];
              
              NSString *dataPath = [documentsPathlist stringByAppendingFormat:@"%@",result.pathDisplay];
              
              NSLog(@"Final DataPath = %@",dataPath);
              
              [fileData writeToFile:dataPath atomically:YES];*/
             
             
         }
         else
         {
             NSString *title = @"";
             NSString *message = @"";
             if (routeError) {
                 // Route-specific request error
                 title = @"Route-specific error";
                 if ([routeError isPath]) {
                     message = [NSString stringWithFormat:@"Invalid path: %@", routeError.path];
                 } else if ([routeError isOther]) {
                     message = [NSString stringWithFormat:@"Unknown error: %@", routeError];
                 }
             }
             else
             {
                 // Generic request error
                 title = @"Generic request error";
                 if ([error isInternalServerError]) {
                     DBRequestInternalServerError *internalServerError = [error asInternalServerError];
                     message = [NSString stringWithFormat:@"%@", internalServerError];
                 } else if ([error isBadInputError]) {
                     DBRequestBadInputError *badInputError = [error asBadInputError];
                     message = [NSString stringWithFormat:@"%@", badInputError];
                 } else if ([error isAuthError]) {
                     DBRequestAuthError *authError = [error asAuthError];
                     message = [NSString stringWithFormat:@"%@", authError];
                 } else if ([error isRateLimitError]) {
                     DBRequestRateLimitError *rateLimitError = [error asRateLimitError];
                     message = [NSString stringWithFormat:@"%@", rateLimitError];
                 } else if ([error isHttpError]) {
                     DBRequestHttpError *genericHttpError = [error asHttpError];
                     message = [NSString stringWithFormat:@"%@", genericHttpError];
                 } else if ([error isClientError]) {
                     DBRequestClientError *genericLocalError = [error asClientError];
                     message = [NSString stringWithFormat:@"%@", genericLocalError];
                 }
             }
             
             UIAlertController *alertController =
             [UIAlertController alertControllerWithTitle:title
                                                 message:message
                                          preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
             [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                 style:(UIAlertActionStyle)UIAlertActionStyleCancel
                                                               handler:nil]];
             [self presentViewController:alertController animated:YES completion:nil];
             
         }
     }];
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *CellIdentifier = @"Cell";
    
    static NSString *simpleTableIdentifier = @"DropboxTableViewCell";
    
    DropboxTableViewCell *cell = (DropboxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DropboxTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.imgView.layer.cornerRadius =cell.imgView.frame.size.width/2;//= 30;
    //cell.imgView.layer.masksToBounds = YES;
   
    cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    DocDir = [DocDir stringByAppendingString:@"/dropBoxTemp"];
    
    DocDir = [DocDir stringByAppendingPathComponent:[dArray objectAtIndex:indexPath.row]];
    
    //    NSLog(@"My Path = %@",DocDir);
    
    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
    
    UIImage *img=[[UIImage alloc] initWithData:pictureData];
    
//    NSURL *imageURL=[[NSURL alloc]initWithString:img];
//
//    [cell.imgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    cell.imgView.image = img;
    
    NSString *str = [dArray objectAtIndex:indexPath.row];
    
    NSString *newStr = [str substringFromIndex:1];
    
    cell.dropboxLabel.text= newStr;
    
    cell.dropboxDownload.tag = indexPath.row;
    
    [[cell.dropboxDownload imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
    [cell.dropboxDownload addTarget:self action:@selector(download_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)download_btn:(UIButton*)sender
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self downloadImage:[dArray objectAtIndex:sender.tag]];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logOut:(id)sender
{
    [DBClientsManager unlinkAndResetClients];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)downloadFileFromDropBox:(NSData *)filePath
{
    [self getName];
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Uploading...", @"HUD loading title");
    
    sendImage = [[NSMutableArray alloc]init];
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    lastHighestCount = HigestImageCount;
    
    HigestImageCount++;
    
    NSLog(@"Dropbox Count = %d",HigestImageCount);
    
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
    
    [filePath writeToFile:Path atomically:YES];
    
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
    
    
    UIImage *chosenImage = [UIImage imageWithData:filePath];
    
    NSData *thumbnailData = [self generateThumnail:chosenImage thumbnailData:filePath];
    
    [fullImage addObject:filePath];
    [thumbImage addObject:thumbnailData];

    
    imageID = [NSString stringWithFormat:@"%d",HigestImageCount];

    
    [self completeSendImage];
    
//    [self sendImage:filePath nd:filePath sd:[NSString stringWithFormat:@"%d",HigestImageCount]];
    
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
    
    [self getName];
    
    
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)sendImage:(NSData*)data nd:(NSData*)th sd:(NSString*)s
{
    
    NSLog(@"data = %d",data.length);
    
    
    //    UIImage *img = [UIImage imageNamed:@"text-xxl.png"];
    //
    //    NSData *dfs = UIImagePNGRepresentation(img);
    
    
    
    NSMutableURLRequest *requests = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                     {
                                         
                                         [formData appendPartWithFileData:data name:@"upload_files" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                         
                                         [formData appendPartWithFileData:th name:@"thumb_img" fileName:@"uploads.png" mimeType:@"image/jpeg"];
                                         
                                         [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
                                         
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
    
    //    requests.timeoutInterval= 20;
    
    //    [requests setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [requests setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
    //    [requests setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //    [requests setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
    //
    //    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
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
                                     });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                  {
                      if (error)
                      {
                          NSLog(@"Error For Image: %@", error);
                          
                          //                          [hud hideAnimated:YES];
                          //
                          //                          [_BlurView removeFromSuperview];
                          
                      }
                      else
                      {
                          //                          NSLog(@"iSuccess %@ %@", response, responseObject);
                          
                          
                          //                          NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                          //
                          //                          NSLog(@"Reponse String = %@",responseString);
                          
                          NSDictionary *responsseObject=[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          
                          NSLog(@"Response For Image:%@",responsseObject);
                          
                          
                          NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                          
                          
                          NSString *minAvil=[responsseObject objectForKey:@"Duration Status"];
                          
                          NSString *spcAvil = [responsseObject objectForKey:@"Space Status"];
                          
                          
                          [defaults setValue:minAvil forKey:@"minAvil"];
                          
                          [defaults setValue:spcAvil forKey:@"spcAvil"];
                          
                          
                          [defaults synchronize];
                          
                          
                          [self.navigationController popViewControllerAnimated:YES];
                          
                          
                          //                          [hud hideAnimated:YES];
                          //
                          //                          [_BlurView removeFromSuperview];
                          
                      }
                  }];
    
    [uploadTask resume];
    
    
    
    /*    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
     
     [manager POST:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
     [formData appendPartWithFileData:data
     name:@"upload_files"
     fileName:@"file.png" mimeType:@"image/jpeg"];
     
     //        [formData appendPartWithFormData:[key1 dataUsingEncoding:NSUTF8StringEncoding]
     //                                    name:@"key1"];
     //
     //        [formData appendPartWithFormData:[key2 dataUsingEncoding:NSUTF8StringEncoding]
     //                                    name:@"key2"];
     
     [formData appendPartWithFileData:th name:@"thumb_img" fileName:@"img.png" mimeType:@"image/jpeg"];
     
     //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application/03D6148D-BF6D-4B92-AC31-578B9971DE19/Documents/MyImagesAndVideos/3.png"] name:@"thumb_img" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
     
     [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding] name:@"image_id"];
     
     [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding] name:@"lang"];
     
     [formData appendPartWithFormData:[user_id dataUsingEncoding:NSUTF8StringEncoding] name:@"User_ID"];
     
     
     // etc.
     }
     progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
     NSLog(@"iResponse: %@", responseObject);
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
     NSLog(@"iError: %@", error);
     }];*/
    
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
        if( [[dic valueForKey:@"DataType"] isEqualToString:@"Image"])
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



@end
