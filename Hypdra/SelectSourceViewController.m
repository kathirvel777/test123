//
//  SelectSourceViewController.m
//  Montage
//
//  Created by MacBookPro on 4/15/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SelectSourceViewController.h"
#import "OLFacebookAlbumRequest.h"
#import "OLFacebookPhotosForAlbumRequest.h"
#import "OLFacebookAlbum.h"
#import "OLFacebookImage.h"
#import "OLFacebookImagePickerController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "OLInstagramImagePickerController.h"
#import "OLInstagramImage.h"
#import "DropboxDownloadFileViewControlller.h"
#import "DropboxIntegrationViewController.h"
#import "SectionViewController.h"
#import "ELCImagePickerController.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AFNetworking.h"
#import "FlickrKit.h"
#import "PhotoViewController.h"
#import "WebViewController.h"



@interface SelectSourceViewController ()<UINavigationControllerDelegate, OLFacebookImagePickerControllerDelegate,OLInstagramImagePickerControllerDelegate>
{
    NSMutableArray *imageName,*sendImage;
    NSString *user_id;
    NSMutableURLRequest *request;
    int HigestImageCount;
    
    NSString *imgName;
    
    #define URL @"http://108.175.2.116/montage/api/api.php?rquest=image_upload"
}

@property (nonatomic, strong) OLFacebookAlbumRequest *albumRequest;
@property (nonatomic, strong) NSArray *selected;
@property (nonatomic, strong) NSArray *selectedImages;
@property (nonatomic, retain) FKFlickrNetworkOperation *todaysInterestingOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@property (nonatomic, retain) NSString *userID;


@end

@implementation SelectSourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies])
//    {
//        NSString* domainName = [cookie domain];
//        NSRange domainRange = [domainName rangeOfString:@"flickr"];
//        if(domainRange.length > 0)
//        {
//            [storage deleteCookie:cookie];
//        }
//    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    // Check if there is a stored token
    // You should do this once on app launch
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            if (!error)
            {
                [self userLoggedIn:userName userID:userId];
            }
            else
            {
                [self userLoggedOut];
            }
        });
    }];
    
    [self getName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    //    [self updateImagesToServer];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //Cancel any operations when you leave views
//    self.navigationController.navigationBarHidden = NO;
    
    [self.todaysInterestingOp cancel];
    [self.myPhotostreamOp cancel];
    [self.completeAuthOp cancel];
    [self.checkAuthOp cancel];
    [self.uploadOp cancel];
    [super viewWillDisappear:animated];
}

- (void) userAuthenticateCallback:(NSNotification *)notification
{
    NSURL *callbackURL = notification.object;
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)
            {
                [self userLoggedIn:userName userID:userId];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }

            [self.navigationController popToRootViewControllerAnimated:YES];
  
            
//            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            
//            SelectSourceViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SelectSource"];
//            
//            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            
//            [self presentViewController:vc animated:YES completion:NULL];
//
            
            
        });
    }];
}

- (void) userLoggedIn:(NSString *)username userID:(NSString *)userID
{
    self.userID = userID;
    NSLog(@"USer Loggin");
    
    
    
    //[self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    //self.authLabel.text = [NSString stringWithFormat:@"You are logged in as %@", username];
}

- (void) userLoggedOut
{
    NSLog(@"USer logout");
    
    // [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    // self.authLabel.text = @"Login to flickr";
}


- (IBAction)Back:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CSection"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}


- (IBAction)Gallery:(id)sender
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
    
    
    int count =HigestImageCount;
    
    
    for (NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage])
            {
                
                count++;
                
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                NSData *data = UIImagePNGRepresentation(image);// UIImageJPEGRepresentation(image, 0.5);
                
                NSError *error;
                NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
                
                NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImages"]];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
                
                NSString  *withString =[NSString stringWithFormat:@"/%d",count];
                
                
                withString = [withString stringByAppendingString:@".png"];
                
                
                dataPath = [dataPath stringByAppendingFormat:@"%@",withString];
                
                NSLog(@"FilePath:%@",dataPath);
                
                [data writeToFile:dataPath atomically:YES];
                
                
                NSString *tempString = [NSString stringWithFormat:@"%d",count];
                
                tempString = [tempString stringByAppendingString:@".png"];
                
                
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


- (IBAction)Facebook:(id)sender
{
    NSLog(@"Clicked..");
    
    OLFacebookImagePickerController *picker = [[OLFacebookImagePickerController alloc] init];
    
    //   picker.selected = self.selected;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)Instagram:(id)sender
{
    OLInstagramImagePickerController *imagePicker = [[OLInstagramImagePickerController alloc] initWithClientId:@"cc3b41091d97462c8742fc77b60d92eb" secret:@"60b267b0d4714718955f521d4ac6829d" redirectURI:@"http://www.seekitech.com/"];
    
    imagePicker.delegate = self;
    imagePicker.selected = self.selectedImages;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)Flickr:(id)sender
{
    
    NSLog(@"Flickr");
    
    
    
    if ([FlickrKit sharedFlickrKit].isAuthorized)
    {
        /*
         Example using the string/dictionary method of using flickr kit
         */
        self.myPhotostreamOp = [[FlickrKit sharedFlickrKit] call:@"flickr.photos.search" args:@{@"user_id": self.userID, @"per_page": @"15"} maxCacheAge:FKDUMaxAgeNeverCache completion:^(NSDictionary *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response) {
                    NSMutableArray *photoURLs = [NSMutableArray array];
                    for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                        NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                        [photoURLs addObject:url];
                    }
                    
                    NSLog(@"Photo URL:%@",photoURLs);
                    
                    PhotoViewController *fivePhotos = [[PhotoViewController alloc] initWithURLArray:photoURLs];
                    
  
                    [self presentViewController:fivePhotos animated:YES completion:NULL];

                    
//                    [self.navigationController pushViewController:fivePhotos animated:YES];
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                }
            });
        }];
    }
    else
    {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        
        if ([FlickrKit sharedFlickrKit].isAuthorized)
        {
            [[FlickrKit sharedFlickrKit] logout];
            [self userLoggedOut];
        }
        else
        {
            
            NSLog(@"WebView");
            
            WebViewController *authView = [[WebViewController alloc] init];
            
            
//            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            
//            SectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CSection"];
//            
//            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentViewController:authView animated:YES completion:NULL];
            
            //[self.navigationController pushViewController:authView animated:YES];
        }
    }
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        NSLog(@"ObserveValue");
        // self.progress.progress = progress;
        //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    });
}


