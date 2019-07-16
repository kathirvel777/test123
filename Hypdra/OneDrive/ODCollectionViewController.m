//
//  ODCollectionViewController.m
//  TestOneDrive
//
//  Created by MacBookPro4 on 10/27/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import "ODCollectionViewController.h"
#import "AFNetworking.h"
#import "DEMORootViewController.h"
#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"


//#import "ODXProgressViewController.h"

@interface ODCollectionViewController ()
{
    NSString *user_id,*imageID,*originalFileType;
    NSURL *imagePath;
    NSIndexPath *selectedValue,*imgValue;
    int HigestImageCount,lastHighestCount;
    NSMutableArray *OnlyImages,*finalArray,*imageName,*sendImage,*fullImage,*thumbImage;
    NSData *imageOrVideoData,*thumbdata;
    MBProgressHUD *hud;
    NSProgress *progress;
}

//@property ODXProgressViewController *progressController;
@property NSMutableDictionary *thumbnails;

@property BOOL selection;

@property NSMutableArray *selectedItems;
@property UIRefreshControl *refreshControl;

@property (strong, nonatomic) UIView* BlurView;
@property (strong, nonatomic) UIWindow* currentWindow;


//define URL @"https://www.hypdra.com/api/api.php?rquest=image_upload"

#define URL @"https://hypdra.com/api/api.php?rquest=image_upload_final"


@end

//static void *ProgressObserverContext = &ProgressObserverContext;

@implementation ODCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.items = [NSMutableDictionary dictionary];
    self.itemsLookup = [NSMutableArray array];
    self.thumbnails = [NSMutableDictionary dictionary];
    self.refreshControl = [[UIRefreshControl alloc] init];
   // self.progressController = [[ODXProgressViewController alloc] initWithParentViewController:self];
    
    
    _currentWindow = [UIApplication sharedApplication].keyWindow;
    
    _BlurView = [[UIView alloc]initWithFrame:CGRectMake(_currentWindow.frame.origin.x, _currentWindow.frame.origin.y, _currentWindow.frame.size.width, _currentWindow.frame.size.height)];
    _BlurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    
    if (!self.currentItem)
    {
        self.title = @"OneDrive";
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (self.client)
    {
        [self loadChildren];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    imagePath = nil;
    
    [self.btndone setEnabled:YES];
    
}

- (void)loadChildren
{
    NSString *itemId = (self.currentItem) ? self.currentItem.id : @"root";
    ODChildrenCollectionRequest *childrenRequest = [[[[self.client drive] items:itemId] children] request];
    if (![self.client serviceFlags][@"NoThumbnails"])
    {
        NSLog(@"child thumb called");
        [childrenRequest expand:@"thumbnails"];
    }
    NSLog(@"ChildrenRequest:%@",childrenRequest);
    [self loadChildrenWithRequest:childrenRequest];
}

- (void)onLoadedChildren:(NSArray *)children
{
    NSLog(@"Children on onload:%@",children);
    if (self.refreshControl.isRefreshing)
    {
        [self.refreshControl endRefreshing];
    }
    [children enumerateObjectsUsingBlock:^(ODItem *item, NSUInteger index, BOOL *stop)
     {
        // if ([item.file.mimeType isEqualToString:@"image/png"] ||[item.file.mimeType isEqualToString:@"image/jpeg"]||[item.file.mimeType isEqualToString:@"video/mp4"])
        // {
         if([_mime_Type isEqualToString:@"video"])
         {
             if ([item.file.mimeType isEqualToString:@"video/mp4"])
             {
                 if (![self.itemsLookup containsObject:item.id])
                 {
                     [self.itemsLookup addObject:item.id];
                 }
                 self.items[item.id] = item;
             }
         }
         else
         {
             if ([item.file.mimeType isEqualToString:@"image/png"] ||[item.file.mimeType isEqualToString:@"image/jpeg"])
             {
             if (![self.itemsLookup containsObject:item.id])
             {
                 [self.itemsLookup addObject:item.id];
             }
             self.items[item.id] = item;
             }
         }
     }];
    [self loadThumbnails:children];
    
    NSLog(@"ItemLookup:%@",_itemsLookup);
    NSLog(@"items:%@",_items);
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.ODCollectionView reloadData];
    });
}

- (void)loadThumbnails:(NSArray *)items
{
    for (ODItem *item in items)
    {
        if ([item thumbnails:0])
        {
            [[[[[[self.client drive] items:item.id] thumbnails:@"0"] small] contentRequest] downloadWithCompletion:^(NSURL *location, NSURLResponse *response, NSError *error)
             {
                 if (!error)
                 {
                     self.thumbnails[item.id] = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                     dispatch_async(dispatch_get_main_queue(), ^(){
                         [self.ODCollectionView reloadData];
                     });
                 }
             }];
        }
    }
}

- (void)loadChildrenWithRequest:(ODChildrenCollectionRequest*)childrenRequests
{
    [childrenRequests getWithCompletion:^(ODCollection *response, ODChildrenCollectionRequest *nextRequest, NSError *error)
     {
         if (!error)
         {
             NSLog(@"Response Value:%@",response.value);
             if (response.value)
             {
                 [self onLoadedChildren:response.value];
             }
             if (nextRequest){
                 [self loadChildrenWithRequest:nextRequest];
             }
         }
         else if ([error isAuthenticationError])
         {
             [self showErrorAlert:error];
             [self onLoadedChildren:@[]];
         }
     }];
}

