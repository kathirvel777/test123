//
//  MyImages.m
//  Montage
//
//  Created by MacBookPro on 3/21/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MyImages.h"
#import "AFNetworking.h"
#import "MQHorizontalFlowLayout.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ViewController.h"
#import "SWImageRotation.h"
#import "CollectionViewCell.h"
#import "SelectSourceViewController.h"


@interface MyImages ()<NSURLConnectionDataDelegate>
{
    
    NSMutableArray *imageName,*sendImage;
    NSString *user_id;
    NSMutableURLRequest *request;
    
    NSString *imgName,*deleteName;
    
    #define URL @"http://108.175.2.116/montage/api/api.php?rquest=image_upload"
    
}
@end

@implementation MyImages

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self loadImageFromServer];
    
    
//    [self sendImage];
    
//    [self SendValues];
    
    imageName = [[NSMutableArray alloc]init];

    sendImage = [[NSMutableArray alloc]init];
    
    self.chosenImages = [[NSMutableArray alloc]init];
    
    [self getName];
    

//    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    [self.flowLayout setItemSize:CGSizeMake(191, 250)];
//    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    self.flowLayout.minimumInteritemSpacing = 0.0f;
//
//    [self.collectionView setCollectionViewLayout:self.flowLayout];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:10.0f];
    [flowLayout setMinimumLineSpacing:10.0f];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
//    [flowLayout setItemSize:CGSizeMake(150.0f, 150.0f)];
//
//    [self.collectionView l setMinimumLineSpacing:5];
//    [self.PaperCollection setCollectionViewLayout:self.flowLayout];
//    self.PaperCollection.bounces = YES;
//    [self.PaperCollection setShowsHorizontalScrollIndicator:NO];
//    [self.PaperCollection setShowsVerticalScrollIndicator:NO];
//
//    
//    MQHorizontalFlowLayout *flowLayout = [[MQHorizontalFlowLayout alloc] init];
//    flowLayout.rowCount = 1;
//    flowLayout.columnCount = 3;
//    //    _VideoView1.dataSource = self;
//    //    _VideoView1.delegate = self;
//    self.collectionView.collectionViewLayout = flowLayout;
//    self.collectionView.showsHorizontalScrollIndicator = YES;
//    self.collectionView.showsVerticalScrollIndicator = YES;
//    self.collectionView.pagingEnabled = YES;
//    self.collectionView.decelerationRate = 0.0f;
//    self.collectionView.backgroundColor = [UIColor clearColor];

}


-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
//    [self updateImagesToServer];

}




//{
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    user_id = [defaults valueForKey:@"USER_ID"];
//    
//    NSLog(@"User ID = %@",user_id);
//    
//    if(user_id == NULL)
//    {
//        
//        NSLog(@"Here");
//        
//        
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        ViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login"];
//        
//        //                 [self.navigationController pushViewController:vc animated:YES];
//        
//        [self presentViewController:vc animated:YES completion:NULL];
//        
//
//    }
//    else
//    {
//        
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [imageName count]+1;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
   
  //  cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 0.2f;
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    
    DocDir = [DocDir stringByAppendingString:@"/MyImages"];

    
    NSLog(@"Image Directory = %@",DocDir);

    if (indexPath.row == [imageName count])
    {
        NSLog(@"Last");
        UIImage *img=[UIImage imageNamed:@"plus-icon-black-2.png"];
        cell.image.image = img;
        
        cell.edit_btn.hidden = true;
        cell.close_btn.hidden = true;
        cell.headerView.hidden = true;
    }
    else
    {
        DocDir = [DocDir stringByAppendingPathComponent:[imageName objectAtIndex:indexPath.row]];
    
        NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
    
        UIImage *img=[[UIImage alloc] initWithData:pictureData];
    
        cell.image.image = img;
        
        cell.edit_btn.hidden = false;
        cell.close_btn.hidden = false;
        cell.headerView.hidden = false;
    }
    
