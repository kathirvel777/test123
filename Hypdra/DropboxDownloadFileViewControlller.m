//
//  DropboxDownloadFileViewControlller.m
//  DropboxIntegration
//
//  Created by TheAppGuruz-iOS-101 on 26/04/14.
//  Copyright (c) 2014 TheAppGuruz-iOS-101. All rights reserved.
//

#import "DropboxDownloadFileViewControlller.h"
#import "MBProgressHUD.h"
#import "DropboxCell.h"
#import "DropboxIntegrationViewController.h"

@interface DropboxDownloadFileViewControlller ()
{
    NSMutableArray *imageName,*sendImage,*finalArray,*OnlyImages;
    NSString *user_id;
    NSMutableURLRequest *request;
    int HigestImageCount;
    
    NSString *imgName;
    
    #define URL @"http://108.175.2.116/montage/api/api.php?rquest=image_upload"
}

@end

@implementation DropboxDownloadFileViewControlller

@synthesize tbDownload;
@synthesize loadData;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getName];

//    [[DBSession sharedSession] unlinkAll];

    if (!loadData)
    {
        loadData = @"";
    }
    
    marrDownloadData = [[NSMutableArray alloc] init];
    
    [self.restClient loadMetadata:@"/"];

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    //    [self updateImagesToServer];
}


#pragma mark - Dropbox Methods
- (DBRestClient *)restClient
{
	if (restClient == nil)
    {
		restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;
	}
    
    return restClient;
}

-(void)fetchAllDropboxData
{
    [self.restClient loadMetadata:loadData];
}

-(void)downloadFileFromDropBox:(NSString *)filePath
{
    
    sendImage = [[NSMutableArray alloc]init];
    
//    int count = HigestImageCount;

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
    
    
    
//    [data writeToFile:Path atomically:YES];
    
    
    NSLog(@"Self = %@",self.restClient);
    
    
    [self.restClient loadFile:filePath intoPath:Path];
    
    
    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:Path]];
    
    UIImage *img=[[UIImage alloc] initWithData:pictureData];
    
    NSData *data = UIImagePNGRepresentation(img);
    

    
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
    
    if( [self setImageParams:data imageID:[NSString stringWithFormat:@"%d",HigestImageCount]])
    {
        NSLog(@"Enter block");
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
         {
             NSLog(@"Response = %@",urlResponse);
         }];
        
        NSLog(@"Image Sent");
    }
    else
    {
        NSLog(@"Image Failed...");
    }


    
/*    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
 
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImages"]];
 
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
 
    NSString  *withString =[NSString stringWithFormat:@"/%d",count];
 
    withString = [withString stringByAppendingString:@".png"];
 
    dataPath = [dataPath stringByAppendingFormat:@"%@",withString];
    
    NSLog(@"FilePath:%@",dataPath);
    
 //   [data writeToFile:dataPath atomically:YES];
    
    [self.restClient loadFile:filePath intoPath:dataPath];
 
    NSString *tempString = [NSString stringWithFormat:@"%d",count];
    
    tempString = [tempString stringByAppendingString:@".png"];
    
    [sendImage addObject:tempString];

    
    [self getName];

    [self updateImagesToServer];*/
    
}

- (void)restClient:(DBRestClient*)restClient loadedSharableLink:(NSString*)link
           forFile:(NSString*)path
{
    
    NSLog(@"Sharable link %@",link);
    NSLog(@"File Path %@ ",path);
}


#pragma mark - DBRestClientDelegate Methods for Load Data

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
//    for (int i = 0; i < [metadata.contents count]; i++)
//    {
//        DBMetadata *data = [metadata.contents objectAtIndex:i];
    
            NSArray *validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"png", nil];
            NSLog(@"Folder '%@' contains:", metadata.path);
    
            for (DBMetadata *file in metadata.contents)
            {
                NSLog(@"%@", file.path);
                NSString* extension = [[file.path pathExtension] lowercaseString];
                if(![file isDirectory] && [validExtensions indexOfObject:extension]!=NSNotFound)
                {
                    
                    NSLog(@"Root = %@",[DBSession sharedSession]);
                    
                   [marrDownloadData addObject:file];
                    
                    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
                    
                    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
                    NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:@"/dropBoxTemp"];
                    
                    NSError *error;

                    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
                        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];
                    
                    NSString *dataPath = [documentsPathlist stringByAppendingFormat:@"/%@",file.filename];
                    
                    NSLog(@"FilePath:%@",dataPath);
                    
//                    NSArray *pathos = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                    NSString *myPath = [pathos objectAtIndex:0];
//                    
//                    myPath = [myPath stringByAppendingString:@"/dropBoxTemp"];
//                    
//                    
//                    myPath = [myPath stringByAppendingString:file.filename];
                    
                    NSString *samplePath = @"/";
                    
                    samplePath = [samplePath stringByAppendingString:file.filename];

                    
                    NSLog(@"Rest = %@",self.restClient);
                    
                    [self.restClient loadFile:samplePath intoPath:dataPath];
                    
                    
                    
//                    [self.filesListView addCellForFile: file];

