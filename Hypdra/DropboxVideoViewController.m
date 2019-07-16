//
//  DropboxVideoViewController.m
//  Montage
//
//  Created by Srinivasan on 25/10/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "DropboxVideoViewController.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "DropboxVideoTableViewCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVFoundation.h>
#import "SwipeBack.h"

@interface DropboxVideoViewController ()
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

@implementation DropboxVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.swipeBackEnabled=NO;

    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];
    
    
    dArray = [[NSMutableArray alloc]init];
    
    self.tableView.bounces = false;
    [self temp];

    //[self getName];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
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
              message:message preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
             
             [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyle)UIAlertActionStyleCancel
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
        NSString *pathDisplay=entry.pathDisplay;
        NSLog(@"theee image path is %@",pathDisplay);
        
        if([itemName containsString:@".mp4"])
        {
            if ([self isVideoType:itemName])
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

             }
             [self.tableView reloadData];
             [hud hideAnimated:YES];

         }];
    }
}

- (BOOL)isVideoType:(NSString *)itemName
{
    NSRange range = [itemName rangeOfString:@"\\.mp4" options:NSRegularExpressionSearch];
    
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
             [self downloadFileFromDropBox:fileData fileName:imagePath];
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
    
    static NSString *simpleTableIdentifier = @"DropboxVideoTableViewCell";
    
    DropboxVideoTableViewCell *cell = (DropboxVideoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DropboxVideoTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.imgView.layer.cornerRadius =cell.imgView.frame.size.width/2;//= 30;
    
    cell.imgView.clipsToBounds = YES;
    
    cell.imgView.layer.borderWidth = 2.0f;
    
    cell.imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    DocDir = [DocDir stringByAppendingString:@"/dropBoxTemp"];
    
    DocDir = [DocDir stringByAppendingPathComponent:[dArray objectAtIndex:indexPath.row]];
    
    NSData* pictureData1=[[NSData alloc]initWithContentsOfFile:DocDir];
    
    UIImage *img1=[[UIImage alloc] initWithData:pictureData1];
    
    cell.imgView.image = img1;
    
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
    
    
    //    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *DocDir = [ScreensDir objectAtIndex:0];
    //    DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
    //    NSMutableDictionary *dic = [OnlyImages objectAtIndex:sender.tag];
    //    NSLog(@"OnlyVideos %@",OnlyImages);
    //    NSString *id1 = [dic valueForKey:@"Id"];
    //
    //    DocDir = [DocDir stringByAppendingPathComponent:[id1 stringByAppendingString:@".png"]];
    //
    //    NSURL *imageURL = [NSURL fileURLWithPath:DocDir];
    
    [self downloadImage:[dArray objectAtIndex:sender.tag]];
    
}

- (IBAction)logout:(id)sender
{
    [DBClientsManager unlinkAndResetClients];
   // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)Cancel:(id)sender
{
    
}

-(void)downloadFileFromDropBox:(NSData *)VideoData fileName:(NSString *)filename
{

    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    DocDir = [DocDir stringByAppendingString:@"/dropBoxTemp"];
    DocDir = [DocDir stringByAppendingPathComponent:filename];
    
    [VideoData writeToFile:DocDir atomically:YES];
    
    NSURL *videoURL = [NSURL fileURLWithPath:DocDir];
   
    if ([self.delegate respondsToSelector:@selector(didFinishedDropBoxVideo:)])
    {
        [self.delegate didFinishedDropBoxVideo:videoURL];
        [self.navigationController popViewControllerAnimated:YES];

        // [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (IBAction)backAction:(id)sender
{
   // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}
@end