- (IBAction)DropBox:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DropboxDownloadFileViewControlller *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DropboxDownloadFileViewControlller"];
    
    UINavigationController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

#pragma mark - OLFacebookImagePickerControllerDelegate methods

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^()
     {
         [[[UIAlertView alloc] initWithTitle:@"Oops" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
     }];
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray*)images
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.selected = images;
    
    sendImage = [[NSMutableArray alloc]init];

    NSURL *url;
    
    int count = HigestImageCount;
    
    int i = 0;
    
    for (OLFacebookImage *image in images)
    {
        
        i++;
        
        url = image.fullURL;
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        [self saveData:imageData inc:(count+i)];
        
    }
    
    [self getName];
    
    [self updateImagesToServer];
    
    NSLog(@"User did pick %lu images", (unsigned long) images.count);
}

- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"User cancelled facebook image picking");
}

-(void)saveData:(NSData*)iData inc:(int)count
{
    NSData *data = iData;
    
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImages"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString  *withString =[NSString stringWithFormat:@"/%d",count];
    
    withString = [withString stringByAppendingString:@".png"];
    
    dataPath = [dataPath stringByAppendingFormat:@"%@",withString];
    
    NSLog(@"FilePath:%@",dataPath);
    
    [data writeToFile:dataPath atomically:YES];
    
    NSString *tempString = [NSString stringWithFormat:@"%d",count];
    
    tempString = [tempString stringByAppendingString:@".png"];
    
    [sendImage addObject:tempString];
}


-(void)getName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    HigestImageCount = 0;
    imageName = [[NSMutableArray alloc]init];
    
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *myPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyImages"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:myPath withIntermediateDirectories:NO attributes:nil error:&error];
    
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
        NSString *tempCon;
        int temInt;
        NSRange endRange = [myPath rangeOfString:@"."];
        int i = (int)endRange.location;
        
        if (i > 0)
        {
            NSRange searchRange = NSMakeRange(0, endRange.location);
            tempCon = [myPath substringWithRange:searchRange];
            NSLog(@"tempCon %@",tempCon);
            //            searchRange = [tempCon rangeOfString:@"_" options:NSBackwardsSearch];
            //            tempCon = [tempCon substringFromIndex:(searchRange.location+1)];
            temInt=tempCon.intValue;
            if(temInt > HigestImageCount){
                HigestImageCount =temInt;
            }
            NSLog(@"HigestCount %d",HigestImageCount);
        }
    }
    
}


#pragma mark - OLInstagramImagePickerControllerDelegate methods

- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFinishPickingImages:(NSArray*)images
{
    self.selectedImages = images;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    sendImage = [[NSMutableArray alloc]init];
    
    int count = HigestImageCount;
    
    int i = 0;
    
    NSURL *url;
    
    for (OLInstagramImage *image in images)
    {
        i++;

        NSLog(@"User selected instagram image with full URL: %@", image.fullURL);
        
        url = image.fullURL;
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        [self saveData:imageData inc:(count+i)];

    }
    
//    NSString *ImageURL = [url absoluteString];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    [self getName];
    
    [self updateImagesToServer];
    
}

- (void)instagramImagePickerDidCancelPickingImages:(OLInstagramImagePickerController *)imagePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
            
            DocDir = [DocDir stringByAppendingString:@"/MyImages/"];
            
            DocDir = [DocDir stringByAppendingPathComponent:imgName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
//            NSLog(@"Image Path = %@",DocDir);
            
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