//    if (indexPath.row == [imageName count])
//    {
//        NSLog(@"Last");
//        
//        img=[UIImage imageNamed:@"plus-icon-black-2.png"];
//        
//        cell.image.image = img;
//    }
//    
    
    cell.edit_btn.tag=indexPath.row;
    [cell.edit_btn addTarget:self action:@selector(edit_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.close_btn.tag = indexPath.row;
    [cell.close_btn addTarget:self action:@selector(close_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



-(void)edit_btn:(UIButton*)sender
{
    int position = (int)sender.tag;

    NSString *name = [imageName objectAtIndex:position];

    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    DocDir = [DocDir stringByAppendingString:@"/MyImages/"];

    DocDir = [DocDir stringByAppendingPathComponent:name];
    
    NSLog(@"Get Image Path = %@",DocDir);
    
    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
    
    UIImage *img = [UIImage imageWithData:pictureData];
    
    [[NSUserDefaults standardUserDefaults]setObject:UIImagePNGRepresentation(img) forKey:@"EditImage"];
    
    [[NSUserDefaults standardUserDefaults]setValue:name forKey:@"EditImageName"];

    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
      SWImageRotation *controller = [[SWImageRotation alloc] initWithNibName:@"SWImageRotation" bundle:[NSBundle mainBundle]];
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:controller animated:YES completion:NULL];
}

-(void)close_btn:(UIButton*)sender
{
    NSLog(@"Close");
    
    NSString *img = [imageName objectAtIndex:sender.tag];
    
    deleteName = img;
    
    NSRange searchRange = [img rangeOfString:@"." options:NSBackwardsSearch];
    
    NSString *tempCon = [img substringToIndex:(searchRange.location)];

    
    NSLog(@"Img = %@",tempCon);
    
    
    [self deleteImage:tempCon];
    
}


-(void)deleteImage:(NSString*)deleteID
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //            NSDictionary *params = @{@"User_Name":@"Ragu",@"Email_ID": self.email.text,@"Password":self.password.text,};
    
    NSDictionary *params = @{@"User_ID":user_id ,@"image_id":deleteID,@"lang":@"ios"};
    
    [manager POST:@"http://108.175.2.116/montage/api/api.php?rquest=delete_my_image" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Login Json Response:%@",responseObject);
         
         [self localDelete];
         
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         //responseBlock(nil, FALSE, error);
     }];
}


-(void)localDelete
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSError *error;

//    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
//    
//    
//    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath;
    
    filePath = [documentsPath stringByAppendingString:@"/MyImages/"];
    
    filePath = [filePath stringByAppendingPathComponent:deleteName];

    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    
    if (success)
    {
        UIAlertView *removedSuccessFullyAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [removedSuccessFullyAlert show];
     
        [self getName];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
}



- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width / 1.0f;
    
    CGFloat picHimension = self.view.frame.size.width / 2.0f;
    
    return CGSizeMake(picDimension, picHimension);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    CGFloat leftRightInset = self.view.frame.size.width / 25.0f;
//    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
//    
//}


- (IBAction)pickImage:(id)sender
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
//    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];

    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    sendImage = [[NSMutableArray alloc]init];
    
    NSLog(@"Size = %lu",(unsigned long)info.count);
    
    int count = (int)[imageName count];
    
    for (NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage])
            {

                count++;

                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                NSData *data = UIImageJPEGRepresentation(image, 0.5);

                NSError *error;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *dataPath = [paths objectAtIndex:0]; // Get documents folder
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
                
                NSString  *withString =[NSString stringWithFormat:@"/%@_%@_%d",user_id,@"Images",count];
                
                withString = [withString stringByAppendingString:@".jpg"];

                dataPath = [dataPath stringByAppendingFormat:@"%@",withString];
                
                NSLog(@"FilePath:%@",dataPath);
                
                [data writeToFile:dataPath atomically:YES];
                
                
                NSString *tempString = [NSString stringWithFormat:@"%@_%@_%d",user_id,@"Images",count];
                
                tempString = [tempString stringByAppendingString:@".jpg"];
                
                [sendImage addObject:tempString];
                
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
        else
        {
            NSLog(@"Uknown asset type");
        }
    }
    
    [self getName];
    
    [self updateImagesToServer];
}