- (ODItem *)itemForIndex:(NSIndexPath *)indexPath
{
    NSString *itemId = self.itemsLookup[indexPath.row];
    return self.items[itemId];
}

#pragma mark CollectionView Methods

- (ODCollectionViewController *)collectionViewWithItem:(ODItem *)item;
{
    ODCollectionViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"ODCollection"];
    newController.title = item.name;
    newController.currentItem = item;
    newController.client = self.client;
    return newController;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.itemsLookup count];
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width / 3.4f;
    return CGSizeMake(picDimension, picDimension);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    fullImage =[[NSMutableArray alloc]init];
    thumbImage=[[NSMutableArray alloc]init];
    
    __block ODItem *item = [self itemForIndex:indexPath];

    if (item.file)
    {
        ODURLSessionDownloadTask *task = [[[[self.client drive] items:item.id] contentRequest] downloadWithCompletion:^(NSURL *filePath, NSURLResponse *response, NSError *error)
      {
          NSLog(@"FilePath:%@",filePath);
          
          if (!error)
          {
              if ([item.file.mimeType isEqualToString:@"text/plain"])
              {
                  NSLog(@"Texttype");
              }
              else
              {
                  NSLog(@"mimetype images or video");

                  imagePath = nil;
                  imgValue = nil;
                  
                  imgValue = indexPath;
              
                  imageOrVideoData = [NSData dataWithContentsOfURL:filePath];

                  thumbdata = UIImagePNGRepresentation(self.thumbnails[item.id]);
                  
                  
                /*  NSLog(@"item.name:%@ \n item.url:%@ \n item.image:%@ \n item.video:%@",item.name,item.webUrl,item.image,item.video);
                  
                 NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                 NSString *newFilePath = [documentPath stringByAppendingPathComponent:@"sample1.png"];
                  
                  NSLog(@"newFilePath:%@",newFilePath);
                  
                  [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:newFilePath] error:nil];
             */
                  
                  if([_mime_Type isEqualToString:@"video"])
                  {
                      if(imageOrVideoData!=nil && thumbdata!=nil)
                      {
                      if ([self.delegate respondsToSelector:@selector(didFinishedODVideo:thumbnail:)])
                      {
                      dispatch_async(dispatch_get_main_queue(), ^{
                       
                          [self.delegate didFinishedODVideo:imageOrVideoData thumbnail:thumbdata];
                          [self.navigationController popViewControllerAnimated:YES];
                      });
                      
                      }
                      }
                      else
                      {
                          NSLog(@"video data is nil");
                      }
                  }
                  else
                  {
                      if(imageOrVideoData!=nil)
                      {
                      if ([self.delegate respondsToSelector:@selector(didFinishedODImage:)])
                      {
                      dispatch_async(dispatch_get_main_queue(), ^{
                        
                          [self.delegate didFinishedODImage:imageOrVideoData];
                          [self.navigationController popViewControllerAnimated:YES];
                           
                          });
                      }
                      }
                      else
                      {
                          NSLog(@"image data is nil");
                      }
                  }
              }
          }
          else
          {
              [self showErrorAlert:error];
              [self.selectedItems removeObject:item];
          }
      }];
        
       // task.progress.totalUnitCount = item.size;
      //  [self.progressController showProgressWithTitle:[NSString stringWithFormat:@"Downloading %@", item.name] progress:task.progress];
       // progress=task.progress;
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Deselected..");
    
    ODCollectionViewCell* cell = (ODCollectionViewCell*)[collectionView  cellForItemAtIndexPath:indexPath];
    //    cell.alpha = 1;
    
    cell.selectedImage.hidden = true;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODItem *item = [self itemForIndex:indexPath];
    
    ODCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ODCollectionViewCell" forIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];

    // Reset the old image
    cell.imgView.image = nil;
    cell.backgroundColor = [UIColor blackColor];

    if (self.selection && [self.selectedItems containsObject:item])
    {
        cell.selected = YES;
    }
    
    if (self.thumbnails[item.id])
    {
        UIImage *image = self.thumbnails[item.id];
        cell.imgView.image = image;
    }
    
    bgColorView.backgroundColor = [UIColor grayColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    if (item.folder)
    {
        cell.backgroundColor = [UIColor blueColor];
    }
    return cell;
}


- (void)showErrorAlert:(NSError*)error
{
    NSString *errorMsg;
    if ([error isAuthCanceledError]) {
        errorMsg = @"Sign-in was canceled!";
    }
    else if ([error isAuthenticationError]) {
        errorMsg = @"There was an error in the sign-in flow!";
    }
    else if ([error isClientError]) {
        errorMsg = @"Oops, we sent a bad request!";
    }
    else {
        errorMsg = @"Uh oh, an error occurred!";
    }
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:errorMsg
      message:[NSString stringWithFormat:@"%@", error]
    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    
    [errorAlert addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:errorAlert animated:YES completion:nil];
    });
}


- (IBAction)ODLogout:(id)sender
{
    
        [self.client signOutWithCompletion:^(NSError *signOutError){
            self.items = nil;
            self.items = [NSMutableDictionary dictionary];
            self.itemsLookup = nil;
            self.itemsLookup = [NSMutableArray array];
            self.client = nil;
            self.currentItem = nil;
            self.title = @"OneDrive";
            
            dispatch_async(dispatch_get_main_queue(), ^(){

                // Reload from main thread
                [self.ODCollectionView reloadData];
                
            });
        }];
    
}


- (IBAction)backAction:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_2" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