//                    NSString *localThumbnailPath = [self localThumbnailPathForFile: file]; // create a local-file-path for the thumbnail

//                    [self.restClient loadThumbnail: file.path ofSize:@"l" intoPath:dataPath];

                    
                    
//                    [self.restClient loadFile:samplePath intoPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:file.filename]];
//
                    
//                    NSLog(@"myPath = %@",myPath);
                    
 //                   NSData *data =

                }
            }
 //   }
    
    [tbDownload reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}




-(void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath
{
    NSLog(@"Loaded Thumbnail = %@",destPath);
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [tbDownload reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - DBRestClientDelegate Methods for Download Data
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"LoadedFile");
//    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    UINavigationController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NavigationController"];
//    
//    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    [self presentViewController:vc animated:YES completion:NULL];
    
/*    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
      message:@"File downloaded successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
     [alert show]; */
}

-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
/*    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];*/
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrDownloadData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dropbox_Cell"];
    
    DBMetadata *metadata = [marrDownloadData objectAtIndex:indexPath.row];
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    DocDir = [DocDir stringByAppendingString:@"/dropBoxTemp"];
    
    DocDir = [DocDir stringByAppendingPathComponent:metadata.filename];
    
    //    NSLog(@"My Path = %@",DocDir);
    
    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
    
    UIImage *img=[[UIImage alloc] initWithData:pictureData];
    
    cell.imgView.image = img;
    
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

    
//    cell.imageView.image =
    
    [cell.btnIcon setTitle:metadata.path forState:UIControlStateDisabled];
    
    [cell.btnIcon addTarget:self action:@selector(btnDownloadPress:) forControlEvents:UIControlEventTouchUpInside];
    
    if (metadata.isDirectory) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.btnIcon.hidden = YES;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.btnIcon.hidden = NO;
    }
    
    cell.lblTitle.text = metadata.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
/*    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBMetadata *metadata = [marrDownloadData objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DropboxDownloadFileViewControlller *dropboxDownloadFileViewControlller = [storyboard instantiateViewControllerWithIdentifier:@"DropboxDownloadFileViewControlller"];
    dropboxDownloadFileViewControlller.loadData = metadata.path;
    [self.navigationController pushViewController:dropboxDownloadFileViewControlller animated:YES]; */
}

#pragma mark - Action Methods
-(void)btnDownloadPress:(id)sender
{
    UIButton *btnDownload = (UIButton *)sender;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSLog(@"Downloaded..");
    
    [self performSelector:@selector(downloadFileFromDropBox:) withObject:[btnDownload titleForState:UIControlStateDisabled] afterDelay:.1];
    
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
    
    
    //
    //    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    //
    //    NSMutableArray *subpredicates = [NSMutableArray array];
    //
    //    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"]];
    //
    //    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    //
    //    NSMutableArray *getAllImages = [[NSMutableArray alloc]init];
    //
    //    NSArray *onlyImages = [directoryContents filteredArrayUsingPredicate:filter];
    //
    //    for (int i = 0; i < onlyImages.count; i++)
    //    {
    //        NSString *imagePath = [myPath stringByAppendingPathComponent:[onlyImages objectAtIndex:i]];
    //
    //        NSString *myPath = [imagePath lastPathComponent];
    //
    //        [imageName addObject:myPath];
    //
    //        NSLog(@"Gievn Image = %@",myPath);
    //        NSString *tempCon;
    //        NSRange endRange = [myPath rangeOfString:@"."];
    //        int i = (int)endRange.location;
    //
    //        if (i > 0)
    //        {
    //            NSRange searchRange = NSMakeRange(0, endRange.location);
    //            tempCon = [myPath substringWithRange:searchRange];
    //            NSLog(@"tempCon %@",tempCon);
    //
    //            temInt=tempCon.intValue;
    //            if(temInt > HigestImageCount){
    //                HigestImageCount =temInt;
    //            }
    //            NSLog(@"HigestCount %d",HigestImageCount);
    //        }
    //}
    
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

-(void)updateImagesToServer
{
    NSLog(@"updateImageToServer..");
    
    //[self loadSavedFile];
    
    @try
    {
        for(imgName in sendImage)
        {
            
            NSLog(@"Send Image Inside Loop... = %@",imgName);
            
            NSRange searchRange = [imgName rangeOfString:@"." options:NSBackwardsSearch];
            
            NSString *tempCon = [imgName substringToIndex:(searchRange.location)];
            
            NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *DocDir = [ScreensDir objectAtIndex:0];
            
            DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos/"];
            
            DocDir = [DocDir stringByAppendingPathComponent:imgName];
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            NSData *imgData = UIImagePNGRepresentation(img);
            
            //           NSLog(@"Image Data = %@",imgData);
            
            if( [self setImageParams:imgData imageID:tempCon])
            {
                NSLog(@"Enter block");
                
                NSOperationQueue *queue = [NSOperationQueue mainQueue];
                
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:queue
                                       completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
                 {
                     
                     NSLog(@"Response = %@",urlResponse);
                     
                 }];
                
                NSLog(@"Image Sent");
            }
            else
            {
                NSLog(@"Image Failed...");
            }
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Image Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Image Exception");
    }
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