-(void)getName
{
    
    imageName = [[NSMutableArray alloc]init];
    
    NSArray *pathos = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [pathos objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    myPath = [myPath stringByAppendingString:@"/MyImages"];
    
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    
    NSMutableArray *subpredicates = [NSMutableArray array];
    
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"]];
    
    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    
    NSMutableArray *getAllImages = [[NSMutableArray alloc]init];
    
    NSArray *onlyImages = [directoryContents filteredArrayUsingPredicate:filter];
    
    for (int i = 0; i < onlyImages.count; i++)
    {
        NSString *imagePath = [myPath stringByAppendingPathComponent:[onlyImages objectAtIndex:i]];
        
        NSString *myPath = [imagePath lastPathComponent];
        
        [imageName addObject:myPath];
        
        NSLog(@"Gievn Image = %@",myPath);
    }
    
    [self.collectionView reloadData];

}

//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == [imageName count])
    {
        
//      [self getGalleryImage];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SelectSourceViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SelectSource"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    else
    {
        NSLog(@"Select = %@",[imageName objectAtIndex:indexPath.row]);
    }
}

-(void)getGalleryImage
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    //    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}


-(void)sendImage
{
    
    UIImage *image = [UIImage imageNamed:@"ios_9.jpg"];  // name of the image
    
    NSData *imageData =  UIImagePNGRepresentation(image);  // convert your image into data
    
    NSString *urlString = [NSString stringWithFormat:URL];  // enter your url to upload
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];  // allocate AFHTTPManager
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:imageData
                                    name:@"upload_files"
                                fileName:@"image.jpg" mimeType:@"image/jpeg"];   // add image to formData
        
        [formData appendPartWithFormData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"image_id"];    // add your other keys !!!

        
        [formData appendPartWithFormData:[@"100" dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"User_ID"];    // add your other keys !!!

        
        [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"lang"];    // add your other keys !!!

    }
    progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"Response: %@", responseObject);    // Get response from the server
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"Error: %@", error);   // Gives Error
    }];
}


-(void)SendValues
{
    
    NSLog(@"Enter Send Values");
    
    UIImage *image = [UIImage imageNamed:@"3_Images_12.jpg"];  // name of the image
    
    NSData *imageData =  UIImagePNGRepresentation(image);
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        
        [formData appendPartWithFileData:imageData
                                    name:@"upload_files"
                                fileName:@"image.jpg" mimeType:@"image/jpeg"];   // add image to formData
        
        [formData appendPartWithFormData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"image_id"];    // add your other keys !!!
        
        
        [formData appendPartWithFormData:[@"100" dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"User_ID"];    // add your other keys !!!
        
        
        [formData appendPartWithFormData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]
                                    name:@"lang"];    // add your other keys !!
        
        
 //       [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                 
                        });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                    {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
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
            
            NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *DocDir = [ScreensDir objectAtIndex:0];
            DocDir = [DocDir stringByAppendingPathComponent:imgName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            NSLog(@"Image Path = %@",DocDir);
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            NSData *imgData = UIImagePNGRepresentation(img);
            
            if( [self setImageParams:imgData])
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


-(BOOL)setImageParams:(NSData *)imgData
{
    @try
    {
 
//        UIImage *img = [UIImage imageNamed:@"letter-c-icon-png-4.png"];
//        
//        imgData = UIImageJPEGRepresentation(img, 1.0);
        
        
        if (imgData!=nil)
        {
            
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
        
 //           NSLog(@"Image send to  server = %@",imgData);
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[imgName dataUsingEncoding:NSUTF8StringEncoding]];
        
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


- (IBAction)Next:(id)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MovePage"
     object:self];

}

@end
